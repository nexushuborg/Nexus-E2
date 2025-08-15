import {Router} from "express";
import {registerStudent,verifyAuthOtp} from "../../controllers/student/user.controller.js"
import {validateRequest} from "../../middlewares/validationRequest.js"
import {loginStudentSchema, registerStudentSchema} from "../../validation/student.valid.js"
import { upload } from "../../middlewares/multer.middleware.js";
import { uploadProfileImage } from "../../controllers/student/upload.controller.js";
import { authStudentMiddleware } from "../../middlewares/auth.middleware.js";
import {profileController} from "../../controllers/student/profile.controller.js";
import { loginController } from "../../controllers/student/user.controller.js";
import { logoutController,logoutAllController,resendAuthOtp ,regenrateAccessToken,requestPasswordReset,verifyPasswordResetOtp,resetPassword,resendForgotPasswordOtp,verifyForgotPasswordOtp,resetForgotPassword,requestForgotPasswordOtp} from "../../controllers/student/user.controller.js";

const router = Router();


//Routes related to authentication
router.post("/register",validateRequest(registerStudentSchema), registerStudent);
router.post("/login",validateRequest(loginStudentSchema),loginController)
router.post("/logout",authStudentMiddleware,logoutController)
router.post("/logout-all",authStudentMiddleware,logoutAllController)
router.post("/verify-auth-otp",verifyAuthOtp);
router.post("/resend-auth-otp",resendAuthOtp);
router.get("/regenerate-access-token",regenrateAccessToken);

//Routes related to profile image upload
router.post("/upload-profile-image",authStudentMiddleware,upload.single('profileImage'),uploadProfileImage)
router.get("/profile",authStudentMiddleware,profileController)

//Routes related to reset-password
//FLOW: User is logged in → Goes to Profile/Settings → Clicks "Reset Password" button
//1: User will request to reset-password and backend will send an OTP + 60 sec coundown
router.post('/reset-password/request', authStudentMiddleware, requestPasswordReset);
//2: User enters the OTP received in the email and backend will verify the OTP and send a resetToken if the OTP is valid
router.post('/reset-password/verify-otp', authStudentMiddleware, verifyPasswordResetOtp);
//3: User enters the new password, frontend sends the resetToken and new password to the backend
//backend will verify the resetToken and update the password and log user out from all devices and redirect to login page
router.post('/reset-password', authStudentMiddleware, resetPassword);

//Routes related to forgot-password
// FOR NOT LOGGED IN USER
//FLOW: User is not logged in → On Login page → Clicks "Forgot Password" link
//1: User enters email and backend sends an OTP to the email
router.post('/forgot-password/request', requestForgotPasswordOtp);
//2: User enters the OTP received in email and backend verifies OTP and returns a resetToken
router.post('/forgot-password/verify-otp', verifyForgotPasswordOtp);
//3: User enters new password with resetToken and backend resets the password
router.post('/forgot-password/reset', resetForgotPassword);
//4: User can resend OTP *if needed*
router.post('/forgot-password/resend-otp', resendForgotPasswordOtp);

export default router;