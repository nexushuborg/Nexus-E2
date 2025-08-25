import mongoose,{Schema} from "mongoose";
import connection from "../configs/connectDB.js";
import { createModel } from "../utils/modelConnector.js";


const assignmentSchema = new Schema({
    title: {
        type: String,
        required: true,
        trim: true
    },
    description:{
        type: String,
        required: true,
        trim: true
    },
    subject:{
        type: Schema.Types.ObjectId,
        ref: "Subject",
        required: true
    },
    teacher:{
        type: Schema.Types.ObjectId,
        ref: "Teacher",
        required: true
    },
    section:{
        type: Schema.Types.ObjectId,
        ref: "Section",
        required: true
    },
    deadline:{
        type: Date,
        required: true
    },
    instruction:{
        type: String,
    },
    status:{
        type: String,
        enum: ["active", "completed", "overdue"],
        default: "active"
    },

},{
    timestamps: true
})

const Assignment = createModel("Assignment", assignmentSchema, "main");
export default Assignment;