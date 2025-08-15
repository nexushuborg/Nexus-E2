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
| `/reset-password/request` | POST | Bearer Token | Request password reset OTP |
| `/reset-password/verify-otp` | POST | Bearer Token | Verify password reset OTP |
| `/reset-password` | POST | Bearer Token | Reset password with new password |
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

## 4. Reset Password (3-Step Process)

> **Note**: Password reset is for **authenticated users only**. User must be logged in to reset their password. This is different from "forgot password" functionality.

### Password Reset Flow Overview:

• **Step 1 - Request OTP**: Send your **access token** (from login) in Authorization header to `POST /reset-password/request` with **empty body** → Backend uses token to identify user, generates 6-digit OTP, stores in Redis (5min expiry), sends OTP to user's registered email, returns success message with 60-second rate limit

• **Step 2 - Verify OTP**: Send your **access token** + **OTP from email** in body `{"otp": "123456"}` to `POST /reset-password/verify-otp` → Backend validates OTP against Redis cache, generates **resetToken** (6-digit, 10min expiry), stores in Redis, returns `{"resetToken": "789012"}` which you must save for next step

• **Step 3 - Reset Password**: Send your **access token** + **new password** + **resetToken from step 2** in body `{"newPassword": "newPass123", "resetToken": "789012"}` to `POST /reset-password` → Backend validates resetToken, updates password, **logs out user from all devices**, blacklists current access token, clears all Redis entries, returns success message → **User must login again with new password**

### 4.1 Request Password Reset OTP

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/reset-password/request` |
| **Authentication** | Bearer Token Required |

#### Headers
| Key | Value |
|-----|-------|
| Authorization | Bearer `<access_token>` |
| Content-Type | application/json |

#### Request Body
```json
{}
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "Password reset OTP sent successfully to your registered email"
}
```

### 4.2 Verify Password Reset OTP

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/reset-password/verify-otp` |
| **Authentication** | Bearer Token Required |

#### Headers
| Key | Value |
|-----|-------|
| Authorization | Bearer `<access_token>` |
| Content-Type | application/json |

#### Request Body
```json
{
  "otp": "123456"
}
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "Password reset OTP verified successfully",
  "resetToken": "789012"
}
```

