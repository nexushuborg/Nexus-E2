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
    deleteUploadedFiles,
    getNotes
} from "../../controllers/teacher/user.controller.js";
import { telegramUpload, upload } from "../../middlewares/multer.middleware.js";
import {uploadProfileImage} from "../../controllers/teacher/upload.controller.js"
import {validateRequest} from "../../middlewares/validationRequest.js"
import {registerTeacherSchema,loginTeacherSchema, newPasswordSchema} from "../../validation/teacher.valid.js"

const router = Router();

/**
 * @swagger
 * /teacher/register:
 *   post:
 *     tags: [Teacher Auth]
 *     summary: Register a new teacher
 *     description: Register a new teacher account with email verification
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - full_name
 *               - email
 *               - password
 *               - designation
 *               - gender
 *               - departments
 *               - subjects
 *               - sections
 *             properties:
 *               full_name:
 *                 type: string
 *                 example: "Dr. Jane Smith"
 *               email:
 *                 type: string
 *                 format: email
 *                 example: "jane.smith@example.com"
 *               password:
 *                 type: string
 *                 minLength: 6
 *                 example: "password123"
 *               designation:
 *                 type: string
 *                 example: "Professor"
 *               gender:
 *                 type: string
 *                 enum: [male, female, other]
 *                 example: "female"
 *               departments:
 *                 type: array
 *                 items:
 *                   type: string
 *                 example: ["60d21b4667d0d8992e610c85"]
 *               subjects:
 *                 type: array
 *                 items:
 *                   type: string
 *                 example: ["60d21b4667d0d8992e610c85"]
 *               sections:
 *                 type: array
 *                 items:
 *                   type: string
 *                 example: ["60d21b4667d0d8992e610c85"]
 *     responses:
 *       201:
 *         description: Teacher registered successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Success'
 */
router.post("/register",validateRequest(registerTeacherSchema), registerTeacher);

/**
 * @swagger
 * /teacher/get-all-subjects-and-department:
 *   get:
 *     tags: [Teacher Auth]
 *     summary: Get all subjects and departments
 *     description: Get all available subjects and departments for teacher registration
 *     responses:
 *       200:
 *         description: Subjects and departments retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "Data retrieved successfully"
 *                 data:
 *                   type: object
 *                   properties:
 *                     subjects:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           _id:
 *                             type: string
 *                           name:
 *                             type: string
 *                           code:
 *                             type: string
 *                     departments:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           _id:
 *                             type: string
 *                           name:
 *                             type: string
 */
router.get("/get-all-subjects-and-department", getAllSubjectsAndDepartment);

/**
 * @swagger
 * /teacher/get-all-sections:
 *   get:
 *     tags: [Teacher Auth]
 *     summary: Get all sections
 *     description: Get all available sections for teacher assignment
 *     responses:
 *       200:
 *         description: Sections retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "Sections retrieved successfully"
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       _id:
 *                         type: string
 *                       name:
 *                         type: string
 *                       department:
 *                         type: string
 */
router.get("/get-all-sections", getAllSections);

/**
 * @swagger
 * /teacher/verify-auth-otp:
 *   post:
 *     tags: [Teacher Auth]
 *     summary: Verify authentication OTP
 *     description: Verify OTP sent during teacher registration
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - otp
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *                 example: "jane.smith@example.com"
 *               otp:
 *                 type: string
 *                 example: "123456"
 *     responses:
 *       200:
 *         description: OTP verified successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Success'
 */
router.post("/verify-auth-otp", verifyAuthOtp);

/**
 * @swagger
 * /teacher/resend-auth-otp:
 *   post:
 *     tags: [Teacher Auth]
 *     summary: Resend authentication OTP
 *     description: Resend OTP for teacher email verification
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *                 example: "jane.smith@example.com"
 *     responses:
 *       200:
 *         description: OTP sent successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Success'
 */
router.post("/resend-auth-otp", resendAuthOtp)

/**
 * @swagger
 * /teacher/login:
 *   post:
 *     tags: [Teacher Auth]
 *     summary: Login teacher
 *     description: Authenticate teacher and return JWT tokens
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - password
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *                 example: "jane.smith@example.com"
 *               password:
 *                 type: string
 *                 example: "password123"
 *     responses:
 *       200:
 *         description: Login successful
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "Login successful"
 *                 data:
 *                   type: object
 *                   properties:
 *                     teacher:
 *                       $ref: '#/components/schemas/Teacher'
 *                     tokens:
 *                       type: object
 *                       properties:
 *                         accessToken:
 *                           type: string
 *                         refreshToken:
 *                           type: string
 */
