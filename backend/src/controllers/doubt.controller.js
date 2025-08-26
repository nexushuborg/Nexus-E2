import Doubt from '../models/doubt.model.js';
import crypto from 'crypto';
import Subject from '../models/subject.model.js';
import { MongoRedisLike } from "../services/mongoRedisLike.js";

export const createDoubt = async (req, res) => {
    try {
        const { title, description, subjectId } = req.body;
        const studentId = req.user._id;

        if (!title || !description || !subjectId) {
            return res.status(400).json({
                success: false,
                message: "All fields are required"
            });
        }

        // Get teacher ID from subject
        const subject = await Subject.findById(subjectId).populate('subj_faculty');
        if (!subject) {
            return res.status(404).json({
                success: false,
                message: "Subject not found"
            });
        }

        // Get the first teacher assigned to this subject
        const teacher = subject.subj_faculty[0]?.teacher;
        if (!teacher) {
            return res.status(404).json({
                success: false,
                message: "No teacher assigned to this subject"
            });
        }

        // Create a unique room ID
        const roomId = crypto.randomUUID();

        const doubt = await Doubt.create({
            title,
            description,
            subject: subjectId,
            student: studentId,
            teacher,
            roomId,
            status: 'unresolved'
        });

        // Notify teacher about new doubt
        const teacherSocket = await MongoRedisLike.getUserSession(teacher.toString());
        if (teacherSocket?.status === 'online') {
            global.io.to(teacherSocket.socketId).emit('new_doubt', {
                doubtId: doubt._id,
                title,
                description,
                studentId,
                roomId
            });
        }

        return res.status(201).json({
            success: true,
            data: doubt,
            message: "Doubt created successfully"
        });
    } catch (error) {
        console.error('Error in createDoubt:', error);
        return res.status(500).json({
            success: false,
            message: "Internal server error"
        });
    }
};

export const resolveDoubt = async (req, res) => {
    try {
        const { doubtId } = req.params;
        const teacherId = req.user._id;

        const doubt = await Doubt.findOne({ _id: doubtId, teacher: teacherId });
        if (!doubt) {
            return res.status(404).json({
                success: false,
                message: "Doubt not found"
            });
        }

        doubt.status = 'resolved';
        await doubt.save();

        // Notify student about resolved doubt
        const studentSocket = await MongoRedisLike.getUserSession(doubt.student.toString());
        if (studentSocket?.status === 'online') {
            global.io.to(studentSocket.socketId).emit('doubt_resolved', {
                doubtId: doubt._id
            });
        }

        return res.status(200).json({
            success: true,
            data: doubt,
            message: "Doubt marked as resolved"
        });
    } catch (error) {
        console.error('Error in resolveDoubt:', error);
        return res.status(500).json({
            success: false,
            message: "Internal server error"
        });
    }
};

export const getStudentDoubts = async (req, res) => {
    try {
        const studentId = req.user._id;
        const doubts = await Doubt.find({ student: studentId })
            .populate('subject', 'subject_name subject_code')
            .populate('teacher', 'full_name')
            .sort('-createdAt');

        return res.status(200).json({
            success: true,
            data: doubts,
            message: "Doubts retrieved successfully"
        });
    } catch (error) {
        console.error('Error in getStudentDoubts:', error);
        return res.status(500).json({
            success: false,
            message: "Internal server error"
        });
    }
};

export const getTeacherDoubts = async (req, res) => {
    try {
        const teacherId = req.user._id;
        const { status } = req.query;

        const query = { teacher: teacherId };
        if (status) {
            query.status = status;
        }

        const doubts = await Doubt.find(query)
            .populate('subject', 'subject_name subject_code')
            .populate('student', 'full_name reg_no')
            .sort('-createdAt');

        return res.status(200).json({
            success: true,
            data: doubts,
            message: "Doubts retrieved successfully"
        });
    } catch (error) {
        console.error('Error in getTeacherDoubts:', error);
        return res.status(500).json({
            success: false,
            message: "Internal server error"
        });
    }
};
