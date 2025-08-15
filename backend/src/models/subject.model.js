import mongoose from "mongoose";

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

const Subject = mongoose.model("Subject", subjectSchema);
export default Subject;