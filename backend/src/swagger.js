import swaggerJSDoc from "swagger-jsdoc";
import swaggerUi from "swagger-ui-express";

const options = {
    definition: {
        openapi: "3.0.0",
        info: {
            title: "Nexus E2 API",
            version: "1.0.0",
            description: `
# Nexus E2 Learning Management System API

A comprehensive API for the Nexus E2 Learning Management System that supports both students and teachers.

## Features
- 🔐 **Authentication & Authorization**: JWT-based authentication with access and refresh tokens
- 👥 **User Management**: Separate student and teacher registration, login, and profile management
- 📚 **Notes Management**: Upload, categorize, and download educational materials
- 🏫 **Section Management**: Organize students and teachers by academic sections
- 📧 **Email Verification**: OTP-based email verification for account security
- 🔄 **Password Management**: Secure password reset and forgot password functionality
- 🗂️ **File Handling**: Support for multiple file formats with Telegram Bot API integration
- ⚡ **Rate Limiting**: Built-in protection against abuse and spam

## Authentication Flow
1. **Registration**: Create account with email verification
2. **Login**: Receive access and refresh tokens
3. **Authorization**: Use Bearer token for protected endpoints
4. **Token Refresh**: Automatic token renewal for seamless experience

## Base URLs
- **Development**: \`http://localhost:8000/api/v1\`
- **Production**: \`https://api.nexuse2.com/api/v1\`

## Rate Limits
- **General API**: 100 requests per 15 minutes per IP
- **OTP Requests**: Specific cooldown periods for security
- **File Uploads**: Size and type restrictions apply

## Error Handling
All endpoints return consistent error responses with appropriate HTTP status codes and descriptive messages.

## Support
For API support, please contact: support@nexuse2.com
            `,
            termsOfService: "https://nexuse2.com/terms",
            contact: {
                name: "Nexus E2 API Support",
                email: "support@nexuse2.com",
                url: "https://nexuse2.com/support"
            },
            license: {
                name: "MIT",
                url: "https://spdx.org/licenses/MIT.html"
            }
        },
        servers: [
            {
                url: "http://localhost:8000/api/v1",
                description: "Development server"
            },
            {
                url: "https://api.nexuse2.com/api/v1",
                description: "Production server"
            }
        ],
        tags: [
            {
                name: "Student Auth",
                description: "Student authentication and authorization operations"
            },
            {
                name: "Student Notes",
                description: "Student notes and file download operations"
            },
            {
                name: "Student Profile",
                description: "Student profile management operations"
            },
            {
                name: "Teacher Auth",
                description: "Teacher authentication and authorization operations"
            },
            {
                name: "Teacher Notes",
                description: "Teacher notes upload and management operations"
            },
            {
                name: "Teacher Profile",
                description: "Teacher profile management operations"
            },
            {
                name: "Teacher Management",
                description: "Teacher class and student management operations"
            }
        ],
        components: {
            securitySchemes: {
                bearerAuth: {
                    type: "http",
                    scheme: "bearer",
                    bearerFormat: "JWT",
                    description: "JWT Authorization header using the Bearer scheme. Example: 'Authorization: Bearer {token}'"
                }
            },
            responses: {
                UnauthorizedError: {
                    description: "Authentication token is missing or invalid",
                    content: {
                        "application/json": {
                            schema: {
                                type: "object",
                                properties: {
                                    success: { type: "boolean", example: false },
                                    message: { type: "string", example: "Access token is required" }
                                }
                            }
                        }
                    }
                },
                ForbiddenError: {
                    description: "Access denied - insufficient permissions",
                    content: {
                        "application/json": {
                            schema: {
                                type: "object",
                                properties: {
                                    success: { type: "boolean", example: false },
                                    message: { type: "string", example: "Access denied" }
                                }
                            }
                        }
                    }
                },
                NotFoundError: {
                    description: "The requested resource was not found",
                    content: {
                        "application/json": {
                            schema: {
                                type: "object",
                                properties: {
                                    success: { type: "boolean", example: false },
                                    message: { type: "string", example: "Resource not found" }
                                }
                            }
                        }
                    }
                },
                ValidationError: {
                    description: "Request validation failed",
                    content: {
                        "application/json": {
                            schema: { $ref: "#/components/schemas/ValidationError" }
                        }
                    }
                },
                RateLimitError: {
                    description: "Rate limit exceeded",
                    content: {
                        "application/json": {
                            schema: { $ref: "#/components/schemas/RateLimitError" }
                        }
                    }
                },
                ServerError: {
                    description: "Internal server error",
                    content: {
                        "application/json": {
                            schema: {
                                type: "object",
                                properties: {
                                    success: { type: "boolean", example: false },
                                    message: { type: "string", example: "Internal server error" },
                                    error: { type: "string", example: "Detailed error message (development only)" }
                                }
                            }
                        }
                    }
                }
            },
            parameters: {
                SubjectIdParam: {
                    in: "path",
                    name: "subjectId",
                    required: true,
                    schema: { type: "string" },
                    description: "ID of the subject",
                    example: "60d21b4667d0d8992e610c85"
                },
                SectionIdParam: {
                    in: "path", 
                    name: "sectionId",
                    required: true,
                    schema: { type: "string" },
                    description: "ID of the section",
                    example: "60d21b4667d0d8992e610c85"
                },
                FileIdParam: {
                    in: "path",
                    name: "fileId", 
                    required: true,
                    schema: { type: "string" },
                    description: "Telegram file ID",
                    example: "BQACAgUAAyEGAASb56CfAAMJaKc..."
                },
                CategoryQueryParam: {
                    in: "query",
                    name: "category",
                    schema: {
                        type: "string",
                        enum: ["notes", "assignment", "quiz", "lab", "pyq", "project", "other"]
                    },
                    description: "Filter by note category"
                },
                ChapterNoQueryParam: {
                    in: "query",
                    name: "chapterNo",
                    schema: { type: "number" },
                    description: "Filter by chapter number"
                }
            },
            examples: {
                StudentRegistration: {
                    summary: "Student registration example",
                    value: {
                        full_name: "John Doe",
                        email: "john.doe@example.com",
                        password: "SecurePass123!",
                        reg_no: "2021CS001",
                        phoneNo: "+1234567890",
                        batch: 2021,
                        gender: "male",
                        department: "60d21b4667d0d8992e610c85",
                        section: "60d21b4667d0d8992e610c85"
                    }
                },
                TeacherRegistration: {
                    summary: "Teacher registration example",
                    value: {
                        full_name: "Dr. Jane Smith",
                        email: "jane.smith@soa.du.in",
                        password: "SecurePass123!",
                        designation: "Professor",
                        gender: "female",
                        departments: ["60d21b4667d0d8992e610c85"],
                        subjects: ["60d21b4667d0d8992e610c85", "60d21b4667d0d8992e610c86"],
                        sections: ["60d21b4667d0d8992e610c85"]
                    }
                },
                LoginCredentials: {
                    summary: "Login credentials example",
                    value: {
                        email: "user@example.com",
                        password: "SecurePass123!"
                    }
                },
                OTPVerification: {
                    summary: "OTP verification example",
                    value: {
                        email: "user@example.com",
                        otp: "123456"
                    }
                },
                PasswordReset: {
                    summary: "Password reset example",
                    value: {
                        resetToken: "abc123def456",
                        newPassword: "NewSecurePass123!"
                    }
                },
                NotesUpload: {
                    summary: "Notes upload example",
                    value: {
                        title: "Chapter 1: Introduction to Programming",
                        description: "Basic concepts and fundamentals of programming",
                        category: "notes",
                        subject: "60d21b4667d0d8992e610c85",
                        sections: ["60d21b4667d0d8992e610c85", "60d21b4667d0d8992e610c86"],
                        chapterNo: 1
                    }
                }
            },
            schemas: {
                Student: {
                    type: "object",
                    properties: {
                        _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                        full_name: { type: "string", example: "John Doe" },
                        email: { type: "string", format: "email", example: "john.doe@example.com" },
                        reg_no: { type: "string", example: "2021CS001" },
                        phoneNo: { type: "string", example: "+1234567890" },
                        batch: { type: "number", example: 2021 },
                        gender: { type: "string", enum: ["male", "female", "other"], example: "male" },
                        isVerified: { type: "boolean", example: true },
                        department: { 
                            type: "object",
                            properties: {
                                _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                                name: { type: "string", example: "Computer Science" }
                            }
                        },
                        section: {
                            type: "object", 
                            properties: {
                                _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                                name: { type: "string", example: "A" }
                            }
                        },
                        profileImage: { type: "string", example: "https://cloudinary.com/image/upload/v1234567890/profile.jpg" }
                    }
                },
                Teacher: {
                    type: "object",
                    properties: {
                        _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                        full_name: { type: "string", example: "Dr. Jane Smith" },
                        email: { type: "string", format: "email", example: "jane.smith@soa.du.in" },
                        designation: { type: "string", example: "Professor" },
                        gender: { type: "string", enum: ["male", "female", "other"], example: "female" },
                        isVerified: { type: "boolean", example: true },
                        departments: {
                            type: "array",
                            items: {
                                type: "object",
                                properties: {
                                    _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                                    name: { type: "string", example: "Computer Science" }
                                }
                            }
                        },
                        subjects: {
                            type: "array",
                            items: {
                                type: "object",
                                properties: {
                                    _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                                    name: { type: "string", example: "Data Structures" },
                                    code: { type: "string", example: "CS201" }
                                }
                            }
                        },
                        sections: {
                            type: "array",
                            items: {
                                type: "object",
                                properties: {
                                    _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                                    name: { type: "string", example: "A" }
                                }
                            }
                        },
                        profileImage: { type: "string", example: "https://cloudinary.com/image/upload/v1234567890/profile.jpg" }
                    }
                },
                Notes: {
                    type: "object",
                    properties: {
                        _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                        title: { type: "string", example: "Chapter 1: Introduction to Programming" },
                        description: { type: "string", example: "Basic concepts and fundamentals of programming" },
                        category: { type: "string", enum: ["notes", "assignment", "quiz", "lab", "pyq", "project", "other"], example: "notes" },
                        subject: {
                            type: "object",
                            properties: {
                                _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                                name: { type: "string", example: "Programming Fundamentals" },
                                code: { type: "string", example: "CS101" }
                            }
                        },
                        section: {
                            type: "object",
                            properties: {
                                _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                                name: { type: "string", example: "A" }
                            }
                        },
                        chapter: {
                            type: "object",
                            properties: {
                                _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                                chapter_no: { type: "number", example: 1 },
                                subject: { type: "string", example: "60d21b4667d0d8992e610c85" },
                                section: { type: "string", example: "60d21b4667d0d8992e610c85" }
                            }
                        },
                        teacher: {
                            type: "object",
                            properties: {
                                _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                                full_name: { type: "string", example: "Dr. Jane Smith" }
                            }
                        },
                        files: {
                            type: "array",
                            items: {
                                type: "object",
                                properties: {
                                    file_id: { type: "string", example: "BQACAgUAAyEGAASb56CfAAMJaKc..." },
                                    original_name: { type: "string", example: "chapter1.pdf" },
                                    mime_type: { type: "string", example: "application/pdf" },
                                    file_size: { type: "string", example: "2.5 MB" }
                                }
                            }
                        },
                        uploadedAt: { type: "string", format: "date-time", example: "2023-08-22T10:30:00.000Z" },
                        updatedAt: { type: "string", format: "date-time", example: "2023-08-22T10:30:00.000Z" }
                    }
                },
                Chapter: {
                    type: "object",
                    properties: {
                        _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                        chapter_no: { type: "number", example: 1 },
                        subject: { type: "string", example: "60d21b4667d0d8992e610c85" },
                        section: { type: "string", example: "60d21b4667d0d8992e610c85" },
                        createdAt: { type: "string", format: "date-time", example: "2023-08-22T10:30:00.000Z" }
                    }
                },
                Subject: {
                    type: "object",
                    properties: {
                        _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                        name: { type: "string", example: "Data Structures and Algorithms" },
                        code: { type: "string", example: "CS201" },
                        department: { type: "string", example: "60d21b4667d0d8992e610c85" },
                        createdAt: { type: "string", format: "date-time", example: "2023-08-22T10:30:00.000Z" }
                    }
                },
                Department: {
                    type: "object", 
                    properties: {
                        _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                        name: { type: "string", example: "Computer Science and Engineering" },
                        code: { type: "string", example: "CSE" },
                        createdAt: { type: "string", format: "date-time", example: "2023-08-22T10:30:00.000Z" }
                    }
                },
                Section: {
                    type: "object",
                    properties: {
                        _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                        name: { type: "string", example: "A" },
                        department: {
                            type: "object",
                            properties: {
                                _id: { type: "string", example: "60d21b4667d0d8992e610c85" },
                                name: { type: "string", example: "Computer Science" }
                            }
                        },
                        batch: { type: "number", example: 2021 },
                        createdAt: { type: "string", format: "date-time", example: "2023-08-22T10:30:00.000Z" }
                    }
                },
                TokenResponse: {
                    type: "object",
                    properties: {
                        success: { type: "boolean", example: true },
                        message: { type: "string", example: "Login successful" },
                        data: {
                            type: "object",
                            properties: {
                                user: { 
                                    oneOf: [
                                        { $ref: "#/components/schemas/Student" },
                                        { $ref: "#/components/schemas/Teacher" }
                                    ]
                                },
                                tokens: {
                                    type: "object",
                                    properties: {
                                        accessToken: { type: "string", example: "eyJhbGciOiJIUzI1NiIs..." },
                                        refreshToken: { type: "string", example: "eyJhbGciOiJIUzI1NiIs..." }
                                    }
                                }
                            }
                        }
                    }
                },
                OTPVerificationResponse: {
                    type: "object",
                    properties: {
                        success: { type: "boolean", example: true },
                        message: { type: "string", example: "OTP verified successfully" },
                        data: {
                            type: "object",
                            properties: {
                                resetToken: { type: "string", example: "abc123def456" }
                            }
                        }
                    }
                },
                ValidationError: {
                    type: "object",
                    properties: {
                        success: { type: "boolean", example: false },
                        message: { type: "string", example: "Validation error" },
                        errors: {
                            type: "array",
                            items: {
                                type: "object",
                                properties: {
                                    field: { type: "string", example: "email" },
                                    message: { type: "string", example: "Email is required" }
                                }
                            }
                        }
                    }
                },
                FileUploadError: {
                    type: "object",
                    properties: {
                        success: { type: "boolean", example: false },
                        message: { type: "string", example: "File upload error" },
                        error: { type: "string", example: "File size exceeds maximum limit of 30MB" }
                    }
                },
                RateLimitError: {
                    type: "object",
                    properties: {
                        success: { type: "boolean", example: false },
                        message: { type: "string", example: "Too many requests, please try again later." }
                    }
                },
                Error: {
                    type: "object",
                    properties: {
                        success: { type: "boolean", example: false },
                        message: { type: "string", example: "Error message" },
                        error: { type: "string", example: "Detailed error description" }
                    }
                },
                Success: {
                    type: "object",
                    properties: {
                        success: { type: "boolean", example: true },
                        message: { type: "string", example: "Operation successful" }
                    }
                }
            }
        }
    },
    apis: ["./src/routes/student/*.js", "./src/routes/teacher/*.js"]
};