### 4.3 Reset Password

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/reset-password` |
| **Authentication** | Bearer Token Required |

#### Headers
| Key | Value |
|-----|-------|
| Authorization | Bearer `<access_token>` |
| Content-Type | application/json |

#### Request Body
```json
{
  "newPassword": "newPassword123",
  "resetToken": "789012"
}
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "Password reset successfully. Please login with your new password."
}
```

## 5. Logout Current Session

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

## 6. Logout From All Devices

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

## 7. Get Profile

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

## 8. Upload Profile Image

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
| 6 | POST `/reset-password/request` with Bearer token | 200 - Reset OTP sent |
| 7 | Check email for reset OTP | 6-digit reset OTP received |
| 8 | POST `/reset-password/verify-otp` with OTP | 200 - Get reset token |
| 9 | POST `/reset-password` with new password & reset token | 200 - Password changed, logged out |
| 10 | POST `/login` with new password | 200 - Login with new credentials |
| 11 | POST `/logout` with Bearer token | 200 - Session ended |
| 12 | GET `/profile` with same token | 401 - Token revoked |

## Password Reset Testing Flow (Step-by-Step)

| Step | Endpoint | Body | Expected Response | Notes |
|------|----------|------|------------------|-------|
| **1** | `POST /login` | `{"email": "user@example.com", "reg_no": "21CS001", "password": "oldPassword"}` | 200 - Access token | **Save access token** |
| **2** | `POST /reset-password/request` | `{}` (empty) | 200 - OTP sent message | Check email for OTP |
| **3** | Wait 60 seconds | - | - | Rate limiting cooldown |
| **4** | `POST /reset-password/request` | `{}` (empty) | 429 - Rate limited | Before 60 seconds |
| **5** | `POST /reset-password/verify-otp` | `{"otp": "123456"}` | 200 - Reset token | **Save resetToken** |
| **6** | `POST /reset-password` | `{"newPassword": "newPassword123", "resetToken": "789012"}` | 200 - Password reset | User logged out |
| **7** | `GET /profile` | - | 401 - Token revoked | Previous token invalid |
| **8** | `POST /login` | `{"email": "user@example.com", "reg_no": "21CS001", "password": "newPassword123"}` | 200 - New session | Login with new password |

## Authentication States Testing

| Scenario | Expected Status | Response Message |
|----------|----------------|------------------|
| Valid token for protected routes | 200 | Success |
| No token provided | 401 | "Access denied. No token provided." |
| Invalid/malformed token | 401 | "Invalid access token" |
| Expired token | 401 | "Access token has expired" |
| Blacklisted token (after logout) | 401 | "Token has been revoked. Please login again." |
| Unverified account | 403 | "Account not verified" |

## Password Reset Security Features

| Feature | Description | Implementation |
|---------|-------------|----------------|
| **Rate Limiting** | 60-second cooldown between OTP requests | Redis cache with expiry |
| **OTP Expiry** | OTP valid for 5 minutes only | Redis TTL |
| **Reset Token Expiry** | Reset token valid for 10 minutes | Redis TTL |
| **Session Invalidation** | All sessions logged out after password reset | Refresh token clearing + token blacklisting |
| **Same Password Check** | Prevents setting same password | Password comparison |
| **Authentication Required** | Only logged-in users can reset password | Bearer token validation |

## Password Reset Error Scenarios

| Scenario | HTTP Status | Response Message |
|----------|-------------|------------------|
| **Request OTP without auth** | 401 | "Access token required" |
| **Request OTP too soon** | 429 | "Please wait before requesting a new password reset OTP" |
| **Invalid OTP format** | 400 | "OTP must be 6 digits long" |
| **Expired OTP** | 400 | "Password reset OTP expired or not found" |
| **Wrong OTP** | 400 | "Invalid password reset OTP" |
| **Password too short** | 400 | "Password must be at least 6 characters long" |
| **Invalid reset token** | 400 | "Invalid or expired reset token. Please verify OTP again." |
| **Same as current password** | 400 | "New password cannot be the same as current password" |

## Logout Scenarios Testing

| Test Case | Setup | Expected Result |
|-----------|--------|----------------|
| **Normal Logout** | Login → POST `/logout` | 200 - Token blacklisted |
| **Multiple Device Logout** | Login on 2 tokens → POST `/logout-all` | All tokens invalidated |
| **Already Logged Out** | Logout → Use same token | 401 - Token revoked |
| **Invalid Token Logout** | POST `/logout` with invalid token | 401 - Invalid token |
| **Logout Without Token** | POST `/logout` without Authorization | 401 - Token required |
| **Auto Logout After Password Reset** | Reset password → Try old token | 401 - Token revoked |

## Token Management Flow

| Action | Frontend Behavior | Backend Response |
|--------|------------------|------------------|
| **Login** | Store access token, set refresh cookie | 200 - Tokens provided |
| **Access Protected Route** | Send Bearer token in header | 200/401 based on token |
| **Reset Password** | Clear stored token after reset | 200 - All sessions ended |
| **Logout** | Clear stored token, call logout API | 200 - Token blacklisted |
| **Logout All** | Clear all stored tokens | 200 - All sessions ended |
| **Token Expired** | Redirect to login page | 401 - Need new login |

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

### Password Reset Fields
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| Authorization Header | String | Yes | Bearer `<access_token>` |
| otp | String | Yes (Step 2) | 6-digit OTP from email |
| newPassword | String | Yes (Step 3) | New password (6-50 characters) |
| resetToken | String | Yes (Step 3) | Reset token from OTP verification |

### Logout Fields
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| Authorization Header | String | Yes | Bearer `<access_token>` |
| refreshToken | String | No | Optional if not using cookies |

## Important Notes

| Topic | Details |
|-------|---------|
| **Registration OTP Expiry** | 5 minutes after generation |
| **Registration OTP Cooldown** | 60 seconds between requests |
| **Password Reset OTP Expiry** | 5 minutes after generation |
| **Password Reset OTP Cooldown** | 60 seconds between requests |
| **Reset Token Expiry** | 10 minutes after OTP verification |
| **Token Storage** | Store access token securely in localStorage/sessionStorage |
| **Token Transmission** | Always use Authorization header for protected routes |
| **Password Reset Behavior** | User is logged out from all devices after password reset |
| **Session Management** | `/logout-all` invalidates all user sessions |
| **File Formats** | Supports common image formats (jpg, png, gif) |
| **Response Format** | All endpoints return JSON |
| **Refresh Tokens** | Automatically set as HTTP-only cookies |
| **Password Reset Auth** | User must be logged in to reset password (not "forgot password") |

## Security Features

| Feature | Description |
|---------|-------------|
| **Token Blacklisting** | Logged out tokens cannot be reused |
| **Automatic Cleanup** | Expired blacklisted tokens are cleaned periodically |
| **Multi-Device Support** | Can logout from current device or all devices |
| **HTTP-Only Cookies** | Refresh tokens stored securely |
| **Bearer Token Auth** | Standard JWT implementation |
| **Password Reset Security** | OTP + Reset Token double verification |
| **Rate Limiting** | Prevents OTP spam and brute force attacks |
| **Session Invalidation** | Complete session cleanup after password reset |