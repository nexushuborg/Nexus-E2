import { uploadFileOnCloudinary } from "../../services/cloudinary.service.js";
import Student from "../../models/student.model.js";
import fs from 'fs';

export const uploadProfileImage = async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({
                success: false,
                message: "No file uploaded"
            });
        }

        const cloudinaryResponse = await uploadFileOnCloudinary(req.file.path);

        if (!cloudinaryResponse) {
            if (req.file && fs.existsSync(req.file.path)) {
                fs.unlinkSync(req.file.path);
            }
            return res.status(500).json({
                success: false,
                message: "Failed to upload image to cloud storage"
            });
        }

        const updatedStudent = await Student.findByIdAndUpdate(
            req.user._id,
            {
                profile_picture: {
                    Image: cloudinaryResponse.secure_url,
                    publicId: cloudinaryResponse.public_id
                }
            },
            { new: true, runValidators: true } // why we are using runValidators: true? because we want to validate the updated data

        ).select('-password -refreshToken');
        
        if (!updatedStudent) {
            if (req.file && fs.existsSync(req.file.path)) {
                fs.unlinkSync(req.file.path);
            }
            return res.status(404).json({
                success: false,
                message: "Student not found"
            });
        }

        if (req.file && fs.existsSync(req.file.path)) {
            fs.unlinkSync(req.file.path);
        }

        return res.status(200).json({
            success: true,
            message: "Profile image uploaded and updated successfully",
            data: {
                url: cloudinaryResponse.secure_url,
                width: cloudinaryResponse.width,
                height: cloudinaryResponse.height,
                uploadedAt: new Date().toISOString(),
                student: {
                    full_name: updatedStudent?.full_name,
                    reg_number: updatedStudent.reg_no,
                    profile_picture: updatedStudent.profile_picture.Image
                }
            }
        });

    } catch (error) {
        console.error("Upload error:", error);

        if (req.file && fs.existsSync(req.file.path)) {
            fs.unlinkSync(req.file.path);
        }

        return res.status(500).json({
            success: false,
            message: "Internal server error during upload"
        });
    }
};