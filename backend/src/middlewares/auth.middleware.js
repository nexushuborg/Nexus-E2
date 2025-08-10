import userModel from "../models/user.model.js";
import bcrypt from "bcrypt"
import jwt from "jsonwebtoken"
import blacklistTokenModel from "../models/blacklisttoken.model.js";

export const authUser = async (req,res,next) => {
    const token = req.cookies.token || req.headers.authorization?.split(' ')[1];
    if(!token){
        return res.status(401).json({message:'Unauthorised'});
    }
    const isBlackListed = await blacklistTokenModel.findOne({token:token});
    if(isBlackListed){
        return res.status(401).json({message:"Unauthorised"})
    }
    try{
        const decoded = jwt.verify(token,process.env.JWT_SECRET);
        const user = await userModel.findById(decoded._id);
        req.user = user;
        next();
    }catch(error){
        return res.status(401).json({message:'Unauthorized'})
    }
}