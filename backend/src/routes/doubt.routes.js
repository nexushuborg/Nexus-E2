import { Router } from 'express';
import { authStudentMiddleware, authTeacherMiddleware } from '../middlewares/auth.middleware.js';
import { 
    createDoubt, 
    getStudentDoubts, 
    getTeacherDoubts, 
    resolveDoubt,
    createDoubtRoom,
    updateDoubtStatus,
    getDoubtHistory
} from '../controllers/doubt.controller.js';

const router = Router();

// Student routes
router.route('/student/create').post(authStudentMiddleware, createDoubt);
router.route('/student/list').get(authStudentMiddleware, getStudentDoubts);

// Teacher routes
router.route('/teacher/list').get(authTeacherMiddleware, getTeacherDoubts);
router.route('/teacher/resolve/:doubtId').patch(authTeacherMiddleware, resolveDoubt);

// Add these new routes
router.post('/create-room', createDoubtRoom);
router.patch('/:roomId/status', updateDoubtStatus);
router.get('/history/:userId', getDoubtHistory);

export default router;
