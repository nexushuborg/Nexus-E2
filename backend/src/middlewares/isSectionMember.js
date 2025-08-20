import Section from "../models/section.model.js";

export const validateStudentInSection = async (req, res, next) => {
  try {
    const student = req.user;

    if (!student) {
      return res.status(401).json({
        success: false,
        message: "User not authenticated"
      });
    }

    const userSectionId = student?.section;
    if (!userSectionId) {
      return res.status(403).json({
        success: false,
        message: "User does not belong to any section"
      });
    }

    const section = await Section.findById(userSectionId)
      .populate("degree")
      .populate("students")
      .populate({
        path: "faculty.teacher",
        model: "Teacher",
        select: "_id name email"
      })
      .populate({
        path: "faculty.subjects",
        model: "Subject",
        select: "_id subject_code subject_name short_name"
      });

    if (!section) {
      return res.status(404).json({
        success: false,
        message: "Section not found"
      });
    }

    // ✅ Use .equals() for ObjectId comparison
    const isMember = section.students.some(s => s.equals(student._id));

    if (!isMember) {
      console.log("Failed membership check for student:", student._id);
      console.log("Section students include:", section.students.map(s => s.toString()));
      return res.status(403).json({
        success: false,
        message: "User is not a member of this section"
      });
    }

    req.section = section;
    next();

  } catch (error) {
    console.error("Error in isSectionMember middleware:", error);
    return res.status(500).json({
      success: false,
      message: "Internal server error",
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};