import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../routes.dart';

class MaterialsPage extends StatelessWidget {
  const MaterialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = ['AAD-2', 'COA', 'ALA', 'IM', 'IDM'];

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
          title: const Text(
            'Materials',
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: AppTheme.textColor),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: AppTheme.textColor),
              onPressed: () {},
            ),
          ],
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
                children: subjects.map((subject) => _buildSubjectCard(context, subject)).toList(),
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Text(
                  'Arcanum',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 16,
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

  Widget _buildSubjectCard(BuildContext context, String subject) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, Routes.subject, arguments: subject),
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
                    child: const Icon(Icons.folder_outlined, color: AppTheme.textColor),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    subject,
                    style: const TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '24 files',
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
}
