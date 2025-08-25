import mongoose,{Schema} from "mongoose";
import jwt from "jsonwebtoken";
import bcrypt from "bcryptjs";
import connection from "../configs/connectDB.js";
import { createModel } from "../utils/modelConnector.js";


const studentSchema = new Schema({
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
        }
    },
    password:{
        type: String,
        required: true,
        minlength: 8,
        //password should contain at least one uppercase letter, one lowercase letter, one number, and one special character
        validate: {
            validator: function(v) {
                // Skip validation if password is already hashed (starts with $2b$)
                if (v.startsWith('$2b$')) {
                    return true;
                }

                return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/.test(v);
            },
            message: props => `${props.value} is not a valid password!`
        }
    },
    reg_no :{
        type: String,
        required: true,
        unique: true,
        trim: true,
    },
    slno:{
        type: Number,
        required: true,
    },
    section:{
      type:Schema.Types.ObjectId,
      ref: "Section",
    },
    is_cr:{
       type:Boolean,
       default: false,
    },
    email:{
        type: String,
        required: true,
        unique: true,
        trim: true,
    },
    phoneNo:{
        type: String,
        required: true,
        unique: true,
    },
    isVerified:{
        type: Boolean,
        default: false,
    },
    degree:{
        type: Schema.Types.ObjectId,
        ref: "Degree",
        required: true,
    },
    branch:{
        type:Schema.Types.ObjectId,
        ref: "Branch",
        required: true,
    },
    //we will have i mean 2027 batch means they will graduate in 2027
    batch:{
        type: Number,
        required: true,
    },
    currentYear:{
        type: Number,
        // required: true,
    },
    gender:{
        type: String,
        enum:["male","female"],
        required: true,
    },
    refreshToken:{
        type: String,
        default: null,
    },
    status: {
        type: String,
        enum: ['online', 'offline', 'away', 'busy'],
        default: 'offline'
    },
    lastSeen: { type: Date, default: Date.now },
    socketId: { type: String, default: null }, // Current socket connection
    createdAt: { type: Date, default: Date.now },
},{
    timestamps: true,
})

studentSchema.pre("save",async function(next){
    if(!this.isModified("password")) return next();
    try {
        const salt = await bcrypt.genSalt(10);
        this.password = await bcrypt.hash(this.password,salt);
        next();
    } catch (error) {
        next(error);
    }
})

studentSchema.methods.comparePassword = async function (givenPassword) {
    return await bcrypt.compare(givenPassword, this.password);
}

//Access token generation
studentSchema.methods.generateAccessToken = function () {
    return jwt.sign(
        {
            userId: this._id,
        },
        process.env.ACCESS_TOKEN_SECRET,
        { expiresIn: "1d" }
    )
}


studentSchema.methods.generateRefreshToken = function () {
    return jwt.sign(
        {
            userId: this._id,
        },
        process.env.REFRESH_TOKEN_SECRET,
        { expiresIn: "30d" }
    )
}


const Student = createModel("Student", studentSchema, "main");

export default Student;