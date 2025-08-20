import jwt from 'jsonwebtoken';
import Student from '../models/student.model.js';
import blacklistTokenModel from '../models/blacklisttoken.model.js';
import Teacher from "../models/teacher.model.js"

export const authStudentMiddleware = async (req,res,next) => {
    try {
        const accessToken = req.headers.authorization?.split(" ")[1] || req.cookies.accessToken;
        // console.log("Full headers:", req.headers);
        // console.log("Authorization header:", req.headers.authorization);
        // console.log("Access Token:", accessToken);
        if (!accessToken) {
            return res.status(401).json({
                success: false,
                message: "Access token required"
            });
        }
        const isBlacklisted = await blacklistTokenModel.findOne({ token: accessToken });
        if (isBlacklisted) {
            return res.status(401).json({
                success: false,
                message: "Token is revoked"
            });
        }
        const decoded = jwt.verify(accessToken, process.env.ACCESS_TOKEN_SECRET);
        const student = await Student.findById(decoded.userId).select('-password -refreshToken');
        if (!student) {
            return res.status(404).json({
                success: false,
                message: "Student not found "
            });
        }
        req.user = student;
        next();
    } catch (error) {

        console.error("Authentication error:", error);
        return res.status(401).json({
            success: false,
            message: "Invalid access token",
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }


}

export const authTeacherMiddleware = async (req, res, next) => {
    try {
        const accessToken = req.headers.authorization?.split(" ")[1] || req.cookies.accessToken;
        console.log("Full headers:", req.headers);
        console.log("Authorization header:", req.headers.authorization);
        console.log("Access Token:", accessToken);

        if (!accessToken) {
            return res.status(401).json({
                success: false,
                message: "Access token required"
            });
        }

        const isBlacklisted = await blacklistTokenModel.findOne({ token: accessToken });
        if (isBlacklisted) {
            return res.status(401).json({
                success: false,
                message: "Token is revoked"
            });
        }

        const decoded = jwt.verify(accessToken, process.env.ACCESS_TOKEN_SECRET);
        const teacher = await Teacher.findById(decoded.id).select('-password -refreshToken');

        if (!teacher) {
            return res.status(404).json({
                success: false,
                message: "Teacher not found"
            });
        }

        req.user = teacher;
        next();
    } catch (error) {
        console.error("Authentication error:", error);
        return res.status(401).json({
            success: false,
            message: "Invalid access token",
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
}