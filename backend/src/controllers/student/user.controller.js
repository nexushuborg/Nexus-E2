import Section from "../../models/section.model.js";
import Branches from "../../models/branch.model.js";
import Degree from "../../models/degree.model.js"
import Student from "../../models/student.model.js";
import { redisClient } from "../../configs/connectRedis.js"
import { sendOTP } from "../../services/sendmail.js"
import blacklistTokenModel from "../../models/blacklisttoken.model.js";
import jwt from "jsonwebtoken";
import Notes from "../../models/notes.model.js"
import { bot } from "../../configs/connectTelegram.js"
import axios from "axios";
import https from "https";
import http from "http";
import { Stream } from "stream";
import Chapter from "../../models/chapter.model.js";
import Subject from "../../models/subject.model.js";

export const registerStudent = async (req, res) => {
    try {
        console.log("Register endpoint hit - Incoming cookies:", req.cookies);

        const { full_name, password, reg_no, slno, email, phoneNo, degree, branch, batch, gender } = req.body;

        if (!full_name || !password || !reg_no || !slno || !email || !phoneNo || !degree || !branch || !batch || !gender) {
            return res.status(400).json({
                success: false,
                message: "Please fill all the fields"
            })
        }

        const existingStudent = await Student.findOne({
            $or: [
                { reg_no },
                { phoneNo },
                { email }

            ]
        })

        if (existingStudent) {
            return res.status(400).json({
                success: false,
                message: "Student already exists"
            })
        }

        const existingDegree = await Degree.findOne({
            $or: [
                { name: degree },
                { short_name: degree }
            ]
        });

        if (!existingDegree) {
            return res.status(400).json({
                success: false,
                message: "Degree not found"
            })
        }

        const existingBranch = await Branches.findOne({
            $or: [
                { name: branch },
                { short_name: branch }
            ]
        });
        if (!existingBranch) {
            return res.status(400).json({
                success: false,
                message: "Branch not found"
            })
        }

        // let checkedSection = await Section.findOne({
        //     section_name: section,
        //     batch,
        //     degree: existingDegree._id,
        //     branch: existingBranch._id
        // })

        // if (!checkedSection) {
        //     checkedSection = await Section.create({
        //         section_name: section,
        //         batch,
        //         degree: existingDegree._id,
        //         branch: existingBranch._id
        //     })
        // }

        // Calculate current year based on batch
        const currentYear = new Date().getFullYear();
        const yearOfAdmission = batch - 4; // Assuming 4-year course
        const currentYearOfStudy = Math.min(4, Math.max(1, currentYear - yearOfAdmission));

        const student = await Student.create({
            full_name,
            password,
            reg_no,
            slno,
            // section: checkedSection._id,
            email,
            phoneNo,
            degree: existingDegree._id,
            branch: existingBranch._id,
            batch,
            gender,
            currentYear: currentYearOfStudy
        })



        //generate otp and send that

        //6digits
        const otp = Math.floor(100000 + Math.random() * 900000).toString();

        redisClient.set(`otp:${email}`, otp, "EX", 300) //5 minutes expiry

        //To cool down otp request for 60s means next otp will called after 60s
        redisClient.set(`otp_limit:${email}`, "sent", "EX", 60);

        //send otp to email
        const response = await sendOTP(email, otp);
        if (!response.success) {
            return res.status(500).json({
                success: false,
                message: "Failed to send OTP , please try again later"
            })
        }

        return res.status(201).json({
            success: true,
            message: "Student registered successfully",
        })

    } catch (error) {
        console.log("Register endpoint error - Response cookies:", res.getHeaders());
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error.message
        });
    }
}


