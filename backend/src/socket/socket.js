import { Server } from 'socket.io';
import MongoRedisLike from '../services/mongoRedisLike.js';
import ChatService from '../services/chatService.js';

export const initializeSocket = (server) => {
    const io = new Server(server, {
        cors: {
            origin: process.env.FRONTEND_URL || "*",
            methods: ["GET", "POST"]
        }
    });

    // Make io available globally
    global.io = io;

    io.on('connection', async (socket) => {
        console.log('New client connected');

        // Handle user authentication and connection
        socket.on('authenticate', async ({ userId, role }) => {
            try {
                // Store user session
                await MongoRedisLike.setUserSession(userId, socket.id, role);

                // Join user to their personal room
                socket.join(userId);

                // Get and send any unread messages
                const unreadMessages = await ChatService.getUnreadMessages(userId);
                if (unreadMessages.length > 0) {
                    socket.emit('unread_messages', unreadMessages);
                }
            } catch (error) {
                console.error('Authentication error:', error);
            }
        });

        // Handle new messages
        socket.on('send_message', async (messageData) => {
            try {
                await ChatService.sendMessage(messageData);
            } catch (error) {
                console.error('Error sending message:', error);
                socket.emit('message_error', { error: 'Failed to send message' });
            }
        });

        // Handle typing status
        socket.on('typing_start', async ({ roomId, userId }) => {
            try {
                await MongoRedisLike.setTypingStatus(roomId, userId);
                socket.to(roomId).emit('user_typing', { userId });
            } catch (error) {
                console.error('Error setting typing status:', error);
            }
        });

        socket.on('typing_end', async ({ roomId, userId }) => {
            try {
                await MongoRedisLike.clearTypingStatus(roomId, userId);
                socket.to(roomId).emit('user_stopped_typing', { userId });
            } catch (error) {
                console.error('Error clearing typing status:', error);
            }
        });

        // Handle disconnection
        socket.on('disconnect', async () => {
            try {
                const session = await MongoRedisLike.findSessionBySocketId(socket.id);
                if (session) {
                    await MongoRedisLike.deleteUserSession(session.userId, session.role);
                }
            } catch (error) {
                console.error('Disconnect error:', error);
            }
        });
    });

    return io;
};