router.post('/login',validateRequest(loginTeacherSchema), login);

/**
 * @swagger
 * /teacher/logout:
 *   post:
 *     tags: [Teacher Auth]
 *     summary: Logout teacher
 *     description: Logout teacher and invalidate current session
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Logout successful
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Success'
 */
router.post('/logout', authTeacherMiddleware, teacherLogoutController);

/**
 * @swagger
 * /teacher/logout-all:
 *   post:
 *     tags: [Teacher Auth]
 *     summary: Logout from all devices
 *     description: Logout teacher from all devices and invalidate all sessions
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Logout from all devices successful
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Success'
 */
router.post('/logout-all', authTeacherMiddleware, teacherLogoutAllController);

/**
 * @swagger
 * /teacher/profile:
 *   get:
 *     tags: [Teacher Profile]
 *     summary: Get teacher profile
 *     description: Get authenticated teacher's profile information
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Profile retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "Profile retrieved successfully"
 *                 data:
 *                   $ref: '#/components/schemas/Teacher'
 */
router.get("/profile", authTeacherMiddleware, teacherProfileController);

/**
 * @swagger
 * /teacher/upload-profile-image:
 *   post:
 *     tags: [Teacher Profile]
 *     summary: Upload profile image
 *     description: Upload and update teacher profile image
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               profileImage:
 *                 type: string
 *                 format: binary
 *                 description: Profile image file (max 5MB, jpg/jpeg/png only)
 *     responses:
 *       200:
 *         description: Profile image uploaded successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "Profile image uploaded successfully"
 *                 data:
 *                   type: object
 *                   properties:
 *                     profileImage:
 *                       type: string
 *                       example: "https://cloudinary.com/image/upload/v1234567890/profile.jpg"
 */
router.post("/upload-profile-image",authTeacherMiddleware,upload.single('profileImage'),uploadProfileImage)

/**
 * @swagger
 * /teacher/regenerate-access-token:
 *   post:
 *     tags: [Teacher Auth]
 *     summary: Regenerate access token
 *     description: Generate new access token using refresh token
 *     responses:
 *       200:
 *         description: Access token regenerated successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "Access token regenerated successfully"
 *                 data:
 *                   type: object
 *                   properties:
 *                     accessToken:
 *                       type: string
 */
router.post('/regenerate-access-token', regenerateTeacherAccessToken);

/**
 * @swagger
 * /teacher/reset-password/request:
 *   patch:
 *     tags: [Teacher Auth]
 *     summary: Request password reset
 *     description: Request password reset for logged-in teacher (sends OTP to email)
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Password reset OTP sent successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Success'
 */
router.patch('/reset-password/request', authTeacherMiddleware, requestPasswordReset);

/**
 * @swagger
 * /teacher/reset-password/verify-otp:
 *   post:
 *     tags: [Teacher Auth]
 *     summary: Verify password reset OTP
 *     description: Verify OTP for password reset and get reset token
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - otp
 *             properties:
 *               otp:
 *                 type: string
 *                 example: "123456"
 *     responses:
 *       200:
 *         description: OTP verified, reset token provided
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "OTP verified successfully"
 *                 data:
 *                   type: object
 *                   properties:
 *                     resetToken:
 *                       type: string
 */
router.post('/reset-password/verify-otp', authTeacherMiddleware, verifyPasswordResetOtp);

/**
 * @swagger
 * /teacher/reset-password:
 *   post:
 *     tags: [Teacher Auth]
 *     summary: Reset password
 *     description: Reset password using reset token (logs out from all devices)
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - resetToken
 *               - newPassword
 *             properties:
 *               resetToken:
 *                 type: string
 *                 description: Token received after OTP verification
 *               newPassword:
 *                 type: string
 *                 minLength: 6
 *                 example: "newpassword123"
 *     responses:
 *       200:
 *         description: Password reset successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Success'
 */
router.post('/reset-password',validateRequest(newPasswordSchema) ,authTeacherMiddleware, resetPassword);

