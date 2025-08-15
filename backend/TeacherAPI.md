# Teacher API Documentation

## 1. Register Teacher

### Endpoint
`POST /register`

### Description
Registers a new teacher in the system.

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

### Responses
#### Success
```json
{
  "success": true,
  "message": "Teacher registered successfully, OTP sent to email",
  "teacherId": "64e8f0c2b5d1a2a3b4c5d6e7"
}
```

#### Error
- `400 Bad Request`: Missing required fields, invalid `sectionWithSubject`, or teacher already exists.
- `404 Not Found`: Department, section, or subject not found.
- `500 Internal Server Error`: Server error during registration.

---

## 2. Get All Subjects and Departments

### Endpoint
`GET /get-all-subjects-and-department`

### Description
Fetches all subjects and departments available in the system.

### Example Request
```
GET /get-all-subjects-and-department
```

### Responses
#### Success
```json
{
  "success": true,
  "message": "Subjects and Departments fetched successfully",
  "subjects": [
    {
      "id": "64e8f0c2b5d1a2a3b4c5d6e9",
      "name": "Mathematics"
    }
  ],
  "departments": [
    {
      "id": "64e8f0c2b5d1a2a3b4c5d6e7",
      "name": "Computer Science"
    }
  ]
}
```

#### Error
- `404 Not Found`: No subjects or departments found.
- `500 Internal Server Error`: Server error.

---

## 3. Get All Sections

### Endpoint
`GET /get-all-sections`

### Description
Fetches all sections for a specific year.

### Query Parameters
- `year` (required): The batch year for which sections are to be fetched.

### Example Request
```
GET /get-all-sections?year=2027
```

### Responses
#### Success
```json
{
  "success": true,
  "message": "Sections fetched successfully",
  "sections": [
    {
      "id": "64e8f0c2b5d1a2a3b4c5d6e8",
      "name": "Section A",
      "batch": 2027
    }
  ]
}
```

#### Error
- `400 Bad Request`: Year is required.
- `404 Not Found`: No sections found for the specified year.
- `500 Internal Server Error`: Server error.

---

## 4. Verify Authentication OTP

### Endpoint
`POST /verify-auth-otp`

### Description
Verifies the OTP sent to the teacher's email during registration.

### Request Body
```json
{
  "email": "john.doe@soa.du.in",
  "otp": "123456"
}
```

### Responses
#### Success
```json
{
  "success": true,
  "message": "OTP verified successfully",
  "teacher": {
    "id": "64e8f0c2b5d1a2a3b4c5d6e7",
    "full_name": "John Doe",
    "email": "john.doe@soa.du.in",
    "department": {
      "name": "Computer Science"
    },
    "section": [
      {
        "name": "Section A",
        "batch": 2027
      }
    ],
    "subjects": [
      {
        "name": "Mathematics",
        "code": "MATH101"
      }
    ]
  },
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### Error
- `400 Bad Request`: Missing email or OTP, invalid OTP, or OTP expired.
- `500 Internal Server Error`: Server error during OTP verification.

---

## 5. Resend Authentication OTP

### Endpoint
`POST /resend-auth-otp`

### Description
Resends the OTP to the teacher's email.

### Request Body
```json
{
  "email": "john.doe@soa.du.in"
}
```

### Responses
#### Success
```json
{
  "success": true,
  "message": "OTP sent successfully"
}
```

#### Error
- `400 Bad Request`: Missing email.
- `429 Too Many Requests`: OTP resend cooldown period not completed.
- `500 Internal Server Error`: Failed to send OTP email.