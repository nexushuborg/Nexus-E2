import Subject from "../../models/subject.model.js"
import Section from "../../models/section.model.js";
import Department from "../../models/department.model.js";
import Teacher from "../../models/teacher.model.js";
import Branch from "../../models/branch.model.js";
import Student from "../../models/student.model.js";
import Notes from "../../models/notes.model.js";
import { sendOTP } from "../../services/sendmail.js";
import redisClient from "../../configs/connectRedis.js";
import blacklistTokenModel from "../../models/blacklisttoken.model.js";
import fs from "fs"
import { bot } from "./../../configs/connectTelegram.js"
import Chapter from "../../models/chapter.model.js";

import mongoose from 'mongoose';


export const getAllSubjectsAndDepartment = async (req, res) => {
    try {
        const subject = await Subject.find().select("-class_notes -subj_faculty -__v -createdAt -updatedAt");
        if (!subject || subject.length === 0) {
            return res.status(404).json({
                success: false,
                message: "No subjects found"
            })
        }
        const department = await Department.find().select("-__v -createdAt -updatedAt");
        if (!department || department.length === 0) {
            return res.status(404).json({
                success: false,
                message: "No departments found"
            })
        }
        return res.status(200).json({
            success: true,
            message: "Subjects and Departments fetched successfully",
            subjects: subject,
            departments: department
        })
    } catch (error) {
        console.log("Error fetching subjects:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error.message
        })
    }
}

export const getAllSections = async (req, res) => {
    //query konsa year ka secction chahiye
    const { year } = req.query;
    try {
        if (!year) {
            return res.status(400).json({
                success: false,
                message: "Year is required",
            });
        }
        const sections = await Section.find({ batch: year }).select("-faculty -students -strength -__v -createdAt -updatedAt ");
        if (!sections || sections.length === 0) {
            return res.status(404).json({
                success: false,
                message: "No sections found for the specified year",
            });
        }
        return res.status(200).json({
            success: true,
            message: "Sections fetched successfully",
            sections: sections,
        });

    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal server error",
        })
    }
}


