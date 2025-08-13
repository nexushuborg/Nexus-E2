import Student from "../../models/student.model.js";

const calculateAcademicYear = (batch) => {
    const currentYear = new Date().getFullYear();
    const yearsCompleted = batch - currentYear;

    if (yearsCompleted <= 0) {
        return `${Math.abs(yearsCompleted) + 1}${getOrdinalSuffix(Math.abs(yearsCompleted) + 1)} Year`;
    } else {
        return "Graduated";
    }
};

const getOrdinalSuffix = (num) => {
    const j = num % 10;
    const k = num % 100;

    if (j === 1 && k !== 11) {
        return "st";
    }
    if (j === 2 && k !== 12) {
        return "nd";
    }
    if (j === 3 && k !== 13) {
        return "rd";
    }
    return "th";
};

export const profileController = async (req, res) => {
    try {
        const student = await Student.findById(req.student._id)
            .populate('degree', 'name duration') // Assuming degree has name and duration fields
            .populate('branch', 'name code') // Assuming branch has name and code fields
            .populate('section', 'name') // Assuming section has name field
            .select('-password -refreshToken');

        if (!student) {
            return res.status(404).json({
                success: false,
                message: "Student not found"
            });
        }

        const academicYear = calculateAcademicYear(student.batch);

        const profileData = {
            profile_picture: student.profile_picture?.Image || null,
            full_name: student.full_name,
            degree: {
                name: student.degree?.name || null,
                duration: student.degree?.duration || null
            },
            reg_number: student.reg_no,
            academic_year: academicYear,
            branch: {
                name: student.branch?.name || null,
                code: student.branch?.code || null
            },
            section: student.section?.name || null
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
