import { MongoRedisLike } from '../../services/mongoRedisLike.js';

export const socketAuthMiddleware = async (socket, next) => {
    try {
        const { userId, role } = socket.handshake.auth;
        
        if (!userId || !role) {
            return next(new Error('Authentication required: userId and role needed'));
        }

        // Validate user exists and get session
        const session = await MongoRedisLike.getUserSession(userId);
        if (!session) {
            return next(new Error('User session not found'));
        }

        // Attach data to socket
        socket.userId = userId;
        socket.userRole = role;
        socket.userType = role.toLowerCase();
        
        // Update session 
        await MongoRedisLike.setUserSession(userId, {
            userId,
            socketId: socket.id,
            status: 'online',
            role
        });

        next();
    } catch (error) {
        console.error('Socket auth error:', error);
        next(new Error('Authentication failed'));
    }
};

export const requireAuth = (socket, next) => {
    if (!socket.userId) {
        return next(new Error('Authentication required'));
    }
    next();
};