export const verifyAuthOtp = async (req, res) => {
    try {
        const { email, otp } = req.body;
        if (!email || !otp) {
            return res.status(400).json({
                success: false,
                message: "Please provide email and otp"
            })
        }
        const otpFromCache = await redisClient.get(`otp:${email}`);
        if (!otpFromCache) {
            return res.status(400).json({
                success: false,
                message: "OTP expired or not found"
            })
        }
        if (otpFromCache !== otp) {
            return res.status(400).json({
                success: false,
                message: "Invalid OTP"
            })
        }

        if (otp.length !== 6) {
            return res.status(400).json({
                success: false,
                message: "OTP must be 6 digits long"
            })
        }

        const student = await Student.findOneAndUpdate(
            { email },
            {
                isVerified: true
            },
            {
                new: true,
                runValidators: false
            }
        )
        if (!student) {
            return res.status(404).json({
                success: false,
                message: "Student not found"
            })
        }

        const accessToken = student.generateAccessToken();
        const refreshToken = student.generateRefreshToken();

        student.refreshToken = refreshToken;
        await student.save({ validateBeforeSave: false });// why we are not validating here? because we already validated in register endpoint

        //clear otp from cache
        await redisClient.del(`otp:${email}`);
        await redisClient.del(`otp_limit:${email}`);

        const authenticatedUser = await Student.findById(student._id)
            .select("-password -v -refreshToken -v")
            .populate("degree", "short_name name")
            .populate("branch", "short_name name")
            .populate("section", "section_name");

        return res.cookie("refreshToken", refreshToken, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'lax'//why we are using lax instead of strict? because we want to allow cross-site requests for this cookie
        }).status(200).json({
            success: true,
            message: "OTP verified successfully",
            student: authenticatedUser,
            accessToken,
        })

    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error.message
        });
    }
}

export const resendAuthOtp = async (req, res) => {
    try {
        const { email } = req.body;
        if (!email) {
            return res.status(400).json({
                success: false,
                message: "Please provide email"
            })
        }
        const otpLimit = await redisClient.get(`otp_limit:${email}`);
        if (otpLimit) {
            return res.status(429).json({
                success: false,
                message: "Please wait before requesting a new OTP"
            })
        }

        let otp = await redisClient.get(`otp:${email}`);
        if (!otp) {
            otp = Math.floor(100000 + Math.random() * 900000).toString();
            await redisClient.set(`otp:${email}`, otp, "EX", 300); //5 minutes expiry
        }
        //send otp to email
        const response = await sendOTP(email, otp);
        if (!response.success) {
            return res.status(500).json({
                success: false,
                message: "Failed to send OTP , please try again later"
            })
        }
        //To cool down otp request for 60s means next otp will called after 60s
        await redisClient.set(`otp_limit:${email}`, "sent", "EX", 60);

        return res.status(200).json({
            success: true,
            message: "OTP sent successfully",
        })
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error.message
        });

    }
}

export const loginController = async (req, res) => {
    try {
        const { email, reg_no, password } = req.body;

        //email aur reg_no dono optional hai
        if (!email && !reg_no) {
            return res.status(400).json({
                success: false,
                message: "Please provide email or registration number"
            });
        }

        if (!password) {
            return res.status(400).json({
                success: false,
                message: "Please provide password"
            });
        }

        const student = await Student.findOne({
            $or: [
                { email: email },
                { reg_no: reg_no }
            ]
        });

        if (!student) {
            return res.status(401).json({
                success: false,
                message: "Invalid credentials mark1"
            });
        }

        const isPasswordValid = await student.comparePassword(password);

        if (!isPasswordValid) {
            return res.status(401).json({
                success: false,
                message: "Invalid credentials mark2"
            });
        }

        if (!student.isVerified) {
            return res.status(403).json({
                success: false,
                message: "Please verify your account first"
            });
        }

        const accessToken = student.generateAccessToken();
        const refreshToken = student.generateRefreshToken();

        student.refreshToken = refreshToken;
        await student.save({ validateBeforeSave: false }); // why we are not validating here? because we already validated in register endpoint

        const authenticatedUser = await Student.findById(student._id)
            .select("-password -__v -refreshToken")
            .populate("degree", "short_name name")
            .populate("branch", "short_name name")
            .populate("section", "section_name");

        return res.cookie("refreshToken", refreshToken, {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'lax'//why we are using lax instead of strict? because we want to allow cross-site requests for this cookie
        }).status(200).json({
            success: true,
            message: "Login successful",
            student: authenticatedUser,
            accessToken,
        });

    } catch (error) {
        console.error("Login error:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error.message
        });
    }
};

