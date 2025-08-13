import jwt from 'jsonwebtoken';
import Student from '../models/student.model.js';

export const verifyJWT = async (req, res, next) => {
    try {
        const token = req.cookies?.accessToken || req.header("Authorization")?.replace("Bearer ", "");

        if (!token) {
            return res.status(401).json({
                success: false,
                message: "Unauthorized request - No token provided"
            });
        }

        const decodedToken = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);

        const student = await Student.findById(decodedToken?.userId)
            .select("-password -refreshToken")
            .populate('section', 'section_name')
            .populate('degree', 'short_name name')
            .populate('branch', 'short_name name');

        if (!student) {
            return res.status(401).json({
                success: false,
                message: "Invalid access token - Student not found"
            });
        }

        if (!student.isVerified) {
            return res.status(403).json({
                success: false,
                message: "Account not verified. Please verify your account first."
            });
        }

        req.user = student;
        req.student = student;

        next();

    } catch (error) {
        console.error("JWT Verification Error:", error.message);

        if (error.name === 'TokenExpiredError') {
            return res.status(401).json({
                success: false,
                message: "Access token expired. Please login again."
            });
        } else if (error.name === 'JsonWebTokenError') {
            return res.status(401).json({
                success: false,
                message: "Invalid access token format"
            });
        } else {
            return res.status(401).json({
                success: false,
                message: "Token verification failed"
            });
        }
    }
};
