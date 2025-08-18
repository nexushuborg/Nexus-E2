import { uploadFileOnCloudinary } from "../../services/cloudinary.service.js";
import Teacher from "../../models/teacher.model.js";
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

        const updatedTeacher = await Teacher.findByIdAndUpdate(
            req.user._id,
            {
                profile_picture: {
                    Image: cloudinaryResponse.secure_url,
                    publicId: cloudinaryResponse.public_id
                }
            },
            { new: true, runValidators: true } // why we are using runValidators: true? because we want to validate the updated data

        ).select('-password -refreshToken');
        
        if (!updatedTeacher) {
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
                profile_picture: updatedTeacher.profile_picture.Image,
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

