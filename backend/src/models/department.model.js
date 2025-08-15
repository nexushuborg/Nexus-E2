import mongoose from 'mongoose';


const departmentSchema = new mongoose.Schema({
    name:{
        type: String,
        required: true,
        unique: true,
    },
    short_name: {
        type: String,
        required: true,
    },
    hod:{
        type: mongoose.Schema.Types.ObjectId,
        ref: "Teacher",
    }
},{
    timestamps: true,
})

const Department = mongoose.model("Department", departmentSchema);
export default Department;