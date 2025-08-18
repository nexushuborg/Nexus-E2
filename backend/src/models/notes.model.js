import monogoose,{Schema} from 'mongoose';

const notesSchema = new Schema({
    title:{
        type:String,
        required:true,
        trim:true
    },
    description:{
        type:String,
        required:true,
        trim:true
    },
    file_url:{
        type:String,
        required:true,
        trim:true
    },
    file_type:{
        type:String,
        enum:["pdf","doc","txt","docx","ppt","pptx","jpeg","png"],
        required:true,
        trim:true
    },
    subject:{
        type:Schema.Types.ObjectId,
        ref:"Subject",
        required:true
    },
    teacher:{
        type:Schema.Types.ObjectId,
        ref:"Teacher",
        required:true
    },
    section:{
        type:Schema.Types.ObjectId,
        ref:"Section",
        required:true
    },
    is_pyq:{
        type:Boolean,
        default:false
    },
    exam_year:{
        type:Number
    },
    semester:{
        type:Number,
        enum:[1,2,3,4,5,6,7,8]
    }
},{
    timestamps:true
})

//Indexing krlo bhaiya for faster search
notesSchema.index(
    {
        subject:1,
        tecaher:1,
        section:1
    }
)

notesSchema.index(
    {
        title:"text",
        description:"text"
    }
)

const Notes = monogoose.model("Notes",notesSchema);

export default Notes;