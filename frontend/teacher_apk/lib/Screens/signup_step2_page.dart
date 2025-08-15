// Sign Up Step 2: Academic Information
import 'package:flutter/material.dart';
import '../theme.dart';

class SignUpStep2Page extends StatefulWidget {
  const SignUpStep2Page({super.key});

  @override
  State<SignUpStep2Page> createState() => _SignUpStep2PageState();
}

class _SignUpStep2PageState extends State<SignUpStep2Page> {
  String? _department;
  String? _designation;
  final List<String> _sections = [];

  // State variables for the dialog
  String? _selectedDegree;
  String? _selectedYear;

  // Dummy data for dependent dropdowns/fields
  final Map<String, List<String>> _yearsForDegree = {
    'B.Tech': ['1st', '2nd', '3rd', '4th'],
    'M.Tech': ['1st', '2nd'],
    'PhD': ['1st', '2nd', '3rd', '4th', '5th'],
  };

  final Map<String, Map<String, List<String>>> _sectionsForYear = {
    'B.Tech': {
      '1st': ['A', 'B', 'C', 'C2', 'C3'],
      '2nd': ['D', 'E', 'F', 'D1'],
      '3rd': ['G', 'H', 'I'],
      '4th': ['J', 'K', 'L'],
    },
    'M.Tech': {
      '1st': ['M', 'N'],
      '2nd': ['O', 'P'],
    },
    'PhD': {
      '1st': ['Q', 'R', 'R1'],
      '2nd': ['S', 'T'],
      '3rd': ['U', 'V'],
      '4th': ['W', 'X'],
      '5th': ['Y', 'Z'],
    }
  };

   final Map<String, Map<String, Map<String, List<String>>>> _subjectsForSection = {
    'B.Tech': {
      '1st': {
        'A': ['Maths-1', 'Physics-1', 'Chemistry-1'],
        'B': ['Maths-1', 'Physics-1', 'Chemistry-1'],
        'C': ['Maths-1', 'Physics-1', 'Chemistry-1'],
        'C2': ['Maths-1', 'Physics-1', 'Chemistry-1'],
        'C3': ['Maths-1', 'Physics-1', 'Chemistry-1'],
      },
      '2nd': {
        'D': ['Maths-2', 'Physics-2', 'Chemistry-2'],
        'E': ['Maths-2', 'Physics-2', 'Chemistry-2'],
        'F': ['Maths-2', 'Physics-2', 'Chemistry-2'],
        'D1': ['Maths-2', 'Physics-2', 'Chemistry-2'],
      },
       '3rd': {
        'G': ['DBMS', 'OS', 'CN'],
        'H': ['DBMS', 'OS', 'CN'],
        'I': ['DBMS', 'OS', 'CN'],
      },
      '4th': {
        'J': ['AI', 'ML', 'Cloud'],
        'K': ['AI', 'ML', 'Cloud'],
        'L': ['AI', 'ML', 'Cloud'],
      },
    },
     'M.Tech': {
      '1st': {
        'M': ['Advanced Algo', 'Advanced OS'],
        'N': ['Advanced Algo', 'Advanced OS'],
      },
      '2nd': {
        'O': ['Research Methodologies', 'Thesis'],
        'P': ['Research Methodologies', 'Thesis'],
      },
    },
     'PhD': {
      '1st': {
        'Q': ['Advanced Research Topics 1'],
        'R': ['Advanced Research Topics 1'],
        'R1': ['Advanced Research Topics 1'],
      },
      '2nd': {
        'S': ['Advanced Research Topics 2'],
        'T': ['Advanced Research Topics 2'],
      },
       '3rd': {
        'U': ['Advanced Research Topics 3'],
        'V': ['Advanced Research Topics 3'],
      },
       '4th': {
        'W': ['Advanced Research Topics 4'],
        'X': ['Advanced Research Topics 4'],
      },
       '5th': {
        'Y': ['Thesis Submission'],
        'Z': ['Thesis Submission'],
      },
    }
  };