/**
 * @swagger
 * /teacher/forgot-password/request:
 *   post:
 *     tags: [Teacher Auth]
 *     summary: Request forgot password OTP
 *     description: Request password reset for non-logged-in teacher (sends OTP to email)
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *                 example: "jane.smith@example.com"
 *     responses:
 *       200:
 *         description: Forgot password OTP sent successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Success'
 */
router.post('/forgot-password/request', requestForgotPasswordOtp);

/**
 * @swagger
 * /teacher/forgot-password/verify-otp:
 *   post:
 *     tags: [Teacher Auth]
 *     summary: Verify forgot password OTP
 *     description: Verify OTP for forgot password and get reset token
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - otp
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *                 example: "jane.smith@example.com"
 *               otp:
 *                 type: string
 *                 example: "123456"
 *     responses:
 *       200:
 *         description: OTP verified, reset token provided
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "OTP verified successfully"
 *                 data:
 *                   type: object
 *                   properties:
 *                     resetToken:
 *                       type: string
 */
router.post('/forgot-password/verify-otp', verifyForgotPasswordOtp);

/**
 * @swagger
 * /teacher/forgot-password/reset:
 *   post:
 *     tags: [Teacher Auth]
 *     summary: Reset forgotten password
 *     description: Reset password using reset token from forgot password flow
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - resetToken
 *               - newPassword
 *             properties:
 *               resetToken:
 *                 type: string
 *                 description: Token received after OTP verification
 *               newPassword:
 *                 type: string
 *                 minLength: 6
 *                 example: "newpassword123"
 *     responses:
 *       200:
 *         description: Password reset successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Success'
 */
router.post('/forgot-password/reset', resetForgotPassword);

/**
 * @swagger
 * /teacher/forgot-password/resend-otp:
 *   post:
 *     tags: [Teacher Auth]
 *     summary: Resend forgot password OTP
 *     description: Resend OTP for forgot password flow
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *                 example: "jane.smith@example.com"
 *     responses:
 *       200:
 *         description: OTP resent successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Success'
 */
router.post('/forgot-password/resend-otp',validateRequest(newPasswordSchema), resendForgotPasswordOtp);

/**
 * @swagger
 * /teacher/make-cr/{sectionId}:
 *   post:
 *     tags: [Teacher Management]
 *     summary: Make student class representative
 *     description: Assign a student as class representative for a section (max 2 CRs per section)
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: sectionId
 *         required: true
 *         schema:
 *           type: string
 *         description: ID of the section
 *         example: "60d21b4667d0d8992e610c85"
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - studentId
 *             properties:
 *               studentId:
 *                 type: string
 *                 description: ID of the student to make CR
 *                 example: "60d21b4667d0d8992e610c85"
 *     responses:
 *       200:
 *         description: CR assigned successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Success'
 *       400:
 *         description: Maximum 2 CRs already assigned for this section
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.post('/make-cr/:sectionId',authTeacherMiddleware, makeCRController);

/**
 * @swagger
 * /teacher/change-cr/{sectionId}:
 *   put:
 *     tags: [Teacher Management]
 *     summary: Change class representative
 *     description: Change existing class representative for a section
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: sectionId
 *         required: true
 *         schema:
 *           type: string
 *         description: ID of the section
 *         example: "60d21b4667d0d8992e610c85"
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - oldCRId
 *               - newCRId
 *             properties:
 *               oldCRId:
 *                 type: string
 *                 description: ID of the current CR to remove
 *                 example: "60d21b4667d0d8992e610c85"
 *               newCRId:
 *                 type: string
 *                 description: ID of the new student to make CR
 *                 example: "60d21b4667d0d8992e610c86"
 *     responses:
 *       200:
 *         description: CR changed successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Success'
 */
router.put('/change-cr/:sectionId',authTeacherMiddleware, changeCRController);

/**
 * @swagger
 * /teacher/get-all-students/{year}/{branch}:
 *   get:
 *     tags: [Teacher Management]
 *     summary: Get all students by year and branch
 *     description: Get all students in a particular year and branch
 *     parameters:
 *       - in: path
 *         name: year
 *         required: true
 *         schema:
 *           type: number
 *         description: Academic year
 *         example: 2021
 *       - in: path
 *         name: branch
 *         required: true
 *         schema:
 *           type: string
 *         description: Branch/Department ID
 *         example: "60d21b4667d0d8992e610c85"
 *     responses:
 *       200:
 *         description: Students retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "Students retrieved successfully"
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Student'
 */
