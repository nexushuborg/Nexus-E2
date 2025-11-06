import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../services/api_service.dart';
import '../../widgets/glass_frame.dart';
import 'package:intl/intl.dart';

class PyqsPage extends StatefulWidget {
  const PyqsPage({super.key});

  @override
  State<PyqsPage> createState() => _PyqsPageState();
}

class _PyqsPageState extends State<PyqsPage> {
  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _pyqs = [];
  String? _subjectId;
  String? _subjectName;
  String _selectedCategory = 'Mid Sem';
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
        _fetchPyqs();
      }
    });
  }

  Future<void> _fetchPyqs() async {
    if (_subjectId == null) return;

    try {
      final apiService = ApiService();
      final response = await apiService.getSubjectNotes(
        subjectId: _subjectId!,
        category: 'pyq',
      );
      setState(() {
        _pyqs = List<Map<String, dynamic>>.from(response['notes']);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadPyq(String fileId, String fileName) async {
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
                onPressed: _fetchPyqs,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final filteredPyqs = _pyqs
        .where((pyq) =>
            pyq['examType']?.toLowerCase() == _selectedCategory.toLowerCase())
        .toList();

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('$_subjectName PYQs'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFilterChip('Mid Sem'),
                  _buildFilterChip('End Sem'),
                ],
              ),
            ),
            Expanded(
              child: filteredPyqs.isEmpty
                  ? const Center(
                      child: Text(
                        'No PYQs available',
                        style: TextStyle(color: AppTheme.textColor),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredPyqs.length,
                      itemBuilder: (context, index) {
                        final pyq = filteredPyqs[index];
                        final file = (pyq['files'] as List).first;
                        final fileId = file['file_id'];
                        final isDownloading =
                            _downloadingStatus[fileId] ?? false;

                        return GlassFrame(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: ListTile(
                            title: Text(
                              pyq['title'] ?? 'Untitled PYQ',
                              style: const TextStyle(
                                color: AppTheme.textColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('MMM d, yyyy')
                                      .format(DateTime.parse(pyq['createdAt'])),
                                  style: TextStyle(
                                    color: AppTheme.withOpacity(
                                        AppTheme.textColor, 0.7),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  pyq['description'] ?? 'No description',
                                  style: TextStyle(
                                    color: AppTheme.withOpacity(
                                        AppTheme.textColor, 0.7),
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isDownloading
                                    ? Icons.hourglass_empty
                                    : Icons.download,
                                color: AppTheme.textColor,
                              ),
                              onPressed: isDownloading
                                  ? null
                                  : () =>
                                      _downloadPyq(fileId, file['file_name']),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedCategory == label;
    return InkWell(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.buttonBg
              : AppTheme.withOpacity(Colors.white, 0.1),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          children: [
            Icon(
              Icons.history_edu,
              color: isSelected ? AppTheme.textColor2 : AppTheme.textColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppTheme.textColor2 : AppTheme.textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
