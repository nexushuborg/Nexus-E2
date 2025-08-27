import Doubt from '../models/doubt.model.js';
import crypto from 'crypto';
import Subject from '../models/subject.model.js';
import { MongoRedisLike } from "../services/mongoRedisLike.js";
import Room from '../models/room.model.js'; // Added import for Room

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

// Add these new methods to the existing controller
export const createDoubtRoom = async (req, res) => {
    try {
        const { studentId, teacherId, subject, description, doubtType = 'unresolved' } = req.body;

        if (!studentId || !teacherId || !subject || !description) {
            return res.status(400).json({
                success: false,
                message: "Missing required fields: studentId, teacherId, subject, description"
            });
        }

        // Generate unique room ID
        const roomId = `doubt_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;

        // Create room in database
        const room = await Room.create({
            conversationId: roomId,
            participants: [studentId, teacherId],
            type: 'direct',
            createdBy: studentId,
            lastMessage: {
                messageId: null,
                text: `Doubt created: ${description.substring(0, 50)}...`,
                senderId: studentId,
                timestamp: new Date()
            },
            unreadCount: new Map([[teacherId, 1]]),
            isActive: true
        });

        // Create doubt record
        const doubt = await Doubt.create({
            roomId,
            studentId,
            teacherId,
            subject,
            description,
            status: doubtType,
            createdAt: new Date()
        });

        res.status(201).json({
            success: true,
            data: {
                roomId,
                doubtId: doubt._id,
                status: doubtType
            }
        });
    } catch (error) {
        console.error('Create doubt room error:', error);
        res.status(500).json({
            success: false,
            message: "Failed to create doubt room"
        });
    }
};

export const updateDoubtStatus = async (req, res) => {
    try {
        const { roomId } = req.params;
        const { status } = req.body;

        if (!['resolved', 'unresolved'].includes(status)) {
            return res.status(400).json({
                success: false,
                message: "Status must be 'resolved' or 'unresolved'"
            });
        }

        const doubt = await Doubt.findOneAndUpdate(
            { roomId },
            { status, resolvedAt: status === 'resolved' ? new Date() : null },
            { new: true }
        );

        if (!doubt) {
            return res.status(404).json({
                success: false,
                message: "Doubt not found"
            });
        }

        // Notify all participants via socket if they're online
        if (global.io) {
            global.io.in(roomId).emit('doubt_status_updated', {
                roomId,
                status,
                updatedAt: new Date().toISOString()
            });
        }

        res.json({
            success: true,
            data: doubt
        });
    } catch (error) {
        console.error('Update doubt status error:', error);
        res.status(500).json({
            success: false,
            message: "Failed to update doubt status"
        });
    }
};

export const getDoubtHistory = async (req, res) => {
    try {
        const { userId } = req.params;
        const { status, page = 1, limit = 10 } = req.query;

        const query = {};
        if (status) query.status = status;

        // Find doubts where user is either student or teacher
        query.$or = [
            { studentId: userId },
            { teacherId: userId }
        ];

        const doubts = await Doubt.find(query)
            .sort({ createdAt: -1 })
            .skip((page - 1) * limit)
            .limit(parseInt(limit))
            .populate('studentId', 'name email')
            .populate('teacherId', 'name email');

        const total = await Doubt.countDocuments(query);

        res.json({
            success: true,
            data: {
                doubts,
                pagination: {
                    page: parseInt(page),
                    limit: parseInt(limit),
                    total,
                    pages: Math.ceil(total / limit)
                }
            }
        });
    } catch (error) {
        console.error('Get doubt history error:', error);
        res.status(500).json({
            success: false,
            message: "Failed to fetch doubt history"
        });
    }
};

// Add this method for sending messages with files via REST API
export const sendMessageWithFiles = async (req, res) => {
    try {
        const { roomId, senderId, senderModel, recipientId, text } = req.body;
        const files = req.files;

        if (!roomId || !senderId || !senderModel) {
            return res.status(400).json({
                success: false,
                message: "Missing required fields: roomId, senderId, senderModel"
            });
        }

        // Import required services
        const { encryptMessage } = await import('../services/messageEncryption.js');
        const { MongoRedisLike } = await import('../services/mongoRedisLike.js');
        const { processAndUploadFiles } = await import('../services/fileUpload.service.js');

        // Encrypt text if present
        let encryptedContent = null;
        if (text) {
            encryptedContent = await encryptMessage(text);
        }

        // Process and upload files if present
        let uploadedFiles = [];
        if (files && files.length > 0) {
            uploadedFiles = await processAndUploadFiles(files);
        }

        const messageData = {
            roomId,
            senderId,
            senderModel,
            recipientId,
            content: encryptedContent,
            files: uploadedFiles,
            createdAt: new Date().toISOString(),
            status: 'sent'
        };

        // Check if recipient is online
        const recipientSession = await MongoRedisLike.getUserSession(recipientId);
        const recipientOnline = !!(recipientSession && recipientSession.status === 'online');

        if (recipientOnline) {
            // Send via socket if recipient is online
            if (global.io) {
                global.io.in(roomId).emit('new_message', messageData);
            }

            res.json({
                success: true,
                message: 'Message delivered',
                data: messageData
            });
        } else {
            // Queue for offline delivery
            if (!recipientId) {
                return res.status(400).json({
                    success: false,
                    message: "recipientId is required when recipient is offline"
                });
            }

            await MongoRedisLike.addPendingMessage(recipientId, roomId, messageData);

            res.json({
                success: true,
                message: 'Message queued for offline delivery',
                data: messageData
            });
        }
    } catch (error) {
        console.error('Send message with files error:', error);
        res.status(500).json({
            success: false,
            message: error.message
        });
    }
};