export const registerTeacher = async (req, res) => {
    let teacher = null;
    let updatedSections = [];
    let updatedSubjects = [];

    try {
        const { full_name, gender, email, password, department, designation, sectionWithSubject } = req.body;

        // Validate required fields
        if (!full_name || !gender || !email || !password || !department || !designation || !sectionWithSubject) {
            return res.status(400).json({
                success: false,
                message: "All fields are required"
            });
        }

        // Validate sectionWithSubject array
        if (!Array.isArray(sectionWithSubject) || sectionWithSubject.length === 0) {
            return res.status(400).json({
                success: false,
                message: "sectionWithSubject must be a non-empty array"
            });
        }

        // Check if teacher already exists
        const existingTeacher = await Teacher.findOne({ email });
        if (existingTeacher) {
            return res.status(400).json({
                success: false,
                message: "Faculty Already Exists"
            });
        }

        // Validate department exists
        const departmentByUser = await Department.findById(department);
        if (!departmentByUser) {
            return res.status(404).json({
                success: false,
                message: "Department Not Found"
            });
        }

        // Batch validate all subjects and sections exist
        const subjectIds = [...new Set(sectionWithSubject.map(item => item.subject))];
        const sectionIds = [...new Set(sectionWithSubject.map(item => item.section))];

        const [existingSubjects, existingSections] = await Promise.all([
            Subject.find({ _id: { $in: subjectIds } }).select('_id'),
            Section.find({ _id: { $in: sectionIds } }).select('_id')
        ]);

        const foundSubjectIds = existingSubjects.map(s => s._id.toString());
        const foundSectionIds = existingSections.map(s => s._id.toString());

        // Check for missing subjects
        const missingSubjects = subjectIds.filter(id => !foundSubjectIds.includes(id));
        if (missingSubjects.length > 0) {
            return res.status(404).json({
                success: false,
                message: `Subject(s) do not exist: ${missingSubjects.join(', ')}`
            });
        }

        // Check for missing sections
        const missingSections = sectionIds.filter(id => !foundSectionIds.includes(id));
        if (missingSections.length > 0) {
            return res.status(404).json({
                success: false,
                message: `Section(s) do not exist: ${missingSections.join(', ')}`
            });
        }

        // Create teacher
        teacher = await Teacher.create({
            full_name,
            email,
            gender,
            password,
            department: departmentByUser._id,
            designation
        });

        if (!teacher) {
            return res.status(500).json({
                success: false,
                message: "Failed to create teacher"
            });
        }

        // Process sections and subjects updates
        for (const { section: sectionId, subject: subjectId } of sectionWithSubject) {
            try {
                // Update Section with teacher and subject
                const existingFaculty = await Section.findOne({
                    _id: sectionId,
                    "faculty.teacher": teacher._id
                });

                if (existingFaculty) {
                    // Teacher exists - ADD subject to existing subjects array
                    await Section.findOneAndUpdate(
                        { _id: sectionId, "faculty.teacher": teacher._id },
                        {
                            $addToSet: {
                                "faculty.$.subjects": subjectId
                            }
                        }
                    );
                } else {
                    // Teacher doesn't exist - CREATE new faculty entry
                    await Section.findByIdAndUpdate(
                        sectionId,
                        {
                            $push: {
                                faculty: {
                                    teacher: teacher._id,
                                    subjects: [subjectId]
                                }
                            }
                        }
                    );
                }
                updatedSections.push(sectionId);

                // Update Teacher with section and subject
                await Teacher.findByIdAndUpdate(
                    teacher._id,
                    {
                        $addToSet: {
                            section: sectionId,
                            subjects: subjectId
                        }
                    }
                );

                // Update Subject with teacher and section
                const existingSubjectTeacher = await Subject.findOne({
                    _id: subjectId,
                    "subj_faculty.teacher": teacher._id
                });

                if (existingSubjectTeacher) {
                    // Teacher exists - ADD section to existing sections array
                    await Subject.findOneAndUpdate(
                        { _id: subjectId, "subj_faculty.teacher": teacher._id },
                        {
                            $addToSet: {
                                "subj_faculty.$.sections": sectionId
                            }
                        }
                    );
                } else {
                    // Teacher doesn't exist - CREATE new faculty entry
                    await Subject.findByIdAndUpdate(
                        subjectId,
                        {
                            $push: {
                                subj_faculty: {
                                    teacher: teacher._id,
                                    sections: [sectionId]
                                }
                            }
                        }
                    );
                }
                updatedSubjects.push(subjectId);

            } catch (updateError) {
                console.error(`Error updating section ${sectionId} or subject ${subjectId}:`, updateError);
                throw updateError;
            }
        }

        // Generate and send OTP
        const otp = Math.floor(100000 + Math.random() * 900000);

        // Store in Redis
        await redisClient.set(`otp_teacher_${teacher._id}`, otp, "EX", 300); // 5 minutes
        await redisClient.set(`otp_cooldown_teacher_${teacher._id}`, true, "EX", 60); // 1 minute cooldown

        // Send OTP email
        const otpResult = await sendOTP(email, otp);
        if (!otpResult.success) {
            throw new Error("Failed to send OTP email");
        }

        return res.status(201).json({
            success: true,
            message: "Teacher registered successfully, OTP sent to email",
            teacherId: teacher._id
        });

    } catch (error) {
        console.error("Teacher registration error:", error);

        // Rollback operations
        if (teacher) {
            try {
                // Remove teacher from all updated sections
                if (updatedSections.length > 0) {
                    await Section.updateMany(
                        { _id: { $in: updatedSections } },
                        {
                            $pull: {
                                faculty: { teacher: teacher._id }
                            }
                        }
                    );
                }

                // Remove teacher from all updated subjects
                if (updatedSubjects.length > 0) {
                    await Subject.updateMany(
                        { _id: { $in: updatedSubjects } },
                        {
                            $pull: {
                                subj_faculty: { teacher: teacher._id }
                            }
                        }
                    );
                }

                // Delete teacher
                await Teacher.findByIdAndDelete(teacher._id);

                // Clean up Redis keys
                await redisClient.del(`otp_teacher_${teacher._id}`);
                await redisClient.del(`otp_cooldown_teacher_${teacher._id}`);

                console.log("Rollback completed successfully");
            } catch (rollbackError) {
                console.error("Rollback failed:", rollbackError);
            }
        }

        return res.status(500).json({
            success: false,
            message: "Internal server error during teacher registration",
            error: error.message
        });
    }
}


export const verifyAuthOtp = async (req, res) => {
    const { email, otp, teacherId } = req.body;
    console.log("mark1 ")
    if (!email || !otp) {
        return res.status(400).json({
            success: false,
            message: "Email and OTP are required"
        });
    }

    //otp length
    if (otp.length !== 6) {
        return res.status(400).json({
            success: false,
            message: "OTP must be 6 digits long"
        });
    }

    const cachedOtp = await redisClient.get(`otp_teacher_${teacherId}`);
    console.log(cachedOtp)
    if (!cachedOtp) {
        return res.status(400).json({
            success: false,
            message: "OTP has expired or does not exist"
        });
    }
    if (cachedOtp !== otp) {
        return res.status(400).json({
            success: false,
            message: "Invalid OTP"
        });
    }

    // If OTP is valid, delete it from Redis
    redisClient.del(`otp_teacher_${email}`);
    redisClient.del(`otp_cooldown_teacher_${email}`);

    const user = await Teacher.findOne({ email });
    const accessToken = user.generateAccessToken();
    const refreshToken = user.generateRefreshToken();
    user.refreshToken = refreshToken;
    user.isVerified = true;
    await user.save({ validateBeforeSave: false });

    res.cookie("refreshToken", refreshToken, {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        sameSite: "lax",
    })

    const loggedUser = await Teacher.findById(user._id)
        .populate('department', 'name')
        .populate('section', 'section_name batch')
        .populate('subjects', 'subject_code subject_name')
        .select("-password -refreshToken -__v -createdAt -updatedAt")


    return res.status(200).json({
        success: true,
        message: "OTP verified successfully",
        teacher: loggedUser,
        accessToken,
    });
}

