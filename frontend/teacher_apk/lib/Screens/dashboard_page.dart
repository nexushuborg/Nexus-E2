// Dashboard screen for teacher after login/signup
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/arcanum_logo.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
              // Search and Actions Bar
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: Row(
                  children: [
                    // Search Bar
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(51),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: AppTheme.primaryColor),
                            const SizedBox(width: 12),
                            Text(
                              'Search',
                              style: TextStyle(
                                color: AppTheme.primaryColor.withAlpha(127),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Action Buttons
                    IconButton(
                      iconSize: 35.0,
                      icon: Icon(Icons.notifications_none, color: AppTheme.primaryColor),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      iconSize: 35.0,
                      icon: Icon(Icons.settings, color: Colors.grey.shade900),
                      onPressed: () => Navigator.pushNamed(context, 'settings'),
                    ),
                  ],
                ),
              ),

              // Welcome Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'profile'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24, // Which makes the diameter 48
                          backgroundColor: AppTheme.primaryColor,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 28, // Slightly smaller than the avatar radius for padding
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello Professor!',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                color: AppTheme.primaryColor.withAlpha(178),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Dashboard Grid
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.fromLTRB(24, 50, 24, 16),
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _DashboardCard(
                      icon: Icons.upload_file,
                      label: 'Upload\nNotes',
                      onTap: () {},
                    ),
                    _DashboardCard(
                      icon: Icons.announcement,
                      label: 'Generate\na Notice',
                      onTap: () {},
                    ),
                    _DashboardCard(
                      icon: Icons.question_answer,
                      label: 'Doubts\nCorner',
                      onTap: () {},
                    ),
                    _DashboardCard(
                      icon: Icons.class_,
                      label: 'Your\nClasses',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // Logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: ArcanumLogo(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(51),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25), // Shadow color (30% opacity)
              offset: const Offset(-2, 10),    // Offset mostly downwards, slightly to the left
              blurRadius: 8,                  // Blur radius
              spreadRadius: 1,                // Spread radius
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.grey.shade900), // Changed to Colors.black
            const SizedBox(height: 16),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
