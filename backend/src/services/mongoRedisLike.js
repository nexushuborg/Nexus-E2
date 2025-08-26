import Session from "../models/session.model.js";
import TypingStatus from "../models/typing.model.js";
import Student from "../models/student.model.js";
import Teacher from "../models/teacher.model.js";

export class MongoRedisLike {
    static async setUserSession(userId, sessionData) {
        await Session.findOneAndUpdate(
            { userId },
            {
                userId,
                ...sessionData,
                lastActivity: new Date(),
                expiresAt: new Date(Date.now() + 30 * 60 * 1000), // 30 minutes from now
            },
            { upsert: true }
        );

        // Update the user's status
        const [student, teacher] = await Promise.all([
            Student.findById(userId),
            Teacher.findById(userId)
        ]);

        if (student) {
            await Student.findByIdAndUpdate(userId, {
                status: sessionData.status,
                socketId: sessionData.socketId
            });
        } else if (teacher) {
            await Teacher.findByIdAndUpdate(userId, {
                status: sessionData.status,
                socketId: sessionData.socketId
            });
        }
    }

    static async getUserSession(userId) {
        return await Session.findOne({ userId });
    }

    static async getUserBySocketId(socketId) {
        const session = await Session.findOne({ socketId });
        return session?.userId;
    }

    static async getAllActiveSessions() {
        return await Session.find({ status: 'online' });
    }

    static async setTypingStatus(roomId, userId) {
        await TypingStatus.findOneAndUpdate(
            { roomId, userId },
            {
                roomId,
                userId,
                isTyping: true,
                startedAt: new Date(),
                expiresAt: new Date(Date.now() + 10 * 1000), // 10 seconds
            },
            { upsert: true }
        );
    }

    static async getTypingStatus(roomId) {
        return await TypingStatus.find({
            roomId,
            isTyping: true,
            expiresAt: { $gt: new Date() }
        });
    }

    static async clearTypingStatus(roomId, userId) {
        await TypingStatus.findOneAndDelete({ roomId, userId });
    }
}
