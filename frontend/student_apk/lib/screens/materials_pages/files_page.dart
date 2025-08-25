import 'package:flutter/material.dart';
import 'package:student_apk/theme.dart';

class FilesPage extends StatelessWidget {
  const FilesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final chapter = args?['chapter'] ?? '';
    final type = args?['type'] ?? '';
    final subject = args?['subject'] ?? '';

    String getTitle() {
      if (type == 'Project') {
        return 'Project Files';
      } else {
        return '$chapter - $type';
      }
    }

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
            getTitle(),
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
                          hintText: 'Search for files and many more',
                          hintStyle: TextStyle(color: AppTheme.textColor.withAlpha(128)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download, color: AppTheme.textColor),
                      onPressed: () {},
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
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(25),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.buttonBg.withAlpha(25),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.picture_as_pdf, color: AppTheme.buttonBg),
                        ),
                        title: const Text(
                          'File Name',
                          style: TextStyle(
                            color: AppTheme.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          '50 likes • 2hr ago',
                          style: TextStyle(
                            color: AppTheme.textColor.withAlpha(128),
                            fontSize: 12,
                          ),
                        ),
                        trailing: const Icon(Icons.download, color: AppTheme.textColor),
                      ),
                    ),
                  );
                },
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
}
