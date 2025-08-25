import mongoose, { Schema } from "mongoose";
import connection from "../configs/connectDB.js";
import { createModel } from "../utils/modelConnector.js";


const notesSchema = new Schema(
  {
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
    files: [
      {
        file_id: { type: String, required: true },
        message_id: { type: String, required: true },
        original_name: { type: String, trim: true },
        mime_type: { type: String, trim: true },
        file_size: { type: Number },
        created_at: { type: Date, default: Date.now },
      },
    ],
    category: {
      type: String,
      enum: ["notes", "assignment", "quiz", "lab", "pyq", "project", "other"],
      required: true,
      default: "notes",
    },
    chapter: {
      type: Schema.Types.ObjectId,
      ref: "Chapter",
      required: true,
    },
    subject: {
      type: Schema.Types.ObjectId,
      ref: "Subject",
      required: true,
    },
    teacher: {
      type: Schema.Types.ObjectId,
      ref: "Teacher",
      required: true,
    },
    section: {
      type: Schema.Types.ObjectId,
      ref: "Section",
      required: true,
    },
    is_pyq: {
      type: Boolean,
      default: false,
    },
    exam_year: {
      type: Number,
    },
    semester: {
      type: Number,
      enum: [1, 2, 3, 4, 5, 6, 7, 8],
    },
  },
  {
    timestamps: true,
  }
);

// Indexes
notesSchema.index({ subject: 1, chapter: 1 });
notesSchema.index({ title: "text", description: "text" });

const Notes = createModel("Notes", notesSchema, "main");
export default Notes;