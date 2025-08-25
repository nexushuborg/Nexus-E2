import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../routes.dart';

class SubjectPage extends StatelessWidget {
  const SubjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final subject = ModalRoute.of(context)?.settings.arguments as String? ?? '';
    final options = [
      ('Notes', '24 notes'),
      ('PYQ\'s', '24 pyq\'s'),
      ('Assignment', '24 assignments'),
      ('Quiz', '24 quiz files'),
      ('Lab', '24 lab files'),
      ('Project', '24 project files'),
    ];

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            '$subject by Prof. Name Title',
            style: const TextStyle(
              color: AppTheme.textColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(25),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(Icons.search, color: AppTheme.textColor),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: AppTheme.textColor),
                        decoration: InputDecoration(
                          hintText: 'Search for notes, subjects and more',
                          hintStyle: TextStyle(color: AppTheme.textColor.withAlpha(128)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.tune, color: AppTheme.textColor),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: options.map((option) => _buildOptionCard(
                  context,
                  subject,
                  option.$1,
                  option.$2,
                )).toList(),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'ARCANUM',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 14,
                    fontFamily: 'MajorMonoDisplay',
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String subject, String title, String subtitle) {
    return InkWell(
      onTap: () => Navigator.pushNamed(
        context,
        Routes.subjectContent,
        arguments: {
          'subject': subject,
          'type': title,
        },
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(25),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                icon: const Icon(Icons.more_vert, color: AppTheme.textColor),
                onPressed: () {},
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: AppTheme.textColor, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(_getIconForOption(title), color: AppTheme.textColor),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppTheme.textColor.withAlpha(128),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForOption(String option) {
    switch (option) {
      case 'Notes':
        return Icons.note_outlined;
      case 'PYQ\'s':
        return Icons.history_edu_outlined;
      case 'Assignment':
        return Icons.assignment_outlined;
      case 'Quiz':
        return Icons.quiz_outlined;
      case 'Lab':
        return Icons.science_outlined;
      case 'Project':
        return Icons.work_outline;
      default:
        return Icons.folder_outlined;
    }
  }
}