const cleanupExpiredTokens = async () => {
    try {
        const result = await blacklistTokenModel.deleteMany({
            createdAt: { $lt: new Date(Date.now() - 24 * 60 * 60 * 1000) } // 24 hours ago
        });
        if (result.deletedCount > 0) {
            console.log(`Cleaned up ${result.deletedCount} expired blacklisted tokens`);
        }
    } catch (error) {
        console.error('Error cleaning up expired tokens:', error);
    }
};

export const logoutController = async (req, res) => {
    try {
        const accessToken = req.headers.authorization?.split(' ')[1];
        const refreshToken = req.cookies.refreshToken; // user cannot send refresh token in body because use sameSite lax for cookie

        console.log("Full headers:", req.headers);
        console.log("Authorization header:", req.headers.authorization);

        if (!accessToken) {
            return res.status(400).json({
                success: false,
                message: "Access token is required for logout"
            });
        }

        let decoded;
        try {
            decoded = jwt.verify(accessToken, process.env.ACCESS_TOKEN_SECRET);
        } catch (error) {
            return res.status(401).json({
                success: false,
                message: "Invalid access token"
            });
        }

        // Use findByIdAndUpdate to avoid validation issues
        await Student.findByIdAndUpdate(
            decoded.userId,
            { refreshToken: null },
            { new: true }
        );

        // Blacklist the access token
        await blacklistTokenModel.create({
            token: accessToken
        });

        // Handle refresh token blacklisting if it exists
        if (refreshToken) {
            try {
                jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET);
                await blacklistTokenModel.create({
                    token: refreshToken
                });
            } catch (error) {
                console.log("Invalid refresh token during logout:", error.message);
            }
        }

        // Clear the refresh token cookie
        res.clearCookie('refreshToken', {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'lax'
        });

        // Random cleanup of expired tokens (10% chance)
        if (Math.random() < 0.1) {
            cleanupExpiredTokens().catch(err => console.error('Background cleanup failed:', err));
        }

        return res.status(200).json({
            success: true,
            message: "Logout successful"
        });

    } catch (error) {
        console.error("Logout error:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error during logout"
        });
    }
};

export const logoutAllController = async (req, res) => {
    try {
        const accessToken = req.headers.authorization?.split(' ')[1];

        if (!accessToken) {
            return res.status(400).json({
                success: false,
                message: "Access token is required"
            });
        }

        let decoded;
        try {
            decoded = jwt.verify(accessToken, process.env.ACCESS_TOKEN_SECRET);
        } catch (error) {
            return res.status(401).json({
                success: false,
                message: "Invalid access token"
            });
        }

        // Check if student exists before proceeding
        const student = await Student.findById(decoded.userId);
        if (!student) {
            return res.status(404).json({
                success: false,
                message: "Student not found"
            });
        }

        // Blacklist the current access token
        await blacklistTokenModel.create({
            token: accessToken
        });

        // Handle refresh token blacklisting
        const refreshToken = req.cookies.refreshToken || req.body.refreshToken;
        if (refreshToken) {
            try {
                jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET);
                await blacklistTokenModel.create({
                    token: refreshToken
                });
            } catch (error) {
                console.log("Invalid refresh token during logout all:", error.message);
            }
        }

        // Use findByIdAndUpdate to clear refresh token and avoid validation issues
        await Student.findByIdAndUpdate(
            decoded.userId,
            { refreshToken: null },
            { new: true }
        );

        // Clear the refresh token cookie
        res.clearCookie('refreshToken', {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'lax'
        });

        // Random cleanup of expired tokens (10% chance)
        if (Math.random() < 0.1) {
            cleanupExpiredTokens().catch(err => console.error('Background cleanup failed:', err));
        }

        return res.status(200).json({
            success: true,
            message: "Logged out from all devices successfully"
        });

    } catch (error) {
        console.error("Logout all error:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error during logout"
        });
    }
};

