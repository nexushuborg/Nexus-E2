import { Router } from 'express';
import { authStudentMiddleware, authTeacherMiddleware } from '../middlewares/auth.middleware.js';
import { createDoubt, getStudentDoubts, getTeacherDoubts, resolveDoubt } from '../controllers/doubt.controller.js';

const router = Router();

// Student routesZ
router.route('/student/create').post(authStudentMiddleware, createDoubt);
router.route('/student/list').get(authStudentMiddleware, getStudentDoubts);

// Teacher routes
router.route('/teacher/list').get(authTeacherMiddleware, getTeacherDoubts);
router.route('/teacher/resolve/:doubtId').patch(authTeacherMiddleware, resolveDoubt);

export default router;
