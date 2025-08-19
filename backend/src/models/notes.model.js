import mongoose, { Schema } from "mongoose";

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
        file_id: { type: String, required: true }, // Telegram file_id
        message_id: { type: String, required: true }, // Telegram message id (needed for deletion)
        original_name: { type: String, trim: true }, // original filename
        mime_type: { type: String, trim: true }, // pdf, png, doc etc
        file_size: { type: Number }, // size in bytes
      },
    ],
    category: {
      type: String,
      enum: [
        "notes",
        "assignment",
        "quiz",
        "lab",
        "pyq",
        "project",
        "other",
      ],
      required: true,
      trim: true,
      default: "notes",
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


notesSchema.index({
  subject: 1,
  teacher: 1,
  section: 1,
});

notesSchema.index({
  title: "text",
  description: "text",
});

const Notes = mongoose.model("Notes", notesSchema);

export default Notes;
