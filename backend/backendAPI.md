# Nexus-E2 Backend API

## Quick Setup
```bash
npm install
cp .env.example .env  # Edit with your values
npm start
```

**Environment Variables:**
```bash
PORT=3000
MONGO_URI=mongodb://localhost:27017/nexus-e2
JWT_SECRET=your_jwt_secret_key_here
```

## Database Models

**User Schema:**
```javascript
{
  fullname: { firstname: String (required), lastname: String },
  email: String (required, unique),
  password: String (required, min: 6, hidden),
  regnumber: String (required, unique),
  profilepic: { Image: String, ImageId: String }
}
```

**BlacklistToken Schema:**
```javascript
{
  token: String (required, unique),
  createdAt: Date (expires after 24h)
}
```

## API Endpoints

| Method | Endpoint | Description | Auth | Body Required |
|--------|----------|-------------|------|---------------|
| POST | `/students/register` | Register user | No | ✅ |
| POST | `/students/login` | Login user | No | ✅ |
| GET | `/students/profile` | Get profile | Yes | No |
| GET | `/students/logout` | Logout user | Yes | No |

## Authentication
- **JWT Token** valid for 24 hours
- Send via: Cookie OR `Authorization: Bearer <token>`
- Tokens blacklisted on logout

## Postman Testing

### 1. Register User
```http
POST /students/register
Content-Type: application/json

{
  "fullname": { "firstname": "John", "lastname": "Doe" },
  "email": "john@example.com",
  "password": "password123",
  "regnumber": "REG001"
}

Response: { "token": "jwt...", "user": {...} }
```

### 2. Login User
```http
POST /students/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}

Response: { "token": "jwt...", "user": {...} }
```

### 3. Get Profile
```http
GET /students/profile
Authorization: Bearer <your_jwt_token>

Response: { "_id": "...", "fullname": {...}, "email": "...", ... }
```

### 4. Logout
```http
GET /students/logout
Authorization: Bearer <your_jwt_token>

Response: { "message": "Logout successfull" }
```

## Validation Rules
- **Email:** Must be valid email format
- **Password:** Minimum 6 characters
- **All fields required** for registration

## Error Responses

**400 - Validation Error:**
```json
{ "errors": [{ "msg": "Email must be a valid email address", "param": "email" }] }
```

**401 - Unauthorized:**
```json
{ "message": "Unauthorised" }
```

## Frontend Integration

**Login Flow:**
1. POST `/students/login` → Store token
2. Include `Authorization: Bearer <token>` in headers
3. Handle 401 → Redirect to login

**Auth Check:**
- GET `/students/profile` → 200 = authenticated, 401 = redirect to login

**Logout:**
- GET `/students/logout` → Clear stored token → Redirect to login

## Security Features
- Passwords hashed with bcrypt (10 rounds)
- JWT tokens expire in 24h
- Token blacklisting on logout
- Automatic cleanup of expired tokens