export const regenrateAccessToken = async (req, res) => {
    try {
        const refreshToken = req.cookies.refreshToken;
        if (!refreshToken) {
            return res.status(401).json({
                success: false,
                message: "Refresh token is required"
            });
        }


        // Check if the refresh token is blacklisted
        const isBlacklisted = await blacklistTokenModel.findOne({ token: refreshToken });
        if (isBlacklisted) {
            return res.status(401).json({
                success: false,
                message: "Token is revoked"
            })
        }

        const userSentAccessToken = req.cookies.accessToken || req.headers?.authorization?.split(' ')[1];
        console.log("dedewd", userSentAccessToken)
        if (userSentAccessToken) {
            await blacklistTokenModel.create({
                token: userSentAccessToken
            })
        }
        let decoded;
        try {
            decoded = jwt.verify(refreshToken, process.env.REFRESH_TOKEN_SECRET);
            console.log("Decoded refresh token:", decoded);
        } catch (error) {
            return res.status(401).json({
                success: false,
                message: "Invalid refresh token"
            });
        }

        const student = await Student.findById(decoded.userId);
        console.log("student ", student)
        if (!student || student.refreshToken !== refreshToken) {
            return res.status(401).json({
                success: false,
                message: "Invalid refresh token"
            });
        }
        const accessToken = student.generateAccessToken();
        return res.status(200).json({
            success: true,
            message: "Access token regenerated successfully",
            accessToken
        });

    } catch (error) {
        console.error("Regenerate access token error:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error during access token regeneration"
        });

    }
}


