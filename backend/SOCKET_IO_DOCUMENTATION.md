# Socket.IO Implementation Documentation

## 🚀 **Overview**

This document provides comprehensive details about the Socket.IO implementation for the doubt chat system. The system handles real-time communication between students and teachers with authentication, validation, and offline message queuing.

## 📁 **File Structure**

```
backend/src/socket/
├── index.js                           # Main Socket.IO server setup
├── middleware/
│   ├── auth.middleware.js             # Authentication middleware
│   └── validation.middleware.js       # Data validation middleware
├── controllers/
│   └── chat.controller.js             # Event handler logic
└── routes/
    └── chat.routes.js                 # Event routing and middleware chaining
```

## 🔐 **Authentication System**

### **Connection Authentication**
- **Method**: `socket.handshake.auth`
- **Required Fields**: `userId`, `role`
- **Validation**: User session verification via MongoDB
- **Result**: User data attached to socket object

```javascript
// Client connection with auth
const socket = io('ws://localhost:8000', {
  auth: {
    userId: "student-123",
    role: "Student"
  }
});
```

### **Socket Object Properties**
After authentication, socket object contains:
```javascript
socket.userId = "student-123"        // Authenticated user ID
socket.userRole = "Student"          // User role (Student/Teacher)
socket.userType = "student"          // Lowercase role
socket.data.roomId = "doubt-456"     // Current room (set when joining)
```

## 📡 **Socket Events**

### **Public Events (No Authentication Required)**

#### 1. **`test` Event**
- **Purpose**: Health check and connection testing
- **Data**: `{ my_name: string }`
- **Response**: `test_response` event + Ack callback
- **Use Case**: Verify socket connection and basic functionality

```javascript
// Client
socket.emit('test', { my_name: "Saswat" }, (ack) => {
  console.log('Ack response:', ack);
});

// Listen for response
socket.on('test_response', (data) => {
  console.log('Test response:', data.message);
});

// Server Response
{
  "message": "Hello Saswat, your socket is working fine!"
}
```

#### 2. **`ping_check` Event**
- **Purpose**: Latency and connection health monitoring
- **Data**: Any data (echoed back)
- **Response**: `pong_check` event + Ack callback
- **Use Case**: Monitor connection quality and response times

```javascript
// Client
socket.emit('ping_check', { timestamp: Date.now() }, (ack) => {
  console.log('Ping response:', ack);
});

// Listen for response
socket.on('pong_check', (data) => {
  console.log('Pong received:', data);
});

// Server Response
{
  "ok": true,
  "now": 1703123456789,
  "echo": { "timestamp": 1703123456789 }
}
```

### **Protected Events (Authentication Required)**

#### 3. **`join_doubt_room` Event**
- **Purpose**: Join a specific doubt chat room
- **Authentication**: Required
- **Validation**: Required fields + enum validation
- **Data**: `{ roomId, userId, userType, doubtStatus }`
- **Response**: Ack callback with room confirmation

```javascript
// Client
socket.emit('join_doubt_room', {
  roomId: "doubt_123",
  userId: "student-123",
  userType: "student",
  doubtStatus: "unresolved"
}, (ack) => {
  if (ack.ok) {
    console.log('Joined room:', ack.roomId);
  }
});

// Server Response (Ack)
{
  "ok": true,
  "roomId": "doubt_123"
}

// Server also emits
socket.emit('check_missed_messages', { userId: "student-123" });
```

**Validation Schema:**
```javascript
{
  required: ['roomId', 'userId'],
  enums: {
    userType: ['student', 'teacher'],
    doubtStatus: ['resolved', 'unresolved']
  }
}
```

#### 4. **`send_message` Event**
- **Purpose**: Send encrypted message to room participants
- **Authentication**: Required
- **Validation**: Required fields + enum validation
- **Data**: `{ roomId, senderId, senderModel, recipientId, text, files }`
- **Response**: Ack callback with delivery status

```javascript
// Client
socket.emit('send_message', {
  roomId: "doubt_123",
  senderId: "student-123",
  senderModel: "Student",
  recipientId: "teacher-456",
  text: "Hello teacher, I have a question",
  files: [] // Array of file objects
}, (ack) => {
  if (ack.delivered) {
    console.log('Message delivered');
  } else if (ack.queued) {
    console.log('Message queued for offline delivery');
  }
});

// Server Response (Ack)
{
  "delivered": true  // or "queued": true
}

// Server broadcasts to room
io.in("doubt_123").emit('new_message', {
  roomId: "doubt_123",
  senderId: "student-123",
  senderModel: "Student",
  recipientId: "teacher-456",
  content: { encryptedMessage: "...", key: "...", iv: "..." },
  files: [],
  createdAt: "2024-01-01T12:00:00.000Z",
  status: "sent"
});
```

