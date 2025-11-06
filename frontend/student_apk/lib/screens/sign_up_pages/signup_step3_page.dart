import 'package:flutter/material.dart';
import 'package:student_apk/theme.dart';
import 'package:student_apk/routes.dart';
import 'package:student_apk/widgets/glass_frame.dart';
import '../../models/signup_data.dart';
import '../../services/api_service.dart';

class SignUpStep3Page extends StatefulWidget {
  final SignupData signupData;

  const SignUpStep3Page({
    super.key,
    required this.signupData,
  });

  @override
  State<SignUpStep3Page> createState() => _SignUpStep3PageState();
}

class _SignUpStep3PageState extends State<SignUpStep3Page> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  late SignupData _signupData;
  bool _isLoading = false;
  bool _isResendLoading = false;
  int _resendTimer = 0;
  bool get _canResend => _resendTimer == 0;

  @override
  void initState() {
    super.initState();
    _signupData = widget.signupData;
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() => _resendTimer = 60);
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_resendTimer > 0) _resendTimer--;
      });
      return _resendTimer > 0;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is SignupData) {
      _signupData = args;
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onCodeDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length != 6 || _signupData.email == null) return;

    setState(() => _isLoading = true);
    try {
      final apiService = ApiService();
      final response = await apiService.verifyOtp(
        email: _signupData.email!,
        otp: otp,
      );

      if (response['success'] == true) {
        if (!mounted) return;
        Navigator.pushNamed(context, Routes.signupStep4,
            arguments: _signupData);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(response['message'] ?? 'OTP verification failed')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 24, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: AppTheme.textColor),
                      onPressed: () => Navigator.pushReplacementNamed(
                        context,
                        Routes.signupStep2,
                        arguments: widget.signupData,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppTheme.textColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('Δ',
                            style: TextStyle(
                                color: AppTheme.backgroundGradientStart,
                                fontSize: 24)),
                      ),
                    ),
                  ],
                ),
              ),

              // Header
              const Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Your Profile',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Verification',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Glass Frame Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 24),
                  child: GlassFrame(
                    borderRadius: BorderRadius.circular(40),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Enter Code',
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "We've sent a verification code to your registered email address ${_signupData.email}",
                            style: TextStyle(
                              color: AppTheme.textColor.withAlpha(178),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // OTP Input Fields
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                              6,
                              (index) => Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  controller: _controllers[index],
                                  focusNode: _focusNodes[index],
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: const TextStyle(
                                    color: AppTheme.textColor2,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: const InputDecoration(
                                    counterText: '',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (value) =>
                                      _onCodeDigitChanged(index, value),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Resend Code Button
                          Center(
                            child: TextButton(
                              onPressed: _resendTimer > 0
                                  ? null
                                  : () async {
                                      setState(() => _isResendLoading = true);
                                      try {
                                        final apiService = ApiService();
                                        final response =
                                            await apiService.resendOtp(
                                          email: _signupData.email!,
                                        );

                                        if (response['success'] == true) {
                                          _startResendTimer();
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'OTP has been resent to your email'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        } else {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  response['message'] ??
                                                      'Failed to resend OTP'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'An error occurred. Please try again.'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } finally {
                                        if (mounted) {
                                          setState(
                                              () => _isResendLoading = false);
                                        }
                                      }
                                    },
                              child: _isResendLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppTheme.textColor),
                                      ),
                                    )
                                  : Text(
                                      _resendTimer > 0
                                          ? 'Resend Code in ${_resendTimer}s'
                                          : 'Resend Code',
                                      style: TextStyle(
                                        color: _resendTimer > 0
                                            ? AppTheme.textColor
                                                .withOpacity(0.5)
                                            : AppTheme.textColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 40),

                          // Verify Button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.buttonBg,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                              onPressed: _isLoading ? null : _verifyOtp,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppTheme.textColor2),
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Verify',
                                          style: TextStyle(
                                            color: AppTheme.textColor2,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(Icons.arrow_forward,
                                            color: AppTheme.textColor2),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Step Indicator
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                4,
                                (index) => Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: index == 2
                                            ? AppTheme.buttonBg
                                            : AppTheme.textColor.withAlpha(76),
                                      ),
                                    )),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: Text(
                              'Step 3 of 4',
                              style: TextStyle(
                                color: AppTheme.textColor.withAlpha(178),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
