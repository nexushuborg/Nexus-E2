import mongoose, { Schema } from "mongoose";
import connection from "../configs/connectDB.js";
import { createModel } from "../utils/modelConnector.js";

const notificationSchema = new Schema({
  title: {
    type: String,
    required: true,
    trim: true,
  },
  message: {
    type: String,
    required: true,
  },
  type: {
    type: String,
    enum: ["assignment", "exam", "event", "other"],
    required: true,
  },
  sender: {
    type: Schema.Types.ObjectId,
    ref: "Teacher",
    required: true,
  },
  recipient: [
    {
      user: {
        type: Schema.Types.ObjectId,
        ref: "User",
      },
      read: {
        type: Boolean,
        default: false,
      },
      readAt: {
        type: Date,
        default: null,
      },
    },
  ],
  section: {
    type: Schema.Types.ObjectId,
    ref: "Section",
    required: true,
  },
  related_item: {
    item_type: {
      type: String,
      enum: ["assignment", "exam", "event"],
      required: true,
    },
    item_id: {
      type: Schema.Types.ObjectId,
      required: true,
    }
  },
  expireAt: {
    type: Date,
    default: null,
  }
},{
    timestamps: true,
});

const Notification = createModel("Notification", notificationSchema, "main");
export default Notification;