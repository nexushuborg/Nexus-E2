import mongoose from "mongoose";
import connection from "../configs/connectDB.js";
import { createModel } from "../utils/modelConnector.js";

const branchSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    short_name: {
        type: String,
        required: true,
    },
    degree: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Degree",
        required: true,
    },
}, {
    timestamps: true,
});
const Branch = createModel("Branch", branchSchema, "main");
export default Branch;