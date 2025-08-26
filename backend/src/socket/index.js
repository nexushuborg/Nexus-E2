import { Server } from 'socket.io';
import { socketAuthMiddleware } from './middleware/auth.middleware.js';
import { setupChatRoutes } from './routes/chat.routes.js';

export const initializeSocket = (server) => {
    const io = new Server(server, {
        cors: {
            origin: process.env.ALLOWED_ORIGINS?.split(',') || '*',
            methods: ['GET', 'POST'],
            credentials: true
        },
        transports: ['polling', 'websocket'],
        pingTimeout: 30000
    });

    // Global middleware for all connections
    io.use(socketAuthMiddleware);

    // Make io available globally
    global.io = io;

    io.on('connection', (socket) => {
        console.log('Socket connected:', socket.id);
        console.log('User authenticated:', socket.userId, socket.userRole);

        // Log all events for debugging
        socket.onAny((eventName, ...args) => {
            console.log(`📨 Event received: ${eventName} from ${socket.userId}`, args);
        });

        // Setup chat routes
        setupChatRoutes(socket);
    });

    return io;
};


