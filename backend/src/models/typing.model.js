import mongoose from "mongoose";
import { createModel } from "../utils/modelConnector.js";

const typingStatusSchema = new mongoose.Schema({
  roomId: {
    type: String,
    required: true,
    index: true,
  },
  userId: {
    type: String,
    required: true,
    index: true,
  },
  isTyping: {
    type: Boolean,
    default: true,
  },
  startedAt: {
    type: Date,
    default: Date.now,
  },
  expiresAt: { type: Date, default: Date.now, expires: 10 },
});

const TypingStatus = createModel("TypingStatus", typingStatusSchema, "chat");
export default TypingStatus;
