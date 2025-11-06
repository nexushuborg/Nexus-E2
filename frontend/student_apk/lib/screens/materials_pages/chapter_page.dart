import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../services/api_service.dart';
import '../../widgets/glass_frame.dart';
import 'package:intl/intl.dart';

class ChapterPage extends StatefulWidget {
  const ChapterPage({super.key});

  @override
  State<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _chapters = [];
  late TabController _tabController;
  String? _subjectId;
  String? _subjectName;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _subjectId = args['subjectId'];
          _subjectName = args['subjectName'];
        });
        _fetchChapters();
      }
    });
  }

  Future<void> _fetchChapters() async {
    if (_subjectId == null) return;

    try {
      final apiService = ApiService();
      final response = await apiService.getSubjectNotes(
        subjectId: _subjectId!,
      );
      setState(() {
        _chapters = List<Map<String, dynamic>>.from(response['notes']);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadNote(String fileId, String fileName) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Starting download...')),
      );
      final apiService = ApiService();
      await apiService.downloadNote(noteId: fileId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Downloaded: $fileName')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
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
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _error = null;
                  });
                  _fetchChapters();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(_subjectName ?? 'Subject Notes'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Notes'),
              Tab(text: 'Assignments'),
              Tab(text: 'PYQs'),
              Tab(text: 'Lab Work'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildNotesList('notes'),
            _buildNotesList('assignment'),
            _buildNotesList('pyq'),
            _buildNotesList('lab'),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesList(String category) {
    final categoryNotes =
        _chapters.where((note) => note['category'] == category).toList();

    if (categoryNotes.isEmpty) {
      return const Center(
        child: Text(
          'No materials available',
          style: TextStyle(color: AppTheme.textColor),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: categoryNotes.length,
      itemBuilder: (context, index) {
        final note = categoryNotes[index];
        return GlassFrame(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            title: Text(
              note['title'] ?? 'Untitled Note',
              style: const TextStyle(color: AppTheme.textColor),
            ),
            subtitle: Text(
              'Chapter ${note['chapterNo']}: ${note['chapterName']}',
              style: TextStyle(
                  color: AppTheme.withOpacity(AppTheme.textColor, 0.7)),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note['description'] ?? 'No description',
                      style: const TextStyle(color: AppTheme.textColor),
                    ),
                    const Divider(color: AppTheme.textColor),
                    ...(note['files'] as List).map((file) => ListTile(
                          leading: Icon(
                            _getFileIcon(file['mime_type']),
                            color: AppTheme.textColor,
                          ),
                          title: Text(
                            file['original_name'],
                            style: const TextStyle(color: AppTheme.textColor),
                          ),
                          subtitle: Text(
                            '${_formatFileSize(file['file_size'])} • ${DateFormat('MMM d, yyyy').format(DateTime.parse(file['created_at']))}',
                            style: TextStyle(
                                color: AppTheme.withOpacity(
                                    AppTheme.textColor, 0.7)),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.download,
                                color: AppTheme.textColor),
                            onPressed: () => _downloadNote(
                                file['file_id'], file['original_name']),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
    if (size is String) return size;
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
