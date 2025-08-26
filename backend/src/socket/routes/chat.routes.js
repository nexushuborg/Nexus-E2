import { ChatController } from '../controllers/chat.controller.js';
import { requireAuth } from '../middleware/auth.middleware.js';
import { validateSocketData, validationSchemas } from '../middleware/validation.middleware.js';
import { uploadMiddleware } from '../../services/fileUpload.service.js';
import { sendMessageWithFiles } from '../../controllers/doubt.controller.js';

export const setupChatRoutes = (socket) => {
    // Public routes (no auth required)
    socket.on('test', (data, ack) => {
        ChatController.handleTest(socket, data, ack);
    });

    socket.on('ping_check', (data, ack) => {
        ChatController.handlePingCheck(socket, data, ack);
    });

    // Protected routes (require authentication)
    socket.on('join_doubt_room', (data, ack) => {
        requireAuth(socket, () => {
            validateSocketData(validationSchemas.joinRoom)(socket, data, () => {
                ChatController.handleJoinRoom(socket, data, ack);
            });
        });
    });

    socket.on('send_message', (data, ack) => {
        requireAuth(socket, () => {
            validateSocketData(validationSchemas.sendMessage)(socket, data, () => {
                ChatController.handleSendMessage(socket, data, ack);
            });
        });
    });

    socket.on('check_missed_messages', (data, ack) => {
        requireAuth(socket, () => {
            ChatController.handleCheckMissedMessages(socket, data, ack);
        });
    });

    socket.on('typing_status', (data) => {
        requireAuth(socket, () => {
            ChatController.handleTypingStatus(socket, data);
        });
    });

    // Handle disconnect
    socket.on('disconnect', () => {
        ChatController.handleDisconnect(socket);
    });
};

// REST API routes for chat
export const setupChatAPIRoutes = (router) => {
    // Send message with files (multipart/form-data)
    router.post('/send-message', uploadMiddleware.array('files', 5), sendMessageWithFiles);
    
    return router;
};
