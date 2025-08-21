# Student API Testing Guide

## Base Configuration
| Property | Value |
|----------|-------|
| Base URL | `http://localhost:8000/api/v1/student` |
| Server Port | 8000 |
| Route Prefix | `/api/v1/student` |

## Documentation Sections Overview

| Section | Route(s) | Authentication | Description |
|---------|----------|----------------|-------------|
| **[1. Register Student](#1-register-student)** | `POST /register` | None | Register new student account |
| **[2. Verify OTP](#2-verify-otp)** | `POST /verify-auth-otp` | None | Verify registration email OTP |
| **[3. Login Student](#3-login-student)** | `POST /login` | None | Student login with credentials |
| **[4. Reset Password](#4-reset-password-3-step-process)** | `POST /reset-password/*` | Bearer Token | Reset password for logged-in users (3 steps) |
| **[5. Forgot Password](#5-forgot-password-4-step-process)** | `POST /forgot-password/*` | None | Reset password for non-logged users (4 steps) |
| **[6. Logout Current Session](#6-logout-current-session)** | `POST /logout` | Bearer Token | Logout from current device |
| **[7. Logout From All Devices](#7-logout-from-all-devices)** | `POST /logout-all` | Bearer Token | Logout from all devices |
| **[8. Get Profile](#8-get-profile)** | `GET /profile` | Bearer Token | Retrieve student profile data |
| **[9. Upload Profile Image](#9-upload-profile-image)** | `POST /upload-profile-image` | Bearer Token | Upload student profile picture |
| **[10. Get Student Subjects](#10-get-student-subjects)** | `GET /get-all-subjects` | Bearer Token | Get all subjects for student's section |
| **[11. Get Subject Notes](#11-get-subject-notes)** | `GET /get-notes/:subjectId` | Bearer Token | Get notes for a specific subject |
| **[12. Download Notes](#12-download-notes)** | `GET /download-notes/:fileId` | Bearer Token | Download specific notes file |
| **[13. Regenerate Access Token](#13-regenerate-access-token)** | `GET /regenerate-access-token` | None | Generate new access token using refresh token |

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
| `/forgot-password/request` | POST | None | Request forgot password OTP |
| `/forgot-password/verify-otp` | POST | None | Verify forgot password OTP |
| `/forgot-password/reset` | POST | None | Reset password with resetToken |
| `/forgot-password/resend-otp` | POST | None | Resend forgot password OTP |
| `/profile` | GET | Bearer Token | Get student profile |
| `/upload-profile-image` | POST | Bearer Token | Upload profile image |
| `/get-all-subjects` | GET | Bearer Token | Get student's subjects |
| `/get-notes/:subjectId` | GET | Bearer Token | Get subject notes |
| `/download-notes/:fileId` | GET | Bearer Token | Download note file |
| `/regenerate-access-token` | GET | None | Regenerate access token |

# Access Token and Refresh Token Definitions

## Access Token

An **Access Token** is a short-lived security credential that grants authenticated access to protected API resources. It serves as a digital key that proves the user's identity and authorization to access specific endpoints.

### Key Characteristics:
- **Purpose**: Authenticates and authorizes API requests
- **Format**: JSON Web Token (JWT) containing user information and permissions
- **Usage**: Sent in the `Authorization: Bearer <token>` header with each API request
- **Security**: Contains encoded user data, permissions, and expiration timestamp
- **Validation**: Server validates the token's signature and expiration on each request
- **Scope**: Grants access to specific API endpoints and user resources

### When Access Tokens are Used:
- Making requests to protected API endpoints
- Accessing user-specific data and resources
- Performing authenticated operations (profile updates, password changes, etc.)
- Validating user permissions for specific actions

### Access Token Lifecycle:
1. **Generation**: Created upon successful login or OTP verification
2. **Storage**: Stored securely in client-side storage (localStorage, sessionStorage)
3. **Transmission**: Included in HTTP headers for authenticated requests
4. **Validation**: Verified by server on each protected endpoint access
5. **Expiration**: Automatically becomes invalid after predetermined time
6. **Renewal**: Must be refreshed using refresh token when expired

---

## Refresh Token

A **Refresh Token** is a long-lived security credential used to obtain new access tokens without requiring the user to re-authenticate. It provides a secure way to maintain user sessions while keeping access tokens short-lived for security.

### Key Characteristics:
- **Purpose**: Generates new access tokens when current ones expire
- **Format**: Secure random string or JWT with longer expiration
- **Storage**: Stored as HTTP-only cookie for enhanced security
- **Security**: Cannot be accessed by client-side JavaScript, preventing XSS attacks
- **Validation**: Verified against server-side whitelist or database records
- **Single Use**: Some implementations invalidate refresh token after each use

### When Refresh Tokens are Used:
- Automatically obtaining new access tokens when they expire
- Maintaining user sessions without requiring re-login
- Seamless user experience during extended application usage
- Background token renewal in single-page applications

### Refresh Token Lifecycle:
1. **Generation**: Created alongside access token during authentication
2. **Storage**: Set as secure HTTP-only cookie by the server
3. **Automatic Usage**: Client automatically uses refresh token for token renewal
4. **Validation**: Server validates refresh token against stored records
5. **Token Exchange**: Exchanges valid refresh token for new access token
6. **Rotation**: New refresh token may be issued with each token refresh
7. **Revocation**: Invalidated during logout or security events

---

## Token Relationship

### How They Work Together:
1. **Initial Authentication**: User logs in → Server issues both access and refresh tokens
2. **API Requests**: Client uses access token for authenticated requests
3. **Token Expiration**: Access token expires → Client automatically uses refresh token
4. **Token Renewal**: Refresh token exchanges for new access token + optionally new refresh token
5. **Seamless Experience**: User continues using application without re-authentication

### Security Benefits:
- **Reduced Risk**: Short-lived access tokens limit exposure if compromised
- **Secure Storage**: Refresh tokens stored in HTTP-only cookies prevent client-side access
- **Automatic Renewal**: Maintains security while providing smooth user experience
- **Revocation Control**: Both tokens can be invalidated during logout or security breaches

### Token Flow Example:
```
1. Login → Access Token (short-lived) + Refresh Token (long-lived)
2. API Call → Use Access Token in Authorization header
3. Token Expires → Client detects expiration
4. Token Refresh → Use Refresh Token to get new Access Token
5. Continue → Use new Access Token for subsequent requests
```

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
  "full_name": "janardhan nayak",
  "password": "Password@123",
  "reg_no": "21CS001",
  "slno": 20,
  "section": "A",
  "email": "janardhan@rockstar.com",
  "phoneNo": "8763119702",
  "degree": "BTech",
  "branch": "CSE",
  "batch": 2023,
  "gender": "male"
}
```

### Response (201 - Success)
```json
{
  "success": true,
  "message": "Student registered successfully"
}
```

### Response (400 - Validation Error)
```json
{
  "success": false,
  "message": "Please fill all the fields"
}
```

### Response (400 - Student Already Exists)
```json
{
  "success": false,
  "message": "Student already exists"
}
```

### Response (400 - Degree Not Found)
```json
{
  "success": false,
  "message": "Degree not found"
}
```

### Response (400 - Branch Not Found)
```json
{
  "success": false,
  "message": "Branch not found"
}
```

### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
}
```

### Postman Testing Steps
| Step | Action |
|------|--------|
| 1 | Set method to POST |
| 2 | Set Content-Type to application/json |
| 3 | Add student data in request body |
| 4 | Send request |
| 5 | Verify 201 response and success message |

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

### Response (400 - Missing Fields)
```json
{
  "success": false,
  "message": "Please provide email and otp"
}
```

### Response (400 - OTP Expired)
```json
{
  "success": false,
  "message": "OTP expired or not found"
}
```

### Response (400 - Invalid OTP)
```json
{
  "success": false,
  "message": "Invalid OTP"
}
```

### Response (400 - Invalid OTP Length)
```json
{
  "success": false,
  "message": "OTP must be 6 digits long"
}
```

### Response (404 - Student Not Found)
```json
{
  "success": false,
  "message": "Student not found"
}
```

### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
}
```

### Postman Testing Steps
| Step | Action |
|------|--------|
| 1 | Set method to POST |
| 2 | Set Content-Type to application/json |
| 3 | Add email and OTP in request body |
| 4 | Send request |
| 5 | Verify 200 response and access token |

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

### Response (400 - Missing Credentials)
```json
{
  "success": false,
  "message": "Please provide email or registration number"
}
```

### Response (400 - Missing Password)
```json
{
  "success": false,
  "message": "Please provide password"
}
```

### Response (401 - Invalid Credentials)
```json
{
  "success": false,
  "message": "Invalid credentials mark1"
}
```

### Response (401 - Invalid Password)
```json
{
  "success": false,
  "message": "Invalid credentials mark2"
}
```

### Response (403 - Account Not Verified)
```json
{
  "success": false,
  "message": "Please verify your account first"
}
```

### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
}
```

### Postman Testing Steps
| Step | Action |
|------|--------|
| 1 | Set method to POST |
| 2 | Set Content-Type to application/json |
| 3 | Add login credentials in request body |
| 4 | Send request |
| 5 | Verify 200 response and access token |

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

#### Response (429 - Rate Limited)
```json
{
  "success": false,
  "message": "Please wait before requesting a new password reset OTP"
}
```

#### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
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

#### Response (400 - Missing OTP)
```json
{
  "success": false,
  "message": "Please provide OTP"
}
```

#### Response (400 - Invalid OTP Format)
```json
{
  "success": false,
  "message": "OTP must be 6 digits long"
}
```

#### Response (400 - OTP Expired)
```json
{
  "success": false,
  "message": "Password reset OTP expired or not found"
}
```

#### Response (400 - Invalid OTP)
```json
{
  "success": false,
  "message": "Invalid password reset OTP"
}
```

#### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
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

#### Response (400 - Missing Password)
```json
{
  "success": false,
  "message": "New password is required"
}
```

#### Response (400 - Invalid Password Format)
```json
{
  "success": false,
  "message": "New password must be a string"
}
```

#### Response (400 - Password Too Short)
```json
{
  "success": false,
  "message": "Password must be at least 6 characters long"
}
```

#### Response (400 - Password Too Long)
```json
{
  "success": false,
  "message": "Password must not exceed 50 characters"
}
```

#### Response (400 - Password Has Whitespace)
```json
{
  "success": false,
  "message": "Password cannot start or end with whitespace"
}
```

#### Response (400 - Missing Reset Token)
```json
{
  "success": false,
  "message": "Reset token is required"
}
```

#### Response (400 - Invalid Reset Token)
```json
{
  "success": false,
  "message": "Reset token must be 6 characters long"
}
```

#### Response (400 - Reset Token Expired)
```json
{
  "success": false,
  "message": "Reset token expired. Please verify OTP again."
}
```

#### Response (400 - Invalid Reset Token)
```json
{
  "success": false,
  "message": "Invalid reset token. Please verify OTP again."
}
```

#### Response (400 - Same Password)
```json
{
  "success": false,
  "message": "New password cannot be the same as current password"
}
```

#### Response (404 - Student Not Found)
```json
{
  "success": false,
  "message": "Student not found"
}
```

#### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
}
```

## 5. Forgot Password (4-Step Process)

> **Note**: Forgot password is for **non-authenticated users**. User is NOT logged in and has forgotten their password. This is accessed from the login page via "Forgot Password" link.

### Forgot Password Flow Overview:

• **Step 1 - Request OTP**: User on login page clicks "Forgot Password" → Send **email** in body `{"email": "user@example.com"}` to `POST /forgot-password/request` → Backend checks if email exists, generates 6-digit OTP, stores in Redis (10min expiry), sends OTP to email, returns generic success message (doesn't reveal if email exists) with 120-second rate limit

• **Step 2 - Verify OTP**: User enters **email** + **OTP from email** in body `{"email": "user@example.com", "otp": "123456"}` to `POST /forgot-password/verify-otp` → Backend validates email exists and OTP matches Redis cache, generates secure **resetToken** (64-char, 15min expiry), stores in Redis, clears OTP data, returns `{"resetToken": "abc123..."}` which must be saved for next step

• **Step 3 - Reset Password**: User enters **new password** + **confirm password** + **resetToken from step 2** in body `{"resetToken": "abc123...", "newPassword": "newPass123", "confirmPassword": "newPass123"}` to `POST /forgot-password/reset` → Backend validates passwords match, resetToken exists, updates password, **logs out user from all devices**, blacklists existing refresh tokens, clears Redis entries, returns success message → **User must login with new password**

• **Step 4 - Resend OTP (Optional)**: If user didn't receive OTP, send **email** in body `{"email": "user@example.com"}` to `POST /forgot-password/resend-otp` → Backend resends existing OTP or generates new one if expired, applies same 120-second rate limit

### 5.1 Request Forgot Password OTP

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/forgot-password/request` |
| **Authentication** | None |

#### Headers
| Key | Value |
|-----|-------|
| Content-Type | application/json |

#### Request Body
```json
{
  "email": "john.doe@example.com"
}
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "If the email exists, an OTP has been sent"
}
```

#### Response (400 - Missing Email)
```json
{
  "success": false,
  "message": "Please provide email address"
}
```

#### Response (429 - Rate Limited)
```json
{
  "success": false,
  "message": "Please wait before requesting a new OTP"
}
```

#### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
}
```

### 5.2 Verify Forgot Password OTP

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/forgot-password/verify-otp` |
| **Authentication** | None |

#### Headers
| Key | Value |
|-----|-------|
| Content-Type | application/json |

#### Request Body
```json
{
  "email": "john.doe@example.com",
  "otp": "123456"
}
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "OTP verified successfully",
  "resetToken": "abc123def456ghi789jkl012mno345pqr678stu901vwx234yzab567cdef890ghij123"
}
```

#### Response (400 - Missing Fields)
```json
{
  "success": false,
  "message": "Please provide email and OTP"
}
```

#### Response (400 - Invalid OTP Length)
```json
{
  "success": false,
  "message": "OTP must be 6 digits long"
}
```

#### Response (404 - Student Not Found)
```json
{
  "success": false,
  "message": "Student not found"
}
```

#### Response (400 - OTP Expired)
```json
{
  "success": false,
  "message": "OTP expired or not found"
}
```

#### Response (400 - Invalid OTP)
```json
{
  "success": false,
  "message": "Invalid OTP"
}
```

#### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
}
```

### 5.3 Reset Forgot Password

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/forgot-password/reset` |
| **Authentication** | None |

#### Headers
| Key | Value |
|-----|-------|
| Content-Type | application/json |

#### Request Body
```json
{
  "resetToken": "abc123def456ghi789jkl012mno345pqr678stu901vwx234yzab567cdef890ghij123",
  "newPassword": "newPassword123",
  "confirmPassword": "newPassword123"
}
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "Password reset successful. Please login with your new password."
}
```

#### Response (400 - Missing Fields)
```json
{
  "success": false,
  "message": "Please provide reset token, new password and confirm password"
}
```

#### Response (400 - Password Mismatch)
```json
{
  "success": false,
  "message": "Passwords do not match"
}
```

#### Response (400 - Password Too Short)
```json
{
  "success": false,
  "message": "Password must be at least 8 characters long"
}
```

#### Response (400 - Invalid Reset Token)
```json
{
  "success": false,
  "message": "Invalid or expired reset token"
}
```

#### Response (404 - Student Not Found)
```json
{
  "success": false,
  "message": "Student not found"
}
```

#### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
}
```

### 5.4 Resend Forgot Password OTP

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/forgot-password/resend-otp` |
| **Authentication** | None |

#### Headers
| Key | Value |
|-----|-------|
| Content-Type | application/json |

#### Request Body
```json
{
  "email": "john.doe@example.com"
}
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "OTP sent successfully"
}
```

#### Response (400 - Missing Email)
```json
{
  "success": false,
  "message": "Please provide email address"
}
```

#### Response (429 - Rate Limited)
```json
{
  "success": false,
  "message": "Please wait before requesting a new OTP"
}
```

#### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
}
```

## 6. Logout Current Session

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

### Response (401 - Unauthorized)
```json
{
  "success": false,
  "message": "Access denied. No token provided."
}
```

### Response (401 - Invalid Token)
```json
{
  "success": false,
  "message": "Invalid access token"
}
```

### Response (401 - Token Expired)
```json
{
  "success": false,
  "message": "Access token has expired"
}
```

### Response (401 - Token Revoked)
```json
{
  "success": false,
  "message": "Token has been revoked. Please login again."
}
```

### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
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

## 7. Logout From All Devices

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

### Response (401 - Unauthorized)
```json
{
  "success": false,
  "message": "Access denied. No token provided."
}
```

### Response (401 - Invalid Token)
```json
{
  "success": false,
  "message": "Invalid access token"
}
```

### Response (401 - Token Expired)
```json
{
  "success": false,
  "message": "Access token has expired"
}
```

### Response (401 - Token Revoked)
```json
{
  "success": false,
  "message": "Token has been revoked. Please login again."
}
```

### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
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

## 8. Get Profile

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

### Response (401 - Unauthorized)
```json
{
  "success": false,
  "message": "Access denied. No token provided."
}
```

### Response (401 - Invalid Token)
```json
{
  "success": false,
  "message": "Invalid access token"
}
```

### Response (401 - Token Expired)
```json
{
  "success": false,
  "message": "Access token has expired"
}
```

### Response (401 - Token Revoked)
```json
{
  "success": false,
  "message": "Token has been revoked. Please login again."
}
```

### Response (404 - Student Not Found)
```json
{
  "success": false,
  "message": "Student not found"
}
```

### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
}
```

## 9. Upload Profile Image

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

### Response (400 - No File Provided)
```json
{
  "success": false,
  "message": "Please provide a profile image"
}
```

### Response (400 - Invalid File Type)
```json
{
  "success": false,
  "message": "Only image files are allowed"
}
```

### Response (400 - File Too Large)
```json
{
  "success": false,
  "message": "File size too large. Maximum size is 5MB"
}
```

### Response (401 - Unauthorized)
```json
{
  "success": false,
  "message": "Access denied. No token provided."
}
```

### Response (401 - Invalid Token)
```json
{
  "success": false,
  "message": "Invalid access token"
}
```

### Response (401 - Token Expired)
```json
{
  "success": false,
  "message": "Access token has expired"
}
```

### Response (401 - Token Revoked)
```json
{
  "success": false,
  "message": "Token has been revoked. Please login again."
}
```

### Response (404 - Student Not Found)
```json
{
  "success": false,
  "message": "Student not found"
}
```

### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
}
```

### Postman Testing Steps
| Step | Action |
|------|--------|
| 1 | Set method to POST |
| 2 | Add Authorization header with Bearer token |
| 3 | Set Content-Type to application/json |
| 4 | Send request |
| 5 | Verify image upload success |

## 10. Get Student Subjects

| Property | Value |
|----------|-------|
| **Method** | GET |
| **Endpoint** | `/get-all-subjects` |
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
    "message": "Subjects fetched successfully",
    "subjects": [
        {
            "subjectId": "66c4b8e5a1234567890abcef",
            "subjectName": "DSA",
            "subjectFullName": "Data Structures and Algorithms",
            "subjectCode": "CS201"
        },
        {
            "subjectId": "66c4b8e5a1234567890abcf0",
            "subjectName": "DBMS",
            "subjectFullName": "Database Management Systems",
            "subjectCode": "CS301"
        },
        {
            "subjectId": "66c4b8e5a1234567890abcf1",
            "subjectName": "OS",
            "subjectFullName": "Operating Systems",
            "subjectCode": "CS302"
        },
        {
            "subjectId": "66c4b8e5a1234567890abcf2",
            "subjectName": "CN",
            "subjectFullName": "Computer Networks",
            "subjectCode": "CS303"
        },
    ]
}
```

### Response (401 - Unauthorized)
```json
{
  "success": false,
  "message": "Access denied. No token provided."
}
```

### Response (401 - Invalid Token)
```json
{
  "success": false,
  "message": "Invalid access token"
}
```

### Response (401 - Token Expired)
```json
{
  "success": false,
  "message": "Access token has expired"
}
```

### Response (401 - Token Revoked)
```json
{
  "success": false,
  "message": "Token has been revoked. Please login again."
}
```

### Response (404 - No Subjects Found)
```json
{
  "success": false,
  "message": "No subjects found for your section"
}
```

### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
}
```

### Postman Testing Steps
| Step | Action |
|------|--------|
| 1 | Set method to GET |
| 2 | Add Authorization header with Bearer token |
| 3 | Set Content-Type to application/json |
| 4 | Send request |
| 5 | Verify subjects list in response |

## 11. Get Subject Notes

| Property | Value |
|----------|-------|
| **Method** | GET |
| **Endpoint** | `/get-notes/:subjectId` |
| **Authentication** | Bearer Token Required |

### Headers
| Key | Value |
|-----|-------|
| Authorization | Bearer `<access_token>` |
| Content-Type | application/json |

### URL Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| subjectId | String | ID of the subject to get notes for |

### Response (200 - Success)
```json
{
    "success": true,
    "message": "Fetched notes successfully",
    "count": 3,
    "notes": [
        {
            "_id": "66c4b8e5a1234567890abcde",
            "subjectId": "66c4b8e5a1234567890abcef",
            "chapterNo": "2",
            "chapterName": "Data Structures and Algorithms",
            "title": "Arrays and Linked Lists",
            "description": "Comprehensive notes on arrays, linked lists, and their operations including insertion, deletion, and traversal.",
            "files": [
                {
                    "file_id": "BQACAgUAAyEGAASb56CfAAMKaKXHxUZqoSqzC-WlmJk76bIkwWMAApYYAAJ7sylVXkgiP4YtUl82BA",
                    "message_id": "12",
                    "original_name": "chapter2_arrays_linkedlists.pdf",
                    "mime_type": "application/pdf",
                    "file_size": "8.45 MB",
                    "created_at": "2025-08-21T10:30:00.000Z"
                },
                {
                    "file_id": "BQACAgUAAyEGAASb56CfAAMLaKXHtuGNipEybqHaZT1sNMf_Op4AApUYAAJ7sylVK3dFa4WweNk2BA",
                    "message_id": "13",
                    "original_name": "arrays_examples.cpp",
                    "mime_type": "text/x-c++src",
                    "file_size": "2.14 KB",
                    "created_at": "2025-08-21T10:32:00.000Z"
                }
            ],
            "created_at": "2025-08-21T10:30:00.000Z"
        },
        {
            "_id": "66c4b8e5a1234567890abce0",
            "subjectId": "66c4b8e5a1234567890abcef",
            "chapterNo": "2",
            "chapterName": "Data Structures and Algorithms",
            "title": "Binary Trees and Tree Traversals",
            "description": "Introduction to binary trees, binary search trees, and different tree traversal techniques including inorder, preorder, and postorder.",
            "files": [
                {
                    "file_id": "BQACAgUAAyEGAASb56CfAAMPaKOUtqysSP1I06TKC7_NaP3_0oYAAsUUAAINpiBVZg_FsFCzbyg2BA",
                    "message_id": "17",
                    "original_name": "binary_trees_chapter2.pdf",
                    "mime_type": "application/pdf",
                    "file_size": "15.32 MB",
                    "created_at": "2025-08-20T14:45:00.000Z"
                },
                {
                    "file_id": "BQACAgUAAyEGAASb56CfAAMQaKXHxUZqoSqzC-WlmJk76bIkwWMAApYYAAJ7sylVXkgiP4YtUl82BA",
                    "message_id": "18",
                    "original_name": "tree_traversal_diagrams.png",
                    "mime_type": "image/png",
                    "file_size": "1.23 MB",
                    "created_at": "2025-08-20T14:47:00.000Z"
                }
            ],
            "created_at": "2025-08-20T14:45:00.000Z"
        }
    ]
}
```

### Response (401 - Unauthorized)
```json
{
  "success": false,
  "message": "Access denied. No token provided."
}
```

### Response (401 - Invalid Token)
```json
{
  "success": false,
  "message": "Invalid access token"
}
```

### Response (401 - Token Expired)
```json
{
  "success": false,
  "message": "Access token has expired"
}
```

### Response (401 - Token Revoked)
```json
{
  "success": false,
  "message": "Token has been revoked. Please login again."
}
```

### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
}
```

### Postman Testing Steps
| Step | Action |
|------|--------|
| 1 | Set method to GET |
| 2 | Add Authorization header with Bearer token |
| 3 | Replace :subjectId in URL with actual subject ID |
| 4 | Set Content-Type to application/json |
| 5 | Send request |
| 6 | Verify notes list in response |

## 12. Download Notes

| Property | Value |
|----------|-------|
| **Method** | GET |
| **Endpoint** | `/download-notes/:fileId` |
| **Authentication** | Bearer Token Required |

### Headers
| Key | Value |
|-----|-------|
| Authorization | Bearer `<access_token>` |

### URL Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| fileId | String | ID of the note file to download |

### Response
- **Success**: File download stream
- **Content-Type**: Application/PDF or appropriate mime type
- **Content-Disposition**: attachment; filename="note_file_name.pdf"

### Error Responses
```json
{
  "success": false,
  "message": "File not found"
}
```
```json
{
  "success": false,
  "message": "Access denied"
}
```

### Response (401 - Unauthorized)
```json
{
  "success": false,
  "message": "Access denied. No token provided."
}
```

### Response (401 - Invalid Token)
```json
{
  "success": false,
  "message": "Invalid access token"
}
```

### Response (401 - Token Expired)
```json
{
  "success": false,
  "message": "Access token has expired"
}
```

### Response (401 - Token Revoked)
```json
{
  "success": false,
  "message": "Token has been revoked. Please login again."
}
```

### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
}
```

### Postman Testing Steps
| Step | Action |
|------|--------|
| 1 | Set method to GET |
| 2 | Add Authorization header with Bearer token |
| 3 | Replace :fileId in URL with actual file ID |
| 4 | Send request |
| 5 | Verify file download starts |

## 13. Regenerate Access Token

| Property | Value |
|----------|-------|
| **Method** | GET |
| **Endpoint** | `/regenerate-access-token` |
| **Authentication** | None |

### Headers
| Key | Value |
|-----|-------|
| Content-Type | application/json |

### Request Body
```json
{}
```

### Response (200 - Success)
```json
{
  "success": true,
  "message": "Access token regenerated successfully",
  "accessToken": "eyJhbGciOiJIUzI1NiIs..."
}
```

### Response (401 - Error)
```json
{
  "success": false,
  "message": "Refresh token is required"
}
```

### Response (401 - Invalid Token)
```json
{
  "success": false,
  "message": "Invalid refresh token"
}
```

### Response (401 - Token Revoked)
```json
{
  "success": false,
  "message": "Token is revoked"
}
```

### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error during access token regeneration"
}
```

### Response (401 - Unauthorized)
```json
{
  "success": false,
  "message": "Access denied. No token provided."
}
```

### Response (401 - Invalid Token)
```json
{
  "success": false,
  "message": "Invalid access token"
}
```

### Response (401 - Token Expired)
```json
{
  "success": false,
  "message": "Access token has expired"
}
```

### Response (401 - Token Revoked)
```json
{
  "success": false,
  "message": "Token has been revoked. Please login again."
}
```

### Response (500 - Server Error)
```json
{
  "success": false,
  "message": "Internal server error",
  "error": "Error details in development mode"
}
```

### Postman Testing Steps
| Step | Action |
|------|--------|
| 1 | Set method to GET |
| 2 | Ensure refresh token cookie is set |
| 3 | Set Content-Type to application/json |
| 4 | Send request |
| 5 | Verify new access token in response |

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
| 11 | GET `/get-all-subjects` with Bearer token | 200 - List of subjects |
| 12 | GET `/get-notes/:subjectId` with valid subject ID | 200 - List of notes |
| 13 | GET `/download-notes/:fileId` with valid file ID | 200 - File download |
| 14 | GET `/regenerate-access-token` with refresh token | 200 - New access token |
| 15 | POST `/logout` with Bearer token | 200 - Session ended |
| 16 | GET `/profile` with same token | 401 - Token revoked |

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

## Forgot Password Testing Flow (Step-by-Step)

| Step | Endpoint | Body | Expected Response | Notes |
|------|----------|------|------------------|-------|
| **1** | `POST /forgot-password/request` | `{"email": "user@example.com"}` | 200 - Generic success | Check email for OTP |
| **2** | `POST /forgot-password/request` | `{"email": "user@example.com"}` | 429 - Rate limited | Before 120 seconds |
| **3** | Wait 120 seconds | - | - | Rate limiting cooldown |
| **4** | `POST /forgot-password/verify-otp` | `{"email": "user@example.com", "otp": "123456"}` | 200 - Reset token | **Save resetToken** |
| **5** | `POST /forgot-password/reset` | `{"resetToken": "abc123...", "newPassword": "newPass123", "confirmPassword": "newPass123"}` | 200 - Password reset | User logged out from all devices |
| **6** | `POST /login` | `{"email": "user@example.com", "reg_no": "21CS001", "password": "oldPassword"}` | 401 - Invalid credentials | Old password doesn't work |
| **7** | `POST /login` | `{"email": "user@example.com", "reg_no": "21CS001", "password": "newPass123"}` | 200 - New session | Login with new password |

## Alternative Flow: Resend OTP

| Step | Endpoint | Body | Expected Response | Notes |
|------|----------|------|------------------|-------|
| **1** | `POST /forgot-password/request` | `{"email": "user@example.com"}` | 200 - Generic success | Initial OTP request |
| **2** | Wait 120+ seconds | - | - | Rate limit expires |
| **3** | `POST /forgot-password/resend-otp` | `{"email": "user@example.com"}` | 200 - OTP sent | Resends same OTP if valid, or new OTP if expired |
| **4** | `POST /forgot-password/verify-otp` | `{"email": "user@example.com", "otp": "123456"}` | 200 - Reset token | Continue with reset flow |

## Authentication States Testing

| Scenario | Expected Status | Response Message |
|----------|----------------|------------------|
| Valid token for protected routes | 200 | Success |
| No token provided | 401 | "Access denied. No token provided." |
| Invalid/malformed token | 401 | "Invalid access token" |
| Expired token | 401 | "Access token has expired" |
| Blacklisted token (after logout) | 401 | "Token has been revoked. Please login again." |
| Unverified account | 403 | "Account not verified" |

## Password Reset vs Forgot Password Comparison

| Feature | Reset Password | Forgot Password |
|---------|----------------|-----------------|
| **User State** | Logged in (has access token) | Not logged in (no access token) |
| **Access From** | Inside app (profile/settings) | Login page ("Forgot Password" link) |
| **Authentication** | Bearer Token Required | No Authentication |
| **OTP Expiry** | 5 minutes | 10 minutes |
| **Rate Limit** | 60 seconds | 120 seconds |
| **Reset Token** | 6-digit numeric | 64-character secure string |
| **Reset Token Expiry** | 10 minutes | 15 minutes |
| **Email Security** | Uses authenticated user's email | Validates email exists before proceeding |
| **Password Confirmation** | Single password field | Requires password + confirm password |
| **Steps** | 3 steps | 3 steps + optional resend |

## Password Reset Security Features

| Feature | Description | Implementation |
|---------|-------------|----------------|
| **Rate Limiting** | 60-second cooldown between OTP requests | Redis cache with TTL |
| **OTP Expiry** | OTP valid for 5 minutes only | Redis TTL |
| **Reset Token Expiry** | Reset token valid for 10 minutes | Redis TTL |
| **Session Invalidation** | All sessions logged out after password reset | All sessions logged out after password reset |
| **Same Password Check** | Prevents setting same password | Prevents setting same password |
| **Authentication Required** | Only logged-in users can reset password | No authentication required (for forgot scenarios) |
| **Email Privacy** | Uses authenticated user's email | Generic response (doesn't reveal if email exists) |

## Forgot Password Security Features

| Feature | Description | Implementation |
|---------|-------------|----------------|
| **Email Privacy Protection** | Generic response whether email exists or not | Returns same message for valid/invalid emails |
| **Rate Limiting** | 120-second cooldown between OTP requests | Redis cache with TTL |
| **OTP Expiry** | OTP valid for 10 minutes only | Redis TTL |
| **Reset Token Security** | 64-character secure token with timestamp | Generated with crypto-random components |
| **Reset Token Expiry** | Reset token valid for 15 minutes | Redis TTL |
| **Password Confirmation** | Requires matching password confirmation | Frontend and backend validation |
| **Session Invalidation** | All existing sessions terminated | Refresh token clearing + blacklisting |
| **OTP Reuse** | Same OTP resent if still valid | Efficient Redis caching |

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

## Forgot Password Error Scenarios

| Scenario | HTTP Status | Response Message |
|----------|-------------|------------------|
| **Missing email** | 400 | "Please provide email address" |
| **Request OTP too soon** | 429 | "Please wait before requesting a new OTP" |
| **Missing email or OTP** | 400 | "Please provide email and OTP" |
| **Invalid OTP format** | 400 | "OTP must be 6 digits long" |
| **Student not found (verify)** | 404 | "Student not found" |
| **Expired OTP** | 400 | "OTP expired or not found" |
| **Wrong OTP** | 400 | "Invalid OTP" |
| **Missing reset fields** | 400 | "Please provide reset token, new password and confirm password" |
| **Password mismatch** | 400 | "Passwords do not match" |
| **Password too short** | 400 | "Password must be at least 8 characters long" |
| **Invalid reset token** | 400 | "Invalid or expired reset token" |
| **Student not found (reset)** | 404 | "Student not found" |

## Logout Scenarios Testing

| Test Case | Setup | Expected Result |
|-----------|--------|----------------|
| **Normal Logout** | Login → POST `/logout` | 200 - Token blacklisted |
| **Multiple Device Logout** | Login on 2 tokens → POST `/logout-all` | All tokens invalidated |
| **Already Logged Out** | Logout → Use same token | 401 - Token revoked |
| **Invalid Token Logout** | POST `/logout` with invalid token | 401 - Invalid token |
| **Logout Without Token** | POST `/logout` without Authorization | 401 - Token required |
| **Auto Logout After Password Reset** | Reset password → Try old token | 401 - Token revoked |
| **Auto Logout After Forgot Password** | Reset via forgot password → Try old token | 401 - Token revoked |

## Token Management Flow

| Action | Frontend Behavior | Backend Response |
|--------|------------------|------------------|
| **Login** | Store access token, set refresh cookie | 200 - Tokens provided |
| **Access Protected Route** | Send Bearer token in header | 200/401 based on token |
| **Reset Password** | Clear stored token after reset | 200 - All sessions ended |
| **Forgot Password Reset** | No token needed, redirect to login after reset | 200 - All sessions ended |
| **Logout** | Clear stored token, call logout API | 200 - Token blacklisted |
| **Logout All** | Clear all stored tokens | 200 - All sessions ended |
| **Token Expired** | Redirect to login page | 401 - Need new login |
| **Token Regeneration** | Use refresh token to get new access token | 200 - New access token |

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

### Forgot Password Fields
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| email | String | Yes | Registered email address |
| otp | String | Yes (Step 2) | 6-digit OTP from email |
| resetToken | String | Yes (Step 3) | 64-character reset token from OTP verification |
| newPassword | String | Yes (Step 3) | New password (8+ characters) |
| confirmPassword | String | Yes (Step 3) | Confirm new password (must match newPassword) |

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
| **Forgot Password OTP Expiry** | 10 minutes after generation |
| **Forgot Password OTP Cooldown** | 120 seconds between requests |
| **Reset Token Expiry (Password Reset)** | 10 minutes after OTP verification |
| **Reset Token Expiry (Forgot Password)** | 15 minutes after OTP verification |
| **Token Storage** | Store access token securely in localStorage/sessionStorage |
| **Token Transmission** | Always use Authorization header for protected routes |
| **Password Reset Behavior** | User is logged out from all devices after password reset |
| **Forgot Password Behavior** | User is logged out from all devices after forgot password reset |
| **Session Management** | `/logout-all` invalidates all user sessions |
| **File Formats** | Supports common image formats (jpg, png, gif) |
| **Response Format** | All endpoints return JSON |
| **Refresh Tokens** | Automatically set as HTTP-only cookies |
| **Password Reset Auth** | User must be logged in to reset password (not "forgot password") |
| **Forgot Password Auth** | No authentication required (for users who forgot password) |
| **Email Privacy** | Forgot password doesn't reveal if email exists |
| **OTP Resend** | Available for forgot password flow if needed |
| **Notes Access** | Students can only access notes for subjects in their assigned section |
| **Chapter-based Notes** | Notes are organized by chapters within subjects |
| **File Download Limits** | Maximum file size: 20MB (Telegram Bot API limit) |
| **Token Regeneration** | Available for expired access tokens using refresh tokens |

## Security Features

| Feature | Description |
|---------|-------------|
| **Token Blacklisting** | Logged out tokens cannot be reused |
| **Automatic Cleanup** | Expired blacklisted tokens are cleaned periodically |
| **Multi-Device Support** | Can logout from current device or all devices |
| **HTTP-Only Cookies** | Refresh tokens stored securely |
| **Bearer Token Auth** | Standard JWT implementation |
| **Password Reset Security** | OTP + Reset Token double verification |
| **Forgot Password Security** | Email privacy protection + secure reset tokens |
| **Rate Limiting** | Prevents OTP spam and brute force attacks |
| **Session Invalidation** | Complete session cleanup after password reset |
| **Email Privacy Protection** | Generic responses in forgot password flow |
| **Secure Token Generation** | 64-character crypto-secure reset tokens for forgot password |
| **Password Confirmation** | Required for forgot password reset |
| **Different Timeouts** | Longer timeouts for non-authenticated flows |
| **Section Validation** | Students can only access data for their assigned section |
| **File Type Validation** | Strict file type checking for uploads |
| **Chapter-based Access Control** | Notes access controlled by subject and chapter |
| **Token Regeneration** | Secure refresh token-based access token renewal |