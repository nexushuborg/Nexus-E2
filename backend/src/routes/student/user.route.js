import {Router} from "express";
import {registerStudent,verifyAuthOtp} from "../../controllers/student/user.controller.js"
import {validateRequest} from "../../middlewares/validationRequest.js"
import {registerStudentSchema} from "../../validation/student.valid.js"

const router = Router();


router.post("/register",validateRequest(registerStudentSchema), registerStudent);
router.post("/verify-auth-otp",verifyAuthOtp);


export default router;