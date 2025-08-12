import mongoose,{Schema} from "mongoose";


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
                return /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/.test(v);
            },
            message: props => `${props.value} is not a valid password!`
        }
    },
    role:{
        type:String,
        enum :["student","teacher","admin"],
        required :true,

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
      required: true,
    },
    cr:{
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
    gender:{
        type: String,
        enum:["male","female"],
        required: true,
    },
    user_id:{
        type: Schema.Types.ObjectId,
        ref: "User",
        required: true,
    },
    refreshToken:{
        type: String,
        default: null,
    }
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
            role: this.role,
        },
        process.env.ACCESS_TOKEN_SECRET,
        { expiresIn: "1d" }
    )
}


studentSchema.methods.generateRefreshToken = function () {
    return jwt.sign(
        {
            userId: this._id,
            role: this.role,
        },
        process.env.REFRESH_TOKEN_SECRET,
        { expiresIn: "7d" }
    )
}


const Student = mongoose.model("Student", studentSchema);

export default Student;