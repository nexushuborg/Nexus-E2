import mongoose,{Schema} from "mongoose";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import connection from "../configs/connectDB.js";
import { createModel } from "../utils/modelConnector.js";

const teacherSchema = new Schema({
    full_name:{
        type: String,
        required: true,
        trim: true,
    },
    profile_picture: {
        Image:{
            type: String,
            default: "https://res.cloudinary.com/dzqj1xk2h/image/upload/v1709301234/default_profile_picture.png"
        },
        publicId:{
            type: String,
            default: null,
        }
    },
    section:[
        {
            type:Schema.Types.ObjectId,
            ref: "Section",

        }
    ],
    email:{
        type: String,
        required: true,
        unique: true,
        trim: true,
        //mail must end wuth @soa.du.in
        match: [/^[a-zA-Z0-9._%+-]+@soa\.du\.in$/, "Please enter a valid SOA email address"]
    },
    password:{
        type: String,
        required: true,
        minlength: 8,
         //password should contain at least one uppercase letter, one lowercase letter, one number, and one special character
        validate: {
            validator: function(v) {
                return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/.test(v);
            },
            message: props => `${props.value} is not a valid password!`
        }
    },
    isVerified:{
        type: Boolean,
        default: false,
    },
    department:{
        type: Schema.Types.ObjectId,
        ref: "Department",
    },
    designation:{
        type: String,
        trim: true,
    },
    gender:{
        type: String,
        enum :["male","female"],
        required: true,
    },
    subjects:[
        {
            type: Schema.Types.ObjectId,
            ref: "Subject",
        }
    ],
    refreshToken :{
        type: String,
        default: null,
    },
    status: {
        type: String,
        enum: ['online', 'offline', 'away', 'busy'],
        default: 'offline'
    },
    lastSeen: { type: Date, default: Date.now },
    socketId: { type: String, default: null }, 
    createdAt: { type: Date, default: Date.now },

},{
    timestamps: true,
})


teacherSchema.pre("save",async function(next){
    if(!this.isModified("password")){
        return next();
    }

    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
})

teacherSchema.methods.comparePassword = async function(candidatePassword) {
    return await bcrypt.compare(candidatePassword, this.password);
}

teacherSchema.methods.generateAccessToken = function() {
    return jwt.sign({ id: this._id, email: this.email }, process.env.ACCESS_TOKEN_SECRET, { expiresIn: '1d' });
}

teacherSchema.methods.generateRefreshToken = function() {
    return jwt.sign({ id: this._id, email: this.email }, process.env.REFRESH_TOKEN_SECRET, { expiresIn: '30d' });
}

const Teacher = createModel("Teacher", teacherSchema, "main");
export default Teacher;


