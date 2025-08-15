import 'package:flutter/material.dart';

// Main widget for the Arcanum Login screen.
// It's a StatefulWidget because its state (like text field inputs, password visibility) can change.
class ArcanumLogin extends StatefulWidget {
  const ArcanumLogin({super.key});

  @override
  State<ArcanumLogin> createState() => _ArcanumLoginState();
}

// State class for ArcanumLogin. Manages the mutable state of the login screen.
class _ArcanumLoginState extends State<ArcanumLogin> {
  // Controllers for handling the text input in email and password fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // State variables for UI interactions.
  bool _isPasswordObscured = true; // Tracks whether the password text is hidden.
  bool _rememberMe = false; // Tracks the state of the "Remember Me" checkbox.

  // Dispose of controllers when the widget is removed from the widget tree to free up resources.
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Toggles the visibility of the password text.
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  // Updates the state when the "Remember Me" checkbox value changes.
  void _onRememberMeChanged(bool? value) {
    setState(() {
      _rememberMe = value ?? false; // Defaults to false if value is null.
    });
  }

  // Handles the login button press event.
  void _onLoginPressed() {
    String email = _emailController.text;
    String password = _passwordController.text;
    // TODO: Implement actual login authentication here.
    // Navigate to Dashboard after successful login
    Navigator.pushReplacementNamed(context, 'dashboard');
  }

  // Handles the "Forgot Password?" text press event.
  void _onForgotPasswordPressed() {
    // TODO: Implement navigation to the Forgot Password screen.
    // Remove print statement for production.
  }

  // Handles the "Sign Up" text press event.
  void _onSignUpPressed() {
    Navigator.pushNamed(context, 'signupStep1');
  }

  // Builds the UI for the login screen.
  @override
  Widget build(BuildContext context) {
    return Container(
      // Applies a gradient background to the entire screen.
      decoration: _buildBackgroundDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent, // Makes scaffold background transparent to show container's gradient.
        body: SingleChildScrollView( // Allows the content to be scrollable if it exceeds screen height.
          child: Padding(
            padding: const EdgeInsets.only(left: 35, top: 150, right: 35), // Overall padding for the content.
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left).
              mainAxisSize: MainAxisSize.min, // Column takes up minimum vertical space.
              children: <Widget>[
                const _LoginHeader(), // Reusable widget for the login screen header.
                const SizedBox(height: 130), // Spacing.
                _EmailTextField(controller: _emailController), // Reusable widget for the email input field.
                const SizedBox(height: 20), // Spacing.
                _PasswordTextField( // Reusable widget for the password input field.
                  controller: _passwordController,
                  isObscured: _isPasswordObscured,
                  onToggleVisibility: _togglePasswordVisibility,
                ),
                const SizedBox(height: 15), // Spacing.
                _RememberMeForgotPasswordRow( // Reusable widget for "Remember Me" and "Forgot Password?".
                  rememberMe: _rememberMe,
                  onRememberMeChanged: _onRememberMeChanged,
                  onForgotPasswordPressed: _onForgotPasswordPressed,
                ),
                const SizedBox(height: 30), // Spacing.
                _LoginButton(onPressed: _onLoginPressed), // Reusable widget for the login button.
                const SizedBox(height: 30), // Spacing before "Or" divider
                const _OrDivider(),
                const SizedBox(height: 30), // Spacing after "Or" divider
                Row( // Center the sign up link
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SignUpLink(onPressed: _onSignUpPressed),
                  ],
                ),
                const SizedBox(height: 50), // Added some bottom padding for scroll view
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create the background gradient decoration.
  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.white,
          Colors.purple.shade500,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}

// The following listed below are Reusable Widget Components >>>
// These are private stateless widgets, indicated by the leading underscore,
// meaning they are intended for use only within this file (login.dart).

// Widget to display the header section of the login screen.
class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Login',
          style: TextStyle(
            color: Colors.purple.shade800,
            fontSize: 50,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Academic Management\nSimplified',
          style: TextStyle(
            color: Colors.purple.shade800,
            fontSize: 22,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

// Widget for the email input text field.
class _EmailTextField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withAlpha(204),
        hintText: 'Enter your registered mail id',
        hintStyle: const TextStyle(color: Color(0xFF757575)),
        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF7E57C2)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4A148C), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

// Widget for the password input text field.
class _PasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isObscured;
  final VoidCallback onToggleVisibility;

  const _PasswordTextField({
    required this.controller,
    required this.isObscured,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black87),
      obscureText: isObscured,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withAlpha(204),
        hintText: 'Enter your Password',
        hintStyle: const TextStyle(color: Color(0xFF757575)),
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF7E57C2)),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF7E57C2),
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4A148C), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }
}

// Widget for the row containing the "Remember Me" checkbox and "Forgot Password?" text.
class _RememberMeForgotPasswordRow extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onForgotPasswordPressed;

  const _RememberMeForgotPasswordRow({
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onForgotPasswordPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Checkbox(
              value: rememberMe,
              onChanged: onRememberMeChanged,
              activeColor: Colors.purple.shade800,
              checkColor: Colors.white,
              shape: const CircleBorder(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            GestureDetector(
              onTap: () => onRememberMeChanged(!rememberMe),
              child: Text(
                'Remember Me',
                style: TextStyle(
                  color: Colors.purple.shade800,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: onForgotPasswordPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerRight,
          ),
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: Colors.purple.shade800,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

// Widget for the login button.
class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.shade800,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: onPressed,
      child: const Text('LOGIN'),
    );
  }
}

// Widget for the "Or" divider.
class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0), // This controls the length of the dividers
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              color: Colors.purple.shade800,
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0), // This is the existing padding for the "Or" text
            child: Text(
              'Or',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade800,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.purple.shade800,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// Widget for the "Sign Up" link.
class _SignUpLink extends StatelessWidget {
  final VoidCallback onPressed;

  const _SignUpLink({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Colors.purple.shade800, // Default color
          ),
          children: <TextSpan>[
            const TextSpan(text: "Don't have an account? "),
            TextSpan(
              text: 'Sign up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple.shade900, // Kept shade900 as it was, or should this be 800?
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
