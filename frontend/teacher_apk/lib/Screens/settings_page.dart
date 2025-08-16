// Account Settings screen
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/arcanum_logo.dart';
import '../utils/ui_constants.dart';
import 'Login.dart'; // Added for ArcanumLogin navigation

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Helper method to show logout confirmation dialog
  Future<bool?> _showLogoutConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.backgroundGradientStart, // Fixed: Used AppTheme.backgroundGradientStart
          shape: RoundedRectangleBorder(borderRadius: UIConstants.circularRadius(UIConstants.glassRadius)), // Fixed: Used UIConstants.circularRadius
          title: Text('Confirm Logout', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold)),
          content: Text('Are you sure you want to log out?', style: TextStyle(color: AppTheme.primaryColor.withAlpha(204))), // Fixed: withAlpha
          actions: <Widget>[
            TextButton(
              child: Text('Cancel', style: TextStyle(color: AppTheme.primaryColor.withAlpha(153))), // Fixed: withAlpha
              onPressed: () {
                Navigator.of(context).pop(false); // User cancelled
              },
            ),
            TextButton(
              child: Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.backgroundGradientStart, AppTheme.backgroundGradientEnd],
        ),
      ),
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
                      icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor, size: UIConstants.iconSizeMedium),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: UIConstants.spacingMedium),
                    Text(
                      'Settings',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.more_vert, color: AppTheme.primaryColor, size: UIConstants.iconSizeMedium),
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
                        padding: const EdgeInsets.all(UIConstants.spacingLarge),
                        decoration: UIConstants.glassDecoration(),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(UIConstants.spacingSmall),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(51), // Fixed: withAlpha
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: AppTheme.primaryColor,
                                size: UIConstants.iconSizeLarge,
                              ),
                            ),
                            const SizedBox(width: UIConstants.spacingMedium),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Santosh Kumar',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: UIConstants.spacingXSmall),
                                  Text(
                                    '+91 - 90300 20398',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor.withAlpha(178), // Fixed: withAlpha
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    'Santkumar@gmail.com',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor.withAlpha(178), // Fixed: withAlpha
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.edit, color: AppTheme.primaryColor, size: UIConstants.iconSizeMedium),
                          ],
                        ),
                      ),
                      const SizedBox(height: UIConstants.spacingMedium),

                      // Update Available Card
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: UIConstants.spacingLarge,
                          vertical: UIConstants.spacingMedium,
                        ),
                        decoration: UIConstants.glassDecoration(),
                        child: Row(
                          children: [
                            Icon(Icons.download, color: AppTheme.primaryColor, size: UIConstants.iconSizeMedium),
                            const SizedBox(width: UIConstants.spacingSmall),
                            Expanded(
                              child: Text(
                                'App Update Available',
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              'v23.2.12',
                              style: TextStyle(
                                color: AppTheme.primaryColor.withAlpha(178), // Fixed: withAlpha
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: UIConstants.spacingSmall),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: UIConstants.iconSizeSmall,
                              color: AppTheme.primaryColor,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: UIConstants.spacingMedium),

                      // Settings Options
                      _SettingsOption(
                        icon: Icons.notifications_none,
                        label: 'Notifications',
                        onTap: () {},
                      ),
                      const SizedBox(height: UIConstants.spacingSmall),
                      _SettingsOption(
                        icon: Icons.lock_outline,
                        label: 'Privacy and Security',
                        onTap: () {},
                      ),
                      const SizedBox(height: UIConstants.spacingSmall),
                      _SettingsOption(
                        icon: Icons.help_outline,
                        label: 'Need help?',
                        onTap: () {},
                      ),
                      const SizedBox(height: UIConstants.spacingSmall),
                      _SettingsOption(
                        icon: Icons.info_outline,
                        label: 'About Us',
                        onTap: () {},
                      ),
                      const SizedBox(height: UIConstants.spacingSmall),
                      _SettingsOption(
                        icon: Icons.logout,
                        label: 'Logout',
                        onTap: () async {
                          final confirmed = await _showLogoutConfirmationDialog(context);
                          if (confirmed == true) {
                            // Perform actual logout logic here (e.g., clearing session, tokens)
                            // For now, just navigating
                            if (context.mounted) { // Fixed: Added context.mounted check
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const ArcanumLogin()), // Corrected to ArcanumLogin
                                (Route<dynamic> route) => false, // Remove all previous routes
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(height: UIConstants.spacingSmall),
                      _SettingsOption(
                        icon: Icons.warning_outlined,
                        label: 'Delete your account permanently',
                        onTap: () {},
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),
              ),

              // Logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: UIConstants.spacingLarge),
                child: ArcanumLogo(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsOption({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : AppTheme.primaryColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(UIConstants.spacingLarge),
        decoration: UIConstants.glassDecoration(),
        child: Row(
          children: [
            Icon(icon, color: color, size: UIConstants.iconSizeMedium),
            const SizedBox(width: UIConstants.spacingMedium),
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
              size: UIConstants.iconSizeSmall,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}
