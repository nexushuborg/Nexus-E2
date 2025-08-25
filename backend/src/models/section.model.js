import mongoose,{Schema} from "mongoose";
import connection from "../configs/connectDB.js";
import { createModel } from "../utils/modelConnector.js";

const sectionSchema = new Schema({
  section_name: {
    type: String,
    required: true,
    trim: true,
  },
  batch: {
    type: Number,
    required: true,
  },
  degree: {
    type: Schema.Types.ObjectId,
    ref: "Degree",
    required: true,
  },
  branch: {
    type: Schema.Types.ObjectId,
    ref: "Branch",
    // required: true,
  },
  faculty: [
    {
      teacher: {
        type: Schema.Types.ObjectId,
        ref: "Teacher",
      },
      subjects: [
        {
          type: Schema.Types.ObjectId,
          ref: "Subject",
        },
      ],
    },
  ],
  students: [
    {
      type: Schema.Types.ObjectId,
      ref: "Student",
    },
  ],
  cr:[
    {
      type: Schema.Types.ObjectId,
      ref: "Student",
    }
  ],
  strength: {
    type: Number,
    default: 0,
  },
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true },
});



sectionSchema.methods.isTeacherInSection = function(teacherId) {
  return this.faculty.some(f => 
    f.teacher && f.teacher.toString() === teacherId.toString()
  );
};

const Section = createModel("Section", sectionSchema, "main");
export default Section;