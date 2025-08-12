import mongoose from "mongoose";

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

const Degree = mongoose.model("Degree", degreeSchema);

export default Degree;