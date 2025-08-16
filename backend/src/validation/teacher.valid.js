import { z } from "zod";


const objectId = z
  .string()
  .regex(/^[0-9a-fA-F]{24}$/, "Invalid ObjectId format");

const soaEmailRegex = /^[a-zA-Z0-9._%+-]+@soa\.du\.in$/;

export const registerTeacherSchema = z.object({
  full_name: z.string().min(3, "full_name must be at least 3 characters"),
  gender: z.enum(["male", "female", "other"]).optional(),
  email: z.string().email("Invalid email address").regex(
    soaEmailRegex,
    "Email must end with @soa.du.in"),
  password: z
    .string()
    .min(8, "Password must be at least 8 characters")
    .max(128)
    .regex(/[A-Z]/, "Password must contain an uppercase letter")
    .regex(/[a-z]/, "Password must contain a lowercase letter")
    .regex(/[0-9]/, "Password must contain a number")
    .regex(/[^A-Za-z0-9]/, "Password must contain a special character"),
  department: objectId,
  designation: z.string().min(1, "designation is required"),
  sectionWithSubject: z
    .array(
      z.object({
        section: objectId,
        subject: objectId,
      })
    )
    .min(1, "sectionWithSubject must be a non-empty array"),
});

export const loginTeacherSchema = z.object({
  email: z.string().email("Invalid email address").regex(
    soaEmailRegex,
    "Email must end with @soa.du.in"),
  password: z.string().min(8, "Password must be at least 8 characters")
})


export const newPasswordSchema = z.object({
  newPassword: z
    .string()
    .min(8, "Password must be at least 8 characters")
    .max(128)
    .regex(/[A-Z]/, "Password must contain an uppercase letter")
    .regex(/[a-z]/, "Password must contain a lowercase letter")
    .regex(/[0-9]/, "Password must contain a number")
    .regex(/[^A-Za-z0-9]/, "Password must contain a special character")
})