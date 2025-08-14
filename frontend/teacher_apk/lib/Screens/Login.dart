import 'package:flutter/material.dart';

// Main widget for the Arcanum Login screen.
// It's a StatefulWidget because its state (like text field inputs, password visibility) can change.
class ArcanumLogin extends StatefulWidget {
  const ArcanumLogin({super.key});

  @override
  _ArcanumLoginState createState() => _ArcanumLoginState();
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
    // Placeholder for actual login logic.
    print(
        'Login Tapped! Email: $email, Password: $password, Remember Me: $_rememberMe');
    // Logic ->> Implement actual login authentication here.
  }

  // Handles the "Forgot Password?" text press event.
  void _onForgotPasswordPressed() {
    // Placeholder for navigation to the forgot password screen.
    print('Forgot Password? tapped - UI only');
    // Navigation ->> Implement navigation to the Forgot Password screen.
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
                const SizedBox(height: 150), // Spacing.
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
                const SizedBox(height: 20), // Spacing.
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
            color: Colors.purple.shade900,
            fontSize: 40,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Academic Management\nSimplified',
          style: TextStyle(
            color: Colors.purple.shade700,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

// Widget for the email input text field.
class _EmailTextField extends StatelessWidget {
  final TextEditingController controller; // Controller to manage the text field's content.

  const _EmailTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8), // Semi-transparent white background.
        hintText: 'Email or Username',
        hintStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(Icons.person_outline, color: Colors.purple.shade700), // Icon at the beginning of the field.
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50), // Rounded corners.
          borderSide: BorderSide.none, // No visible border by default.
        ),
        focusedBorder: OutlineInputBorder( // Border style when the field is focused.
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.purple.shade900, width: 2),
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 20), // Inner padding.
      ),
      keyboardType: TextInputType.emailAddress, // Sets the appropriate keyboard type.
    );
  }
}

// Widget for the password input text field.
class _PasswordTextField extends StatelessWidget {
  final TextEditingController controller; // Controller for the text field's content.
  final bool isObscured; // Determines if the password text is hidden.
  final VoidCallback onToggleVisibility; // Callback function to toggle password visibility.

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
      obscureText: isObscured, // Hides or shows the password text.
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.purple.shade700),
        suffixIcon: IconButton( // Icon at the end of the field to toggle visibility.
          icon: Icon(
            isObscured ? Icons.visibility_off : Icons.visibility,
            color: Colors.purple.shade700,
          ),
          onPressed: onToggleVisibility,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.purple.shade900, width: 2),
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }
}

// Widget for the row containing the "Remember Me" checkbox and "Forgot Password?" text.
class _RememberMeForgotPasswordRow extends StatelessWidget {
  final bool rememberMe; // Current state of the "Remember Me" checkbox.
  final ValueChanged<bool?> onRememberMeChanged; // Callback when the checkbox state changes.
  final VoidCallback onForgotPasswordPressed; // Callback when "Forgot Password?" is pressed.

  const _RememberMeForgotPasswordRow({
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onForgotPasswordPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distributes space evenly between children.
      children: <Widget>[
        Row( // Groups the checkbox and its label.
          children: <Widget>[
            SizedBox(
              height: 24.0,
              width: 24.0,
              child: Checkbox(
                value: rememberMe,
                onChanged: onRememberMeChanged,
                activeColor: Colors.purple.shade700, // Color when checked.
                checkColor: Colors.white, // Color of the check mark.
                shape: const CircleBorder(), // Makes the checkbox circular.
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector( // Allows tapping on the text to also toggle the checkbox.
              onTap: () => onRememberMeChanged(!rememberMe),
              child: Text(
                'Remember Me',
                style: TextStyle(
                  color: Colors.purple.shade700,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        TextButton( // "Forgot Password?" button.
          onPressed: onForgotPasswordPressed,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(50, 30), // Ensures a minimum tappable area.
            tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduces extra padding around the button.
            alignment: Alignment.centerRight,
          ),
          child: Text(
            'Forgot Password?',
            style: TextStyle(
              color: Colors.purple.shade700,
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
  final VoidCallback onPressed; // Callback function when the button is pressed.

  const _LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.shade700, // Button background color.
        foregroundColor: Colors.white, // Text color.
        minimumSize: const Size(double.infinity, 50), // Makes the button take full width and a fixed height.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Rounded corners for the button.
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
