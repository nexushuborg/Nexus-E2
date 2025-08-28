import mongoose, { Schema } from "mongoose";
import { createModel } from "../utils/modelConnector.js";

const doubtSchema = new Schema({
  title: {
    type: String,
    required: true,
    trim: true,
  },
  description: {
    type: String,
    required: true,
    trim: true,
  },
  subject: {
    type: Schema.Types.ObjectId,
    ref: "Subject",
    required: true,
  },
  student: {
    type: Schema.Types.ObjectId,
    ref: "Student",
    required: true,
  },
  teacher: {
    type: Schema.Types.ObjectId,
    ref: "Teacher",
    required: true,
  },
  status: {
    type: String,
    enum: ["resolved", "unresolved"],
    default: "unresolved",
  },
  roomId: {
    type: String,
    required: true,
    unique: true,
  },
  lastActivity: {
    type: Date,
    default: Date.now,
  },
}, {
  timestamps: true,
});

doubtSchema.methods.isMember = function(userId,num) {
  if(num === 0){
    return this.student.equals(userId);
  }else{
    return this.teacher.equals(userId);
  }
}

const Doubt = createModel("Doubt", doubtSchema, "main");
export default Doubt;
