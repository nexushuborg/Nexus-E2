# Teacher API Documentation

This document describes the Teacher-related HTTP API endpoints that exist under the teacher router.

Notes
- The API uses JWT access tokens and sets a httpOnly refresh token cookie on successful verification/login.
- Request body validation is enforced using Zod schemas (see `validation/teacher.valid.js`). Emails are restricted to the `@soa.du.in` domain.

## 1. Register Teacher

Endpoint
`POST /register`

Description
Creates a new teacher, links them to sections/subjects and sends a 6-digit OTP to the provided email. Frontend must call `POST /verify-auth-otp` with the OTP to complete verification.

Request body (example)
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

Validation
- `email` must end with `@soa.du.in`.
- `password` must be 8+ chars, contain upper, lower, number and special char.
- `department`, `section`, `subject` are validated as ObjectId strings.

Success (201)
```json
{
  "success": true,
  "message": "Teacher registered successfully, OTP sent to email",
  "teacherId": "64e8f0c2b5d1a2a3b4c5d6e7"
}
```

Errors
- `400` validation errors or teacher already exists
- `404` referenced department/section/subject not found
- `500` internal server error

---

## 2. Get All Subjects and Departments

Endpoint
`GET /get-all-subjects-and-department`

Description
Returns all subjects and departments (trimmed fields) for building registration forms.

Example
```
GET /get-all-subjects-and-department
```

Success (200)
```json
{
  "success": true,
  "message": "Subjects and Departments fetched successfully",
  "subjects": [
    { "id": "64e8f0...", "subject_code": "CS101", "subject_name": "Intro to CS" }
  ],
  "departments": [
    { "id": "64e8f0...", "name": "Computer Science" }
  ]
}
```

---

## 3. Get All Sections

Endpoint
`GET /get-all-sections?year=<batch>`

Description
Returns sections for a batch year. Used by registration UI to select sections.

Success (200)
```json
{
  "success": true,
  "message": "Sections fetched successfully",
  "sections": [
    { "id": "64e8f0...", "section_name": "23411A1", "batch": 2027 }
  ]
}
```

Errors
- `400` if year missing
- `404` if no sections found

---

## 4. Verify Authentication OTP

Endpoint
`POST /verify-auth-otp`

Description
Verifies the 6-digit OTP sent by email during registration. On success the teacher is marked verified, a refresh cookie is set and an accessToken is returned.

Request body (example)
```json
{
  "email": "john.doe@soa.du.in",
  "otp": "123456",
  "teacherId": "64e8f0..." // teacher id returned by register
}
```

Success (200)
```json
{
  "success": true,
  "message": "OTP verified successfully",
  "teacher": {
    "_id": "64e8f0...",
    "full_name": "John Doe",
    "email": "john.doe@soa.du.in",
    "department": { "_id": "...", "name": "Computer Science" },
    "section": [
      { "_id": "...", "section_name": "23411A1", "batch": 2027 }
    ],
    "subjects": [
      { "_id": "...", "subject_code": "CS101", "subject_name": "Intro to CS" }
    ],
    "isVerified": true
  },
  "accessToken": "<jwt.token>"
}
```

Notes
- A httpOnly `refreshToken` cookie is set as part of the response.
- The endpoint expects the `teacherId` (used to look up Redis OTP entries) and compares OTP values as strings.

---

## 5. Resend Authentication OTP

Endpoint
`POST /resend-auth-otp`

Request body
```json
{ "email": "john.doe@soa.du.in", "teacherId": "64e8f0..." }
```

Success (200)
```json
{ "success": true, "message": "OTP sent successfully" }
```

Errors
- `429` when resend cooldown not finished

---

## 6. Login

Endpoint
`POST /login`

Request body (example)
```json
{
  "email": "john.doe@soa.du.in",
  "password": "Password@123"
}
```

Validation
- Email must be `@soa.du.in` (Zod)

Success (200)
```json
{
  "success": true,
  "message": "Login successful",
  "teacher": { "_id": "...", "full_name": "John Doe", "email": "..." },
  "accessToken": "<jwt.token>"
}
```

Notes
- A httpOnly `refreshToken` cookie is set on successful login/verify flows.

