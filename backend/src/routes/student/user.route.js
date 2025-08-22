import { Router } from "express";
import { registerStudent, verifyAuthOtp } from "../../controllers/student/user.controller.js"
import { validateRequest } from "../../middlewares/validationRequest.js"
import { loginStudentSchema, registerStudentSchema } from "../../validation/student.valid.js"
import { upload } from "../../middlewares/multer.middleware.js";
import { uploadProfileImage } from "../../controllers/student/upload.controller.js";
import { authStudentMiddleware } from "../../middlewares/auth.middleware.js";
import {validateStudentInSection} from "../../middlewares/isSectionMember.js"
import { profileController } from "../../controllers/student/profile.controller.js";
import { loginController } from "../../controllers/student/user.controller.js";
import {
    logoutController,
    logoutAllController,
    resendAuthOtp,
    regenrateAccessToken,
    requestPasswordReset,
    verifyPasswordResetOtp,
    resetPassword,
    resendForgotPasswordOtp,
    verifyForgotPasswordOtp,
    resetForgotPassword,
    requestForgotPasswordOtp,
    getAllSubjectOfStudent,
    getNotes,
    downloadNotes
} from "../../controllers/student/user.controller.js";

const router = Router();

/**
 * @swagger
 * /student/register:
 *   post:
 *     tags: [Student Auth]
 *     summary: Register a new student
 *     description: Register a new student account with email verification
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
 *               - reg_no
 *               - phoneNo
 *               - batch
 *               - gender
 *               - department
 *               - section
 *             properties:
 *               full_name:
 *                 type: string
 *                 example: "John Doe"
 *               email:
 *                 type: string
 *                 format: email
 *                 example: "john.doe@example.com"
 *               password:
 *                 type: string
 *                 minLength: 6
 *                 example: "password123"
 *               reg_no:
 *                 type: string
 *                 example: "2021CS001"
 *               phoneNo:
 *                 type: string
 *                 example: "+1234567890"
 *               batch:
 *                 type: number
 *                 example: 2021
 *               gender:
 *                 type: string
 *                 enum: [male, female, other]
 *                 example: "male"
 *               department:
 *                 type: string
 *                 example: "60d21b4667d0d8992e610c85"
 *               section:
 *                 type: string
 *                 example: "60d21b4667d0d8992e610c85"
 *     responses:
 *       201:
 *         description: Student registered successfully
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
 *                   example: "Student registered successfully. Please verify your email."
 *       400:
 *         description: Validation error or email already exists
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.post("/register", validateRequest(registerStudentSchema), registerStudent);

/**
 * @swagger
 * /student/login:
 *   post:
 *     tags: [Student Auth]
 *     summary: Login student
 *     description: Authenticate student and return JWT tokens
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
 *                 example: "john.doe@example.com"
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
 *                     student:
 *                       $ref: '#/components/schemas/Student'
 *                     tokens:
 *                       type: object
 *                       properties:
 *                         accessToken:
 *                           type: string
 *                         refreshToken:
 *                           type: string
 *       401:
 *         description: Invalid credentials
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.post("/login", validateRequest(loginStudentSchema), loginController)

/**
 * @swagger
 * /student/logout:
 *   post:
 *     tags: [Student Auth]
 *     summary: Logout student
 *     description: Logout student and invalidate current session
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
router.post("/logout", authStudentMiddleware, logoutController)

/**
 * @swagger
 * /student/logout-all:
 *   post:
 *     tags: [Student Auth]
 *     summary: Logout from all devices
 *     description: Logout student from all devices and invalidate all sessions
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
router.post("/logout-all", authStudentMiddleware, logoutAllController)

/**
 * @swagger
 * /student/verify-auth-otp:
 *   post:
 *     tags: [Student Auth]
 *     summary: Verify authentication OTP
 *     description: Verify OTP sent during registration
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
 *                 example: "john.doe@example.com"
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
 * /student/resend-auth-otp:
 *   post:
 *     tags: [Student Auth]
 *     summary: Resend authentication OTP
 *     description: Resend OTP for email verification
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
 *                 example: "john.doe@example.com"
 *     responses:
 *       200:
 *         description: OTP sent successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Success'
 */
router.post("/resend-auth-otp", resendAuthOtp);

