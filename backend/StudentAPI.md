# Student API Testing Guide

## Base Configuration
| Property | Value |
|----------|-------|
| Base URL | `http://localhost:8000/api/v1/student` |
| Server Port | 8000 |
| Route Prefix | `/api/v1/student` |

## API Endpoints Overview

| Endpoint | Method | Authentication | Purpose |
|----------|--------|----------------|---------|
| `/register` | POST | None | Register new student |
| `/verify-auth-otp` | POST | None | Verify email OTP |
| `/login` | POST | None | Student login |
| `/logout` | POST | Bearer Token | Logout current session |
| `/logout-all` | POST | Bearer Token | Logout from all devices |
| `/profile` | GET | Bearer Token | Get student profile |
| `/upload-profile-image` | POST | Bearer Token | Upload profile image |

## 1. Register Student

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/register` |
| **Authentication** | None |

### Headers
| Key | Value |
|-----|-------|
| Content-Type | application/json |

### Request Body
```json
{
  "full_name": "John Doe",
  "password": "password123",
  "reg_no": "21CS001",
  "slno": "123456",
  "section": "A",
  "email": "john.doe@example.com",
  "phoneNo": "9876543210",
  "degree": "BTech",
  "branch": "CSE",
  "batch": 2021,
  "gender": "Male"
}
```

### Response (201 - Success)
```json
{
  "success": true,
  "message": "Student registered successfully"
}
```

## 2. Verify OTP

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/verify-auth-otp` |
| **Authentication** | None |

### Headers
| Key | Value |
|-----|-------|
| Content-Type | application/json |

### Request Body
```json
{
  "email": "john.doe@example.com",
  "otp": "123456"
}
```

### Response (200 - Success)
```json
{
  "success": true,
  "message": "OTP verified successfully",
  "student": {
    "full_name": "John Doe",
    "email": "john.doe@example.com",
    "reg_no": "21CS001",
    "degree": {
      "name": "Bachelor of Technology",
      "short_name": "BTech"
    },
    "branch": {
      "name": "Computer Science",
      "short_name": "CSE"
    },
    "section": {
      "section_name": "A"
    }
  },
  "accessToken": "eyJhbGciOiJIUzI1NiIs..."
}
```

## 3. Login Student

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/login` |
| **Authentication** | None |

### Headers
| Key | Value |
|-----|-------|
| Content-Type | application/json |

### Request Body
```json
{
  "email": "john.doe@example.com",
  "reg_no": "21CS001",
  "password": "password123"
}
```

### Response (200 - Success)
```json
{
  "success": true,
  "message": "Login successful",
  "student": {
    "full_name": "John Doe",
    "email": "john.doe@example.com",
    "reg_no": "21CS001"
  },
  "accessToken": "eyJhbGciOiJIUzI1NiIs..."
}
```

## 4. Logout Current Session

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/logout` |
| **Authentication** | Bearer Token Required |

### Headers
| Key | Value |
|-----|-------|
| Authorization | Bearer `<access_token>` |
| Content-Type | application/json |

### Request Body
```json
{}
```
*Note: Body can be empty or you can include refresh token if not using cookies*

```json
{
  "refreshToken": "optional_refresh_token_if_not_using_cookies"
}
```

### Response (200 - Success)
```json
{
  "success": true,
  "message": "Logout successful"
}
```

### Postman Testing Steps
| Step | Action |
|------|--------|
| 1 | Set method to POST |
| 2 | Add Authorization header with Bearer token from login |
| 3 | Set Content-Type to application/json |
| 4 | Body can be empty or raw JSON |
| 5 | Send request |

## 5. Logout From All Devices

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/logout-all` |
| **Authentication** | Bearer Token Required |

### Headers
| Key | Value |
|-----|-------|
| Authorization | Bearer `<access_token>` |
| Content-Type | application/json |

### Request Body
```json
{}
```
*Note: Body can be empty - token from header is sufficient*

### Response (200 - Success)
```json
{
  "success": true,
  "message": "Logged out from all devices successfully"
}
```

### Postman Testing Steps
| Step | Action |
|------|--------|
| 1 | Set method to POST |
| 2 | Add Authorization header with Bearer token |
| 3 | Set Content-Type to application/json |
| 4 | Leave body empty or use empty JSON object |
| 5 | Send request |

## 6. Get Profile

| Property | Value |
|----------|-------|
| **Method** | GET |
| **Endpoint** | `/profile` |
| **Authentication** | Bearer Token Required |

### Headers
| Key | Value |
|-----|-------|
| Authorization | Bearer `<access_token>` |
| Content-Type | application/json |

### Response (200 - Success)
```json
{
  "success": true,
  "message": "Profile retrieved successfully",
  "data": {
    "profile_picture": "https://cloudinary.com/image.jpg",
    "full_name": "John Doe",
    "degree": {
      "name": "Bachelor of Technology",
      "duration": 4
    },
    "reg_number": "21CS001",
    "academic_year": "4th Year",
    "branch": {
      "name": "Computer Science Engineering",
      "code": "CSE"
    },
    "section": "A"
  }
}
```

## 7. Upload Profile Image

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/upload-profile-image` |
| **Authentication** | Bearer Token Required |
| **Content Type** | multipart/form-data |

