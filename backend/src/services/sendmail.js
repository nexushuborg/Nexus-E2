import nodemailer from "nodemailer";

const transporter = nodemailer.createTransport({
    host: "smtp.gmail.com",
    port: 465,
    secure: true,
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASSWORD,
    },
})


export const sendOTP = async (to, otp) => {
    try {
        const send = await transporter.sendMail({
            from: "Arcanum",
            to,
            subject: "OTP Verification",
            html: ` <div style="background-color: white; padding: 2rem; border-radius: 1rem; box-shadow: 0 10px 25px rgba(0,0,0,0.05); max-width: 32rem; width: 100%; text-align: center; border: 1px solid #f3f4f6; margin: auto; font-family: sans-serif;">
            <h2 style="font-size: 1.875rem; font-weight: 800; color: #111827; margin-bottom: 0.5rem;">Verification Code</h2>
            <p style="color: #4b5563; margin-bottom: 1.5rem; line-height: 1.625;">
                Please use the following code to complete your account verification.
            </p>
            <div style="background-color: #eef2ff; padding: 1.5rem 2rem; border-radius: 0.75rem; display: flex; justify-content: center; gap: 1rem; align-items: center; margin-bottom: 1.5rem; box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05);">
                <span style="font-size: 2.25rem; font-weight: 700; letter-spacing: 0.3em; color: #4338ca;">
                    ${otp}
                </span>
            </div>
            <div style="font-size: 0.875rem; color: #6b7280;">
                <p>This code is valid for <strong style="color: #374151;">5 minutes</strong>.</p>
                <p style="margin-top: 0.5rem; color: #ef4444; font-weight: 500;">For your security, do not share this code with anyone.</p>
            </div>
            <hr style="margin: 2rem 0; border-top: 1px solid #e5e7eb;">
            <p style="font-size: 0.75rem; color: #9ca3af;">
                If you did not request this, you can safely ignore this email.
            </p>
        </div>`

        })

        if (send.accepted.length> 0) {
            return {
                success: true,
                message: "OTP sent successfully"
            }
        }
    } catch (error) {
        return {
            success: false,
            message: "Failed to send OTP"
        }
    }
} 