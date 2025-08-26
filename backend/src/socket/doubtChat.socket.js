import Message from '../models/message.model.js';
import { encryptMessage, decryptMessage } from '../services/messageEncryption.js';
import { uploadFile, getFileLink } from '../services/chatService.js';
import { MongoRedisLike } from '../services/mongoRedisLike.js';

export const handleDoubtChat = (io, socket) => {
    console.log('Socket connected:', socket.id);

    // Join doubt room
    socket.on('join_doubt_room', async (data) => {
        try {
            const { userId, roomId, userType } = data;
            console.log(`User ${userId} (${userType}) joining room ${roomId}`);

            // Store user's socket session
            await MongoRedisLike.setUserSession(userId, {
                socketId: socket.id,
                status: 'online',
                currentRoom: roomId
            });

            // Leave any previous rooms
            const rooms = Array.from(socket.rooms);
            rooms.forEach(room => {
                if (room !== socket.id) {
                    socket.leave(room);
                }
            });

            // Join new room and store user data
            await socket.join(roomId);
            socket.data.userId = userId;
            socket.data.userType = userType.toLowerCase(); // Store user type (student/teacher)
            console.log(`Socket ${socket.id} joined room ${roomId} (${userType}: ${userId})`);

            // Check for missed messages while offline
            socket.emit('check_missed_messages', { userId });

            // Get previous messages
            const messages = await Message.find({ roomId })
                .sort('-createdAt')
                .limit(50)
                .lean();

            // Decrypt messages and add file URLs
            const processedMessages = await Promise.all(messages.map(async (msg) => {
                const processed = { ...msg };
                if (msg.content) {
                    try {
                        const decrypted = await decryptMessage(msg.content);
                        processed.content = decrypted;
                    } catch (err) {
                        console.error('Failed to decrypt message:', err);
                        processed.content = null;
                    }
                }
                if (msg.file) {
                    try {
                        processed.fileUrl = await getFileLink(msg.file);
                    } catch (err) {
                        console.error('Failed to get file URL:', err);
                        processed.fileUrl = null;
                    }
                }
                return processed;
            }));

            socket.emit('previous_messages', processedMessages.reverse());
        } catch (error) {
            console.error('Error in join_doubt_room:', error);
            socket.emit('error', { message: 'Failed to join room' });
        }
    });

    // Handle new message
    // Handle manual read receipts (when user actively opens/reads a message)
    socket.on('message_read', async (data) => {
        const { messageId } = data;
        try {
            const message = await Message.findById(messageId);
            if (message) {
                message.status = 'read';
                await message.save();

                // Broadcast read receipt to room
                io.in(message.roomId).emit('message_status', {
                    messageId: message._id,
                    status: 'read'
                });

                console.log(`Message ${messageId} marked as read`);
            }
        } catch (error) {
            console.error('Error handling message read receipt:', error);
        }
    });

    // Handle delivery receipts (automatic when recipient is online)
    const handleMessageDelivery = async (message, recipientId) => {
        try {
            // Check if recipient is online
            const recipientSession = await MongoRedisLike.getUserSession(recipientId);
            if (recipientSession && recipientSession.status === 'online') {
                // If recipient is in the same room, mark as delivered
                const recipientSocket = io.sockets.sockets.get(recipientSession.socketId);
                if (recipientSocket && recipientSocket.rooms.has(message.roomId)) {
                    message.status = 'delivered';
                    await message.save();

                    // Notify both sender and recipient about delivery
                    io.in(message.roomId).emit('message_status', {
                        messageId: message._id,
                        status: 'delivered'
                    });

                    console.log(`Message ${message._id} automatically delivered to recipient ${recipientId}`);
                }
            } else {
                console.log(`Recipient ${recipientId} is offline, message will be delivered later`);
                // Store the message for offline delivery
                await MongoRedisLike.addPendingMessage(recipientId, message._id);
            }
        } catch (error) {
            console.error('Error handling message delivery:', error);
        }
    };

    // Handle reconnection and offline message delivery
    socket.on('check_missed_messages', async (data) => {
        const { userId } = data;
        try {
            // Get pending messages for the user
            const pendingMessages = await MongoRedisLike.getPendingMessages(userId);
            if (pendingMessages && pendingMessages.length > 0) {
                for (const messageId of pendingMessages) {
                    const message = await Message.findById(messageId);
                    if (message) {
                        await handleMessageDelivery(message, userId);
                    }
                }
                // Clear pending messages after delivery
                await MongoRedisLike.clearPendingMessages(userId);
            }
        } catch (error) {
            console.error('Error handling missed messages:', error);
        }
    });

    socket.on('send_message', async (data) => {
        try {
            const { roomId, sender, content, file, senderModel } = data;
            console.log(`New message in room ${roomId} from ${sender} (${senderModel})`);

            // Verify sender is in the room
            if (!socket.rooms.has(roomId)) {
                console.log(`Socket ${socket.id} not in room ${roomId}, rejoining...`);
                await socket.join(roomId);
            }

            let fileId = null;
            if (file) {
                fileId = await uploadFile(file);
                console.log('File uploaded with ID:', fileId);
            }

            // Encrypt message content if present
            let encryptedContent = null;
            if (content) {
                try {
                    encryptedContent = await encryptMessage(content);
                } catch (err) {
                    console.error('Failed to encrypt message:', err);
                    throw new Error('Message encryption failed');
                }
            }

            // Create message document
            const message = await Message.create({
                roomId,
                sender,
                senderModel,
                content: encryptedContent,
                file: fileId,
                messageType: file ? 'file' : 'text',
                status: 'sent'
            });

            // Get file URL if present
            let fileUrl = null;
            if (fileId) {
                try {
                    fileUrl = await getFileLink(fileId);
                } catch (err) {
                    console.error('Failed to get file URL:', err);
                }
            }

            // Get room info
            const room = io.sockets.adapter.rooms.get(roomId);
            const membersCount = room ? room.size : 0;

            // Find recipient type
            const recipientRole = senderModel === 'Student' ? 'teacher' : 'student';

            // Find all sockets in the room
            const socketsInRoom = await io.in(roomId).fetchSockets();

            // Find recipient socket by checking user role
            let recipientSocket = null;
            for (const sock of socketsInRoom) {
                if (sock.data.userType === recipientRole) {
                    recipientSocket = sock;
                    break;
                }
            }

            // Set initial message status
            message.status = recipientSocket ? 'delivered' : 'sent';
            await message.save();

            console.log(`Broadcasting to room ${roomId} (${membersCount} members, recipient is ${recipientSocket ? 'online' : 'offline'})`);

            // Prepare message payload
            const messagePayload = {
                _id: message._id,
                roomId: message.roomId,
                sender: message.sender,
                senderModel: message.senderModel,
                content: content, // Send original content
                fileUrl,
                messageType: message.messageType,
                status: message.status,
                createdAt: message.createdAt
            };

            // Broadcast message to room
            io.in(roomId).emit('new_message', messagePayload);

            if (recipientSocket) {
                // If recipient is online, send directly to ensure delivery
                recipientSocket.emit('new_message', messagePayload);
                console.log(`Message ${message._id} sent directly to recipient socket ${recipientSocket.id}`);
            } else {
                // Store for offline delivery
                const recipientQuery = { roomId, role: recipientRole };
                const recipientDoc = await MongoRedisLike.getRoomMember(roomId, recipientQuery);
                if (recipientDoc) {
                    console.log(`Storing message ${message._id} for offline delivery to ${recipientDoc._id}`);
                    await MongoRedisLike.addPendingMessage(recipientDoc._id, message._id);
                } else {
                    console.error('Recipient not found for room:', roomId);
                }
            }

            console.log(`Message ${message._id} handled with status: ${message.status}`);

            console.log(`Message ${message._id} broadcast successfully to room ${roomId}`);
        } catch (error) {
            console.error('Error in send_message:', error);

            // Update message status to failed if message was created
            if (message) {
                message.status = 'failed';
                await message.save();

                socket.emit('message_status', {
                    messageId: message._id,
                    status: 'failed'
                });
            }

            socket.emit('error', {
                type: 'SEND_MESSAGE_ERROR',
                message: 'Failed to send message',
                details: error.message
            });
        }
    });

    // Handle typing status
    socket.on('typing_status', (data) => {
        const { roomId, userId, status } = data;
        socket.to(roomId).emit('user_typing', { userId, status });
    });

    // Handle user disconnection
    socket.on('disconnect', async () => {
        try {
            const userId = await MongoRedisLike.getUserBySocketId(socket.id);
            if (userId) {
                await MongoRedisLike.setUserSession(userId, {
                    status: 'offline',
                    lastSeen: new Date()
                });
            }
        } catch (error) {
            console.error('Error in disconnect:', error);
        }
    });
};
