import {Router} from "express";
import {registerStudent,verifyAuthOtp} from "../../controllers/student/user.controller.js"
import {validateRequest} from "../../middlewares/validationRequest.js"
import {registerStudentSchema} from "../../validation/student.valid.js"
import { upload } from "../../middlewares/multer.middleware.js";
import { uploadProfileImage } from "../../controllers/student/upload.controller.js";
import { verifyJWT } from "../../middlewares/auth.middleware.js";
import {profileAuthentication} from "../../middlewares/profile.middleware.js";
import {profileController} from "../../controllers/student/profile.controller.js";
import { loginController } from "../../controllers/student/user.controller.js";
import { loginValidation } from "../../middlewares/login.middleware.js";

const router = Router();


router.post("/register",validateRequest(registerStudentSchema), registerStudent);
router.post("/verify-auth-otp",verifyAuthOtp);
router.post("/upload-profile-image",verifyJWT,upload.single('profileImage'),uploadProfileImage)
router.get("/profile",profileAuthentication,profileController)
router.post("/login",loginValidation,loginController)

export default router;