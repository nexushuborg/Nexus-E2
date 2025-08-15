import { z } from "zod";

export const registerStudentSchema = z.object({
  full_name: z
    .string()
    .trim()
    .min(1, { message: "Name is required" })
    .max(100, { message: "Name is too long" }),

  email: z.string().email({ message: "Please enter a valid email address" }),

  phoneNo: z
    .string()
    .trim()
    .regex(/^[6-9]\d{9}$/, {
      message: "Phone number must be a valid 10-digit Indian number",
    }),

  gender: z.enum(["male", "female"], {
    errorMessage: "Gender must be either 'male' or 'female'",
  }),
  slno: z
    .number()
    .int()
    .min(1, { message: "Serial number must be a positive integer" })
    .max(1000, { message: "Serial number cannot exceed 1000" }),

  reg_no: z
    .string()
    .trim()
    .min(6, {
      message: "Registration number must be at least 6 characters long",
    })
    .max(11, {
      message: "Registration number must be at most 11 characters long",
    }),

  batch: z.coerce
    .number()
    .int()
    .min(2022, {
      message: "Batch year must be an integer greater than or equal to 2022",
    })
    .max(2030, { message: "Batch year cannot be in the future beyond 2030" }),

  degree: z
    .string()
    .trim()
    .min(1, { message: "Degree is required" })
    .max(50, { message: "Degree is too long" }),

  branch: z
    .string()
    .trim()
    .min(1, { message: "Branch is required" })
    .max(50, { message: "Branch is too long" }),

  section: z
    .string()
    .trim()
    .min(1, { message: "Section is required" })
    .max(10, { message: "Section is too long" }).optional(),

  password: z
    .string()
    .min(8, { message: "Password must be at least 8 characters long" })
    .max(128, { message: "Password is too long" })
    .regex(
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/,
      {
        message:
          "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character",
      }
    ),
});

export const loginStudentSchema = z.object({
  email: z.string().email({
    message: "Please enter a valid email address",
  }).optional(),

  reg_no: z
    .string()
    .trim()
    .min(6, {
      message: "Registration number must be at least 6 characters long",
    })
    .max(11, {
      message: "Registration number must be at most 11 characters long",
    })
    .optional(),

  password: z
    .string()
    .min(8, { message: "Password must be at least 8 characters long" })
    .max(128, { message: "Password is too long" })
    .regex(
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/,
      {
        message:
          "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character",
      }
    ),
}).refine(
  (data) => data.email || data.reg_no,
  {
    message: "Either email or registration number is required",
    path: ["email"], // can set path to ["reg_no"] or leave as ["email"]
  }
);