router.get('/get-all-students/:year/:branch',getAllStudentsInYearAndBranchController);

/**
 * @swagger
 * /teacher/get-upload-section-notes-details:
 *   get:
 *     tags: [Teacher Notes]
 *     summary: Get upload details for notes
 *     description: Get all sections and subjects assigned to the teacher for notes upload
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Upload details retrieved successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "Upload details retrieved successfully"
 *                 data:
 *                   type: object
 *                   properties:
 *                     sections:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           _id:
 *                             type: string
 *                           name:
 *                             type: string
 *                           department:
 *                             type: object
 *                     subjects:
 *                       type: array
 *                       items:
 *                         type: object
 *                         properties:
 *                           _id:
 *                             type: string
 *                           name:
 *                             type: string
 *                           code:
 *                             type: string
 */
router.get("/get-upload-section-notes-details", authTeacherMiddleware, getUploadSectionNotesDetails);

/**
 * @swagger
 * /teacher/upload-notes:
 *   post:
 *     tags: [Teacher Notes]
 *     summary: Upload notes with files
 *     description: Upload notes with files, title, description, category, subject, and sections
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             required:
 *               - title
 *               - description
 *               - category
 *               - subject
 *               - sections
 *               - chapterNo
 *               - files
 *             properties:
 *               title:
 *                 type: string
 *                 example: "Chapter 1: Introduction to Programming"
 *               description:
 *                 type: string
 *                 example: "Basic concepts and fundamentals of programming"
 *               category:
 *                 type: string
 *                 enum: [notes, assignment, quiz, lab, pyq, project, other]
 *                 example: "notes"
 *               subject:
 *                 type: string
 *                 description: Subject ID
 *                 example: "60d21b4667d0d8992e610c85"
 *               sections:
 *                 type: array
 *                 items:
 *                   type: string
 *                 description: Array of section IDs
 *                 example: ["60d21b4667d0d8992e610c85", "60d21b4667d0d8992e610c86"]
 *               chapterNo:
 *                 type: number
 *                 description: Chapter number
 *                 example: 1
 *               files:
 *                 type: array
 *                 items:
 *                   type: string
 *                   format: binary
 *                 description: Files to upload (max 10 files, 30MB each)
 *     responses:
 *       201:
 *         description: Notes uploaded successfully
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 message:
 *                   type: string
 *                   example: "Notes uploaded successfully for all sections"
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Notes'
 */
router.post("/upload-notes",authTeacherMiddleware,telegramUpload.array("files",10),uploadNotes);

/**
 * @swagger
 * /teacher/delete-uploaded-files/{noteId}:
 *   delete:
 *     tags: [Teacher Notes]
 *     summary: Delete uploaded files
 *     description: Delete uploaded files from a specific note
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: noteId
 *         required: true
 *         schema:
 *           type: string
 *         description: ID of the note containing files to delete
 *         example: "60d21b4667d0d8992e610c85"
 *     responses:
 *       200:
 *         description: Files deleted successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Success'
 *       404:
 *         description: Note not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.delete("/delete-uploaded-files/:noteId", authTeacherMiddleware, deleteUploadedFiles);

/**
 * @swagger
 * /student/download-notes/{fileId}:
 *   get:
 *     tags: [Student Notes]
 *     summary: Download notes file
 *     description: Download a specific notes file using Telegram Bot API.
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: fileId
 *         required: true
 *         schema:
 *           type: string
 *         description: Telegram file ID of the notes file.
 *         example: "BQACAgUAAyEGAASb56CfAAMJaKc..."
 *     responses:
 *       200:
 *         description: File download successful.
 *         content:
 *           application/octet-stream:
 *             schema:
 *               type: string
 *               format: binary
 *       400:
 *         description: Bad request (e.g., missing file ID or Telegram API error).
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       404:
 *         description: File not found on Telegram or in the database.
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       413:
 *         description: File is too large to download via Telegram Bot API.
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 *       500:
 *         description: Internal server error while downloading the file.
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */

router.get("/get-notes/:subjectId", authTeacherMiddleware, getNotes);

export default router;