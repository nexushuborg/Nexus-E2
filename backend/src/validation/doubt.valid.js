import { z } from 'zod';

export const createDoubtSchema = z.object({
    title: z.string({
        required_error: "Title is required",
        invalid_type_error: "Title must be a string"
    }).min(5, "Title must be at least 5 characters long"),
    description: z.string({
        required_error: "Description is required",
        invalid_type_error: "Description must be a string"
    }).min(10, "Description must be at least 10 characters long"),
    subjectId: z.string({
        required_error: "Subject ID is required",
        invalid_type_error: "Subject ID must be a string"
    })
});

export const resolveDoubtSchema = z.object({
    doubtId: z.string({
        required_error: "Doubt ID is required",
        invalid_type_error: "Doubt ID must be a string"
    })
});
