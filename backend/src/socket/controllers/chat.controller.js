import { MongoRedisLike } from '../../services/mongoRedisLike.js';
import { encryptMessage } from '../../services/messageEncryption.js';
import { uploadFile, getFileLink } from '../../services/chatService.js';
import Doubt from '../../models/doubt.model.js';

export class ChatController {
    static async handleTest(socket, data, ack) {
        try {
            console.log('Received data:', JSON.stringify(data, null, 2));

            // Postman socket.io event data is wrapped in a 'data' object
            //{
            //   "my_name": "YourName"
            //}
            const dataObj = typeof data === 'string' ? JSON.parse(data) : data;
            const myName = dataObj?.my_name || dataObj?.data?.my_name || 'Unknown';

            console.log('Extracted name:', myName);

            const payload = { message: `Hello ${myName}, your socket is working fine!` };

            socket.emit('test_response', payload);
            if (typeof ack === 'function') ack(payload);
        } catch (error) {
            console.error('Test handler error:', error);
            if (typeof ack === 'function') ack({ error: error.message });
        }
    }

    static async handlePingCheck(socket, data, ack) {
        try {
            const payload = { ok: true, now: Date.now(), echo: data ?? null };
            socket.emit('pong_check', payload);
            if (typeof ack === 'function') ack(payload);
        } catch (error) {
            console.error('Ping check error:', error);
            if (typeof ack === 'function') ack({ error: error.message });
        }
    }

    static async handleJoinRoom(socket, data, ack) {
        try {
            const { roomId, userId, userType, doubtStatus } = JSON.parse(data);

            // Leave previous rooms except own socket room
            for (const room of socket.rooms) {
                if (room !== socket.id) socket.leave(room);
            }


            if(socket.userType === "student"){
                const Room = await Doubt.findOne({
                    roomId
                })
                if(!Room.isMember(userId,0)){
                    if (typeof ack === 'function') ack({ ok: false,message:"You are not a member" });
                }
            }
            
            if(socket.userType === "teacher"){
                const Room = await Doubt.findOne({
                    roomId
                })
                if(!Room.isMember(userId,1)){
                    if (typeof ack === 'function') ack({ ok: false,message:"You are not a member" });
                }
            }

            await socket.join(roomId);
            socket.data.roomId = roomId;
            socket.data.doubtStatus = doubtStatus || 'unresolved';


            await MongoRedisLike.setUserSession(userId, {
                userid: userId,
                socketId: socket.id,
                status: 'online',
            });
            if (typeof ack === 'function') ack({ ok: true, roomId });
        } catch (error) {
            console.error('Join room error:', error);
            if (typeof ack === 'function') ack({ ok: false, error: error.message });
        }
    }

    static async handleSendMessage(socket, data, ack) {
        try {
            const { roomId, senderId, senderModel, recipientId, text, files } = JSON.parse(data);

            // Encrypt kr do text ko
            let encryptedContent = null;
            if (text) {
                encryptedContent = await encryptMessage(text);
            }

            // Upload files to Telegram
            let uploadedFiles = [];
            if (Array.isArray(files) && files.length > 0) {
                for (const f of files) {
                    const fileId = await uploadFile(f);
                    const url = await getFileLink(fileId);
                    uploadedFiles.push({
                        fileId,
                        url,
                        mimeType: f.mimetype,
                        name: f.originalname
                    });
                }
            }

            const outgoing = {
                roomId,
                senderId,
                senderModel,
                recipientId,
                content: encryptedContent,
                files: uploadedFiles,
                createdAt: new Date().toISOString(),
                status: 'sent'
            };

            // Determine if recipient is online
            let recipientOnline = false;
            if (recipientId) {
                const recSession = await MongoRedisLike.getUserSession(recipientId);
                recipientOnline = !!(recSession && recSession.status === 'online');
            } else {
                // Fallback: anyone else in room counts as recipient online
                const socketsInRoom = await socket.server.in(roomId).fetchSockets();
                recipientOnline = socketsInRoom.some(s => s.id !== socket.id);
            }

            if (recipientOnline) {
                socket.server.in(roomId).emit('new_message', outgoing);
                if (typeof ack === 'function') ack({ delivered: true });
            } else {
                // Cache for offline delivery
                if (!recipientId) throw new Error('recipientId is required when recipient is offline');
                await MongoRedisLike.addPendingMessage(recipientId, roomId, outgoing);
                if (typeof ack === 'function') ack({ queued: true });
            }
        } catch (error) {
            console.error('Send message error:', error);
            if (typeof ack === 'function') return ack({ error: error.message });
            socket.emit('error', { error: error.message });
        }
    }

    static async handleCheckMissedMessages(socket, data, ack) {
        try {
            const userId = socket?.userid;

            const pending = await MongoRedisLike.getPendingMessages(userId);
            console.log("Pending messages count:", pending?.length || 0);

            if (pending && pending.length > 0) {
                for (const p of pending) {
                    const id = p?.userId;
                    if (id === userId) {
                        socket.emit('new_message', p.payload);
                    }
                }
                await MongoRedisLike.clearPendingMessages(userId);
            }

            if (typeof ack === 'function') ack({ ok: true, delivered: pending?.length || 0 });
        } catch (error) {
            console.error('Check missed messages error:', error);
            if (typeof ack === 'function') ack({ ok: false, error: error.message });
        }
    }

    static async handleTypingStatus(socket, data) {
        try {
            const { roomId, userId, status } = data;
            if (roomId && userId) {
                socket.server.in(roomId).emit('user_typing', { userId, status: !!status });
            }
        } catch (error) {
            console.error('Typing status error:', error);
        }
    }

    static async handleDisconnect(socket) {
        try {
            console.log("mark1")
            if (socket?.userid) {
                await MongoRedisLike.setUserSession(socket?.userid, {
                    status: 'offline',
                    socketId: socket.id
                });
            }
        } catch (error) {
            console.error('Disconnect error:', error);
        }
    }
}