// Password Reset Functions
export const requestPasswordReset = async (req, res) => {
    try {
        const student = req.user;
        const { email } = student;

        const otpLimit = await redisClient.get(`reset_otp_limit:${email}`);
        if (otpLimit) {
            return res.status(429).json({
                success: false,
                message: "Please wait before requesting a new password reset OTP"
            });
        }

        const otp = Math.floor(100000 + Math.random() * 900000).toString();

        await redisClient.set(`reset_otp:${email}`, otp, "EX", 300);

        await redisClient.set(`reset_otp_limit:${email}`, "sent", "EX", 60);

        const response = await sendOTP(email, otp);
        if (!response.success) {
            await redisClient.del(`reset_otp:${email}`);
            await redisClient.del(`reset_otp_limit:${email}`);

            return res.status(500).json({
                success: false,
                message: "Failed to send password reset OTP, please try again later"
            });
        }

        return res.status(200).json({
            success: true,
            message: "Password reset OTP sent successfully to your registered email"
        });

    } catch (error) {
        console.error("Request password reset error:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};

export const verifyPasswordResetOtp = async (req, res) => {
    try {
        const student = req.user;
        const { email } = student;
        const { otp } = req.body;

        if (!otp) {
            return res.status(400).json({
                success: false,
                message: "Please provide OTP"
            });
        }

        if (typeof otp !== 'string') {
            return res.status(400).json({
                success: false,
                message: "OTP must be a string"
            });
        }

        if (otp.length !== 6) {
            return res.status(400).json({
                success: false,
                message: "OTP must be 6 digits long"
            });
        }

        if (!/^\d{6}$/.test(otp)) {
            return res.status(400).json({
                success: false,
                message: "OTP must contain only numbers"
            });
        }

        const otpFromCache = await redisClient.get(`reset_otp:${email}`);
        if (!otpFromCache) {
            return res.status(400).json({
                success: false,
                message: "Password reset OTP expired or not found"
            });
        }

        if (otpFromCache !== otp) {
            return res.status(400).json({
                success: false,
                message: "Invalid password reset OTP"
            });
        }

        const verificationToken = Math.floor(100000 + Math.random() * 900000).toString();
        await redisClient.set(`reset_verified:${email}`, verificationToken, "EX", 600); // 10 minutes validity

        await redisClient.del(`reset_otp:${email}`);

        return res.status(200).json({
            success: true,
            message: "Password reset OTP verified successfully",
            resetToken: verificationToken
        });

    } catch (error) {
        console.error("Verify password reset OTP error:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};

export const resetPassword = async (req, res) => {
    try {
        const student = req.user;
        const { email } = student;
        const { newPassword, resetToken } = req.body;

        if (!newPassword) {
            return res.status(400).json({
                success: false,
                message: "New password is required"
            });
        }

        if (typeof newPassword !== 'string') {
            return res.status(400).json({
                success: false,
                message: "New password must be a string"
            });
        }

        if (newPassword.length < 6) {
            return res.status(400).json({
                success: false,
                message: "Password must be at least 6 characters long"
            });
        }

        if (newPassword.length > 50) {
            return res.status(400).json({
                success: false,
                message: "Password must not exceed 50 characters"
            });
        }

        if (newPassword.trim() !== newPassword) {
            return res.status(400).json({
                success: false,
                message: "Password cannot start or end with whitespace"
            });
        }

        if (!resetToken) {
            return res.status(400).json({
                success: false,
                message: "Reset token is required"
            });
        }

        if (typeof resetToken !== 'string') {
            return res.status(400).json({
                success: false,
                message: "Reset token must be a string"
            });
        }

        if (resetToken.length !== 6) {
            return res.status(400).json({
                success: false,
                message: "Reset token must be 6 characters long"
            });
        }

        if (!/^\d{6}$/.test(resetToken)) {
            return res.status(400).json({
                success: false,
                message: "Reset token must contain only numbers"
            });
        }

        const verificationToken = await redisClient.get(`reset_verified:${email}`);
        if (!verificationToken) {
            return res.status(400).json({
                success: false,
                message: "Reset token expired. Please verify OTP again."
            });
        }

        if (verificationToken !== resetToken) {
            return res.status(400).json({
                success: false,
                message: "Invalid reset token. Please verify OTP again."
            });
        }

        const updatedStudent = await Student.findById(student._id);
        if (!updatedStudent) {
            return res.status(404).json({
                success: false,
                message: "Student not found"
            });
        }

        const isSamePassword = await updatedStudent.comparePassword(newPassword);
        if (isSamePassword) {
            return res.status(400).json({
                success: false,
                message: "New password cannot be the same as current password"
            });
        }

        updatedStudent.password = newPassword;
        await updatedStudent.save();

        await redisClient.del(`reset_verified:${email}`);
        await redisClient.del(`reset_otp_limit:${email}`);

        updatedStudent.refreshToken = undefined;
        await updatedStudent.save({ validateBeforeSave: false });

        const currentAccessToken = req.headers.authorization?.split(" ")[1] || req.cookies.accessToken;
        if (currentAccessToken) {
            try {
                await blacklistTokenModel.create({ token: currentAccessToken });
            } catch (blacklistError) {
                console.error("Error blacklisting token:", blacklistError);
                // Don't fail the password reset if blacklisting fails
            }
        }

        return res.status(200).json({
            success: true,
            message: "Password reset successfully. Please login with your new password."
        });

    } catch (error) {
        console.error("Reset password error:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};


// Forgot Password Functions
export const requestForgotPasswordOtp = async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({
                success: false,
                message: "Please provide email address"
            });
        }

        // Check if student exists
        const student = await Student.findOne({ email });
        if (!student) {
            // For security, don't reveal if email exists or not
            return res.status(200).json({
                success: true,
                message: "If the email exists, an OTP has been sent"
            });
        }

        const otpLimit = await redisClient.get(`forgot_password_limit:${email}`);
        if (otpLimit) {
            return res.status(429).json({
                success: false,
                message: "Please wait before requesting a new OTP"
            });
        }

        const otp = Math.floor(100000 + Math.random() * 900000).toString();

        await redisClient.set(`forgot_password_otp:${email}`, otp, "EX", 600);

        await redisClient.set(`forgot_password_limit:${email}`, "sent", "EX", 120);

        const response = await sendOTP(email, otp, "forgot-password");
        if (!response.success) {
            return res.status(500).json({
                success: false,
                message: "Failed to send OTP, please try again later"
            });
        }

        return res.status(200).json({
            success: true,
            message: "If the email exists, an OTP has been sent"
        });

    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error.message
        });
    }
};

export const verifyForgotPasswordOtp = async (req, res) => {
    try {
        const { email, otp } = req.body;

        if (!email || !otp) {
            return res.status(400).json({
                success: false,
                message: "Please provide email and OTP"
            });
        }

        if (otp.length !== 6) {
            return res.status(400).json({
                success: false,
                message: "OTP must be 6 digits long"
            });
        }

        const student = await Student.findOne({ email });
        if (!student) {
            return res.status(404).json({
                success: false,
                message: "Student not found"
            });
        }

        const storedOtp = await redisClient.get(`forgot_password_otp:${email}`);
        if (!storedOtp) {
            return res.status(400).json({
                success: false,
                message: "OTP expired or not found"
            });
        }

        if (storedOtp !== otp) {
            return res.status(400).json({
                success: false,
                message: "Invalid OTP"
            });
        }

        const generateSecureToken = () => {
            const timestamp = Date.now().toString(36);
            const randomPart1 = Math.random().toString(36).substring(2);
            const randomPart2 = Math.random().toString(36).substring(2);
            const randomPart3 = Math.random().toString(36).substring(2);
            return `${timestamp}${randomPart1}${randomPart2}${randomPart3}`.substring(0, 64);
        };

        const resetToken = generateSecureToken();

        await redisClient.set(`password_reset_token:${resetToken}`, email, "EX", 900);

        await redisClient.del(`forgot_password_otp:${email}`);
        await redisClient.del(`forgot_password_limit:${email}`);

        return res.status(200).json({
            success: true,
            message: "OTP verified successfully",
            resetToken
        });

    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error.message
        });
    }
};

export const resetForgotPassword = async (req, res) => {
    try {
        const { resetToken, newPassword, confirmPassword } = req.body;

        if (!resetToken || !newPassword || !confirmPassword) {
            return res.status(400).json({
                success: false,
                message: "Please provide reset token, new password and confirm password"
            });
        }

        if (newPassword !== confirmPassword) {
            return res.status(400).json({
                success: false,
                message: "Passwords do not match"
            });
        }

        if (newPassword.length < 8) {
            return res.status(400).json({
                success: false,
                message: "Password must be at least 8 characters long"
            });
        }

        const email = await redisClient.get(`password_reset_token:${resetToken}`);
        if (!email) {
            return res.status(400).json({
                success: false,
                message: "Invalid or expired reset token"
            });
        }

        const student = await Student.findOne({ email });
        if (!student) {
            return res.status(404).json({
                success: false,
                message: "Student not found"
            });
        }

        student.password = newPassword;
        student.refreshToken = undefined;
        await student.save();

        await redisClient.del(`password_reset_token:${resetToken}`);

        const tokens = await Student.findById(student._id).select('refreshToken');
        if (tokens.refreshToken) {
            await blacklistTokenModel.create({
                token: tokens.refreshToken,
                expiresAt: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000) // 7 days
            });
        }

        return res.status(200).json({
            success: true,
            message: "Password reset successful. Please login with your new password."
        });

    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error.message
        });
    }
};