export const resendAuthOtp = async (req, res) => {
    const { email, teacherId } = req.body;
    if (!email) {
        return res.status(400).json({
            success: false,
            message: "Email is required"
        });
    }

    const otpLimit = await redisClient.get(`otp_cooldown_teacher_${teacherId}`);
    if (otpLimit) {
        return res.status(429).json({
            success: false,
            message: "Please wait before requesting a new OTP"
        });
    }
    let otp = await redisClient.get(`otp_teacher_${teacherId}`);
    if (!otp) {
        otp = Math.floor(100000 + Math.random() * 900000);
        await redisClient.set(`otp_teacher_${teacherId}`, otp, "EX", 300); // 5 minutes
    }
    await redisClient.set(`otp_cooldown_teacher_${teacherId}`, true, "EX", 60); // 1 minute cooldown
    const otpResult = await sendOTP(email, otp);
    if (!otpResult.success) {
        return res.status(500).json({
            success: false,
            message: "Failed to send OTP email"
        });
    }
    return res.status(200).json({
        success: true,
        message: "OTP sent successfully",
        otp: otp
    });
}

export const login = async (req, res) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res.status(400).json({
                success: false,
                message: "Email and password are required"
            });
        }

        const teacher = await Teacher.findOne({ email });
        if (!teacher) {
            return res.status(404).json({
                success: false,
                message: "Invalid Creadentials"
            })
        }

        const isMatch = await teacher.comparePassword(password);
        if (!isMatch) {
            return res.status(400).json({
                success: false,
                message: "Invalid Creadentials"
            });
        }

        if (!teacher.isVerified) {
            return res.status(403).json({
                success: false,
                message: "Please verify your account first"
            });
        }
        const accessToken = teacher.generateAccessToken();
        const refreshToken = teacher.generateRefreshToken();
        teacher.refreshToken = refreshToken;
        await teacher.save({ validateBeforeSave: false });
        res.cookie("refreshToken", refreshToken, {
            httpOnly: true,
            secure: process.env.NODE_ENV === "production",
            sameSite: "lax",
            maxAge: 24 * 60 * 60 * 1000 // 1 day
        });
        const loggedUser = await Teacher.findById(teacher._id)
            .select("-password -refreshToken -__v -createdAt -updatedAt")
            .populate('department', 'name')
            .populate('section', 'section_name batch')
            .populate('subjects', 'subject_code subject_name');
        return res.status(200).json({
            success: true,
            message: "Login successful",
            accessToken,
            teacher: loggedUser
        })
    } catch (error) {
        console.error("Login error:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });

    }
}

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

