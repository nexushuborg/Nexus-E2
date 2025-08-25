import mongoose from 'mongoose';
import { createModel } from '../utils/modelConnector.js';


// Active Sessions Schema (Redis-like functionality)
const sessionSchema = new mongoose.Schema({
  userId: {
    type: String,
    required: true,
    unique: true,
    index: true,
  },
  socketId: {
    type: String,
    required: true,
  },
  status: {
    type: String,
    default: "online",
  },
  connectedAt: {
    type: Date,
    default: Date.now,
  },
  lastActivity: {
    type: Date,
    default: Date.now,
  },
  // TTL index - MongoDB will auto-delete after 30 minutes of inactivity
  expiresAt: {
    type: Date,
    default: Date.now,
    expires: 1800,
  },
});

const Session = createModel("Session", sessionSchema, "chat");
export default Session;