**Validation Schema:**
```javascript
{
  required: ['roomId', 'senderId', 'senderModel'],
  enums: {
    senderModel: ['Student', 'Teacher']
  }
}
```

#### 5. **`check_missed_messages` Event**
- **Purpose**: Retrieve offline messages when user comes online
- **Authentication**: Required
- **Data**: `{ userId }`
- **Response**: Ack callback with delivery count

```javascript
// Client
socket.emit('check_missed_messages', {
  userId: "teacher-456"
}, (ack) => {
  console.log('Messages delivered:', ack.delivered);
});

// Server Response (Ack)
{
  "ok": true,
  "delivered": 3
}

// Server emits missed messages
socket.emit('new_message', { /* message data */ });
socket.emit('new_message', { /* message data */ });
socket.emit('new_message', { /* message data */ });
```

#### 6. **`typing_status` Event**
- **Purpose**: Broadcast typing indicators to room participants
- **Authentication**: Required
- **Data**: `{ roomId, userId, status }`
- **Response**: No response, broadcasts to room

```javascript
// Client
socket.emit('typing_status', {
  roomId: "doubt_123",
  userId: "student-123",
  status: true
});

// Server broadcasts to room
io.in("doubt_123").emit('user_typing', {
  userId: "student-123",
  status: true
});
```

## 🔄 **Event Flow Diagrams**

### **Message Delivery Flow**
```
Student (Online) → send_message → Server
                                    ↓
                              Check recipient status
                                    ↓
                              Recipient Online? → Yes → Broadcast to room
                                    ↓ No
                              Store in offline queue
                                    ↓
                              Ack: "queued"
```

### **Offline Message Retrieval Flow**
```
Teacher (Offline) ← Message stored in queue
        ↓
Teacher comes online → join_doubt_room
        ↓
Server emits check_missed_messages
        ↓
Teacher sends check_missed_messages
        ↓
Server delivers queued messages
        ↓
Server clears queue
        ↓
Ack: "delivered: 3"
```

## 🛡️ **Middleware Chain**

### **Authentication Middleware**
```javascript
// socket/middleware/auth.middleware.js
export const socketAuthMiddleware = async (socket, next) => {
  const { userId, role } = socket.handshake.auth;

  if (!userId || !role) {
    return next(new Error('Authentication required'));
  }

  // Validate session and attach user data
  // ... validation logic

  next();
};
```

### **Validation Middleware**
```javascript
// socket/middleware/validation.middleware.js
export const validateSocketData = (schema) => {
  return (socket, data, next) => {
    // Validate required fields, types, enums
    // ... validation logic

    next();
  };
};
```

### **Middleware Execution Order**
```
1. socketAuthMiddleware (global)
   ↓
2. Event received
   ↓
3. requireAuth (if protected event)
   ↓
4. validateSocketData (if validation required)
   ↓
5. Controller method execution
   ↓
6. Response/Ack sent
```

## 📊 **Error Handling**

### **Error Response Format**
```javascript
// Ack error response
{
  "error": "Error message description"
}

// Socket error event
socket.emit('error', {
  "error": "Error message description"
});
```

### **Common Error Scenarios**
1. **Authentication Failed**: Invalid or missing credentials
2. **Validation Failed**: Missing required fields or invalid data
3. **Room Join Failed**: Invalid room ID or user permissions
4. **Message Send Failed**: Invalid recipient or room access
5. **File Upload Failed**: Invalid file type or size

## 🔧 **Configuration Options**

### **Server Configuration**
```javascript
const io = new Server(server, {
  cors: {
    origin: process.env.ALLOWED_ORIGINS?.split(',') || '*',
    methods: ['GET', 'POST'],
    credentials: true
  },
  transports: ['polling', 'websocket'],
  pingTimeout: 30000
});
```

### **Environment Variables**
```bash
ALLOWED_ORIGINS=http://localhost:3000,https://yourapp.com
BOT_TOKEN=your_telegram_bot_token
TELEGRAM_CHAT_ID=your_telegram_chat_id
```

