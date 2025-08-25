import mongoose from "mongoose";
import connection from "../configs/connectDB.js";
import { createModel } from "../utils/modelConnector.js";

const subjectSchema = new mongoose.Schema({
  subject_code: {
    type: String,
    required: true,
    unique: true,
  },
  subject_name: {
    type: String,
    required: true,
    trim: true,
  },
  short_name: {
    type: String,
    required: true,
    trim: true,
  },
  subj_faculty: [
    {
      teacher: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Teacher",
      },
      sections: [
        {
          type: mongoose.Schema.Types.ObjectId,
          ref: "Section",
        },
      ],
    },
  ],
  class_notes: [
    {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Notes",
    },
  ],
}, {
  timestamps: true,
});

// Register the model with the connection
if (connection.main) {
  connection.main.model("Subject", subjectSchema);
}

// Get the model using the proxy approach for safe access
const Subject = createModel("Subject", subjectSchema, "main");
export default Subject;