export const resendForgotPasswordOtp = async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({
                success: false,
                message: "Please provide email address"
            });
        }

        const otpLimit = await redisClient.get(`forgot_password_limit:${email}`);
        if (otpLimit) {
            return res.status(429).json({
                success: false,
                message: "Please wait before requesting a new OTP"
            });
        }

        const student = await Student.findOne({ email });
        if (!student) {
            return res.status(200).json({
                success: true,
                message: "If the email exists, an OTP has been sent"
            });
        }

        let otp = await redisClient.get(`forgot_password_otp:${email}`);
        if (!otp) {
            // Generate new OTP if none exists
            otp = Math.floor(100000 + Math.random() * 900000).toString();
            await redisClient.set(`forgot_password_otp:${email}`, otp, "EX", 600);
        }

        const response = await sendOTP(email, otp, "forgot-password");
        if (!response.success) {
            return res.status(500).json({
                success: false,
                message: "Failed to send OTP, please try again later"
            });
        }

        await redisClient.set(`forgot_password_limit:${email}`, "sent", "EX", 120);

        return res.status(200).json({
            success: true,
            message: "OTP sent successfully"
        });

    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error.message
        });
    }
};


export const getAllSubjectOfStudent = async (req, res) => {
    try {
        const section = req.section;
        console.log(section)
        if (!section) {
            return res.status(404).json({
                success: false,
                message: "Section not found"
            });
        }

        if (!section.faculty || section.faculty.length === 0) {
            return res.status(404).json({
                success: false,
                message: "No faculty assigned to this section"
            });
        }

        const subjectMap = new Map();

        // Flatten all subjects from all faculties and deduplicate by subjectId
        for (const faculty of section.faculty) {
            if (!faculty.subjects || !Array.isArray(faculty.subjects)) continue;

            for (const sub of faculty.subjects) {
                // Handle both populated (object) and non-populated (ObjectId) cases
                const subjectId = sub._id.toString()

                if (!subjectMap.has(subjectId)) {
                    subjectMap.set(subjectId, {
                        subjectId: sub._id || null,
                        subjectName: sub.short_name || null,
                        subjectFullName: sub.subject_name,
                        subjectCode: sub.subject_code
                    });
                }
            }
        }

        if (subjectMap.size === 0) {
            return res.status(404).json({
                success: false,
                message: "No subjects found for this section"
            });
        }

        const subjectArray = Array.from(subjectMap.values());

        return res.status(200).json({
            success: true,
            message: "Subjects fetched successfully",
            subjects: subjectArray
        });

    } catch (error) {
        console.error("Error in getAllSubjectOfStudent:", error);

        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};

export const getNotes = async (req, res) => {
    try {
        const { subjectId } = req.params;
        const { category, chapterNo } = req.query;

        if (!subjectId) {
            return res.status(400).json({
                success: false,
                message: "Subject ID is required",
            });
        }

        if (!category) {
            return res.status(400).json({
                success: false,
                message: "Category is required (e.g., notes, pyq, assignment, quiz, lab, project)",
            });
        }

        const validCategories = ["notes", "pyq", "assignment", "quiz", "lab", "project"];
        if (!validCategories.includes(category)) {
            return res.status(400).json({
                success: false,
                message: `Invalid category. Must be one of: ${validCategories.join(", ")}`,
            });
        }

        const section = req.section;
        if (!section) {
            return res.status(404).json({
                success: false,
                message: "Section not found",
            });
        }
        const subject = await Subject.findOne({ _id: subjectId});

        const query = {
            subject: subject._id,
            section: section._id,
            category,
        };

        console.log(chapterNo)
        let chapterDoc;
        if (chapterNo) {
             chapterDoc = await Chapter.findOne({ chapter_no: String(chapterNo), subject: subject._id, section: section._id });
            if (!chapterDoc) {
                return res.status(404).json({
                    success: false,
                    message: "Chapter not found"
                });
            }
            query["chapter"] = chapterDoc._id;
        }

        const notesList = await Notes.find(query).sort({ createdAt: -1 });
        console.log(notesList)

        const formatBytes = (bytes) => {
            if (!bytes || bytes === 0) return "0 KB";

            const kb = bytes / 1024;
            const mb = kb / 1024;
            const gb = mb / 1024;

            if (gb >= 1) {
                return `${gb.toFixed(2)} GB`;
            } else if (mb >= 1) {
                return `${mb.toFixed(2)} MB`;
            } else {
                return `${kb.toFixed(2)} KB`;
            }
        };

        const transformedNotes = notesList.map(note => {
            const transformedFiles = note.files.map(file => ({
                file_id: file.file_id,
                message_id: file.message_id,
                original_name: file.original_name,
                mime_type: file.mime_type,
                file_size: formatBytes(file.file_size),
                created_at: file.created_at
            }));

            return {
                _id: note._id,
                subjectId: note.subject,
                chapterNo: chapterDoc?.chapter_no || null,
                chapterName: chapterDoc?.chapter_name || null,
                title: note.title,
                description: note.description,
                files: transformedFiles,
                created_at: note.createdAt
            };
        });

        // Send success response
        return res.status(200).json({
            success: true,
            message: `Fetched ${category} successfully`,
            count: transformedNotes.length,
            notes: transformedNotes,
        });
    } catch (error) {
        console.error("Error in getNotes controller:", error);

        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: process.env.NODE_ENV === "development" ? error.message : undefined,
        });
    }
};

