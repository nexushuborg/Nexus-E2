import { MongoRedisLike } from '../../services/mongoRedisLike.js';

export const socketAuthMiddleware = async (socket, next) => {
    try {
        const { userid, role } = socket.handshake.headers;
        console.log('Authenticating socket:', socket.handshake.headers);

        if (!userid || !role) {
            return next(new Error('Authentication required: userid and role needed'));
        }

        // Validate user exists and get session
        // const session = await MongoRedisLike.getUserSession(userid);
        // if (!session) {
        //     return next(new Error('User session not found'));
        // }

        // Attach data to socket
        socket.userid = userid;
        socket.userRole = role;
        socket.userType = role.toLowerCase();

        // Update session
        await MongoRedisLike.setUserSession(userid, {
            userid,
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
    if (!socket.userid) {
        return next(new Error('Authentication required'));
    }
    next();
};