export const teacherLogoutController = async (req, res) => {
    try {
        const accessToken = req.headers.authorization?.split(' ')[1];
        const refreshToken = req.cookies.refreshToken;

        console.log("Full headers:", req.headers);
        console.log("Authorization header:", req.headers.authorization);

        if (!accessToken) {
            res.clearCookie('refreshToken', {
                httpOnly: true,
                secure: process.env.NODE_ENV === 'production',
                sameSite: 'lax'
            });
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

        await Teacher.findByIdAndUpdate(
            decoded.id,
            { refreshToken: null },
            { new: true }
        );

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

export const teacherLogoutAllController = async (req, res) => {
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

        const teacher = await Teacher.findById(decoded.id);
        if (!teacher) {
            return res.status(404).json({
                success: false,
                message: "Teacher not found"
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

        await Teacher.findByIdAndUpdate(
            decoded.id,
            { refreshToken: null },
            { new: true }
        );

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

export const regenerateTeacherAccessToken = async (req, res) => {
    try {
        const refreshToken = req.cookies.refreshToken;
        if (!refreshToken) {
            return res.status(401).json({
                success: false,
                message: "Refresh token is required"
            });
        }

        const isBlacklisted = await blacklistTokenModel.findOne({ token: refreshToken });
        if (isBlacklisted) {
            return res.status(401).json({
                success: false,
                message: "Token is revoked"
            });
        }

        const userSentAccessToken = req.cookies.accessToken || req.headers?.authorization?.split(' ')[1];
        console.log("Current access token:", userSentAccessToken);

        if (userSentAccessToken) {
            await blacklistTokenModel.create({
                token: userSentAccessToken
            });
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

        const teacher = await Teacher.findById(decoded.id);
        console.log("Teacher:", teacher);

        if (!teacher || teacher.refreshToken !== refreshToken) {
            return res.status(401).json({
                success: false,
                message: "Invalid refresh token"
            });
        }

        const accessToken = teacher.generateAccessToken();
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
};

export const teacherProfileController = async (req, res) => {
    try {
        const teacher = await Teacher.findById(req.user._id)
            .populate('department', 'name short_name')

        if (!teacher) {
            return res.status(404).json({
                success: false,
                message: "Teacher not found"
            });
        }

        let sectionsWithThereSubject = [];

        //we will use Promise.all to get all sections and their subjects
        if (teacher.section && teacher.section.length > 0) {
            sectionsWithThereSubject = await Promise.all(
                teacher.section.map(
                    async (section) => {
                        // Fetch populated subjects
                        const sectionDetails = await Section.findById(section._id)
                            .select("section_name batch degree branch faculty")
                            .populate("faculty.subjects", "subject_code subject_name")
                            .populate("degree", "name short_name duration_years")
                            .populate("branch", "name short_name");
                        if (!sectionDetails) {
                            return null; // Skip if section not found
                        }
                        const obj = {
                            section_name: sectionDetails.section_name,
                            batch: sectionDetails.batch,
                            degree: {
                                name: sectionDetails.degree?.name || null,
                                short_name: sectionDetails.degree?.short_name || null,
                                duration_years: sectionDetails.degree?.duration_years || null
                            },
                            branch: {
                                name: sectionDetails.branch?.name || null,
                                short_name: sectionDetails.branch?.short_name || null
                            },

                            subjects: sectionDetails.faculty.reduce((acc, faculty) => {
                                if (faculty.teacher.toString() === teacher._id.toString()) {
                                    acc.push(...faculty.subjects.map(subj => ({
                                        subject_code: subj.subject_code,
                                        subject_name: subj.subject_name,
                                        subject_id: subj._id
                                    })));
                                }
                                return acc;
                            }, [])


                        }
                        return obj;
                    }
                )
            )
        }


        const profileData = {
            profile_picture: teacher.profile_picture?.Image || null,
            full_name: teacher.full_name,
            email: teacher.email,
            department: {
                name: teacher.department?.name || null,
                short_name: teacher.department?.short_name || null
            },
            designation: teacher.designation || null,
            total_subjects: teacher.subjects.length,
            total_sections: teacher.section.length,
            sections: sectionsWithThereSubject,
        };

        return res.status(200).json({
            success: true,
            message: "Teacher profile retrieved successfully",
            data: profileData
        });

    } catch (error) {
        console.error("Get teacher profile error:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};


//Password Reset Controllers
export const requestPasswordReset = async (req, res) => {
    try {
        const teacher = req.user;
        const { email } = teacher;

        const otpLimit = await redisClient.get(`reset_otp_limit_teacher:${email}`);
        if (otpLimit) {
            return res.status(429).json({
                success: false,
                message: "Please wait before requesting a new password reset OTP"
            });
        }

        const otp = Math.floor(100000 + Math.random() * 900000).toString();

        await redisClient.set(`reset_otp_teacher:${email}`, otp, "EX", 300);

        await redisClient.set(`reset_otp_limit_teacher:${email}`, "sent", "EX", 60);

        const response = await sendOTP(email, otp);
        if (!response.success) {
            await redisClient.del(`reset_otp_teacher:${email}`);
            await redisClient.del(`reset_otp_limit_teacher:${email}`);

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
        const teacher = req.user;
        const { email } = teacher;
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

        const otpFromCache = await redisClient.get(`reset_otp_teacher:${email}`);
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
        await redisClient.set(`reset_verified_teacher:${email}`, verificationToken, "EX", 600); // 10 minutes validity

        await redisClient.del(`reset_otp_teacher:${email}`);

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
        const teacher = req.user;
        const { email } = teacher;
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

        const verificationToken = await redisClient.get(`reset_verified_teacher:${email}`);
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

        const updatedTeacher = await Teacher.findById(teacher._id);
        if (!updatedTeacher) {
            return res.status(404).json({
                success: false,
                message: "Teacher not found"
            });
        }

        const isSamePassword = await updatedTeacher.comparePassword(newPassword);
        if (isSamePassword) {
            return res.status(400).json({
                success: false,
                message: "New password cannot be the same as current password"
            });
        }

        updatedTeacher.password = newPassword;
        await updatedTeacher.save();

        await redisClient.del(`reset_verified_teacher:${email}`);
        await redisClient.del(`reset_otp_limit_teacher:${email}`);

        updatedTeacher.refreshToken = undefined;
        await updatedTeacher.save({ validateBeforeSave: false });

        const currentAccessToken = req.headers.authorization?.split(" ")[1] || req.cookies.accessToken;
        if (currentAccessToken) {
            try {
                await blacklistTokenModel.create({ token: currentAccessToken });
            } catch (blacklistError) {
                console.error("Error blacklisting token:", blacklistError);
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



// Forgot Password Controller for Teachers
export const requestForgotPasswordOtp = async (req, res) => {
    try {
        const { email } = req.body;

        if (!email) {
            return res.status(400).json({
                success: false,
                message: "Please provide email address"
            });
        }

        const teacher = await Teacher.findOne({ email });
        if (!teacher) {
            return res.status(200).json({
                success: true,
                message: "If the email exists, an OTP has been sent"
            });
        }

        const otpLimit = await redisClient.get(`forgot_password_limit_teacher:${email}`);
        if (otpLimit) {
            return res.status(429).json({
                success: false,
                message: "Please wait before requesting a new OTP"
            });
        }

        const otp = Math.floor(100000 + Math.random() * 900000).toString();

        await redisClient.set(`forgot_password_otp_teacher:${email}`, otp, "EX", 600);

        await redisClient.set(`forgot_password_limit_teacher:${email}`, "sent", "EX", 120);

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

        const teacher = await Teacher.findOne({ email });
        if (!teacher) {
            return res.status(404).json({
                success: false,
                message: "Teacher not found"
            });
        }

        const storedOtp = await redisClient.get(`forgot_password_otp_teacher:${email}`);
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

        await redisClient.set(`password_reset_token_teacher:${resetToken}`, email, "EX", 900);

        await redisClient.del(`forgot_password_otp_teacher:${email}`);
        await redisClient.del(`forgot_password_limit_teacher:${email}`);

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
        const { resetToken, newPassword } = req.body;

        if (!resetToken || !newPassword) {
            return res.status(400).json({
                success: false,
                message: "Please provide reset token, new password and confirm password"
            });
        }


        if (newPassword.length < 8) {
            return res.status(400).json({
                success: false,
                message: "Password must be at least 8 characters long"
            });
        }

        const email = await redisClient.get(`password_reset_token_teacher:${resetToken}`);
        if (!email) {
            return res.status(400).json({
                success: false,
                message: "Invalid or expired reset token"
            });
        }

        const teacher = await Teacher.findOne({ email });
        if (!teacher) {
            return res.status(404).json({
                success: false,
                message: "Teacher not found"
            });
        }

        teacher.password = newPassword;
        teacher.refreshToken = undefined;
        await teacher.save();

        await redisClient.del(`password_reset_token_teacher:${resetToken}`);

        const tokens = await Teacher.findById(teacher._id).select('refreshToken');
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

        const otpLimit = await redisClient.get(`forgot_password_limit_teacher:${email}`);
        if (otpLimit) {
            return res.status(429).json({
                success: false,
                message: "Please wait before requesting a new OTP"
            });
        }

        const teacher = await Teacher.findOne({ email });
        if (!teacher) {
            return res.status(200).json({
                success: true,
                message: "If the email exists, an OTP has been sent"
            });
        }

        let otp = await redisClient.get(`forgot_password_otp_teacher:${email}`);
        if (!otp) {
            otp = Math.floor(100000 + Math.random() * 900000).toString();
            await redisClient.set(`forgot_password_otp_teacher:${email}`, otp, "EX", 600);
        }

        const response = await sendOTP(email, otp, "forgot-password");
        if (!response.success) {
            return res.status(500).json({
                success: false,
                message: "Failed to send OTP, please try again later"
            });
        }

        await redisClient.set(`forgot_password_limit_teacher:${email}`, "sent", "EX", 120);

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

//Making CR and Changing CR Controllers
export const makeCRController = async (req, res) => {
    try {
        const { sectionId } = req.params;
        const { studentId } = req.body;

        if (!mongoose.Types.ObjectId.isValid(sectionId)) {
            return res.status(400).json({
                success: false,
                message: "Invalid section ID"
            });
        }

        if (!mongoose.Types.ObjectId.isValid(studentId)) {
            return res.status(400).json({
                success: false,
                message: "Invalid student ID"
            });
        }

        const section = await Section.findById(sectionId);
        if (!section) {
            return res.status(404).json({
                success: false,
                message: "Section not found"
            });
        }

        const student = await Student.findById(studentId);
        if (!student) {
            return res.status(404).json({
                success: false,
                message: "Student not found"
            });
        }

        if (!section.students.includes(studentId)) {
            return res.status(400).json({
                success: false,
                message: "Student does not belong to this section"
            });
        }

        if (student.is_cr) {
            return res.status(400).json({
                success: false,
                message: "Student is already a CR"
            });
        }

        if (section.cr.length >= 2) {
            return res.status(400).json({
                success: false,
                message: "Section already has maximum CRs (2). Please change one of the existing CRs instead."
            });
        }

        await Student.findByIdAndUpdate(studentId, { is_cr: true });

        await Section.findByIdAndUpdate(sectionId, {
            $push: { cr: studentId }
        });

        const updatedSection = await Section.findById(sectionId)
            .populate('cr', 'full_name reg_no email')
            .populate('students', 'full_name reg_no');

        const updatedStudent = await Student.findById(studentId).select('full_name reg_no email is_cr');

        return res.status(200).json({
            success: true,
            message: `CR assigned successfully. Section now has ${section.cr.length + 1} CR(s).`,
            data: {
                section: {
                    _id: updatedSection._id,
                    section_name: updatedSection.section_name,
                    batch: updatedSection.batch,
                    cr: updatedSection.cr,
                    totalCRs: updatedSection.cr.length
                },
                newCR: updatedStudent
            }
        });

    } catch (error) {
        console.error("Error in makeCR:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error.message
        });
    }
};

export const changeCRController = async (req, res) => {
    try {
        const { sectionId } = req.params;
        const { newStudentId, oldStudentId } = req.body;

        if (!mongoose.Types.ObjectId.isValid(sectionId)) {
            return res.status(400).json({
                success: false,
                message: "Invalid section ID"
            });
        }

        if (!mongoose.Types.ObjectId.isValid(newStudentId)) {
            return res.status(400).json({
                success: false,
                message: "Invalid new student ID"
            });
        }

        if (!mongoose.Types.ObjectId.isValid(oldStudentId)) {
            return res.status(400).json({
                success: false,
                message: "Invalid old student ID"
            });
        }

        // Check if section exists
        const section = await Section.findById(sectionId);
        if (!section) {
            return res.status(404).json({
                success: false,
                message: "Section not found"
            });
        }

        const newStudent = await Student.findById(newStudentId);
        const oldStudent = await Student.findById(oldStudentId);

        if (!newStudent) {
            return res.status(404).json({
                success: false,
                message: "New student not found"
            });
        }

        if (!oldStudent) {
            return res.status(404).json({
                success: false,
                message: "Old student not found"
            });
        }

        if (!section.students.includes(newStudentId)) {
            return res.status(400).json({
                success: false,
                message: "New student does not belong to this section"
            });
        }

        if (!section.students.includes(oldStudentId)) {
            return res.status(400).json({
                success: false,
                message: "Old student does not belong to this section"
            });
        }

        if (!section.cr.includes(oldStudentId)) {
            return res.status(400).json({
                success: false,
                message: "Old student is not one of the current CRs of this section"
            });
        }

        if (newStudent.is_cr) {
            return res.status(400).json({
                success: false,
                message: "New student is already a CR"
            });
        }

        if (!oldStudent.is_cr) {
            return res.status(400).json({
                success: false,
                message: "Old student is not marked as CR"
            });
        }

        await Student.findByIdAndUpdate(oldStudentId, { is_cr: false });

        await Student.findByIdAndUpdate(newStudentId, { is_cr: true });

        await Section.findByIdAndUpdate(sectionId, {
            $pull: { cr: oldStudentId },
            $push: { cr: newStudentId }
        });

        const updatedSection = await Section.findById(sectionId)
            .populate('cr', 'full_name reg_no email')
            .populate('students', 'full_name reg_no');

        const updatedNewStudent = await Student.findById(newStudentId).select('full_name reg_no email is_cr');
        const updatedOldStudent = await Student.findById(oldStudentId).select('full_name reg_no email is_cr');

        return res.status(200).json({
            success: true,
            message: `CR changed successfully. Section now has ${updatedSection.cr.length} CR(s).`,
            data: {
                section: {
                    _id: updatedSection._id,
                    section_name: updatedSection.section_name,
                    batch: updatedSection.batch,
                    cr: updatedSection.cr,
                    totalCRs: updatedSection.cr.length
                },
                newCR: updatedNewStudent,
            }
        });

    } catch (error) {
        console.error("Error in changeCR:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: error.message
        });
    }
};

export const getAllStudentsInYearAndBranchController = async (req, res) => {
    try {
        const { year, branch } = req.params;

        const admissionYear = parseInt(year);
        if (isNaN(admissionYear) || admissionYear < 2000 || admissionYear > new Date().getFullYear() + 5) {
            return res.status(400).json({
                success: false,
                message: "Invalid year parameter. Please provide a valid admission year."
            });
        }

        const branchDoc = await Branch.findOne({ short_name: branch.toUpperCase() });
        if (!branchDoc) {
            return res.status(404).json({
                success: false,
                message: `Branch with short_name '${branch}' not found.`
            });
        }

        const students = await Student.find({
            batch: admissionYear,
            branch: branchDoc._id
        })
            .populate('section', 'section_name')
            .populate('degree', 'name short_name')
            .populate('branch', 'name short_name')
            .select('-password -refreshToken')

        return res.status(200).json({
            success: true,
            message: `Found ${students.length} students for batch ${admissionYear} in ${branch} branch.`,
            data: {
                batch: admissionYear,
                branch: branch.toUpperCase(),
                totalStudents: students.length,
                students: students
            }
        });

    } catch (error) {
        console.error('Error fetching students:', error);
        return res.status(500).json({
            success: false,
            message: "Internal server error while fetching students.",
            error: error.message
        });
    }
}

export const getUploadSectionNotesDetails = async (req, res) => {
    try {
        const user = req.user;
        const teacher = await Teacher.findById(user._id)
            .populate({
                path: "section",
                populate: [
                    { path: "degree", select: "name short_name duration_years" },
                    { path: "branch", select: "name short_name" }
                ],
                select: "section_name batch degree branch strength"
            })
            .populate("subjects", "subject_code subject_name short_name");

        //we have to segregate sections by 1st,2nd,3rd,4th year
        if (!teacher) {
            return res.status(404).json({ success: false, message: 'Teacher not found' });
        }

        const sectionByYear = {
            firstYear: [],
            secondYear: [],
            thirdYear: [],
            fourthYear: []
        };

        // Map batches to academic year — adjust mapping if your batch-year logic differs
        teacher.section.forEach((sec) => {
            const details = {
                section_name: sec.section_name,
                batch: sec.batch,
                strength: sec.strength,
                section_id: sec._id,
                degree: sec.degree ? { name: sec.degree.name, short_name: sec.degree.short_name } : null,
                branch: sec.branch ? { name: sec.branch.name, short_name: sec.branch.short_name } : null
            };

            if (sec.batch === 2029) {
                sectionByYear.firstYear.push(details);
            } else if (sec.batch === 2028) {
                sectionByYear.secondYear.push(details);
            } else if (sec.batch === 2027) {
                sectionByYear.thirdYear.push(details);
            } else if (sec.batch === 2026) {
                sectionByYear.fourthYear.push(details);
            }
        });

        const filtered = Object.fromEntries(Object.entries(sectionByYear).filter(([, arr]) => arr.length > 0));

        const subjects = teacher.subjects.map(sub => ({
            subject_code: sub.subject_code,
            subject_name: sub.subject_name,
            short_name: sub.short_name,
            subject_id: sub._id
        }))


        return res.status(200).json({
            success: true,
            message: 'Sections grouped by year fetched successfully',
            sectionByYear: filtered,
            subjects: subjects
        });
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: 'Internal server error while fetching sections by year',
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        })
    }
}

export const uploadNotes = async (req, res) => {
    try {
        const CHAT_ID = process.env.CHAT_ID;
        const { title, description, category, subject, section, chapterNo, chapterName } = req.body;
        const files = req.files;


        const sectionIds = Array.isArray(section) ? section : [section];

        // Check if all sections exist
        const sections = await Section.find({ _id: { $in: sectionIds } });

        if (sections.length === 0) {
            return res.status(404).json({ success: false, message: "No sections found" });
        }


        if (sections.length !== sectionIds.length) {
            return res.status(404).json({ success: false, message: "One or more sections not found" });
        }


        const invalidSections = sections.filter(sectionDetail =>
            !sectionDetail.isTeacherInSection(req.user._id)
        );

        if (invalidSections.length > 0) {
            return res.status(403).json({
                success: false,
                message: "You are not assigned to one or more of these sections",
                invalidSections: invalidSections.map(s => s._id)
            });
        }

        if (!files || files.length === 0) {
            return res.status(400).json({ success: false, message: "No files uploaded" });
        }

        if (!title || !description || !category || !subject || !section || !chapterNo || !chapterName) {
            return res.status(400).json({ success: false, message: "All fields are required" });
        }

        const subjectDetails = await Subject.findById(subject);
        if (!subjectDetails) {
            return res.status(404).json({ success: false, message: "Subject not found" });
        }

        // Upload files to Telegram (once, reuse for all notes)
        const uploadedFiles = [];
        for (const file of files) {
            const filePath = file.path;
            if (!filePath) {
                return res.status(400).json({ success: false, message: "File path missing" });
            }
            const sentMsg = await bot.sendDocument(CHAT_ID, filePath, {
                caption: file.originalname,
            });
            uploadedFiles.push({
                file_id: sentMsg.document.file_id,
                message_id: sentMsg.message_id,
                original_name: file.originalname,
                mime_type: sentMsg.document.mime_type,
                file_size: sentMsg.document.file_size,
            });
            fs.unlinkSync(filePath);
        }

        // Create notes for each section
        const createdNotes = [];
        for (const sectionDetail of sections) {
            // Find or create chapter for this section
            let chapter = await Chapter.findOne({
                subject: subjectDetails._id,
                chapter_no: chapterNo,
                section: sectionDetail._id,
            });
            if (!chapter) {
                chapter = await Chapter.create({
                    chapter_no: chapterNo,
                    chapter_name: chapterName,
                    subject: subjectDetails._id,
                    section: sectionDetail._id,
                });
            }
            // Save note for this section/chapter
            const newNote = await Notes.create({
                title,
                description,
                files: uploadedFiles,
                category,
                chapter: chapter._id,
                subject: subjectDetails._id,
                teacher: req.user._id,
                section: sectionDetail._id,
            });
            createdNotes.push(newNote);
        }

        return res.status(201).json({
            success: true,
            message: "Notes uploaded successfully to all selected sections",
            notes: createdNotes,
        });
    } catch (error) {
        console.error("Error uploading notes:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: process.env.NODE_ENV === 'development' ? error.message : undefined,
        });
    }
};

/*
testing of large file upload using curl command as postman donot support large file upload
curl -X POST "http://localhost:8000/api/v1/teacher/upload-notes" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4YTMxZDU0YTA3ZTZmOWI0ODc5ZjM4MSIsImVtYWlsIjoic2Fzd2F0YmFyYWk2MTFAc29hLmR1LmluIiwiaWF0IjoxNzU1NTQ5NDgzLCJleHAiOjE3NTU2MzU4ODN9._ksCCnUvQQaIot65H4ha7lQEnak08y6sJBJc7a4TxYw" \
  -F "title=My Notes Upload" \
  -F "description=These are sample notes for testing upload." \
  -F "category=notes" \
  -F "subject=68a3170384071ea2d7cc7d3d" \
  -F "section=68a3187e0251e4b8448d6d76" \
  -F "files=@/c/Users/saswa/Downloads/pdf-1.pdf"
*/

export const deleteUploadedFiles = async (req, res) => {
    try {
        const { noteId } = req.params;
        const { fileId } = req.body; // File ID to delete from the request body
        const teacherId = req.teacher._id; // Assuming teacher info is available from authTeacherMiddleware

        if (!noteId) {
            return res.status(400).json({
                success: false,
                message: "Note ID is required"
            });
        }

        if (!fileId) {
            return res.status(400).json({
                success: false,
                message: "File ID is required"
            });
        }
        if (!mongoose.Types.ObjectId.isValid(noteId)) {
            return res.status(400).json({
                success: false,
                message: "Invalid note ID"
            });
        }
        if (!mongoose.Types.ObjectId.isValid(fileId)) {
            return res.status(400).json({
                success: false,
                message: "Invalid file ID"
            });
        }
        const note = await Notes.findById(noteId).populate('section');

        if (!note) {
            return res.status(404).json({
                success: false,
                message: "Note not found"
            });
        }

        const section = note.section;
        if (!section.isTeacherInSection(teacherId)) {
            return res.status(403).json({
                success: false,
                message: "You are not authorized to delete files from this section"
            });
        }

        const fileIndex = note.files.findIndex(file => file.file_id === fileId);

        if (fileIndex === -1) {
            return res.status(404).json({
                success: false,
                message: "File not found in this note"
            });
        }

        const fileToDelete = note.files[fileIndex];

        try {
            await bot.deleteMessage(process.env.CHAT_ID, fileToDelete.message_id);

            note.files.splice(fileIndex, 1);

            if (note.files.length === 0) {
                await Notes.findByIdAndDelete(noteId);

                return res.status(200).json({
                    success: true,
                    message: "File deleted successfully. Note was also removed as it had no remaining files."
                });
            } else {
                await note.save({ validateBeforeSave: false });

                return res.status(200).json({
                    success: true,
                    message: "File deleted successfully",
                    remainingFiles: note.files.length
                });
            }

        } catch (telegramError) {
            console.error(`Error deleting message from Telegram:`, telegramError);

            note.files.splice(fileIndex, 1);

            if (note.files.length === 0) {
                await Notes.findByIdAndDelete(noteId);
            } else {
                await note.save({ validateBeforeSave: false });
            }

            return res.status(200).json({
                success: true,
                message: "File removed from database, but may still exist in Telegram storage",
                warning: "Telegram deletion failed",
                remainingFiles: note.files.length
            });
        }

    } catch (error) {
        console.error('Error in deleteUploadedFiles:', error);
        return res.status(500).json({
            success: false,
            message: "Internal server error while deleting file",
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};

export const getNotes = async (req, res) => {
    try {
        const { subjectId } = req.params;
        const { category, chapterNo } = req.query;
        const teacherId = req.teacher._id;

        if (!subjectId) {
            return res.status(400).json({
                success: false,
                message: "Subject ID is required",
            });
        }

        if (!category) {
            return res.status(400).json({
                success: false,
                message: "Category is required (e.g., notes, pyq, assignment, quiz, lab, project, other)",
            });
        }

        const validCategories = ["notes", "pyq", "assignment", "quiz", "lab", "project", "other"];
        if (!validCategories.includes(category)) {
            return res.status(400).json({
                success: false,
                message: `Invalid category. Must be one of: ${validCategories.join(", ")}`,
            });
        }

        const subject = await Subject.findById(subjectId);
        if (!subject) {
            return res.status(404).json({
                success: false,
                message: "Subject not found",
            });
        }

        const sectionsWithAccess = await Section.find({
            "faculty.teacher": teacherId,
            "faculty.subjects": subjectId
        });

        if (!sectionsWithAccess || sectionsWithAccess.length === 0) {
            return res.status(403).json({
                success: false,
                message: "You are not authorized to access notes for this subject",
            });
        }

        const sectionIds = sectionsWithAccess.map(section => section._id);

        const query = {
            subject: subjectId,
            section: { $in: sectionIds },
            category,
        };

        let chapterDoc;
        if (chapterNo) {
            chapterDoc = await Chapter.findOne({
                chapter_no: String(chapterNo),
                subject: subjectId,
                section: { $in: sectionIds }
            });

            if (!chapterDoc) {
                return res.status(404).json({
                    success: false,
                    message: "Chapter not found in your accessible sections"
                });
            }
            query["chapter"] = chapterDoc._id;
        }

        const notesList = await Notes.find(query)
            .populate('section', 'section_name batch')
            .populate('chapter', 'chapter_no chapter_name')
            .populate('teacher', 'name email')
            .sort({ createdAt: -1 });

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
                chapterNo: note.chapter?.chapter_no || null,
                chapterName: note.chapter?.chapter_name || null,
                sectionName: note.section?.section_name || null,
                sectionBatch: note.section?.batch || null,
                uploadedBy: note.teacher?.name || null,
                isMyUpload: note.teacher._id.toString() === teacherId.toString(),
                title: note.title,
                description: note.description,
                files: transformedFiles,
                exam_year: note.exam_year || null,
                semester: note.semester || null,
                is_pyq: note.is_pyq || false,
                created_at: note.createdAt
            };
        });

        const notesBySection = transformedNotes.reduce((acc, note) => {
            const sectionKey = `${note.sectionName} (Batch ${note.sectionBatch})`;
            if (!acc[sectionKey]) {
                acc[sectionKey] = [];
            }
            acc[sectionKey].push(note);
            return acc;
        }, {});

        return res.status(200).json({
            success: true,
            message: `Fetched ${category} successfully`,
            subject: {
                _id: subject._id,
                name: subject.subject_name,
                code: subject.subject_code
            },
            chapter: chapterDoc ? {
                _id: chapterDoc._id,
                chapter_no: chapterDoc.chapter_no,
                chapter_name: chapterDoc.chapter_name
            } : null,
            totalCount: transformedNotes.length,
            sectionsCount: Object.keys(notesBySection).length,
            notes: transformedNotes,
            notesBySection: notesBySection, 
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