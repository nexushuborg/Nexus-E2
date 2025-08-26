export const validateSocketData = (schema) => {
    return (socket, data, next) => {
        try {
            if (!data) {
                return next(new Error('Data is required'));
            }

            // Basic validation for required fields
            if (schema.required) {
                for (const field of schema.required) {
                    if (!data[field]) {
                        return next(new Error(`${field} is required`));
                    }
                }
            }

            // Type validation
            if (schema.types) {
                for (const [field, type] of Object.entries(schema.types)) {
                    if (data[field] && typeof data[field] !== type) {
                        return next(new Error(`${field} must be of type ${type}`));
                    }
                }
            }

            // Enum validation
            if (schema.enums) {
                for (const [field, allowedValues] of Object.entries(schema.enums)) {
                    if (data[field] && !allowedValues.includes(data[field])) {
                        return next(new Error(`${field} must be one of: ${allowedValues.join(', ')}`));
                    }
                }
            }

            next();
        } catch (error) {
            next(new Error(`Validation error: ${error.message}`));
        }
    };
};

// Predefined validation schemas
export const validationSchemas = {
    authenticate: {
        required: ['userId', 'role'],
        enums: {
            role: ['Student', 'Teacher']
        }
    },
    joinRoom: {
        required: ['roomId', 'userId'],
        enums: {
            userType: ['student', 'teacher'],
            doubtStatus: ['resolved', 'unresolved']
        }
    },
    sendMessage: {
        required: ['roomId', 'senderId', 'senderModel'],
        enums: {
            senderModel: ['Student', 'Teacher']
        }
    }
};