### Headers
| Key | Value |
|-----|-------|
| Authorization | Bearer `<access_token>` |

### Postman Setup for File Upload
| Step | Action |
|------|--------|
| 1 | Select POST method |
| 2 | Add Authorization header with Bearer token |
| 3 | Go to Body tab → Select "form-data" |
| 4 | Add key "profileImage" and change type to "File" |
| 5 | Select your image file (jpg, png, etc.) |

### Request Body (form-data)
| Key | Type | Value |
|-----|------|-------|
| profileImage | File | Select image file |

### Response (200 - Success)
```json
{
  "success": true,
  "message": "Profile image uploaded and updated successfully",
  "data": {
    "url": "https://res.cloudinary.com/your-cloud/image.jpg",
    "publicId": "profile_images/abc123",
    "width": 500,
    "height": 500,
    "uploadedAt": "2024-01-15T10:30:00.000Z",
    "student": {
      "full_name": "John Doe",
      "reg_number": "21CS001",
      "profile_picture": "https://res.cloudinary.com/your-cloud/image.jpg"
    }
  }
}
```

## Complete Testing Flow

| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | POST `/register` with student data | 201 - Registration success |
| 2 | Check email for OTP | 6-digit OTP received |
| 3 | POST `/verify-auth-otp` with email & OTP | 200 - Get access token |
| 4 | GET `/profile` with Bearer token | 200 - Profile data |
| 5 | POST `/upload-profile-image` with token & file | 200 - Image uploaded |
| 6 | POST `/logout` with Bearer token | 200 - Session ended |
| 7 | GET `/profile` with same token | 401 - Token revoked |
| 8 | POST `/login` again | 200 - New session created |
| 9 | POST `/logout-all` with new token | 200 - All sessions ended |

## Authentication States Testing

| Scenario | Expected Status | Response Message |
|----------|----------------|------------------|
| Valid token for protected routes | 200 | Success |
| No token provided | 401 | "Access denied. No token provided." |
| Invalid/malformed token | 401 | "Invalid access token" |
| Expired token | 401 | "Access token has expired" |
| Blacklisted token (after logout) | 401 | "Token has been revoked. Please login again." |
| Unverified account | 403 | "Account not verified" |

## Logout Scenarios Testing

| Test Case | Setup | Expected Result |
|-----------|--------|----------------|
| **Normal Logout** | Login → POST `/logout` | 200 - Token blacklisted |
| **Multiple Device Logout** | Login on 2 tokens → POST `/logout-all` | All tokens invalidated |
| **Already Logged Out** | Logout → Use same token | 401 - Token revoked |
| **Invalid Token Logout** | POST `/logout` with invalid token | 401 - Invalid token |
| **Logout Without Token** | POST `/logout` without Authorization | 401 - Token required |

## Token Management Flow

| Action | Frontend Behavior | Backend Response |
|--------|------------------|------------------|
| **Login** | Store access token, set refresh cookie | 200 - Tokens provided |
| **Access Protected Route** | Send Bearer token in header | 200/401 based on token |
| **Logout** | Clear stored token, call logout API | 200 - Token blacklisted |
| **Logout All** | Clear all stored tokens | 200 - All sessions ended |
| **Token Expired** | Redirect to login page | 401 - Need new login |

## Security Features

| Feature | Description |
|---------|-------------|
| **Token Blacklisting** | Logged out tokens cannot be reused |
| **Automatic Cleanup** | Expired blacklisted tokens are cleaned periodically |
| **Multi-Device Support** | Can logout from current device or all devices |
| **HTTP-Only Cookies** | Refresh tokens stored securely |
| **Bearer Token Auth** | Standard JWT implementation |

## Important Notes

| Topic | Details |
|-------|---------|
| OTP Expiry | 5 minutes after generation |
| OTP Cooldown | 60 seconds between requests |
| Token Storage | Store access token securely in localStorage/sessionStorage |
| Token Transmission | Always use Authorization header for protected routes |
| Logout Behavior | Tokens are blacklisted and cannot be reused |
| Session Management | `/logout-all` invalidates all user sessions |
| File Formats | Supports common image formats (jpg, png, gif) |
| Response Format | All endpoints return JSON |
| Refresh Tokens | Automatically set as HTTP-only cookies |

## Required Fields Validation

### Registration Fields
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| full_name | String | Yes | Student full name |
| password | String | Yes | Account password |
| reg_no | String | Yes | Registration number (unique) |
| slno | String | Yes | Serial number |
| section | String | Yes | Class section |
| email | String | Yes | Email address (unique) |
| phoneNo | String | Yes | Phone number (unique) |
| degree | String | Yes | Degree name or short name |
| branch | String | Yes | Branch name or short name |
| batch | Number | Yes | Batch year |
| gender | String | Yes | Student gender |

### Login Fields
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| email | String | Yes | Registered email address |
| reg_no | String | Yes | Registration number |
| password | String | Yes | Account password |

### OTP Verification Fields
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| email | String | Yes | Email address |
| otp | String | Yes | 6-digit OTP code |

### Logout Fields
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| Authorization Header | String | Yes | Bearer `<access_token>` |
| refreshToken | String | No | Optional if not using cookies |
