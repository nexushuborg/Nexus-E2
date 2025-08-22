# Teacher API Testing Guide

## Base Configuration
| Property | Value |
|----------|-------|
| Base URL | `http://localhost:8000/api/v1/teacher` |
| Server Port | 8000 |
| Route Prefix | `/api/v1/teacher` |

## Documentation Sections Overview

| Section | Route(s) | Authentication | Description |
|---------|----------|----------------|-------------|
| **[1. Register Teacher](#1-register-teacher)** | `POST /register` | None | Register new teacher account |
| **[2. Verify OTP](#2-verify-otp)** | `POST /verify-auth-otp` | None | Verify registration email OTP |
| **[3. Resend OTP](#3-resend-otp)** | `POST /resend-auth-otp` | None | Resend registration OTP |
| **[4. Login Teacher](#4-login-teacher)** | `POST /login` | None | Teacher login with credentials |
| **[5. Reset Password](#5-reset-password-3-step-process)** | `PATCH/POST /reset-password/*` | Bearer Token | Reset password for logged-in users (3 steps) |
| **[6. Forgot Password](#6-forgot-password-4-step-process)** | `POST /forgot-password/*` | None | Reset password for non-logged users (4 steps) |
| **[7. Logout Current Session](#7-logout-current-session)** | `POST /logout` | Bearer Token | Logout from current device |
| **[8. Logout From All Devices](#8-logout-from-all-devices)** | `POST /logout-all` | Bearer Token | Logout from all devices |
| **[9. Get Profile](#9-get-profile)** | `GET /profile` | Bearer Token | Retrieve teacher profile data |
| **[10. Upload Profile Image](#10-upload-profile-image)** | `POST /upload-profile-image` | Bearer Token | Upload teacher profile picture |
| **[11. Get Reference Data](#11-get-reference-data)** | `GET /get-all-*` | None | Get subjects, departments, and sections |
| **[12. Regenerate Access Token](#12-regenerate-access-token)** | `POST /regenerate-access-token` | None | Generate new access token using refresh token |
| **[13. CR Management](#13-cr-management)** | `POST /make-cr/:sectionId` `PUT /change-cr/:sectionId` | Bearer Token | Manage Class Representatives |
| **[14. Student List](#14-student-list)** | `GET /get-all-students/:year/:branch` | None | Get list of students by year and branch |
| **[15. Notes Management](#15-notes-management)** | `GET/POST/DELETE /notes/*` | Bearer Token | Upload, manage, and delete notes |

## API Endpoints Overview

| Endpoint | Method | Authentication | Purpose |
|----------|--------|----------------|---------|
| `/register` | POST | None | Register new teacher |
| `/verify-auth-otp` | POST | None | Verify email OTP |
| `/resend-auth-otp` | POST | None | Resend registration OTP |
| `/login` | POST | None | Teacher login |
| `/logout` | POST | Bearer Token | Logout current session |
| `/logout-all` | POST | Bearer Token | Logout from all devices |
| `/reset-password/request` | PATCH | Bearer Token | Request password reset OTP |
| `/reset-password/verify-otp` | POST | Bearer Token | Verify password reset OTP |
| `/reset-password` | POST | Bearer Token | Reset password with new password |
| `/forgot-password/request` | POST | None | Request forgot password OTP |
| `/forgot-password/verify-otp` | POST | None | Verify forgot password OTP |
| `/forgot-password/reset` | POST | None | Reset password with resetToken |
| `/forgot-password/resend-otp` | POST | None | Resend forgot password OTP |
| `/profile` | GET | Bearer Token | Get teacher profile |
| `/upload-profile-image` | POST | Bearer Token | Upload profile image |
| `/get-all-subjects-and-department` | GET | None | Get subjects and departments |
| `/get-all-sections` | GET | None | Get sections by batch year |
| `/regenerate-access-token` | POST | None | Generate new access token |
| `/make-cr/:sectionId` | POST | Bearer Token | Assign student as CR |
| `/change-cr/:sectionId` | PUT | Bearer Token | Change section CR |
| `/get-all-students/:year/:branch` | GET | None | Get students by year and branch |
| `/get-upload-section-notes-details` | GET | Bearer Token | Get sections and subjects for notes upload |
| `/upload-notes` | POST | Bearer Token | Upload notes with files |
| `/get-notes/:subjectId` | GET | Bearer Token | Get notes by subject and category |
| `/delete-uploaded-files/:noteId` | DELETE | Bearer Token | Delete specific file from note |

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

## 1. Register Teacher

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
  "gender": "male",
  "email": "john.doe@soa.du.in",
  "password": "Password@123",
  "department": "64e8f0c2b5d1a2a3b4c5d6e7",
  "designation": "Assistant Professor",
  "sectionWithSubject": [
    {
      "section": "64e8f0c2b5d1a2a3b4c5d6e8",
      "subject": "64e8f0c2b5d1a2a3b4c5d6e9"
    }
  ]
}
```

### Response (201 - Success)
```json
{
  "success": true,
  "message": "Teacher registered successfully, OTP sent to email",
  "teacherId": "64e8f0c2b5d1a2a3b4c5d6e7"
}
```

### Validation Requirements
| Field | Type | Required | Validation Rules |
|-------|------|----------|------------------|
| full_name | String | Yes | Non-empty string |
| gender | String | Yes | "male", "female", or "other" |
| email | String | Yes | Must end with `@soa.du.in` |
| password | String | Yes | 8+ chars, uppercase, lowercase, number, special char |
| department | String | Yes | Valid ObjectId string |
| designation | String | Yes | Non-empty string |
| sectionWithSubject | Array | Yes | Non-empty array of section-subject pairs |

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
  "email": "john.doe@soa.du.in",
  "otp": "123456",
  "teacherId": "64e8f0c2b5d1a2a3b4c5d6e7"
}
```

### Response (200 - Success)
```json
{
  "success": true,
  "message": "OTP verified successfully",
  "teacher": {
    "_id": "64e8f0c2b5d1a2a3b4c5d6e7",
    "full_name": "John Doe",
    "email": "john.doe@soa.du.in",
    "department": {
      "_id": "64e8f0c2b5d1a2a3b4c5d6e8",
      "name": "Computer Science"
    },
    "section": [
      {
        "_id": "64e8f0c2b5d1a2a3b4c5d6e9",
        "section_name": "23411A1",
        "batch": 2027
      }
    ],
    "subjects": [
      {
        "_id": "64e8f0c2b5d1a2a3b4c5d6ea",
        "subject_code": "CS101",
        "subject_name": "Intro to CS"
      }
    ],
    "isVerified": true
  },
  "accessToken": "eyJhbGciOiJIUzI1NiIs..."
}
```

## 3. Resend OTP

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/resend-auth-otp` |
| **Authentication** | None |

### Headers
| Key | Value |
|-----|-------|
| Content-Type | application/json |

### Request Body
```json
{
  "email": "john.doe@soa.du.in",
  "teacherId": "64e8f0c2b5d1a2a3b4c5d6e7"
}
```

### Response (200 - Success)
```json
{
  "success": true,
  "message": "OTP sent successfully"
}
```

### Response (429 - Rate Limited)
```json
{
  "success": false,
  "message": "Please wait before requesting a new OTP"
}
```

## 4. Login Teacher

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
  "email": "john.doe@soa.du.in",
  "password": "Password@123"
}
```

### Response (200 - Success)
```json
{
  "success": true,
  "message": "Login successful",
  "teacher": {
    "_id": "64e8f0c2b5d1a2a3b4c5d6e7",
    "full_name": "John Doe",
    "email": "john.doe@soa.du.in"
  },
  "accessToken": "eyJhbGciOiJIUzI1NiIs..."
}
```

## 5. Reset Password (3-Step Process)

> **Note**: Password reset is for **authenticated users only**. User must be logged in to reset their password. This is different from "forgot password" functionality.

### Password Reset Flow Overview:

• **Step 1 - Request OTP**: Send your **access token** (from login) in Authorization header to `PATCH /reset-password/request` with **empty body** → Backend uses token to identify user, generates 6-digit OTP, stores in Redis (5min expiry), sends OTP to user's registered email, returns success message with rate limit

• **Step 2 - Verify OTP**: Send your **access token** + **OTP from email** in body `{"otp": "123456"}` to `POST /reset-password/verify-otp` → Backend validates OTP against Redis cache, generates **resetToken** (short-lived), stores in Redis, returns `{"resetToken": "abc123"}` which you must save for next step

• **Step 3 - Reset Password**: Send your **access token** + **new password** + **resetToken from step 2** in body `{"newPassword": "NewPassword@123", "resetToken": "abc123"}` to `POST /reset-password` → Backend validates resetToken, updates password, **logs out user from all devices**, blacklists current access token, clears all Redis entries, returns success message → **User must login again with new password**

### 5.1 Request Password Reset OTP

| Property | Value |
|----------|-------|
| **Method** | PATCH |
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
  "message": "OTP sent to registered email"
}
```

### 5.2 Verify Password Reset OTP

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
  "message": "OTP verified successfully",
  "resetToken": "abc123def456"
}
```

### 5.3 Reset Password

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
  "resetToken": "abc123def456",
  "newPassword": "NewPassword@123"
}
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "Password reset successfully"
}
```

## 6. Forgot Password (4-Step Process)

> **Note**: Forgot password is for **non-authenticated users**. User is NOT logged in and has forgotten their password. This is accessed from the login page via "Forgot Password" link.

### Forgot Password Flow Overview:

• **Step 1 - Request OTP**: User on login page clicks "Forgot Password" → Send **email** in body `{"email": "user@soa.du.in"}` to `POST /forgot-password/request` → Backend checks if email exists, generates 6-digit OTP, stores in Redis (expiry), sends OTP to email, returns success message

• **Step 2 - Verify OTP**: User enters **email** + **OTP from email** in body `{"email": "user@soa.du.in", "otp": "123456"}` to `POST /forgot-password/verify-otp` → Backend validates email exists and OTP matches Redis cache, generates secure **resetToken**, stores in Redis, clears OTP data, returns `{"resetToken": "xyz789..."}` which must be saved for next step

• **Step 3 - Reset Password**: User enters **new password** + **resetToken from step 2** in body `{"resetToken": "xyz789...", "newPassword": "NewPassword@123"}` to `POST /forgot-password/reset` → Backend validates resetToken exists, updates password, **logs out user from all devices**, blacklists existing refresh tokens, clears Redis entries, returns success message → **User must login with new password**

• **Step 4 - Resend OTP (Optional)**: If user didn't receive OTP, send **email** in body `{"email": "user@soa.du.in"}` to `POST /forgot-password/resend-otp` → Backend resends existing OTP or generates new one if expired

### 6.1 Request Forgot Password OTP

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
  "email": "john.doe@soa.du.in"
}
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "OTP sent to email"
}
```

### 6.2 Verify Forgot Password OTP

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
  "email": "john.doe@soa.du.in",
  "otp": "123456"
}
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "OTP verified successfully",
  "resetToken": "xyz789abc012def345ghi678jkl901mno234pqr567stu890vwx123yza456bcd789"
}
```

### 6.3 Reset Forgot Password

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
  "resetToken": "xyz789abc012def345ghi678jkl901mno234pqr567stu890vwx123yza456bcd789",
  "newPassword": "NewPassword@123"
}
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "Password reset successfully"
}
```

### 6.4 Resend Forgot Password OTP

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
  "email": "john.doe@soa.du.in"
}
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "OTP resent successfully"
}
```

## 7. Logout Current Session

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

## 8. Logout From All Devices

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

## 9. Get Profile

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
  "message": "Teacher profile retrieved successfully",
  "data": {
    "profile_picture": "https://res.cloudinary.com/dcrlpbigy/image/upload/v1755292949/g9w0beiyjqbwfyrps7q3.png",
    "full_name": "Pintu laal",
    "email": "saswatbarai611@gmail.com",
    "department": {
      "name": "Computer Science and Engineering",
      "short_name": "CSE"
    },
    "designation": "Assistant Professor",
    "total_subjects": 2,
    "total_sections": 2,
    "sections": [
      {
        "section_name": "23411A1",
        "batch": 2027,
        "degree": {
          "name": "Bachelor of Technology",
          "short_name": "BTech",
          "duration_years": 4
        },
        "branch": {
          "name": "Computer Science and Engineering",
          "short_name": "CSE"
        },
        "subjects": [
          {
            "subject_code": "CS101",
            "subject_name": "Introduction to Computer Science"
          }
        ]
      },
      {
        "section_name": "23411A2",
        "batch": 2027,
        "degree": {
          "name": "Bachelor of Technology",
          "short_name": "BTech",
          "duration_years": 4
        },
        "branch": {
          "name": "Computer Science and Engineering",
          "short_name": "CSE"
        },
        "subjects": [
          {
            "subject_code": "CS102",
            "subject_name": "Programming Fundamentals"
          }
        ]
      }
    ]
  }
}
```

## 10. Upload Profile Image

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
    "profile_picture": "https://res.cloudinary.com/dcrlpbigy/image/upload/v1755292949/g9w0beiyjqbwfyrps7q3.png"
  }
}
```

## 11. Get Reference Data

### 11.1 Get All Subjects and Departments

| Property | Value |
|----------|-------|
| **Method** | GET |
| **Endpoint** | `/get-all-subjects-and-department` |
| **Authentication** | None |

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "Subjects and Departments fetched successfully",
  "subjects": [
    {
      "id": "64e8f0c2b5d1a2a3b4c5d6e7",
      "subject_code": "CS101",
      "subject_name": "Intro to CS"
    }
  ],
  "departments": [
    {
      "id": "64e8f0c2b5d1a2a3b4c5d6e8",
      "name": "Computer Science"
    }
  ]
}
```

### 11.2 Get All Sections

| Property | Value |
|----------|-------|
| **Method** | GET |
| **Endpoint** | `/get-all-sections?year=<batch>` |
| **Authentication** | None |

#### Query Parameters
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| year | Number | Yes | Batch year (e.g., 2027) |

#### Example Request
```
GET /get-all-sections?year=2027
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "Sections fetched successfully",
  "sections": [
    {
      "id": "64e8f0c2b5d1a2a3b4c5d6e9",
      "section_name": "23411A1",
      "batch": 2027
    }
  ]
}
```

## 12. Regenerate Access Token

| Property | Value |
|----------|-------|
| **Method** | POST |
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

## 13. CR Management

> **Note**: Teacher can only create **2** student CRs belonging to the same section i.e there can be only 2 CR for one section, creating more than that will raise errors

### 13.1 Make CR

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/make-cr/:sectionId` |
| **Authentication** | Bearer Token Required |

#### Headers
| Key | Value |
|-----|-------|
| Authorization | Bearer `<access_token>` |
| Content-Type | application/json |

#### Request Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| sectionId | String | ID of the section |

#### Request Body
```json
{
  "studentId": "64e8f0c2b5d1a2a3b4c5d6e7"
}
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "Student assigned as CR successfully"
}
```

### 13.2 Change CR

| Property | Value |
|----------|-------|
| **Method** | PUT |
| **Endpoint** | `/change-cr/:sectionId` |
| **Authentication** | Bearer Token Required |

#### Headers
| Key | Value |
|-----|-------|
| Authorization | Bearer `<access_token>` |
| Content-Type | application/json |

#### Request Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| sectionId | String | ID of the section |

#### Request Body
```json
{
  "oldCrId": "64e8f0c2b5d1a2a3b4c5d6e7",
  "newCrId": "64e8f0c2b5d1a2a3b4c5d6e8"
}
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "CR changed successfully"
}
```

## 14. Student List

| Property | Value |
|----------|-------|
| **Method** | GET |
| **Endpoint** | `/get-all-students/:year/:branch` |
| **Authentication** | None |

### Request Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| year | Number | Batch year (e.g., 2027) |
| branch | String | Branch code or ID |

### Response (200 - Success)
```json
{
  "success": true,
  "message": "Students fetched successfully",
  "data": [
    {
      "id": "64e8f0c2b5d1a2a3b4c5d6e7",
      "name": "Student Name",
      "reg_no": "2023BTCSE00",
      "section": "23411A1",
      "isCR": false
    }
  ]
}
```

## 15. Notes Management

### 15.1 Get Upload Section Notes Details

| Property | Value |
|----------|-------|
| **Method** | GET |
| **Endpoint** | `/get-upload-section-notes-details` |
| **Authentication** | Bearer Token Required |

#### Headers
| Key | Value |
|-----|-------|
| Authorization | Bearer `<access_token>` |
| Content-Type | application/json |

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "Sections grouped by year fetched successfully",
  "sectionByYear": {
    "firstYear": [
      {
        "section_name": "23411A1",
        "batch": 2029,
        "strength": 45,
        "section_id": "64e8f0c2b5d1a2a3b4c5d6e7",
        "degree": {
          "name": "Bachelor of Technology",
          "short_name": "BTech"
        },
        "branch": {
          "name": "Computer Science and Engineering",
          "short_name": "CSE"
        }
      }
    ],
    "secondYear": [
      {
        "section_name": "23411A2",
        "batch": 2028,
        "strength": 42,
        "section_id": "64e8f0c2b5d1a2a3b4c5d6e8",
        "degree": {
          "name": "Bachelor of Technology",
          "short_name": "BTech"
        },
        "branch": {
          "name": "Computer Science and Engineering",
          "short_name": "CSE"
        }
      }
    ]
  },
  "subjects": [
    {
      "subject_code": "CS101",
      "subject_name": "Introduction to Computer Science",
      "short_name": "Intro to CS",
      "subject_id": "64e8f0c2b5d1a2a3b4c5d6e9"
    }
  ]
}
```

### 15.2 Upload Notes

| Property | Value |
|----------|-------|
| **Method** | POST |
| **Endpoint** | `/upload-notes` |
| **Authentication** | Bearer Token Required |
| **Content Type** | multipart/form-data |

#### Headers
| Key | Value |
|-----|-------|
| Authorization | Bearer `<access_token>` |

#### Request Body (form-data)
| Key | Type | Required | Description |
|-----|------|----------|-------------|
| title | String | Yes | Title of the notes |
| description | String | Yes | Description of the notes |
| category | String | Yes | Category: notes, assignment, quiz, lab, pyq, project |
| subject | String | Yes | Subject ID |
| section | String/Array | Yes | Section ID or array of section IDs |
| chapterNo | String | Yes | Chapter number |
| chapterName | String | Yes | Chapter name |
| files | File | Yes | Array of files (max 10, max 20MB each) |

#### File Upload Requirements
| Requirement | Details |
|-------------|---------|
| **Max Files** | 10 files per upload |
| **Max File Size** | 20MB per file |
| **Accepted Formats** | PDF, Word (.doc, .docx), PowerPoint (.ppt, .pptx), Text (.txt), Images (jpg, png) |
| **Storage** | Files uploaded to Telegram Bot API |
| **Chapter Management** | Automatically creates chapters if they don't exist |

#### Response (201 - Success)
```json
{
  "success": true,
  "message": "Notes uploaded successfully to all selected sections",
  "notes": [
    {
      "title": "Sample Chapter 1 Notes udada",
      "description": "Test upload with curl",
      "files": [
        {
          "file_id": "BQACAgUAAyEGAASb56CfAAMPaKdc4YcDg2s_VCcs_QdOokQttEoAAuEYAAJ7szlVa0UoTn_WlKs2BA",
          "message_id": "15",
          "original_name": "Screenshot 2024-01-24 203333.png",
          "mime_type": "image/png",
          "file_size": 532962,
          "_id": "68a75ce25b560face7944052",
          "created_at": "2025-08-21T17:52:34.113Z"
        },
        {
          "file_id": "BQACAgUAAyEGAASb56CfAAMQaKdc5uACy7bM_inQ8bZ4X1FZVyYAAuIYAAJ7szlVjf2vJybZa942BA",
          "message_id": "16",
          "original_name": "Screenshot 2024-11-14 013217.png",
          "mime_type": "image/png",
          "file_size": 1114707,
          "_id": "68a75ce25b560face7944053",
          "created_at": "2025-08-21T17:52:34.118Z"
        }
      ],
      "category": "notes",
      "chapter": "68a75c43024ebf4190913ba3",
      "subject": "68a3170384071ea2d7cc7d3d",
      "teacher": "68a31d54a07e6f9b4879f381",
      "section": "68a3187e0251e4b8448d6d76",
      "is_pyq": false,
      "_id": "68a75ce25b560face7944051",
      "createdAt": "2025-08-21T17:52:34.137Z",
      "updatedAt": "2025-08-21T17:52:34.137Z",
      "__v": 0
    }
  ]
}
```

### 15.3 Get Notes

| Property | Value |
|----------|-------|
| **Method** | GET |
| **Endpoint** | `/get-notes/:subjectId` |
| **Authentication** | Bearer Token Required |

#### Headers
| Key | Value |
|-----|-------|
| Authorization | Bearer `<access_token>` |
| Content-Type | application/json |

#### Request Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| subjectId | String | ID of the subject |

#### Query Parameters
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| category | String | Yes | Category: notes, assignment, quiz, lab, pyq, project, other |
| chapterNo | String | No | Chapter number to filter by |

#### Example Request
```
GET /get-notes/64e8f0c2b5d1a2a3b4c5d6e7?category=notes&chapterNo=1
```

#### Response (200 - Success)
```json
{
  "success": true,
  "message": "Fetched notes successfully",
  "subject": {
    "_id": "64e8f0c2b5d1a2a3b4c5d6e7",
    "name": "Data Structures",
    "code": "CS201"
  },
  "chapter": {
    "_id": "64e8f0c2b5d1a2a3b4c5d6e8",
    "chapter_no": "1",
    "chapter_name": "Introduction to Arrays"
  },
  "totalCount": 5,
  "sectionsCount": 2,
  "notes": [
    {
      "_id": "64e8f0c2b5d1a2a3b4c5d6e9",
      "subjectId": "64e8f0c2b5d1a2a3b4c5d6e7",
      "chapterNo": "1",
      "chapterName": "Introduction to Arrays",
      "sectionName": "CSE-A",
      "sectionBatch": 2023,
      "uploadedBy": "John Doe",
      "isMyUpload": true,
      "title": "Array Basics",
      "description": "Introduction to arrays and their operations",
      "files": [
        {
          "file_id": "BQACAgUAAyEGAASb56CfAAMPaKdc4YcDg2s",
          "message_id": "15",
          "original_name": "arrays_intro.pdf",
          "mime_type": "application/pdf",
          "file_size": "2.5 MB",
          "created_at": "2025-08-21T17:52:34.113Z"
        }
      ],
      "exam_year": null,
      "semester": null,
      "is_pyq": false,
      "created_at": "2025-08-21T17:52:34.137Z"
    }
  ],
  "notesBySection": {
    "CSE-A (Batch 2023)": [...],
    "CSE-B (Batch 2023)": [...]
  }
}
```

### 15.4 Delete Uploaded Files

| Property | Value |
|----------|-------|
| **Method** | DELETE |
| **Endpoint** | `/delete-uploaded-files/:noteId` |
| **Authentication** | Bearer Token Required |

#### Headers
| Key | Value |
|-----|-------|
| Authorization | Bearer `<access_token>` |
| Content-Type | application/json |

#### Request Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| noteId | String | ID of the note containing the file |

#### Request Body
```json
{
  "fileId": "BQACAgUAAyEGAASb56CfAAMPaKdc4YcDg2s"
}
```

#### Response (200 - Success - File Deleted)
```json
{
  "success": true,
  "message": "File deleted successfully",
  "remainingFiles": 3
}
```

#### Response (200 - Success - Note Removed)
```json
{
  "success": true,
  "message": "File deleted successfully. Note was also removed as it had no remaining files."
}
```

#### Response (200 - Success - Telegram Failed)
```json
{
  "success": true,
  "message": "File removed from database, but may still exist in Telegram storage",
  "warning": "Telegram deletion failed",
  "remainingFiles": 2
}
```

### Postman Testing Steps for Notes
| Step | Action |
|------|--------|
| 1 | Set method to GET/POST/DELETE |
| 2 | Add Authorization header with Bearer token |
| 3 | For upload: Go to Body tab → Select "form-data" |
| 4 | Add required fields and files |
| 5 | Send request |
| 6 | Verify response |

## Complete Testing Flow

| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | GET `/get-all-subjects-and-department` | 200 - Get reference data |
| 2 | GET `/get-all-sections?year=2027` | 200 - Get sections for batch |
| 3 | POST `/register` with teacher data | 201 - Registration success |
| 4 | Check email for OTP | 6-digit OTP received |
| 5 | POST `/verify-auth-otp` with email, OTP & teacherId | 200 - Get access token |
| 6 | GET `/profile` with Bearer token | 200 - Profile data |
| 7 | POST `/upload-profile-image` with token & file | 200 - Image uploaded |
| 8 | GET `/get-upload-section-notes-details` with Bearer token | 200 - Sections and subjects data |
| 9 | POST `/upload-notes` with token, files, and metadata | 201 - Notes uploaded successfully |
| 10 | GET `/get-notes/:subjectId?category=notes` with Bearer token | 200 - Notes retrieved successfully |
| 11 | DELETE `/delete-uploaded-files/:noteId` with token and fileId | 200 - File deleted successfully |
| 12 | PATCH `/reset-password/request` with Bearer token | 200 - Reset OTP sent |
| 13 | Check email for reset OTP | 6-digit reset OTP received |
| 14 | POST `/reset-password/verify-otp` with OTP | 200 - Get reset token |
| 15 | POST `/reset-password` with new password & reset token | 200 - Password changed, logged out |
| 16 | POST `/login` with new password | 200 - Login with new credentials |
| 17 | POST `/logout` with Bearer token | 200 - Session ended |
| 18 | GET `/profile` with same token | 401 - Token revoked |

## Password Reset Testing Flow (Step-by-Step)

| Step | Endpoint | Method | Body | Expected Response | Notes |
|------|----------|---------|------|------------------|-------|
| **1** | `/login` | POST | `{"email": "user@soa.du.in", "password": "oldPassword"}` | 200 - Access token | **Save access token** |
| **2** | `/reset-password/request` | PATCH | `{}` (empty) | 200 - OTP sent message | Check email for OTP |
| **3** | `/reset-password/verify-otp` | POST | `{"otp": "123456"}` | 200 - Reset token | **Save resetToken** |
| **4** | `/reset-password` | POST | `{"newPassword": "NewPassword@123", "resetToken": "abc123"}` | 200 - Password reset | User logged out |
| **5** | `/profile` | GET | - | 401 - Token revoked | Previous token invalid |
| **6** | `/login` | POST | `{"email": "user@soa.du.in", "password": "NewPassword@123"}` | 200 - New session | Login with new password |

## Forgot Password Testing Flow (Step-by-Step)

| Step | Endpoint | Method | Body | Expected Response | Notes |
|------|----------|---------|------|------------------|-------|
| **1** | `/forgot-password/request` | POST | `{"email": "user@soa.du.in"}` | 200 - Success | Check email for OTP |
| **2** | `/forgot-password/verify-otp` | POST | `{"email": "user@soa.du.in", "otp": "123456"}` | 200 - Reset token | **Save resetToken** |
| **3** | `/forgot-password/reset` | POST | `{"resetToken": "xyz789...", "newPassword": "NewPassword@123"}` | 200 - Password reset | User logged out from all devices |
| **4** | `/login` | POST | `{"email": "user@soa.du.in", "password": "oldPassword"}` | 401 - Invalid credentials | Old password doesn't work |
| **5** | `/login` | POST | `{"email": "user@soa.du.in", "password": "NewPassword@123"}` | 200 - New session | Login with new password |

## Alternative Flow: Resend OTP

| Step | Endpoint | Method | Body | Expected Response | Notes |
|------|----------|---------|------|------------------|-------|
| **1** | `/forgot-password/request` | POST | `{"email": "user@soa.du.in"}` | 200 - Success | Initial OTP request |
| **2** | `/forgot-password/resend-otp` | POST | `{"email": "user@soa.du.in"}` | 200 - OTP sent | Resends OTP |
| **3** | `/forgot-password/verify-otp` | POST | `{"email": "user@soa.du.in", "otp": "123456"}` | 200 - Reset token | Continue with reset flow |

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
| **Request Method** | PATCH | POST |
| **Email Security** | Uses authenticated user's email | Validates email exists before proceeding |
| **Steps** | 3 steps | 3 steps + optional resend |

## Validation Summary

### Email Validation
| Rule | Description |
|------|-------------|
| Domain Restriction | Must end with `@soa.du.in` |
| Format | Valid email format required |
| Uniqueness | Email must be unique in system |

### Password Validation
| Rule | Description |
|------|-------------|
| Length | Minimum 8 characters |
| Uppercase | At least one uppercase letter |
| Lowercase | At least one lowercase letter |
| Number | At least one numeric digit |
| Special Character | At least one special character |

### Zod Validation Error Example
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": [
    {
      "field": "email",
      "message": "Email must end with @soa.du.in",
      "code": "invalid_format"
    },
    {
      "field": "password",
      "message": "Password must be at least 8 characters long and include uppercase, lowercase, number, and special character",
      "code": "invalid_format"
    }
  ]
}
```

## Required Fields Validation

### Registration Fields
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| full_name | String | Yes | Teacher full name |
| gender | String | Yes | "male", "female", "other" |
| email | String | Yes | Email ending with @soa.du.in (unique) |
| password | String | Yes | Strong password with complexity rules |
| department | String | Yes | Valid ObjectId of department |
| designation | String | Yes | Teacher designation/title |
| sectionWithSubject | Array | Yes | Array of section-subject mappings |

### Login Fields
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| email | String | Yes | Registered email address |
| password | String | Yes | Account password |

### OTP Verification Fields
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| email | String | Yes | Email address |
| otp | String | Yes | 6-digit OTP code |
| teacherId | String | Yes | Teacher ID from registration |

### Section-Subject Mapping
| Field | Type | Required | Description |
|-------|------|----------|-------------|
| section | String | Yes | Valid ObjectId of section |
| subject | String | Yes | Valid ObjectId of subject |

## Error Scenarios

### Registration Errors
| Scenario | HTTP Status | Response Message |
|----------|-------------|------------------|
| **Invalid email domain** | 400 | "Email must end with @soa.du.in" |
| **Weak password** | 400 | "Password must be at least 8 characters long and include uppercase, lowercase, number, and special character" |
| **Teacher already exists** | 400 | "Teacher with this email already exists" |
| **Invalid department ID** | 404 | "Department not found" |
| **Invalid section ID** | 404 | "Section not found" |
| **Invalid subject ID** | 404 | "Subject not found" |
| **Empty sectionWithSubject** | 400 | "At least one section-subject mapping is required" |
| **Missing required fields** | 400 | "Validation failed" with field-specific errors |

### OTP Verification Errors
| Scenario | HTTP Status | Response Message |
|----------|-------------|------------------|
| **Invalid OTP** | 400 | "Invalid OTP" |
| **Expired OTP** | 400 | "OTP has expired" |
| **Teacher not found** | 404 | "Teacher not found" |
| **Missing teacherId** | 400 | "Teacher ID is required" |
| **Already verified** | 400 | "Account is already verified" |

### Login Errors
| Scenario | HTTP Status | Response Message |
|----------|-------------|------------------|
| **Invalid credentials** | 401 | "Invalid email or password" |
| **Account not verified** | 403 | "Please verify your account first" |
| **Account not found** | 404 | "Teacher not found" |
| **Invalid email domain** | 400 | "Email must end with @soa.du.in" |

### Password Reset Errors
| Scenario | HTTP Status | Response Message |
|----------|-------------|------------------|
| **Request OTP without auth** | 401 | "Access token required" |
| **Invalid OTP format** | 400 | "OTP must be 6 digits long" |
| **Expired OTP** | 400 | "Password reset OTP expired or not found" |
| **Wrong OTP** | 400 | "Invalid password reset OTP" |
| **Invalid reset token** | 400 | "Invalid or expired reset token. Please verify OTP again." |
| **Same as current password** | 400 | "New password cannot be the same as current password" |
| **Weak new password** | 400 | "Password must meet complexity requirements" |

### Forgot Password Errors
| Scenario | HTTP Status | Response Message |
|----------|-------------|------------------|
| **Missing email** | 400 | "Please provide email address" |
| **Invalid email domain** | 400 | "Email must end with @soa.du.in" |
| **Teacher not found (verify)** | 404 | "Teacher not found" |
| **Invalid OTP format** | 400 | "OTP must be 6 digits long" |
| **Expired OTP** | 400 | "OTP expired or not found" |
| **Wrong OTP** | 400 | "Invalid OTP" |
| **Invalid reset token** | 400 | "Invalid or expired reset token" |
| **Weak new password** | 400 | "Password must meet complexity requirements" |

### Notes Management Errors
| Scenario | HTTP Status | Response Message |
|----------|-------------|------------------|
| **Missing subject ID** | 400 | "Subject ID is required" |
| **Missing category** | 400 | "Category is required" |
| **Invalid category** | 400 | "Invalid category. Must be one of: notes, pyq, assignment, quiz, lab, project, other" |
| **Subject not found** | 404 | "Subject not found" |
| **Unauthorized access** | 403 | "You are not authorized to access notes for this subject" |
| **Chapter not found** | 404 | "Chapter not found in your accessible sections" |
| **Note not found** | 404 | "Note not found" |
| **File not found** | 404 | "File not found in this note" |
| **Unauthorized delete** | 403 | "You are not authorized to delete files from this section" |

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

## Security Features

| Feature | Description |
|---------|-------------|
| **JWT Access Tokens** | Bearer tokens for API authentication |
| **HTTP-Only Refresh Cookies** | Secure refresh token storage |
| **Token Blacklisting** | Logged out tokens cannot be reused |
| **Email Domain Restriction** | Only @soa.du.in emails allowed |
| **Password Complexity** | Strong password requirements enforced |
| **OTP Verification** | Email verification required for registration |
| **Rate Limiting** | Prevents OTP spam and brute force attacks |
| **Session Invalidation** | Complete session cleanup after password reset |
| **Redis Cache** | Secure OTP and reset token storage with TTL |
| **Automatic Cleanup** | Expired tokens and OTPs are cleaned periodically |
| **File Type Validation** | Strict file type checking for uploads |
| **Section Assignment Validation** | Teachers can only upload to assigned sections |
| **Chapter-based Organization** | Structured notes management by chapters |
| **Telegram Bot Security** | Secure file storage via Telegram Bot API |
| **File Size Limits** | Prevents abuse and ensures performance |
| **Multi-Section Access Control** | Teachers can only access notes from their assigned sections |

## Environment Configuration

### Required Environment Variables
| Variable | Description | Example |
|----------|-------------|---------|
| JWT_SECRET | Secret for JWT signing | random_256_bit_string |
| JWT_EXPIRE | Access token expiry | 15m |
| REFRESH_TOKEN_EXPIRE | Refresh token expiry | 7d |
| REDIS_URL | Redis connection string | redis://localhost:6379 |
| SMTP_HOST | Email server host | smtp.gmail.com |
| SMTP_PORT | Email server port | 587 |
| CLOUDINARY_URL | Cloudinary connection | cloudinary://... |
| BOT_TOKEN | Telegram Bot token | 1234567890:ABCdefGHIjklMNOpqrsTUVwxyz |
| CHAT_ID | Telegram chat ID for file storage | -1001234567890 |

## Database Collections

### Teachers Collection
| Field | Type | Constraints |
|-------|------|-------------|
| _id | ObjectId | Primary key |
| full_name | String | Required |
| email | String | Required, unique, @soa.du.in |
| password | String | Required, hashed |
| gender | String | Required |
| department | ObjectId | Required, ref: Department |
| designation | String | Required |
| sections | [ObjectId] | Array, ref: Section |
| subjects | [ObjectId] | Array, ref: Subject |
| profile_picture | String | Optional, Cloudinary URL |
| isVerified | Boolean | Default: false |
| refreshTokens | [String] | Array of active refresh tokens |
| createdAt | Date | Auto-generated |
| updatedAt | Date | Auto-generated |

### Notes Collection
| Field | Type | Constraints |
|-------|------|-------------|
| _id | ObjectId | Primary key |
| title | String | Required |
| description | String | Required |
| files | Array | Array of file objects |
| category | String | Enum: notes, assignment, quiz, lab, pyq, project, other |
| chapter | ObjectId | Required, ref: Chapter |
| subject | ObjectId | Required, ref: Subject |
| teacher | ObjectId | Required, ref: Teacher |
| section | ObjectId | Required, ref: Section |
| is_pyq | Boolean | Default: false |
| exam_year | Number | Optional |
| semester | Number | Enum: 1-8 |
| createdAt | Date | Auto-generated |
| updatedAt | Date | Auto-generated |

### Chapters Collection
| Field | Type | Constraints |
|-------|------|-------------|
| _id | ObjectId | Primary key |
| chapter_no | String | Required |
| chapter_name | String | Required |
| subject | ObjectId | Required, ref: Subject |
| section | ObjectId | Required, ref: Section |
| order | Number | Default: 0 |
| createdAt | Date | Auto-generated |
| updatedAt | Date | Auto-generated |

### Related Collections References
| Collection | Referenced Fields |
|------------|------------------|
| **Department** | name, short_name |
| **Section** | section_name, batch, degree, branch |
| **Subject** | subject_code, subject_name |
| **Degree** | name, short_name, duration_years |
| **Branch** | name, short_name |
| **Chapter** | chapter_no, chapter_name, order |
| **Notes** | title, description, files, category |

## Important Notes

| Topic | Details |
|-------|---------|
| **Registration OTP Expiry** | 5 minutes after generation |
| **Password Reset OTP Expiry** | 5 minutes after generation |
| **Forgot Password OTP Expiry** | 10 minutes after generation |
| **Reset Token Expiry** | 10-15 minutes after OTP verification |
| **Email Domain Restriction** | Only @soa.du.in emails accepted |
| **Token Storage** | Store access token securely in localStorage/sessionStorage |
| **Token Transmission** | Always use Authorization header for protected routes |
| **Password Reset Behavior** | User is logged out from all devices after password reset |
| **Session Management** | `/logout-all` invalidates all user sessions |
| **File Upload Formats** | Supports common document and image formats |
| **Response Format** | All endpoints return JSON |
| **Refresh Tokens** | Automatically set as HTTP-only cookies |
| **Profile Data Population** | Profile endpoint returns populated department, section, and subject data |
| **Section-Subject Mapping** | Teachers can teach different subjects in different sections |
| **Notes Organization** | Notes are organized by chapters within subjects |
| **File Storage** | Files are stored securely via Telegram Bot API |
| **Chapter Management** | Chapters are automatically created during notes upload |
| **Multi-section Upload** | Teachers can upload notes to multiple sections simultaneously |
| **File Deletion** | Files can be deleted individually with proper validation |
| **Access Control** | Teachers can only access notes for their assigned sections |
| **Multi-Section Access** | Teachers can view notes from all sections they teach for a subject |