export const downloadNotes = async (req, res) => {
    try {
        const { fileId } = req.params;

        if (!fileId) {
            return res.status(400).json({
                success: false,
                message: "File ID is required",
            });
        }

        // Step 1: Get file path from Telegram
        const file = await bot.getFile(fileId);

        if (!file) {
            return res.status(404).json({
                success: false,
                message: "File not found on Telegram",
            });
        }

        // Check file size limit (Telegram Bot API limit is 20MB)
        const MAX_FILE_SIZE = 20 * 1024 * 1024; // 20MB in bytes
        if (file.file_size && file.file_size > MAX_FILE_SIZE) {
            return res.status(413).json({
                success: false,
                message: "File is too large to download via Bot API. Maximum size is 20MB.",
                fileSize: `${(file.file_size / (1024 * 1024)).toFixed(2)} MB`
            });
        }

        const filePath = file.file_path;

        // Step 2: Construct direct Telegram file URL
        const telegramFileUrl = `https://api.telegram.org/file/bot${process.env.BOT_TOKEN}/${filePath}`;

        // Step 3: Get file info from database to get original filename
        const noteFile = await Notes.findOne({ "files.file_id": fileId });
        let originalFileName = "file";

        if (noteFile) {
            const fileInfo = noteFile.files.find(f => f.file_id === fileId);
            if (fileInfo && fileInfo.original_name) {
                originalFileName = fileInfo.original_name;
            }
        }

        // Step 4: Stream file from Telegram to client
        const fileResponse = await axios({
            method: "GET",
            url: telegramFileUrl,
            responseType: "stream", // Important: stream the file
        });

        // Step 5: Set proper headers based on file type
        const contentType = fileResponse.headers['content-type'] || 'application/octet-stream';
        const contentLength = fileResponse.headers['content-length'];

        res.set({
            "Content-Disposition": `attachment; filename="${originalFileName}"`,
            "Content-Type": contentType,
            "Content-Length": contentLength,
            "Cache-Control": "no-cache",
            "Accept-Ranges": "bytes"
        });

        // Pipe the file stream directly to response
        fileResponse.data.pipe(res);

        // Handle stream events
        fileResponse.data.on("error", (err) => {
            console.error("Stream error:", err);
            if (!res.headersSent) {
                return res.status(500).json({
                    success: false,
                    message: "Error streaming file",
                });
            }
        });

        fileResponse.data.on("end", () => {
            console.log("File download completed successfully");
        });

        // Handle response events
        res.on("close", () => {
            console.log("Client disconnected during file download");
        });

    } catch (error) {
        console.error("Error in downloadNotes:", error);

        // Handle Telegram-specific errors
        if (error.response?.status === 400) {
            if (error.message?.includes("file is too big")) {
                return res.status(413).json({
                    success: false,
                    message: "File is too large to download. Telegram Bot API has a 20MB limit for file downloads.",
                });
            }
            return res.status(404).json({
                success: false,
                message: "Invalid file ID or file not found on Telegram",
            });
        }

        if (error.code === 'ETELEGRAM') {
            return res.status(400).json({
                success: false,
                message: "Telegram API error: " + (error.description || error.message),
            });
        }

        return res.status(500).json({
            success: false,
            message: "Internal server error while downloading file",
            error: process.env.NODE_ENV === "development" ? error.message : undefined,
        });
    }
};

/*
curl -X GET "http://localhost:8000/api/v1/student/download-notes/BQACAgUAAyEGAASb56CfAAMIaKXHxUZqoSqzC-WlmJk76bIkwWMAApYYAAJ7sylVXkgiP4YtUl82BA"
-H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2OGEzMjRjMDIyYjNjYTc0MjYyYTg3ZGEiLCJpYXQiOjE3NTU2ODE2OTAsImV4cCI6MTc1NTc2ODA5MH0.L4D0YEddZwL4qlQSb6YzeFx0IQv4XiR8nHA5hAGRH9Q"
 --remote-header-name --remote-name

*/