/**
 * @swagger
 * /student/regenerate-access-token:
 *   get:
 *     tags: [Student Auth]
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
router.get("/regenerate-access-token", regenrateAccessToken);

/**
 * @swagger
 * /student/upload-profile-image:
 *   post:
 *     tags: [Student Profile]
 *     summary: Upload profile image
 *     description: Upload and update student profile image
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
router.post("/upload-profile-image", authStudentMiddleware, upload.single('profileImage'), uploadProfileImage)

/**
 * @swagger
 * /student/profile:
 *   get:
 *     tags: [Student Profile]
 *     summary: Get student profile
 *     description: Get authenticated student's profile information
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
 *                   $ref: '#/components/schemas/Student'
 */
router.get("/profile", authStudentMiddleware, profileController)

/**
 * @swagger
 * /student/reset-password/request:
 *   post:
 *     tags: [Student Auth]
 *     summary: Request password reset
 *     description: Request password reset for logged-in student (sends OTP to email)
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
router.post('/reset-password/request', authStudentMiddleware, requestPasswordReset);

/**
 * @swagger
 * /student/reset-password/verify-otp:
 *   post:
 *     tags: [Student Auth]
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
router.post('/reset-password/verify-otp', authStudentMiddleware, verifyPasswordResetOtp);

/**
 * @swagger
 * /student/reset-password:
 *   post:
 *     tags: [Student Auth]
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
router.post('/reset-password', authStudentMiddleware, resetPassword);

/**
 * @swagger
 * /student/forgot-password/request:
 *   post:
 *     tags: [Student Auth]
 *     summary: Request forgot password OTP
 *     description: Request password reset for non-logged-in student (sends OTP to email)
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
 *                 example: "john.doe@example.com"
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
 * /student/forgot-password/verify-otp:
 *   post:
 *     tags: [Student Auth]
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
 *                 example: "john.doe@example.com"
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
 * /student/forgot-password/reset:
 *   post:
 *     tags: [Student Auth]
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
 * /student/forgot-password/resend-otp:
 *   post:
 *     tags: [Student Auth]
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
 *                 example: "john.doe@example.com"
 *     responses:
 *       200:
 *         description: OTP resent successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Success'
 */
router.post('/forgot-password/resend-otp', resendForgotPasswordOtp);

/**
 * @swagger
 * /student/get-all-subjects:
 *   get:
 *     tags: [Student Notes]
 *     summary: Get all subjects for student
 *     description: Get all subjects assigned to the student's section
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Subjects retrieved successfully
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
 *                   example: "Subjects retrieved successfully"
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *                     properties:
 *                       _id:
 *                         type: string
 *                         example: "60d21b4667d0d8992e610c85"
 *                       name:
 *                         type: string
 *                         example: "Computer Science"
 *                       code:
 *                         type: string
 *                         example: "CS101"
 */
router.get("/get-all-subjects", authStudentMiddleware,validateStudentInSection, getAllSubjectOfStudent);

/**
 * @swagger
 * /student/get-notes/{subjectId}:
 *   get:
 *     tags: [Student Notes]
 *     summary: Get notes for a subject
 *     description: Get notes for a specific subject with optional filtering by category and chapter
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: subjectId
 *         required: true
 *         schema:
 *           type: string
 *         description: ID of the subject
 *         example: "60d21b4667d0d8992e610c85"
 *       - in: query
 *         name: category
 *         schema:
 *           type: string
 *           enum: [notes, assignment, quiz, lab, pyq, project, other]
 *         description: Filter notes by category
 *         example: "notes"
 *       - in: query
 *         name: chapterNo
 *         schema:
 *           type: number
 *         description: Filter notes by chapter number
 *         example: 1
 *     responses:
 *       200:
 *         description: Notes retrieved successfully
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
 *                   example: "Notes retrieved successfully"
 *                 data:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Notes'
 */
router.get("/get-notes/:subjectId", authStudentMiddleware, validateStudentInSection, getNotes);

/**
 * @swagger
 * /student/download-notes/{fileId}:
 *   get:
 *     tags: [Student Notes]
 *     summary: Download notes file
 *     description: Download a specific notes file using Telegram Bot API
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: fileId
 *         required: true
 *         schema:
 *           type: string
 *         description: Telegram file ID of the notes file
 *         example: "BQACAgUAAyEGAASb56CfAAMJaKc..."
 *     responses:
 *       200:
 *         description: File download successful
 *         content:
 *           application/octet-stream:
 *             schema:
 *               type: string
 *               format: binary
 *       404:
 *         description: File not found
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Error'
 */
router.get("/download-notes/:fileId", authStudentMiddleware, downloadNotes);



export default router;