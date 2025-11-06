// Account Settings screen
import 'package:flutter/material.dart';
import '../theme.dart';
import '../routes.dart';
import '../services/api_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isLoading = false;

  Future<void> _handleLogout(bool allDevices) async {
    final confirmed = await _showLogoutConfirmationDialog(context);
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    try {
      final apiService = ApiService();
      if (allDevices) {
        await apiService.logoutAll();
      } else {
        await apiService.logout();
      }
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.login, (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handlePasswordReset() async {
    setState(() => _isLoading = true);
    try {
      // Step 1: Request OTP
      final apiService = ApiService();
      await apiService.requestPasswordReset();
      if (!mounted) return;

      // Step 2: Show OTP input dialog
      final otp = await _showOtpInputDialog();
      if (otp == null) return;

      // Step 3: Verify OTP
      final response = await apiService.verifyPasswordResetOtp(otp: otp);
      final resetToken = response['resetToken'];

      if (!mounted) return;

      // Step 4: Show new password dialog
      final newPassword = await _showNewPasswordDialog();
      if (newPassword == null) return;

      // Step 5: Complete password reset
      await apiService.completePasswordReset(
        newPassword: newPassword,
      );

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.login, (route) => false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<String?> _showOtpInputDialog() {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundGradientStart,
        title: const Text('Enter OTP',
            style: TextStyle(color: AppTheme.textColor)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppTheme.textColor),
          decoration: const InputDecoration(
            hintText: 'Enter the OTP sent to your email',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  Future<String?> _showNewPasswordDialog() {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundGradientStart,
        title: const Text('New Password',
            style: TextStyle(color: AppTheme.textColor)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: AppTheme.textColor),
          decoration: const InputDecoration(
            hintText: 'Enter your new password',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          obscureText: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Change Password'),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showLogoutConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.backgroundGradientStart,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Confirm Logout',
              style: TextStyle(color: AppTheme.textColor)),
          content: Text('Are you sure you want to log out?',
              style: TextStyle(color: AppTheme.textColor.withAlpha(204))),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel',
                  style: TextStyle(color: AppTheme.textColor.withAlpha(153))),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Top Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 24, 24),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: AppTheme.textColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Settings List
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      children: [
                        _buildSettingItem(
                          'Change Password',
                          Icons.lock_outline,
                          onTap: _handlePasswordReset,
                        ),
                        _buildSettingItem(
                          'Logout',
                          Icons.logout,
                          onTap: () => _handleLogout(false),
                          textColor: Colors.red,
                        ),
                        _buildSettingItem(
                          'Logout from all devices',
                          Icons.logout,
                          onTap: () => _handleLogout(true),
                          textColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_isLoading)
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    IconData icon, {
    Color? textColor,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Icon(icon, color: textColor ?? AppTheme.textColor),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppTheme.textColor,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppTheme.textColor,
      ),
      onTap: onTap,
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
