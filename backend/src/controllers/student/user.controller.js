import Section from "../../models/section.model.js";
import Branches from "../../models/branch.model.js";
import Degree from "../../models/degree.model.js"
import Student from "../../models/student.model.js";
import { redisClient } from "../../configs/connectRedis.js"
import { sendOTP } from "../../services/sendmail.js"
import blacklistTokenModel from "../../models/blacklisttoken.model.js";
import jwt from "jsonwebtoken";



export const registerStudent = async (req, res) => {
    try {
        console.log("Register endpoint hit - Incoming cookies:", req.cookies);

        const { full_name, password, reg_no, slno,email, phoneNo, degree, branch, batch, gender } = req.body;

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
            message: error.message
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
        const refreshToken = req.cookies.refreshToken // user cannot send refresh token in body because use sameSite lax for cookie

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

        const student = await Student.findById(decoded.id);
        if (student) {
            student.refreshToken = null;
            await student.save();
        }

        await blacklistTokenModel.create({
            token: accessToken
        });

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

        res.clearCookie('refreshToken', {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'lax'
        });

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

        const student = await Student.findById(decoded.id);
        if (!student) {
            return res.status(404).json({
                success: false,
                message: "Student not found"
            });
        }

        await blacklistTokenModel.create({
            token: accessToken
        });

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

        student.refreshToken = null;
        await student.save();

        res.clearCookie('refreshToken', {
            httpOnly: true,
            secure: process.env.NODE_ENV === 'production',
            sameSite: 'lax'
        });

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
        console.log("dedewd",userSentAccessToken)
        if(userSentAccessToken){
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
        console.log("studnet ",student)
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