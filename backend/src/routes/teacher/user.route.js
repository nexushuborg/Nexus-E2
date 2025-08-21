import { Router } from "express";
import { getAllSections, getAllSubjectsAndDepartment, registerTeacher, verifyAuthOtp, resendAuthOtp, makeCRController, changeCRController, getAllStudentsInYearAndBranchController } from "../../controllers/teacher/user.controller.js"
import { authTeacherMiddleware } from "../../middlewares/auth.middleware.js";
import {
    teacherLogoutController,
    teacherLogoutAllController,
    teacherProfileController,
    requestPasswordReset,
    verifyPasswordResetOtp,
    resetPassword,
    requestForgotPasswordOtp,
    verifyForgotPasswordOtp,
    resetForgotPassword,
    resendForgotPasswordOtp,
    login,
    regenerateTeacherAccessToken,
    getUploadSectionNotesDetails,
    uploadNotes,
    deleteUploadedFiles
} from "../../controllers/teacher/user.controller.js";
import { telegramUpload, upload } from "../../middlewares/multer.middleware.js";
import {uploadProfileImage} from "../../controllers/teacher/upload.controller.js"
import {validateRequest} from "../../middlewares/validationRequest.js"
import {registerTeacherSchema,loginTeacherSchema, newPasswordSchema} from "../../validation/teacher.valid.js"

const router = Router();

router.post("/register",validateRequest(registerTeacherSchema), registerTeacher);
router.get("/get-all-subjects-and-department", getAllSubjectsAndDepartment);
router.get("/get-all-sections", getAllSections);
router.post("/verify-auth-otp", verifyAuthOtp);
router.post("/resend-auth-otp", resendAuthOtp)
router.post('/login',validateRequest(loginTeacherSchema), login);
router.post('/logout', authTeacherMiddleware, teacherLogoutController);
router.post('/logout-all', authTeacherMiddleware, teacherLogoutAllController);
router.get("/profile", authTeacherMiddleware, teacherProfileController);
router.post("/upload-profile-image",authTeacherMiddleware,upload.single('profileImage'),uploadProfileImage)
router.post('/regenerate-access-token', regenerateTeacherAccessToken);

//Routes related to reset-password for Teachers
//FLOW: Teacher is logged in → Goes to Profile/Settings → Clicks "Reset Password" button
//1: Teacher will request to reset-password and backend will send an OTP + 60 sec countdown
router.patch('/reset-password/request', authTeacherMiddleware, requestPasswordReset);
//2: Teacher enters the OTP received in the email and backend will verify the OTP and send a resetToken if the OTP is valid
router.post('/reset-password/verify-otp', authTeacherMiddleware, verifyPasswordResetOtp);
//3: Teacher enters the new password, frontend sends the resetToken and new password to the backend
//backend will verify the resetToken and update the password and log teacher out from all devices and redirect to login page
router.post('/reset-password',validateRequest(newPasswordSchema) ,authTeacherMiddleware, resetPassword);

//Routes related to forgot-password for Teachers
// FOR NOT LOGGED IN TEACHER
//FLOW: Teacher Clicks "Forgot Password" link
//1: Teacher enters email and backend sends an OTP to the email
router.post('/forgot-password/request', requestForgotPasswordOtp);
//2: Teacher enters the OTP received in email and backend verifies OTP and returns a resetToken
router.post('/forgot-password/verify-otp', verifyForgotPasswordOtp);
//3: Teacher enters new password with resetToken and backend resets the password
router.post('/forgot-password/reset', resetForgotPassword);
//4: Teacher can resend OTP if needed
router.post('/forgot-password/resend-otp',validateRequest(newPasswordSchema), resendForgotPasswordOtp);

//Only 2 CRs can be created for one section by using this route
router.post('/make-cr/:sectionId',authTeacherMiddleware, makeCRController); //This route returns error response when the Teacher tries to make more than 2 CRs for a section
//The Teacher can change the CR by using this route
router.put('/change-cr/:sectionId',authTeacherMiddleware, changeCRController);

router.get('/get-all-students/:year/:branch',getAllStudentsInYearAndBranchController); //Returns all the Students in a particular year and branch

router.get("/get-upload-section-notes-details", authTeacherMiddleware, getUploadSectionNotesDetails); //Returns all the sections of the teacher and subjects

router.post("/upload-notes",authTeacherMiddleware,telegramUpload.array("files",10),uploadNotes); //Uploads notes with files, title, description, category, subject, section
router.delete("/delete-uploaded-files/:noteId", authTeacherMiddleware, deleteUploadedFiles); //Deletes uploaded files from the notes

export default router;