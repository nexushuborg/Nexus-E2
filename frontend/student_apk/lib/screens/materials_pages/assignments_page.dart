import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../services/api_service.dart';
import '../../widgets/glass_frame.dart';
import 'package:intl/intl.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  State<AssignmentsPage> createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _assignments = [];
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
        _fetchAssignments();
      }
    });
  }

  Future<void> _fetchAssignments() async {
    if (_subjectId == null) return;

    try {
      final apiService = ApiService();
      final response = await apiService.getSubjectNotes(
        subjectId: _subjectId!,
        category: 'assignment',
      );
      setState(() {
        _assignments = List<Map<String, dynamic>>.from(response['notes']);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadAssignment(String fileId, String fileName) async {
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
                onPressed: _fetchAssignments,
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
          title: Text('$_subjectName Assignments'),
        ),
        body: _assignments.isEmpty
            ? const Center(
                child: Text(
                  'No assignments available',
                  style: TextStyle(color: AppTheme.textColor),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _assignments.length,
                itemBuilder: (context, index) {
                  final assignment = _assignments[index];
                  return GlassFrame(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ExpansionTile(
                      title: Text(
                        assignment['title'] ?? 'Untitled Assignment',
                        style: const TextStyle(
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Due: ${_formatDate(assignment['dueDate'])}',
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
                                assignment['description'] ?? 'No description',
                                style:
                                    const TextStyle(color: AppTheme.textColor),
                              ),
                              const Divider(color: AppTheme.textColor),
                              ...(assignment['files'] as List).map((file) {
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
                                        : () => _downloadAssignment(
                                            fileId, file['original_name']),
                                  ),
                                );
                              }).toList(),
                              if (assignment['submissionDeadline'] != null) ...[
                                const Divider(color: AppTheme.textColor),
                                ListTile(
                                  leading: const Icon(Icons.timer,
                                      color: AppTheme.buttonBg),
                                  title: const Text(
                                    'Submission Deadline',
                                    style: TextStyle(color: AppTheme.textColor),
                                  ),
                                  subtitle: Text(
                                    _formatDate(
                                        assignment['submissionDeadline']),
                                    style: TextStyle(
                                      color: AppTheme.withOpacity(
                                          AppTheme.textColor, 0.7),
                                    ),
                                  ),
                                ),
                              ],
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

  String _formatDate(String? date) {
    if (date == null) return 'No deadline set';
    try {
      final dateTime = DateTime.parse(date);
      return DateFormat('MMM d, yyyy').format(dateTime);
    } catch (e) {
      return 'Invalid date';
    }
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
