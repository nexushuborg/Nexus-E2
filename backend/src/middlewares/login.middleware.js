export const loginValidation = (req, res, next) => {
    try {
        const { email, reg_no, password } = req.body;

        if (!email || !reg_no || !password) {
            return res.status(400).json({
                success: false,
                message: "Please provide email, registration number and password"
            });
        }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            return res.status(400).json({
                success: false,
                message: "Please provide a valid email address"
            });
        }

        if (reg_no.trim().length < 3) {
            return res.status(400).json({
                success: false,
                message: "Please provide a valid registration number"
            });
        }

        if (password.length < 8) {
            return res.status(400).json({
                success: false,
                message: "Password must be at least 8 characters long"
            });
        }

        req.body.email = email.toLowerCase().trim();
        req.body.reg_no = reg_no.trim();

        next();

    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Internal server error",
        });
    }
};