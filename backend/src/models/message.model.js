import mongoose from 'mongoose';
import { createModel } from '../utils/modelConnector.js';

const messageSchema = new mongoose.Schema({
    roomId: {
        type: String,
        required: true,
        index: true
    },
    sender: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        refPath: 'senderModel',
        index: true
    },
    senderModel: {
        type: String,
        required: true,
        enum: ['Student', 'Teacher']
    },
    content: {
        encryptedMessage: String,
        key: String,
        iv: String
    },
    messageType: {
        type: String,
        enum: ['text', 'file'],
        default: 'text'
    },
    file: {
        type: String // Telegram file ID
    },
    status: {
        type: String,
        enum: ['sent', 'delivered', 'read'],
        default: 'sent'
    },
    createdAt: {
        type: Date,
        default: Date.now,
        index: true
    }
});

const Message = createModel("Message", messageSchema, "chat");
export default Message;