import 'package:flutter/material.dart';
import 'package:student_apk/theme.dart';
import 'package:student_apk/routes.dart';

class SubjectContentPage extends StatefulWidget {
  const SubjectContentPage({super.key});

  @override
  State<SubjectContentPage> createState() => _SubjectContentPageState();
}

class _SubjectContentPageState extends State<SubjectContentPage> {
  String _selectedFilter = 'Mid Sem PYQ\'s';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
    final subject = args?['subject'] ?? '';
    final type = args?['type'] ?? '';

    // If it's Project type, directly navigate to files page
    if (type == 'Project') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(
          context,
          Routes.files,
          arguments: {
            'subject': subject,
            'type': type,
            'chapter': 'Project Files'
          },
        );
      });
      return Container();
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
            type == 'PYQ\'s' ? '$subject PYQs' : '$type - $subject by Prof. N.',
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
            if (type == 'PYQ\'s') ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    _buildFilterChip('Mid Sem PYQ\'s'),
                    const SizedBox(width: 12),
                    _buildFilterChip('End Sem PYQ\'s'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
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
                          title: Text(
                            '${subject.toLowerCase()}${_selectedFilter == 'Mid Sem PYQ\'s' ? 'midsem' : 'endsem'}${25 - index}',
                            style: const TextStyle(
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
            ] else
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.files,
                          arguments: {
                            'subject': subject,
                            'type': type,
                            'chapter': 'Chapter ${index + 1}'
                          },
                        );
                      },
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
                                    'Chapter ${index + 1}',
                                    style: const TextStyle(
                                      color: AppTheme.textColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.buttonBg : Colors.white.withAlpha(25),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            Icon(
              Icons.history_edu_outlined,
              color: isSelected ? AppTheme.textColor2 : AppTheme.textColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.textColor2 : AppTheme.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
