import mongoose, { Mongoose } from "mongoose";
import connection from "../configs/connectDB.js";
import { createModel } from "../utils/modelConnector.js";

const blacklistTokenSchema = new mongoose.Schema({
    token:{
        type:String,
        required:true,
        unique:true
    },
    createdAt:{
        type:Date,
        default:Date.now,
        expires:86400 //24 ghanta
    }
});

const blacklistTokenModel = createModel('BlacklistToken', blacklistTokenSchema, "main");
export default blacklistTokenModel;