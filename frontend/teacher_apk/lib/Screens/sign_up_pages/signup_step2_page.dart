// ================== Imports ==================
import 'package:flutter/material.dart';
import 'package:teacher_apk/theme.dart';
import 'dart:convert';
import '../../models/signup_data.dart';
import '../../services/api_service.dart';

// ================== Sign Up Step 2 Page ==================
class SignUpStep2Page extends StatefulWidget {
  const SignUpStep2Page({super.key});

  @override
  State<SignUpStep2Page> createState() => _SignUpStep2PageState();
}

class _SignUpStep2PageState extends State<SignUpStep2Page> {
  SignupData? signupData;
  bool _isLoading = false;
  List<Map<String, dynamic>> _departments = [];
  List<Map<String, dynamic>> _subjects = [];
  List<Map<String, dynamic>> _sections = [];
  String? _selectedDepartmentId;
  String? _selectedDesignation;
  List<String> _selectedSectionIds = [];
  List<String> _selectedSubjectIds = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    signupData = ModalRoute.of(context)?.settings.arguments as SignupData?;
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() { _isLoading = true; });
    final deptSubRes = await ApiService.getDepartmentsAndSubjects();
    final sectionRes = await ApiService.getSections();
    if (deptSubRes.statusCode == 200 && sectionRes.statusCode == 200) {
      final deptSubData = Map<String, dynamic>.from(jsonDecode(deptSubRes.body)['data']);
      final sectionData = List<Map<String, dynamic>>.from(jsonDecode(sectionRes.body)['data']['sections']);
      setState(() {
        _departments = List<Map<String, dynamic>>.from(deptSubData['departments']);
        _subjects = List<Map<String, dynamic>>.from(deptSubData['subjects']);
        _sections = sectionData;
      });
    }
    setState(() { _isLoading = false; });
  }

  Future<void> _submit() async {
    if (_selectedDepartmentId == null || _selectedDesignation == null || _selectedSectionIds.isEmpty || _selectedSubjectIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select all academic fields.')),
      );
      return;
    }
    signupData?.designation = _selectedDesignation;
    signupData?.departments = [_selectedDepartmentId!];
    signupData?.sections = _selectedSectionIds;
    signupData?.subjects = _selectedSubjectIds;
    setState(() { _isLoading = true; });
    final response = await ApiService.registerTeacher(
      fullName: signupData!.fullName!,
      email: signupData!.email!,
      password: signupData!.password!,
      designation: signupData!.designation!,
      gender: signupData!.gender!,
      departments: signupData!.departments,
      subjects: signupData!.subjects,
      sections: signupData!.sections,
    );
    setState(() { _isLoading = false; });
    if (response.statusCode == 201) {
      Navigator.pushNamed(context, 'signupStep3', arguments: signupData!.email);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ' + response.body)),
      );
    }
  }

  // ================== Build Method ==================
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.backgroundGradientStart, AppTheme.backgroundGradientEnd],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // ================== Top Bar ==================
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 24, 0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppTheme.primaryColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              // ================== Form & Stepper ==================
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // ================== Form Content ==================
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create Your Profile',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'Academic Information',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text('Choose your department', style: TextStyle(color: Colors.grey[600])),
                                      value: _selectedDepartmentId,
                                      items: _departments.map((dept) {
                                        return DropdownMenuItem<String>(
                                          value: dept['id'].toString(),
                                          child: Text(dept['name']),
                                        );
                                      }).toList(),
                                      onChanged: (value) => setState(() => _selectedDepartmentId = value),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isExpanded: true,
                                      hint: Text('Designation', style: TextStyle(color: Colors.grey[600])),
                                      value: _selectedDesignation,
                                      items: ['Professor', 'Assistant Professor', 'Lecturer']
                                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                          .toList(),
                                      onChanged: (value) => setState(() => _selectedDesignation = value),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Add sections',
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add_circle, color: AppTheme.primaryColor),
                                      onPressed: () {
                                        // TODO: Implement section addition
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _sections.map((section) {
                                    final isSelected = _selectedSectionIds.contains(section['id'].toString());
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            _selectedSectionIds.remove(section['id'].toString());
                                          } else {
                                            _selectedSectionIds.add(section['id'].toString());
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected ? AppTheme.primaryColor : Colors.white,
                                          borderRadius: BorderRadius.circular(24),
                                          border: isSelected ? null : Border.all(color: Colors.grey[300]!),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              section['name'],
                                              style: TextStyle(
                                                color: isSelected ? Colors.white : AppTheme.primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            if (isSelected)
                                              Icon(
                                                Icons.check,
                                                size: 18,
                                                color: Colors.white,
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _subjects.map((subject) {
                                    final isSelected = _selectedSubjectIds.contains(subject['id'].toString());
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            _selectedSubjectIds.remove(subject['id'].toString());
                                          } else {
                                            _selectedSubjectIds.add(subject['id'].toString());
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected ? AppTheme.primaryColor : Colors.white,
                                          borderRadius: BorderRadius.circular(24),
                                          border: isSelected ? null : Border.all(color: Colors.grey[300]!),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              subject['name'],
                                              style: TextStyle(
                                                color: isSelected ? Colors.white : AppTheme.primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            if (isSelected)
                                              Icon(
                                                Icons.check,
                                                size: 18,
                                                color: Colors.white,
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            // ================== Button and Step Indicator ==================
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: _isLoading
                                        ? CircularProgressIndicator(color: Colors.white)
                                        : Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Text(
                                                'Next',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Icon(Icons.arrow_forward, color: Colors.white),
                                            ],
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Step 2 of 3',
                                  style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
