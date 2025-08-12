import mongoose from "mongoose";

const branchSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    short_name: {
        type: String,
        required: true,
    },
    degree: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Degree",
        required: true,
    },
}, {
    timestamps: true,
});
const Branch = mongoose.model("Branch", branchSchema);
export default Branch;