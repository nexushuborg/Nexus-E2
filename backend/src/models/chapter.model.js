import mongoose,{Schema} from "mongoose";
import connection from "../configs/connectDB.js";
import { createModel } from "../utils/modelConnector.js";


const chapterSchema = new Schema({
  chapter_no: {
    type: String,
    required: true,
    trim: true,
  },
  chapter_name: {
    type: String,
    required: true,
    trim: true,
  },
  subject: {
    type: Schema.Types.ObjectId,
    ref: "Subject",
    required: true,
  },
  section:{
    type:Schema.Types.ObjectId,
    ref: "Section",
    required: true,
  },
  // Optional: Add sequence/ordering
  order: {
    type: Number,
    default: 0,
  },
}, {
  timestamps: true,
});

chapterSchema.index({ subject: 1, chapter_no: 1 }, { unique: true });
chapterSchema.index({ subject: 1, order: 1 });

const Chapter = createModel("Chapter", chapterSchema, "main");
export default Chapter;