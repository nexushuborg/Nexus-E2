import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_apk/routes.dart';
import 'package:student_apk/services/api_service.dart';
import 'package:student_apk/theme.dart';

class SubjectContentPage extends StatefulWidget {
  const SubjectContentPage({super.key});

  @override
  State<SubjectContentPage> createState() => _SubjectContentPageState();
}

class _SubjectContentPageState extends State<SubjectContentPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _notes = [];
  String? _error;
  final Map<String, bool> _downloadingFiles = {};
  String _selectedFilter = 'Mid Sem PYQ\'s';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _fetchNotes(args['subjectId']);
    });
  }

  Future<void> _fetchNotes(String subjectId) async {
    try {
      final apiService = ApiService();
      final response = await apiService.getSubjectNotes(subjectId: subjectId);
      setState(() {
        _notes = List<Map<String, dynamic>>.from(response['notes']);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadFile(String fileId, String fileName) async {
    setState(() {
      _downloadingFiles[fileId] = true;
    });

    try {
      final apiService = ApiService();
      await apiService.downloadNote(noteId: fileId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Downloaded: $fileName')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _downloadingFiles[fileId] = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(args['subjectName'])),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text(args['subjectName'])),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: $_error',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _fetchNotes(args['subjectId']),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // If it's Project type, directly navigate to files page
    if (args['type'] == 'Project') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(
          context,
          Routes.files,
          arguments: {
            'subject': args['subjectName'],
            'type': args['type'],
            'chapter': 'Project Files'
          },
        );
      });
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(args['subjectName']),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _fetchNotes(args['subjectId']),
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
                color: AppTheme.withOpacity(Colors.white, 0.1),
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
                        hintStyle: TextStyle(
                          color: AppTheme.withOpacity(AppTheme.textColor, 0.5),
                        ),
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
          if (args['type'] == 'PYQ\'s') ...[
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
                        color: AppTheme.withOpacity(Colors.white, 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.withOpacity(AppTheme.buttonBg, 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.picture_as_pdf,
                              color: AppTheme.buttonBg),
                        ),
                        title: Text(
                          '${args['subjectName'].toLowerCase()}${_selectedFilter == 'Mid Sem PYQ\'s' ? 'midsem' : 'endsem'}${25 - index}',
                          style: const TextStyle(
                            color: AppTheme.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          '50 likes • 2hr ago',
                          style: TextStyle(
                            color: AppTheme.withOpacity(AppTheme.textColor, 0.5),
                            fontSize: 12,
                          ),
                        ),
                        trailing: const Icon(Icons.download,
                            color: AppTheme.textColor),
                      ),
                    ),
                  );
                },
              ),
            ),
          ] else
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  final note = _notes[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ExpansionTile(
                      title: Text(note['title'] ?? 'Untitled Note'),
                      subtitle: Text(
                        'Chapter ${note['chapterNo']}: ${note['chapterName']}',
                        style: TextStyle(
                          color: AppTheme.withOpacity(Colors.grey[600]!, 1.0),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(note['description'] ?? 'No description'),
                              const Divider(),
                              ...(note['files'] as List).map((file) {
                                final fileId = file['file_id'];
                                final isDownloading =
                                    _downloadingFiles[fileId] ?? false;
                                return ListTile(
                                  leading:
                                      Icon(_getFileIcon(file['mime_type'])),
                                  title: Text(file['original_name']),
                                  subtitle: Text(
                                    '${_formatFileSize(file['file_size'])} • ${DateFormat('MMM d, yyyy').format(DateTime.parse(file['created_at']))}',
                                  ),
                                  trailing: IconButton(
                                    icon: isDownloading
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                                strokeWidth: 2),
                                          )
                                        : const Icon(Icons.download),
                                    onPressed: isDownloading
                                        ? null
                                        : () => _downloadFile(
                                            fileId, file['original_name']),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ],
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
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.buttonBg
              : AppTheme.withOpacity(Colors.white, 0.1),
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

  IconData _getFileIcon(String? mimeType) {
    if (mimeType == null) return Icons.insert_drive_file;
    if (mimeType.startsWith('image/')) return Icons.image;
    if (mimeType.contains('pdf')) return Icons.picture_as_pdf;
    if (mimeType.contains('word')) return Icons.description;
    if (mimeType.contains('presentation')) return Icons.slideshow;
    return Icons.insert_drive_file;
  }

  String _formatFileSize(dynamic size) {
    if (size is String) {
      return size;
    }
    if (size is! num) return 'Unknown size';
    const units = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double fileSize = size.toDouble();
    while (fileSize >= 1024 && i < units.length - 1) {
      fileSize /= 1024;
      i++;
    }
    return '${fileSize.toStringAsFixed(1)} ${units[i]}';
  }
}
