import jwt from "jsonwebtoken";
import Student from "../models/student.model.js";

export const profileAuthentication = async (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;
        let token = null;

        if (authHeader && authHeader.startsWith('Bearer ')) {
            token = authHeader.split(' ')[1];
        }

        if (!token && req.cookies && req.cookies.accessToken) {
            token = req.cookies.accessToken;
        }

        if (!token) {
            return res.status(401).json({
                success: false,
                message: "Access token is required"
            });
        }

        const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);

        const student = await Student.findById(decoded.userId).select('-password -refreshToken');

        if (!student) {
            return res.status(401).json({
                success: false,
                message: "Invalid access token"
            });
        }

        if (!student.isVerified) {
            return res.status(403).json({
                success: false,
                message: "Please verify your account first"
            });
        }

        req.student = student;
        next();
    } catch (error) {
        if (error.name === 'JsonWebTokenError') {
            return res.status(401).json({
                success: false,
                message: "Invalid access token"
            });
        }

        if (error.name === 'TokenExpiredError') {
            return res.status(401).json({
                success: false,
                message: "Access token expired"
            });
        }

        console.error("Auth middleware error:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error"
        });
    }
};
