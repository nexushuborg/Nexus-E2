import mongoose from 'mongoose';
import { createModel } from '../utils/modelConnector.js';
const roomSchema = new mongoose.Schema({
    conversationId: {
        type: String,
        required: true,
        unique: true,
        index: true
    },
    participants: [{
        type: String,
        required: true,
        index: true
    }], // Array of userIds
    type: {
        type: String,
        enum: ['direct', 'group'],
        default: 'direct'
    },
    createdBy: {
        type: String,
        required: true
    },
    lastMessage: {
        messageId: String,
        text: String,
        senderId: String,
        timestamp: Date
    },
    unreadCount: {
        type: Map,
        of: Number,
        default: {}
    },
    isActive: { type: Boolean, default: true },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
});

const Room = createModel("Room", roomSchema, "chat");
export default Room;