import mongoose from 'mongoose';
import { createModel } from '../utils/modelConnector.js';

const pendingMessageSchema = new mongoose.Schema({
    userId: { type: String, index: true, required: true },
    roomId: { type: String, index: true, required: true },
    payload: { type: Object, required: true },
    createdAt: { type: Date, default: Date.now },
    // Auto-expire pending messages after 7 days as a safeguard
    expiresAt: { type: Date, default: () => new Date(Date.now() + 7 * 24 * 60 * 60 * 1000), expires: 60 * 60 * 24 * 7 }
});

const PendingMessage = createModel('PendingMessage', pendingMessageSchema, 'chat');
export default PendingMessage;

