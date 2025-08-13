# Student API Testing Guide

## Base Configuration
| Property | Value |
|----------|-------|
| Base URL | `http://localhost:8000/api/v1/student` |
| Server Port | 8000 |
| Route Prefix | `/api/v1/student` |

## Prerequisites
| Requirement | Description |
|-------------|-------------|
| Server Status | Running on localhost:8000 |
| Testing Tool | Postman installed |
| Database | Valid degree and branch data |
| Email Service | Configured for OTP delivery |

## API Endpoints Overview

| Endpoint | Method | Authentication | Purpose |
|----------|--------|----------------|---------|
| `/register` | POST | None | Register new student |
| `/verify-auth-otp` | POST | None | Verify email OTP |
| `/login` | POST | None | Student login |
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

## 4. Get Profile

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

## 5. Upload Profile Image

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

## Testing Flow

| Step | Action | Expected Result |
|------|--------|----------------|
| 1 | POST `/register` with student data | 201 - Registration success |
| 2 | Check email for OTP | 6-digit OTP received |
| 3 | POST `/verify-auth-otp` with email & OTP | 200 - Get access token |
| 4 | GET `/profile` with Bearer token | 200 - Profile data |
| 5 | POST `/upload-profile-image` with token & file | 200 - Image uploaded |

## Authentication Testing

| Scenario | Expected Status | Response |
|----------|----------------|----------|
| No token provided | 401 | Unauthorized |
| Invalid token | 403 | Forbidden |
| Expired token | 401 | Unauthorized |
| Valid token | 200 | Success |

## Common Errors

| Status Code | Error Message | Solution |
|-------------|---------------|----------|
| 400 | "Please fill all fields" | Provide all required fields |
| 400 | "Student already exists" | Use unique email/phone/reg_no |
| 400 | "Degree not found" | Verify degree exists in database |
| 400 | "Branch not found" | Verify branch exists in database |
| 400 | "OTP expired or not found" | Request new OTP |
| 400 | "Invalid OTP" | Check OTP digits carefully |
| 400 | "OTP must be 6 digits long" | Ensure OTP is exactly 6 digits |
| 401 | "Invalid credentials" | Verify email/reg_no/password |
| 403 | "Please verify your account first" | Complete OTP verification |
| 404 | "Student not found" | Check if student exists |
| 500 | "Internal server error" | Check server logs |

## Important Notes

| Topic | Details |
|-------|---------|
| OTP Expiry | 5 minutes after generation |
| OTP Cooldown | 60 seconds between requests |
| Token Storage | Store access token securely |
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