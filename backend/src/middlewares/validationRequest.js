export const validateRequest = (schema) => (req, res, next) => {
  try {
    schema.parse(req.body);
    next();
  } catch (error) {
    if (error.name === 'ZodError') {
      const errors = error.issues || error.errors || [];
      return res.status(400).json({
        success: false,
        message: "Validation failed",
        errors: errors.map((err) => ({
          field: err.path?.join('.') || 'unknown',
          message: err.message || 'Validation error',
          code: err.code || 'unknown'
        }))
      });
    }

    return res.status(500).json({
      success: false,
      message: "Internal server error",
      error: error.message
    });
  }
};