import {Router} from "express";
import {registerStudent,verifyAuthOtp} from "../../controllers/student/user.controller.js"
import {validateRequest} from "../../middlewares/validationRequest.js"
import {loginStudentSchema, registerStudentSchema} from "../../validation/student.valid.js"
import { upload } from "../../middlewares/multer.middleware.js";
import { uploadProfileImage } from "../../controllers/student/upload.controller.js";
import { authStudentMiddleware } from "../../middlewares/auth.middleware.js";
import {profileController} from "../../controllers/student/profile.controller.js";
import { loginController } from "../../controllers/student/user.controller.js";
import { logoutController,logoutAllController,resendAuthOtp ,regenrateAccessToken} from "../../controllers/student/user.controller.js";

const router = Router();


//Routes related to authentication 
router.post("/register",validateRequest(registerStudentSchema), registerStudent);
router.post("/login",validateRequest(loginStudentSchema),loginController)
router.post("/logout",authStudentMiddleware,logoutController)
router.post("/logout-all",authStudentMiddleware,logoutAllController)
router.post("/verify-auth-otp",verifyAuthOtp);
router.post("/resend-auth-otp",resendAuthOtp);
router.get("/regenerate-access-token",regenrateAccessToken);


router.post("/upload-profile-image",authStudentMiddleware,upload.single('profileImage'),uploadProfileImage)
router.get("/profile",authStudentMiddleware,profileController)

export default router;