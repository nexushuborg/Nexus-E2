import mongoose from "mongoose";
import connection from "../configs/connectDB.js";
import { createModel } from "../utils/modelConnector.js";

const degreeSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        unique:true
    },
    short_name:{
        type: String,
        required: true,
    },
    duration_years:{
        type: Number,
        required: true,
    }
},{
    timestamps: true,
})

const Degree = createModel("Degree", degreeSchema, "main");
export default Degree;