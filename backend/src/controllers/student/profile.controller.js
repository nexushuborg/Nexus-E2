import Student from "../../models/student.model.js";

export const profileController = async (req, res) => {
    try {
        const student = await Student.findById(req.user._id)
            .populate('degree', 'name duration') // Assuming degree has name and duration fields
            .populate('branch', 'name short_name') // Assuming branch has name and code fields
            .populate('section', 'section_name') // Assuming section has name field
            .select('-password -refreshToken');

        if (!student) {
            return res.status(404).json({
                success: false,
                message: "Student not found"
            });
        }

        // Calculate academic year based on batch
        const currentYear = new Date().getFullYear();
        const yearOfAdmission = student.batch - 4; // Assuming 4-year course
        const academicYear = Math.min(4, Math.max(1, currentYear - yearOfAdmission));

        if (student.section) {
            console.log(student.section.section_name);
        }

        const profileData = {
            profile_picture: student.profile_picture?.Image || null,
            full_name: student.full_name,
            degree: {
                name: student.degree?.name || null
            },
            reg_number: student.reg_no,
            academic_year: academicYear,
            branch: {
                name: student.branch?.name || null,
                short_name: student.branch?.short_name || null
            },
            batch: student.batch,
            section: student?.section?.section_name || null,
        };

        return res.status(200).json({
            success: true,
            message: "Profile retrieved successfully",
            data: profileData
        });

    } catch (error) {
        console.error("Get profile error:", error);
        return res.status(500).json({
            success: false,
            message: "Internal server error",
            error: process.env.NODE_ENV === 'development' ? error.message : undefined
        });
    }
};
