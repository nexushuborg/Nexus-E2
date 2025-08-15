import Subject from "../../models/subject.model.js"
import Section from "../../models/section.model.js";
import Department from "../../models/department.model.js";
import Teacher from "../../models/teacher.model.js";
import { sendOTP } from "../../services/sendmail.js";
import redisClient from "../../configs/connectRedis.js";


export const getAllSubjectsAndDepartment = async (req,res) => {
    try {
        const subject = await Subject.find().select("-class_notes -subj_faculty -__v -createdAt -updatedAt");
        if(!subject || subject.length === 0) {
            return res.status(404).json({
                success:false,
                message: "No subjects found"
            })
        }
        const department = await Department.find().select("-__v -createdAt -updatedAt");
        if(!department || department.length === 0) {
            return res.status(404).json({
                success:false,
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
        const {full_name, gender, email, password, department, designation, sectionWithSubject} = req.body;
        
        // Validate required fields
        if(!full_name || !gender || !email || !password || !department || !designation || !sectionWithSubject){
            return res.status(400).json({
                success: false,
                message: "All fields are required"
            });
        }

        // Validate sectionWithSubject array
        if(!Array.isArray(sectionWithSubject) || sectionWithSubject.length === 0) {
            return res.status(400).json({
                success: false,
                message: "sectionWithSubject must be a non-empty array"
            });
        }
        
        // Check if teacher already exists
        const existingTeacher = await Teacher.findOne({email});
        if(existingTeacher){
            return res.status(400).json({
                success: false,
                message: "Faculty Already Exists"
            });
        }

        // Validate department exists
        const departmentByUser = await Department.findById(department);
        if(!departmentByUser){
            return res.status(404).json({
                success: false,
                message: "Department Not Found"
            });
        }

        // Batch validate all subjects and sections exist
        const subjectIds = [...new Set(sectionWithSubject.map(item => item.subject))];
        const sectionIds = [...new Set(sectionWithSubject.map(item => item.section))];

        const [existingSubjects, existingSections] = await Promise.all([
            Subject.find({_id: {$in: subjectIds}}).select('_id'),
            Section.find({_id: {$in: sectionIds}}).select('_id')
        ]);

        const foundSubjectIds = existingSubjects.map(s => s._id.toString());
        const foundSectionIds = existingSections.map(s => s._id.toString());

        // Check for missing subjects
        const missingSubjects = subjectIds.filter(id => !foundSubjectIds.includes(id));
        if(missingSubjects.length > 0) {
            return res.status(404).json({
                success: false,
                message: `Subject(s) do not exist: ${missingSubjects.join(', ')}`
            });
        }

        // Check for missing sections
        const missingSections = sectionIds.filter(id => !foundSectionIds.includes(id));
        if(missingSections.length > 0) {
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

        if(!teacher){
            return res.status(500).json({
                success: false,
                message: "Failed to create teacher"
            });
        }

        // Process sections and subjects updates
        for(const {section: sectionId, subject: subjectId} of sectionWithSubject) {
            try {
                // Update Section with teacher and subject
                const existingFaculty = await Section.findOne({
                    _id: sectionId,
                    "faculty.teacher": teacher._id
                });

                if(existingFaculty) {
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

                if(existingSubjectTeacher) {
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
        if(!otpResult.success){
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
        if(teacher) {
            try {
                // Remove teacher from all updated sections
                if(updatedSections.length > 0) {
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
                if(updatedSubjects.length > 0) {
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


export const verifyAuthOtp =async (req, res) => {
    const {email, otp} = req.body;
    if(!email || !otp) {
        return res.status(400).json({
            success: false,
            message: "Email and OTP are required"
        });
    }

    //otp length 
    if(otp.length !== 6) {
        return res.status(400).json({
            success: false,
            message: "OTP must be 6 digits long"
        });
    }

    const cachedOtp = redisClient.get(`otp_teacher_${email}`);
    if(!cachedOtp) {
        return res.status(400).json({
            success: false,
            message: "OTP has expired or does not exist"
        });
    }
    if(cachedOtp !== otp) {
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
    await user.save({validateBeforeSave: false});
    
    res.cookie("refreshToken", refreshToken, {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        sameSite: "lex",
        maxAge: 24 * 60 * 60 * 1000 
    })

    const loggedUser = await Teacher.findById(user._id)
    .populate('department', 'name')
    .populate('section', 'name batch')
    .populate('subjects', 'name code')
    .select("-password -refreshToken -__v -createdAt -updatedAt")


    return res.status(200).json({
        success: true,
        message: "OTP verified successfully",
        teacher: loggedUser,
        accessToken,
    });
}

export const resendAuthOtp = async (req, res) => {
    const {email} = req.body;
    if(!email) {
        return res.status(400).json({
            success: false,
            message: "Email is required"
        });
    }
    
    const otpLimit = await redisClient.get(`otp_cooldown_teacher_${email}`);
    if(otpLimit) {
        return res.status(429).json({
            success: false,
            message: "Please wait before requesting a new OTP"
        });
    }
    let otp  = await redisClient.get(`otp_teacher_${email}`);
    if(!otp){
        otp = Math.floor(100000 + Math.random() * 900000);
        await redisClient.set(`otp_teacher_${email}`, otp, "EX", 300); // 5 minutes
    }
    await redisClient.set(`otp_cooldown_teacher_${email}`, true, "EX", 60); // 1 minute cooldown
    const otpResult = await sendOTP(email, otp);
    if(!otpResult.success){
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


