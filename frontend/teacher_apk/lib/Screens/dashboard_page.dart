// Dashboard screen for teacher after login/signup
import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/arcanum_logo.dart';
import './upload_notes.dart'; // Added import for UploadNotesScreen

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void _showNoticeDetailsDialog(BuildContext context, String title, String fullContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withAlpha(230), // Semi-transparent white
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.school, color: AppTheme.primaryColor),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Text(
              fullContent,
              style: TextStyle(
                color: AppTheme.primaryColor.withAlpha(204),
                fontSize: 14,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Close',
                style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const String noticeTitle = 'Upcoming Holiday Announcement';
    const String noticePreviewContent =
        'Dear students and faculty, please be advised that the institution will be closed on DD/MM/YYYY in observance of...';
    const String noticeFullContent =
        'Dear students and faculty, please be advised that the institution will be closed on DD/MM/YYYY in observance of [Holiday Name].\n\nAll classes and administrative activities will be suspended on this day. Regular operations will resume on the following day, DD/MM/YYYY.\n\nWe encourage everyone to observe the holiday safely. For any urgent matters, please contact [Contact Person/Department] at [Email/Phone]. Further updates, if any, will be communicated through the official channels.';


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
          child: SingleChildScrollView( // Added SingleChildScrollView
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
                            color: Colors.white.withAlpha(80),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withAlpha(30),
                                offset: const Offset(-1, 8),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: AppTheme.primaryColor),
                              const SizedBox(width: 12),
                              Text(
                                'Search',
                                style: TextStyle(
                                  color: AppTheme.primaryColor.withAlpha(130),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
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
                        color: Colors.white.withAlpha(80),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(30),
                            offset: const Offset(-1, 8),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
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
                GridView.count(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  children: [
                    _DashboardCard(
                      icon: Icons.upload_file,
                      label: 'Upload\nNotes',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const UploadNotesScreen()),
                        );
                      },
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

                // New Container with Heading
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Container(
                    height: 220.0, 
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(60),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Notice board',
                          style: TextStyle(
                            color: AppTheme.primaryColor.withAlpha(204),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(90),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.search, color: AppTheme.primaryColor.withAlpha(204), size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Search for notice',
                                      style: TextStyle(
                                        color: AppTheme.primaryColor.withAlpha(127),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.filter_list, color: AppTheme.primaryColor.withAlpha(204)),
                              onPressed: () {
                                // Handle filter action
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16), 
                        Expanded( 
                          child: SingleChildScrollView( 
                            child: Column(
                              children: [
                                // Notice Preview Card
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(90),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min, // To make Column wrap content
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.school, 
                                            color: AppTheme.primaryColor.withAlpha(178),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '2 hours ago', 
                                            style: TextStyle(
                                              color: AppTheme.primaryColor.withAlpha(127),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8), 
                                      Text(
                                        noticeTitle, 
                                        style: TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        noticePreviewContent,
                                        style: TextStyle(
                                          color: AppTheme.primaryColor.withAlpha(178),
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4), // Space before the arrow
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.arrow_forward_ios,
                                            color: AppTheme.primaryColor.withAlpha(204),
                                            size: 16,
                                          ),
                                          padding: EdgeInsets.zero, // Reduce padding around icon
                                          constraints: const BoxConstraints(), // Reduce tap area to icon size
                                          onPressed: () {
                                            _showNoticeDetailsDialog(context, noticeTitle, noticeFullContent);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Logo
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: ArcanumLogo(color: Colors.white),
                ),
              ],
            ),
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
          color: Colors.white.withAlpha(90),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              offset: const Offset(-2, 10),
              blurRadius: 10,
              spreadRadius: 1,                
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.grey.shade900),
            const SizedBox(height: 16),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 20,
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