---

## 7. Logout / Logout All

Endpoints
- `POST /logout` (invalidate this device) — authenticated
- `POST /logout-all` (invalidate all refresh tokens) — authenticated

Both return 200 with a simple success message.

---

## 8. Teacher Profile

Endpoint
`GET /profile` (authenticated)

Description
Returns teacher profile with populated subjects and sections. Each section includes degree and branch details, along with the subjects taught in that section.

Success (200) example
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
    "designation": "Chamar",
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

Notes
- If `branch` fields are null, it indicates that the `Section.branch` is null or the corresponding Branch document is missing.
- Each section includes the subjects taught in that section, along with degree and batch details.

---

## 9. Upload Profile Image

Endpoint
`POST /upload-profile-image` (authenticated, multipart form-data)

Form field
- `profileImage` — file

Success (200)
```json
{ "success": true, "message": "Profile image uploaded and updated successfully", "data": { "profile_picture": "<url>" } }
```

---

## 10. Reset Password (when logged in)

Flow (authenticated)
1. `PATCH /reset-password/request` — sends OTP to registered email
2. `POST /reset-password/verify-otp` — verifies OTP and returns a short-lived reset token
3. `POST /reset-password` — send new password with reset token to update password

### Example Requests

#### 1. Request OTP
```http
PATCH /reset-password/request
Authorization: Bearer <accessToken>
```
Response:
```json
{
  "success": true,
  "message": "OTP sent to registered email"
}
```

#### 2. Verify OTP
```http
POST /reset-password/verify-otp
Authorization: Bearer <accessToken>
Content-Type: application/json

{
  "otp": "123456"
}
```
Response:
```json
{
  "success": true,
  "message": "OTP verified successfully",
  "resetToken": "<short-lived-reset-token>"
}
```

#### 3. Reset Password
```http
POST /reset-password
Authorization: Bearer <accessToken>
Content-Type: application/json

{
  "resetToken": "<short-lived-reset-token>",
  "newPassword": "NewPassword@123"
}
```
Response:
```json
{
  "success": true,
  "message": "Password reset successfully"
}
```

Validation
- New password must follow the same password rules as registration (`newPassword` schema).

---

## 11. Forgot Password (when not logged in)

Flow
1. `POST /forgot-password/request` — sends OTP to teacher email
2. `POST /forgot-password/verify-otp` — verifies OTP and returns reset token
3. `POST /forgot-password/reset` — reset password using reset token
4. `POST /forgot-password/resend-otp` — resend OTP

### Example Requests

#### 1. Request OTP
```http
POST /forgot-password/request
Content-Type: application/json

{
  "email": "john.doe@soa.du.in"
}
```
Response:
```json
{
  "success": true,
  "message": "OTP sent to email"
}
```

#### 2. Verify OTP
```http
POST /forgot-password/verify-otp
Content-Type: application/json

{
  "email": "john.doe@soa.du.in",
  "otp": "123456"
}
```
Response:
```json
{
  "success": true,
  "message": "OTP verified successfully",
  "resetToken": "<short-lived-reset-token>"
}
```

#### 3. Reset Password
```http
POST /forgot-password/reset
Content-Type: application/json

{
  "resetToken": "<short-lived-reset-token>",
  "newPassword": "NewPassword@123"
}
```
Response:
```json
{
  "success": true,
  "message": "Password reset successfully"
}
```

#### 4. Resend OTP
```http
POST /forgot-password/resend-otp
Content-Type: application/json

{
  "email": "john.doe@soa.du.in"
}
```
Response:
```json
{
  "success": true,
  "message": "OTP resent successfully"
}
```

---

## Validation summary
- Implemented via Zod in `src/validation/teacher.valid.js`.
- Important rules:
  - `email` must be a valid email ending with `@soa.du.in`.
  - `password`/`newPassword` must be >=8 chars with at least one upper, lower, number and special char.
  - `sectionWithSubject` must be a non-empty array of objects with `section` and `subject` ObjectId strings.

---

### Zod Validation Errors Example

When Zod validation fails, the API returns a `400` status code with an array of error objects. Each object contains the field name, error message, and an optional error code.

Example:
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