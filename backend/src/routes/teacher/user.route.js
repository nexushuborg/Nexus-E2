import {Router} from "express";
import {getAllSections,getAllSubjectsAndDepartment,registerTeacher,verifyAuthOtp,resendAuthOtp} from "../../controllers/teacher/user.controller.js"

const router = Router();





router.post("/register",registerTeacher);
router.get("/get-all-subjects-and-department",getAllSubjectsAndDepartment);
router.get("/get-all-sections",getAllSections);
router.post("/verify-auth-otp", verifyAuthOtp);
router.post("/resend-auth-otp", resendAuthOtp)






export default router;