import jwt from 'jsonwebtoken';
import Student from '../models/student.model.js';
import blacklistTokenModel from '../models/blacklisttoken.model.js';

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

export const authenticateToken = async (req, res, next) => {
    try {
        const authHeader = req.headers.authorization;

        if (!authHeader || !authHeader.startsWith('Bearer ')) {
            return res.status(401).json({
                success: false,
                message: "Access denied. No token provided."
            });
        }

        const token = authHeader.split(' ')[1];

        const blacklistedToken = await blacklistTokenModel.findOne({ token });

        if (blacklistedToken) {
            return res.status(401).json({
                success: false,
                message: "Token has been revoked. Please login again."
            });
        }

        const decoded = jwt.verify(token, process.env.ACCESS_TOKEN_SECRET);

        const student = await Student.findById(decoded.id).select('-password -refreshToken');

        if (!student) {
            return res.status(401).json({
                success: false,
                message: "User not found"
            });
        }

        if (!student.isVerified) {
            return res.status(403).json({
                success: false,
                message: "Account not verified"
            });
        }

        req.user = decoded;
        req.student = student;
        next();

    } catch (error) {
        if (error.name === 'TokenExpiredError') {
            return res.status(401).json({
                success: false,
                message: "Access token has expired"
            });
        } else if (error.name === 'JsonWebTokenError') {
            return res.status(401).json({
                success: false,
                message: "Invalid access token"
            });
        } else {
            console.error("Authentication error:", error);
            return res.status(500).json({
                success: false,
                message: "Authentication failed"
            });
        }
    }
};