import mongoose,{Schema} from "mongoose";


const sectionSchema = new Schema({
    section_name:{
        type: String,
        required: true,
        trim: true,
    },
    batch:{
        type:Number,
        required: true,
    },
    degree:{
        type: Schema.Types.ObjectId,
        ref: "Degree",
        required: true,
    },
    branch:{
        type: Schema.Types.ObjectId,
        ref: "Branch",
        required: true,
    },
    faculty:[
        {
            type: Schema.Types.ObjectId,
            ref: "Teacher",
            required: true,
        }
    ],
    students:[
        {
            type: Schema.Types.ObjectId,
            ref: "Student",
            required: true,
        }
    ],
    strength:{
        type: Number,
        default: 0
    }
},{
    timestamps: true,
})

const Section = mongoose.model("Section", sectionSchema);

export default Section;