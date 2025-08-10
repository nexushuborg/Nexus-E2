import mongoose from "mongoose";
import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";

const userSchema = mongoose.Schema({
    fullname:{
        firstname:{
            type:String,
            required:true,
        },
        lastname:{
            type:String,
        }
    },
    email:{
        type:String,
        required:true,
        unique:true
    },
    password:{
        type:String,
        required:true,
        select:false,
        min:[6,"password must be 6 characters long"]
    },
    regnumber:{
        type:String,
        required:true,
        unique:true
    },
    profilepic : {
        Image: String,
        ImageId:String
    }
})

userSchema.methods.generateAuthToken = function(){
    const token = jwt.sign({ _id: this._id }, process.env.JWT_SECRET,{expiresIn:'24h'});
    return token;
}

userSchema.methods.comparePassword = async function(password){
    return await bcrypt.compareSync(password, this.password);
}

userSchema.statics.hashPassword = async function(password){
    return await bcrypt.hashSync(password, 10);
}

const userModel = mongoose.model('user',userSchema)
export default userModel;