## 📱 **Client Implementation Examples**

### **JavaScript/Node.js Client**
```javascript
import { io } from 'socket.io-client';

const socket = io('ws://localhost:8000', {
  auth: {
    userId: 'student-123',
    role: 'Student'
  }
});

// Event listeners
socket.on('connect', () => {
  console.log('Connected to server');
});

socket.on('new_message', (message) => {
  console.log('New message received:', message);
});

socket.on('user_typing', (data) => {
  console.log('User typing:', data);
});

socket.on('error', (error) => {
  console.error('Socket error:', error);
});

// Join room
socket.emit('join_doubt_room', {
  roomId: 'doubt-123',
  userId: 'student-123',
  userType: 'student'
});

// Send message
socket.emit('send_message', {
  roomId: 'doubt-123',
  senderId: 'student-123',
  senderModel: 'Student',
  recipientId: 'teacher-456',
  text: 'Hello teacher!'
});
```

### **React Hook Example**
```javascript
import { useEffect, useRef } from 'react';
import { io } from 'socket.io-client';

const useSocket = (userId, role) => {
  const socketRef = useRef();

  useEffect(() => {
    socketRef.current = io('ws://localhost:8000', {
      auth: { userId, role }
    });

    socketRef.current.on('connect', () => {
      console.log('Connected to chat server');
    });

    return () => {
      socketRef.current?.disconnect();
    };
  }, [userId, role]);

  const joinRoom = (roomId, userType) => {
    socketRef.current?.emit('join_doubt_room', {
      roomId,
      userId,
      userType
    });
  };

  const sendMessage = (roomId, recipientId, text) => {
    socketRef.current?.emit('send_message', {
      roomId,
      senderId: userId,
      senderModel: role,
      recipientId,
      text
    });
  };

  return { socket: socketRef.current, joinRoom, sendMessage };
};
```

## 🧪 **Testing in Postman**

### **Socket.IO Connection Setup**
1. **Create Socket.IO Request**
   - URL: `ws://localhost:8000`
   - Auth Headers:
     ```
     userId: student-123
     role: Student
     ```

2. **Add Event Listeners**
   - `new_message`
   - `test_response`
   - `pong_check`
   - `user_typing`
   - `doubt_status_updated`

3. **Test Events**
   - `test` with Ack enabled
   - `join_doubt_room` with room data
   - `send_message` with message data
   - `typing_status` for typing indicators

## 📈 **Performance Considerations**

### **Connection Management**
- **Ping Timeout**: 30 seconds
- **Transport Fallback**: Polling → WebSocket
- **Room Management**: Automatic cleanup on disconnect
- **Session Expiry**: 30 minutes of inactivity

### **Scalability Features**
- **Global IO Instance**: Accessible throughout application
- **Room-based Broadcasting**: Efficient message delivery
- **Offline Queue**: Reduces server load during peak times
- **Connection Pooling**: Efficient socket management

## 🔍 **Debugging and Monitoring**

### **Server Logs**
```javascript
// Connection logs
Socket connected: socket-id-123
User authenticated: student-123 Student

// Event logs
📨 Event received: test from student-123 [{"my_name": "Saswat"}]
📨 Event received: join_doubt_room from student-123 [{"roomId": "doubt-123"}]

// Error logs
Socket auth error: Authentication failed
Join room error: Invalid room ID
```

### **Client Debug Mode**
```javascript
const socket = io('ws://localhost:8000', {
  auth: { userId: 'test', role: 'Student' },
  debug: true // Enable debug logging
});
```

## 🚨 **Security Features**

### **Authentication**
- Socket-level user verification
- Session-based authentication
- Role-based access control

### **Data Validation**
- Schema-based input validation
- Type and enum checking
- Required field validation

### **Message Security**
- End-to-end encryption
- Encrypted content storage
- Secure file handling

## 📚 **Additional Resources**

- **Socket.IO Official Docs**: https://socket.io/docs/
- **Real-time Chat Patterns**: https://socket.io/docs/v4/rooms/
- **Authentication Best Practices**: https://socket.io/docs/v4/middlewares/
- **Error Handling**: https://socket.io/docs/v4/error-handling/

---

**Last Updated**: January 2024
**Version**: 1.0.0
**Maintainer**: Development Team