  void _showAddSectionDialog() {
    _selectedDegree = null;
    _selectedYear = null;
    String? dialogSelectedSection;
    String? dialogSelectedSubject;

    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(128),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            List<String> currentYears = _selectedDegree != null ? _yearsForDegree[_selectedDegree!] ?? [] : [];
            if (_selectedDegree == null || !currentYears.contains(_selectedYear)) {
               _selectedYear = null;
               dialogSelectedSection = null;
               dialogSelectedSubject = null;
            }

            List<String> currentSectionsList = [];
            if (_selectedDegree != null && _selectedYear != null) {
              currentSectionsList = _sectionsForYear[_selectedDegree!]?[_selectedYear!] ?? [];
            }
            if (_selectedYear == null || !currentSectionsList.contains(dialogSelectedSection)) {
                dialogSelectedSection = null;
                dialogSelectedSubject = null;
            }
            
            List<String> currentSubjectsList = [];
            if (_selectedDegree != null && _selectedYear != null && dialogSelectedSection != null) {
                 currentSubjectsList = _subjectsForSection[_selectedDegree!]?[_selectedYear!]?[dialogSelectedSection!] ?? [];
            }
            if (dialogSelectedSection == null || !currentSubjectsList.contains(dialogSelectedSubject)) {
                dialogSelectedSubject = null;
            }

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Section',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text('Degree', style: TextStyle(color: Colors.grey[600])),
                          value: _selectedDegree,
                          items: ['B.Tech', 'M.Tech', 'PhD']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (value) {
                            setStateDialog(() {
                              _selectedDegree = value;
                              _selectedYear = null; 
                              dialogSelectedSection = null;
                              dialogSelectedSubject = null;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: _selectedDegree == null ? Colors.grey[300] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text('Year', style: TextStyle(color: Colors.grey[600])),
                          value: _selectedYear,
                          items: currentYears
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: _selectedDegree == null ? null : (value) {
                            setStateDialog(() {
                              _selectedYear = value;
                              dialogSelectedSection = null;
                              dialogSelectedSubject = null;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: _selectedYear == null ? Colors.grey[300] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          hint: Text('Section', style: TextStyle(color: Colors.grey[600])),
                          value: dialogSelectedSection,
                          items: currentSectionsList
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: _selectedYear == null ? null : (value) {
                            setStateDialog(() {
                              dialogSelectedSection = value;
                              dialogSelectedSubject = null;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: dialogSelectedSection == null ? Colors.grey[300] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            isExpanded: true,
                            hint: Text('Subject', style: TextStyle(color: Colors.grey[600])),
                            value: dialogSelectedSubject,
                            items: currentSubjectsList
                                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                .toList(),
                            onChanged: dialogSelectedSection == null || currentSubjectsList.isEmpty
                                ? null
                                : (value) {
                                    if (value != null) {
                                       setStateDialog(() => dialogSelectedSubject = value);
                                    }
                                  },
                         ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: (_selectedDegree != null &&
                                _selectedYear != null &&
                                dialogSelectedSection != null &&
                                dialogSelectedSubject != null)
                            ? () {
                                setState(() {
                                  _sections.add('$_selectedDegree - $_selectedYear - $dialogSelectedSection - $dialogSelectedSubject');
                                });
                                Navigator.pop(context);
                              }
                            : null, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          disabledBackgroundColor: Colors.grey[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

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
              // Top Bar
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

              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32), // Original padding
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Part 1: Form Content
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

                                // Department Dropdown
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
                                      value: _department,
                                      items: ['CSE', 'ECE', 'ME', 'CE', 'EE']
                                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                          .toList(),
                                      onChanged: (value) => setState(() => _department = value),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Designation Dropdown
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
                                      value: _designation,
                                      items: ['Professor', 'Assistant Professor', 'Lecturer']
                                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                                          .toList(),
                                      onChanged: (value) => setState(() => _designation = value),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Add Sections
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
                                      onPressed: _showAddSectionDialog,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Section Chips
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: _sections.map((section) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          section,
                                          style: TextStyle(
                                            color: AppTheme.primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        GestureDetector(
                                          onTap: () => setState(() => _sections.remove(section)),
                                          child: Icon(
                                            Icons.close,
                                            size: 18,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )).toList(),
                                ),
                              ],
                            ),
                            // Part 2: Button and Indicator
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: () => Navigator.pushNamed(context, 'signupStep3'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Row(
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
                                // Step Indicator
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
