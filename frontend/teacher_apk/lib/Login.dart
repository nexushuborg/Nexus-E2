import 'package:flutter/material.dart';

class ArcanumLogin extends StatefulWidget {
  const ArcanumLogin({super.key});

  @override
  _ArcanumLoginState createState() => _ArcanumLoginState();
}

class _ArcanumLoginState extends State<ArcanumLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordObscured = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordObscured = !_isPasswordObscured;
    });
  }

  void _onRememberMeChanged(bool? value) {
    setState(() {
      _rememberMe = value ?? false;
    });
  }

  void _onLoginPressed() {
    String email = _emailController.text;
    String password = _passwordController.text;
    print(
        'Login Tapped! Email: $email, Password: $password, Remember Me: $_rememberMe');
    // Logic ->> Login
  }

  void _onForgotPasswordPressed() {
    print('Forgot Password? tapped - UI only');
    // Navigation ->> Forgot Password
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 35, top: 150, right: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const _LoginHeader(),
                const SizedBox(height: 150),
                _EmailTextField(controller: _emailController),
                const SizedBox(height: 20),
                _PasswordTextField(
                  controller: _passwordController,
                  isObscured: _isPasswordObscured,
                  onToggleVisibility: _togglePasswordVisibility,
                ),
                const SizedBox(height: 15),
                _RememberMeForgotPasswordRow(
                  rememberMe: _rememberMe,
                  onRememberMeChanged: _onRememberMeChanged,
                  onForgotPasswordPressed: _onForgotPasswordPressed,
                ),
                const SizedBox(height: 30),
                _LoginButton(onPressed: _onLoginPressed),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
        fillColor: Colors.white.withOpacity(0.8),
        hintText: 'Email or Username',
        hintStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(Icons.person_outline, color: Colors.purple.shade700),
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
      keyboardType: TextInputType.emailAddress,
    );
  }
}

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
        fillColor: Colors.white.withOpacity(0.8),
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.purple.shade700),
        suffixIcon: IconButton(
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
            SizedBox(
              height: 24.0,
              width: 24.0,
              child: Checkbox(
                value: rememberMe,
                onChanged: onRememberMeChanged,
                activeColor: Colors.purple.shade700,
                checkColor: Colors.white,
                shape: const CircleBorder(),
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: () => onRememberMeChanged(!rememberMe), // Also toggle on text tap
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

class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple.shade700,
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
