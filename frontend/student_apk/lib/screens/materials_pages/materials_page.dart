import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../routes.dart';
import '../../services/api_service.dart';

class MaterialsPage extends StatefulWidget {
  const MaterialsPage({super.key});

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _subjects = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSubjects();
  }

  Future<void> _fetchSubjects() async {
    try {
      final apiService = ApiService();
      final response = await apiService.getAllSubjects();
      setState(() {
        _subjects = List<Map<String, dynamic>>.from(response['subjects']);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
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
                _fetchSubjects();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchSubjects,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _subjects.length,
        itemBuilder: (context, index) {
          final subject = _subjects[index];
          return _SubjectCard(
            subjectName: subject['subjectName'] ?? '',
            subjectCode: subject['subjectCode'] ?? '',
            onTap: () => Navigator.pushNamed(
              context,
              Routes.chapterPage,
              arguments: {
                'subjectId': subject['subjectId'],
                'subjectName': subject['subjectName'],
              },
            ),
          );
        },
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final String subjectName;
  final String subjectCode;
  final VoidCallback onTap;

  const _SubjectCard({
    required this.subjectName,
    required this.subjectCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.cardGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.withOpacity(Colors.black, 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              subjectName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subjectCode,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.withOpacity(Colors.grey[600]!, 1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
