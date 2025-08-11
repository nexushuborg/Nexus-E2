import mongoose,{Schema} from "mongoose";

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
            required: true,
        }
    ],
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
    department:{
        type: Schema.Types.ObjectId,
        ref: "Department",
        required: true,
    },
    designation:{
        type: String,
        required: true,
        trim: true,
    },
    gender:{
        type: String,
        enum :["male","female"],
        reqyuired: true,
    },
    subjects:[
        {
            type: Schema.Types.ObjectId,
            ref: "Subject",
        }
    ],
    user_id:{
        type: Schema.Types.ObjectId,
        ref: "User",
        required: true,
    }

},{
    timestamps: true,
})

const Teacher = mongoose.model("Teacher", teacherSchema);
export default Teacher;