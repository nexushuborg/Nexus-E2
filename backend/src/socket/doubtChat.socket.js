import Message from '../models/message.model.js';
import { encryptMessage, decryptMessage } from '../services/messageEncryption.js';
import { uploadFile, getFileLink } from '../services/chatService.js';
import { MongoRedisLike } from '../services/mongoRedisLike.js';

export const handleDoubtChat = (io, socket) => {
    // Join doubt room
    socket.on('join_doubt_room', async (data) => {
        try {
            const { userId, roomId, userType } = data;

            // Store user's socket session
            await MongoRedisLike.setUserSession(userId, {
                socketId: socket.id,
                status: 'online',
                currentRoom: roomId
            });

            socket.join(roomId);

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
    socket.on('send_message', async (data) => {
        try {
            const { roomId, sender, content, file, senderModel } = data;

            let fileId = null;
            if (file) {
                fileId = await uploadFile(file);
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
                senderModel, // 'Student' or 'Teacher'
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

            // Broadcast message to room
            io.to(roomId).emit('new_message', {
                ...message.toObject(),
                content, // Send original content
                fileUrl
            });
        } catch (error) {
            console.error('Error in send_message:', error);
            socket.emit('error', { message: 'Failed to send message' });
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
