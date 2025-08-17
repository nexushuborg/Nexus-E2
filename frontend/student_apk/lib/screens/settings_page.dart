// Account Settings screen
import 'package:flutter/material.dart';
import '../theme.dart';
import '../routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Helper method to show logout confirmation dialog
  Future<bool?> _showLogoutConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.backgroundGradientStart,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Confirm Logout', style: TextStyle(color: AppTheme.textColor, fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to log out?', style: TextStyle(color: AppTheme.textColor.withAlpha(204))),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: AppTheme.textColor.withAlpha(153))),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
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
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 24, 24),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppTheme.textColor, size: 24),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.notifications_none, color: AppTheme.textColor, size: 24),
                    const SizedBox(width: 16),
                    const Icon(Icons.more_vert, color: AppTheme.textColor, size: 24),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      // Profile Info Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withAlpha(51),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(51),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: AppTheme.textColor,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'John Doe',
                                    style: TextStyle(
                                      color: AppTheme.textColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '+91 98765 43210',
                                    style: TextStyle(
                                      color: AppTheme.textColor.withAlpha(178),
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'john.doe@example.com',
                                    style: TextStyle(
                                      color: AppTheme.textColor.withAlpha(178),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.edit, color: AppTheme.textColor, size: 24),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Update Available Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(25),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withAlpha(51),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.download, color: AppTheme.textColor, size: 24),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'App Update Available',
                                style: TextStyle(
                                  color: AppTheme.textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              'v23.2.12',
                              style: TextStyle(
                                color: AppTheme.textColor.withAlpha(178),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: AppTheme.textColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Settings Options
                      _buildSettingsOption(
                        icon: Icons.notifications_none,
                        label: 'Notifications',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildSettingsOption(
                        icon: Icons.lock_outline,
                        label: 'Privacy and Security',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildSettingsOption(
                        icon: Icons.help_outline,
                        label: 'Need help?',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildSettingsOption(
                        icon: Icons.info_outline,
                        label: 'About Us',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      _buildSettingsOption(
                        icon: Icons.logout,
                        label: 'Logout',
                        onTap: () async {
                          final confirmed = await _showLogoutConfirmationDialog(context);
                          if (confirmed == true && context.mounted) {
                            Navigator.pushReplacementNamed(context, Routes.login);
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      _buildSettingsOption(
                        icon: Icons.warning_outlined,
                        label: 'Delete your account permanently',
                        onTap: () {},
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),
              ),

              // Logo at bottom
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CustomPaint(
                    painter: TrianglePainter(color: AppTheme.textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : AppTheme.textColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(25),  // Changed from withOpacity(0.1)
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withAlpha(51),  // Changed from withOpacity(0.2)
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: color,
            ),
          ],
        ),
      ),
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
