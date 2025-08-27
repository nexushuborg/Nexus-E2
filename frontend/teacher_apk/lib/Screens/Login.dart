// ================== Imports ==================
import 'package:flutter/material.dart';
import 'package:teacher_apk/theme.dart';
import '../widgets/arcanum_logo.dart';

// ================== Main Login Widget ==================
class ArcanumLogin extends StatefulWidget {
  const ArcanumLogin({super.key});

  @override
  State<ArcanumLogin> createState() => _ArcanumLoginState();
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
    Navigator.pushReplacementNamed(context, 'dashboard');
  }

  void _onForgotPasswordPressed() {
    Navigator.pushNamed(context, 'forgotPasswordEmail');
  }

  void _onSignUpPressed() {
    Navigator.pushNamed(context, 'signupStep1');
  }

  // ================== Build Method ==================
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 35, top: 80, right: 35),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Center(child: ArcanumLogo(color: AppTheme.primaryColor, fontSize: 25)),
                const SizedBox(height: 80),
                const _LoginHeader(),
                const SizedBox(height: 90),
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
                const SizedBox(height: 30),
                const _OrDivider(),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SignUpLink(onPressed: _onSignUpPressed),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppTheme.backgroundGradientStart,
          AppTheme.backgroundGradientEnd,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    );
  }
}

// ================== Login Header ==================
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
            color: AppTheme.primaryColor,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Academic Management\nSimplified',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 22,
          ),
        ),
      ],
    );
  }
}

// ================== Email Text Field ==================
class _EmailTextField extends StatelessWidget {
  final TextEditingController controller;
  const _EmailTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black87),
      decoration: InputDecoration(
        hintText: 'Enter your registered mail id',
        hintStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(Icons.person_outline, color: AppTheme.primaryColor),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }
}

// ================== Password Text Field ==================
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
        hintText: 'Enter your Password',
        hintStyle: TextStyle(color: Colors.grey.shade600),
        prefixIcon: Icon(Icons.lock_outline, color: AppTheme.primaryColor),
        suffixIcon: IconButton(
          icon: Icon(
            isObscured ? Icons.visibility_off : Icons.visibility,
            color: AppTheme.primaryColor,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }
}

// ================== Remember Me & Forgot Password Row ==================
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
              activeColor: AppTheme.primaryColor,
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
                  color: AppTheme.primaryColor,
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
              color: AppTheme.primaryColor,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

// ================== Login Button ==================
class _LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _LoginButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
        minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: WidgetStateProperty.all(AppTheme.primaryColor),
      ),
      onPressed: onPressed,
      child: const Text('LOGIN'),
    );
  }
}

// ================== Or Divider ==================
class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              color: AppTheme.primaryColor,
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Or',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: AppTheme.primaryColor,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ================== Sign Up Link ==================
class _SignUpLink extends StatelessWidget {
  final VoidCallback onPressed;
  const _SignUpLink({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 14,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Don\'t have an account? ',
              style: TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
