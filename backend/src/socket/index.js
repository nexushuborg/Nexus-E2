import { Server } from 'socket.io';
import { handleDoubtChat } from './doubtChat.socket.js';

export const initializeSocket = (server) => {
    const io = new Server(server, {
        cors: {
            origin: process.env.ALLOWED_ORIGINS?.split(',') || "*",
            methods: ["GET", "POST"]
        },
        pingTimeout: 60000
    });

    io.on('connection', (socket) => {
        console.log('New client connected:', socket.id);

        // Initialize doubt chat handlers
        handleDoubtChat(io, socket);

        socket.on('disconnect', () => {
            console.log('Client disconnected:', socket.id);
        });
    });

    // Make io instance globally available
    global.io = io;

    return io;
};