const swaggerSpec = swaggerJSDoc(options);

// Swagger setup function
export const setupSwagger = (app) => {
    // Serve swagger docs
    app.use("/api-docs", swaggerUi.serve, swaggerUi.setup(swaggerSpec, {
        explorer: true,
        customCss: `
            .swagger-ui .topbar { display: none }
            .swagger-ui .info .title { color: #3b82f6; }
            .swagger-ui .scheme-container { background: #f8fafc; padding: 10px; border-radius: 5px; }
            .swagger-ui .opblock.opblock-post { border-color: #10b981; }
            .swagger-ui .opblock.opblock-get { border-color: #3b82f6; }
            .swagger-ui .opblock.opblock-put { border-color: #f59e0b; }
            .swagger-ui .opblock.opblock-delete { border-color: #ef4444; }
            .swagger-ui .opblock.opblock-patch { border-color: #8b5cf6; }
        `,
        customSiteTitle: "Nexus E2 API Documentation",
        customfavIcon: "/favicon.ico",
        swaggerOptions: {
            persistAuthorization: true,
            displayRequestDuration: true,
            filter: true,
            showExtensions: true,
            showCommonExtensions: true,
            docExpansion: "list",
            defaultModelsExpandDepth: 2,
            defaultModelExpandDepth: 2,
            displayOperationId: false,
            operationsSorter: "alpha",
            tagsSorter: "alpha",
            tryItOutEnabled: true,
            supportedSubmitMethods: ["get", "post", "put", "delete", "patch"],
            oauth2RedirectUrl: `${process.env.BASE_URL || 'http://localhost:8000'}/api-docs/oauth2-redirect.html`
        }
    }));
    
    // Serve swagger spec as JSON
    app.get("/api-docs.json", (req, res) => {
        res.setHeader("Content-Type", "application/json");
        res.setHeader("Access-Control-Allow-Origin", "*");
        res.send(swaggerSpec);
    });
    
    // Health check endpoint for documentation
    app.get("/api-docs/health", (req, res) => {
        res.status(200).json({
            status: "healthy",
            message: "Swagger documentation is running",
            timestamp: new Date().toISOString(),
            version: swaggerSpec.info?.version || "1.0.0"
        });
    });
    
    console.log("📚 Swagger documentation available at /api-docs");
    console.log("📄 OpenAPI spec available at /api-docs.json"); 
    console.log("💚 Documentation health check at /api-docs/health");
};

export default swaggerSpec;