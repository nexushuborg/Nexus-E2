import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../services/api_service.dart';
import '../../widgets/glass_frame.dart';
import 'package:intl/intl.dart';

class LabWorkPage extends StatefulWidget {
  const LabWorkPage({super.key});

  @override
  State<LabWorkPage> createState() => _LabWorkPageState();
}

class _LabWorkPageState extends State<LabWorkPage> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _labWork = [];
  String? _subjectId;
  String? _subjectName;
  final Map<String, bool> _downloadingStatus = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _subjectId = args['subjectId'];
          _subjectName = args['subjectName'];
        });
        _fetchLabWork();
      }
    });
  }

  Future<void> _fetchLabWork() async {
    if (_subjectId == null) return;

    try {
      final apiService = ApiService();
      final response = await apiService.getSubjectNotes(
        subjectId: _subjectId!,
        category: 'lab',
      );
      setState(() {
        _labWork = List<Map<String, dynamic>>.from(response['notes']);
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
    setState(() => _downloadingStatus[fileId] = true);
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
        SnackBar(content: Text('Download failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => _downloadingStatus[fileId] = false);
      }
    }
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
                onPressed: _fetchLabWork,
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
          title: Text('$_subjectName Lab Work'),
        ),
        body: _labWork.isEmpty
            ? const Center(
                child: Text(
                  'No lab work available',
                  style: TextStyle(color: AppTheme.textColor),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _labWork.length,
                itemBuilder: (context, index) {
                  final lab = _labWork[index];
                  return GlassFrame(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ExpansionTile(
                      title: Text(
                        'Lab ${index + 1}: ${lab['title'] ?? 'Untitled Lab'}',
                        style: const TextStyle(
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('MMM d, yyyy')
                            .format(DateTime.parse(lab['createdAt'])),
                        style: TextStyle(
                          color: AppTheme.withOpacity(AppTheme.textColor, 0.7),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lab['description'] ?? 'No description',
                                style:
                                    const TextStyle(color: AppTheme.textColor),
                              ),
                              const Divider(color: AppTheme.textColor),
                              ...(lab['files'] as List).map((file) {
                                final fileId = file['file_id'];
                                final isDownloading =
                                    _downloadingStatus[fileId] ?? false;

                                return ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppTheme.withOpacity(
                                          AppTheme.buttonBg, 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _getFileIcon(file['mime_type']),
                                      color: AppTheme.buttonBg,
                                    ),
                                  ),
                                  title: Text(
                                    file['original_name'],
                                    style: const TextStyle(
                                      color: AppTheme.textColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${_formatFileSize(file['file_size'])} • ${DateFormat('MMM d, yyyy').format(DateTime.parse(file['created_at']))}',
                                    style: TextStyle(
                                      color: AppTheme.withOpacity(
                                          AppTheme.textColor, 0.7),
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: isDownloading
                                        ? const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      AppTheme.textColor),
                                            ),
                                          )
                                        : const Icon(Icons.download,
                                            color: AppTheme.textColor),
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
