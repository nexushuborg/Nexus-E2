import mongoose from 'mongoose';
import connection from '../configs/connectDB.js';
import { createModel } from "../utils/modelConnector.js";


const departmentSchema = new mongoose.Schema({
    name:{
        type: String,
        required: true,
        unique: true,
    },
    short_name: {
        type: String,
        required: true,
    },
    hod:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "Teacher",
    }
},{
    timestamps: true,
})

const Department = createModel("Department", departmentSchema, "main");
export default Department;