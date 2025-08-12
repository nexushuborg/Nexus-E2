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
        }
    ],
    students:[
        {
            type: Schema.Types.ObjectId,
            ref: "Student",
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