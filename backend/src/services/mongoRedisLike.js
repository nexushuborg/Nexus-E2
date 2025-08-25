import ActiveSession from "../models/section.model.js";
import TypingStatus from "../models/typing.model.js";
import Student from "../models/student.model.js";
import Teacher from "../models/teacher.model.js";

/*
role = 1 then student
role = 2 then teacher
*/
class MongoRedisLike {
    static async setUserSession(userId, socketId, role) {
        await ActiveSession.findOneAndUpdate(
            { userId },
            {
                userId,
                socketId,
                status: "online",
                lastActivity: new Date(),
                expiresAt: new Date(Date.now() + 30 * 60 * 1000), // 30 minutes from now
            },
            {
                upsert: true,
                /*
                        it means if the document with the specified userId does not exist,
                        create a new document with the provided userId and socketId.
                        If it does exist, update the existing document with the new socketId.
                        */
            }
        );

        if (role == 1) {
            const student = await Student.findByIdAndUpdate(userId, {
                status: "online",
                socketId,
            });
            if (!student) {
                throw new Error("Student not found");
            }
        } else if (role == 2) {
            const teacher = await Teacher.findByIdAndUpdate(userId, {
                status: "online",
                socketId,
            });
            if (!teacher) {
                throw new Error("Teacher not found");
            }
        }
    }

    static async getUserSession(userId) {
        return await ActiveSession.findOne({ userId });
    }

    static async getAllActiveSessions() {
        return await ActiveSession.find({});
    }

    static async deleteUserSession(userId, role) {
        const session = await ActiveSession.findOneAndDelete({ userId });
        if (role == 1) {
            const student = await Student.findByIdAndUpdate(
                userId,
                {
                    status: "offline",
                    lastSeen: new Date(),
                    socketId: null,
                }
            );
        } else if (role == 2) {
            const teacher = await Teacher.findByIdAndUpdate(
                userId,
                {
                    status: "offline",
                    lastSeen: new Date(),
                    socketId: null,
                }
            );
        }
    }

    static async setTypingStatus(roomId, userId){
        await TypingStatus.findOneAndUpdate(
            { roomId, userId },
            {
                roomId,
                userId,
                isTyping: true,
                startedAt: new Date(),
                expiresAt: new Date(Date.now() + 10 * 1000), // 10 seconds 
            },
            {
                upsert: true,
            }
        )
    }

    static async getTypingStatus(roomId){
        return await TypingStatus.find({ roomId, isTyping: true });
    }
    static async clearTypingStatus(roomId, userId){
        await TypingStatus.findOneAndDelete({ roomId, userId });
    }
}

export default MongoRedisLike;
