import Section from "../../models/section.model.js";
import Branches from "../../models/branch.model.js";
import Degree from "../../models/degree.model.js"
import Student from "../../models/student.model.js";
import { redisClient } from "../../configs/connectRedis.js"
import { sendOTP } from "../../services/sendmail.js"




export const registerStudent = async (req, res) => {
    try {
        const { full_name, password, reg_no, slno, section, email, phoneNo, degree, branch, batch, gender } = req.body;

        if (!full_name || !password || !reg_no || !slno || !section || !email || !phoneNo || !degree || !branch || !batch || !gender) {
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

        let checkedSection = await Section.findOne({
            section_name: section,
            batch,
            degree: existingDegree._id,
            branch: existingBranch._id
        })

        if (!checkedSection) {
            checkedSection = await Section.create({
                section_name: section,
                batch,
                degree: existingDegree._id,
                branch: existingBranch._id
            })
        }

        const student = await Student.create({
            full_name,
            password,
            reg_no,
            slno,
            section: checkedSection._id,
            email,
            phoneNo,
            degree: existingDegree._id,
            branch: existingBranch._id,
            batch,
            gender,

        })

        await Section.findByIdAndUpdate(
            checkedSection?._id,
            {
                $inc: { strength: 1 },
                $addToSet: { students: student._id }
            }
        );


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

        if(otp.length !== 6 ){
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
        await student.save();

        //clear otp from cache
        await redisClient.del(`otp:${email}`);
        await redisClient.del(`otp_limit:${email}`);

        const authenticatedUser = await Student.findById(student._id)
            .select("-password -v -refreshToken -v")
            .populate("degree", "short_name name")
            .populate("branch", "short_name name")
            .populate("section", "section_name");

        return res.cookie("refreshToken",refreshToken).status(200).json({
            success:true,
            message:"OTP verified successfully",
            student: authenticatedUser,
            accessToken,
        })

    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal server error",
        });
    }
}