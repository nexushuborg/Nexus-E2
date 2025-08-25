import mongoose from 'mongoose';
import { createModel } from '../utils/modelConnector';

const messageSchema = new mongoose.Schema({
    messageId: {
        type: String,
        required: true,
        unique: true,
        index: true
    },
    conversationId: {
        type: String,
        required: true,
        index: true
    },
    senderId: {
        type: String,
        required: true,
        index: true
    },
    senderUsername: {
        type: String,
        required: true
    },
    text: {
        type: String,
        required: true
    },
    type: {
        type: String,
        enum: ['text', 'image', 'file', 'audio', 'video'],
        default: 'text'
    },
    status: {
        type: String,
        enum: ['sent', 'delivered', 'read'],
        default: 'sent'
    },
    replyTo: { type: String, default: null }, // messageId being replied to
    editedAt: { type: Date, default: null },
    deletedAt: { type: Date, default: null },
    readBy: [{
        userId: String,
        readAt: { type: Date, default: Date.now }
    }],
    deliveredTo: [{
        userId: String,
        deliveredAt: { type: Date, default: Date.now }
    }],
    createdAt: { type: Date, default: Date.now, index: true }
});

const Message = createModel("Message", messageSchema, "chat");
export default Message;