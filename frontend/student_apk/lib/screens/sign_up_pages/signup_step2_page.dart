import 'package:flutter/material.dart';
import '../../routes.dart';
import '../../models/signup_data.dart';
import '../../theme.dart';
import '../../mixins/form_styling_mixin.dart';
import '../../services/api_service.dart';

class SignUpStep2Page extends StatefulWidget {
  final SignupData signupData;

  const SignUpStep2Page({
    super.key,
    required this.signupData,
  });

  @override
  State<SignUpStep2Page> createState() => _SignUpStep2PageState();
}

class _SignUpStep2PageState extends State<SignUpStep2Page>
    with FormStylingMixin {
  final _formKey = GlobalKey<FormState>();
  final _registrationController = TextEditingController();
  String? _selectedDegree;
  String? _selectedYear;
  String? _selectedDepartment;
  final _sectionController = TextEditingController();
  bool _isLoading = false;

  // Define degree options and their corresponding years and graduation offsets
  final Map<String, Map<String, dynamic>> degreeConfig = {
    'BTech': {'years': 4, 'name': 'BTech'},
    'MTech': {'years': 2, 'name': 'MTech'},
    'BCA': {'years': 3, 'name': 'BCA'},
  };

  // Define departments
  final Map<String, List<String>> degreeDepartments = {
    'BTech': ['CSE', 'ECE', 'ME', 'CE', 'EE', 'EEE'],
    'MTech': ['CSE', 'ECE', 'ME', 'CE', 'EE', 'EEE'],
  };

  List<int> _getBatchList(String? degree) {
    if (degree == null) return [];
    return [2026, 2027, 2028, 2029];
  }

  List<String> _getDepartmentsList() {
    if (_selectedDegree == null) return [];
    return degreeDepartments[_selectedDegree!] ?? [];
  }

  bool _showDepartment() {
    return _selectedDegree != null && _selectedDegree != 'BCA';
  }

  @override
  void initState() {
    super.initState();
    print('SignUpStep2Page initState: ${widget.signupData.toJson()}');
    // Pre-populate fields from signupData if coming back from next step
    if (widget.signupData.regNo != null) {
      _registrationController.text = widget.signupData.regNo!;
    }
    if (widget.signupData.degree != null) {
      _selectedDegree = widget.signupData.degree;
    }
    if (widget.signupData.batch != null) {
      _selectedYear = widget.signupData.batch.toString();
    }
    if (widget.signupData.branch != null) {
      _selectedDepartment = widget.signupData.branch;
    }
    if (widget.signupData.slno != null) {
      _sectionController.text = widget.signupData.slno!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button and logo
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 24, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: AppTheme.textColor),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppTheme.textColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'Δ',
                              style: TextStyle(
                                color: AppTheme.backgroundGradientStart,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Form content
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Create Your Profile',
                          style: TextStyle(
                            color: AppTheme.textColor,
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Academic Information',
                          style: TextStyle(
                            color: AppTheme.textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _registrationController,
                          style: inputTextStyle,
                          decoration: getInputDecoration(
                            labelText:
                                'Enter your registration number (e.g., 2023BTCSE00)',
                          ),
                          validator: (value) {
                            print('Validating registration number: $value');
                            if (value == null || value.isEmpty) {
                              return 'Please enter your registration number';
                            }
                            if (!RegExp(r'^\d{4}[A-Z]{2,}[A-Z0-9]+$')
                                .hasMatch(value)) {
                              return 'Please enter a valid registration number format (e.g., 2023BTCSE00)';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            print('Saving registration number: $value');
                            widget.signupData.regNo = value!;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedDegree,
                          style: inputTextStyle,
                          decoration: getInputDecoration(
                            labelText: 'Choose your degree',
                          ),
                          dropdownColor: Colors.white,
                          items: degreeConfig.keys
                              .map((degree) => DropdownMenuItem(
                                    value: degree,
                                    child: Text(
                                      degree,
                                      style: const TextStyle(
                                        color: AppTheme.textColor2,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDegree = value;
                              _selectedYear = null;
                              _selectedDepartment = null;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select your degree';
                            }
                            return null;
                          },
                          onSaved: (value) => widget.signupData.degree = value!,
                        ),
                        const SizedBox(height: 16),
                        if (_selectedDegree != null) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DropdownButtonFormField<String>(
                                value: _selectedYear,
                                style: inputTextStyle,
                                decoration: getInputDecoration(
                                  labelText: 'Choose your batch',
                                ),
                                dropdownColor: Colors.white,
                                items: _getBatchList(_selectedDegree)
                                    .map((year) => DropdownMenuItem(
                                          value: year.toString(),
                                          child: Text(
                                            year.toString(),
                                            style: const TextStyle(
                                              color: AppTheme.textColor2,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedYear = value;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your graduation year';
                                  }
                                  return null;
                                },
                                onSaved: (value) =>
                                    widget.signupData.batch = int.parse(value!),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  'Select the year you will graduate',
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(178),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (_showDepartment()) ...[
                          DropdownButtonFormField<String>(
                            value: _selectedDepartment,
                            style: inputTextStyle,
                            decoration: getInputDecoration(
                              labelText: 'Choose your department',
                            ),
                            dropdownColor: Colors.white,
                            items: _getDepartmentsList()
                                .map((dept) => DropdownMenuItem(
                                      value: dept,
                                      child: Text(
                                        dept,
                                        style: const TextStyle(
                                          color: AppTheme.textColor2,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedDepartment = value;
                              });
                            },
                            validator: (value) {
                              if (_showDepartment() &&
                                  (value == null || value.isEmpty)) {
                                return 'Please select your department';
                              }
                              return null;
                            },
                            onSaved: (value) =>
                                widget.signupData.branch = value,
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextFormField(
                          controller: _sectionController,
                          style: inputTextStyle,
                          decoration: getInputDecoration(
                            labelText: 'Enter your class serial number (1-100)',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your class serial number';
                            }
                            if (!RegExp(r'^\d+$').hasMatch(value)) {
                              return 'Please enter a valid number';
                            }
                            final number = int.parse(value);
                            if (number < 1 || number > 100) {
                              return 'Serial number must be between 1 and 100';
                            }
                            return null;
                          },
                          onSaved: (value) =>
                              widget.signupData.slno = value?.trim(),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _isLoading = true);
                                      _formKey.currentState!.save();
                                      try {
                                        final apiService = ApiService();
                                        print(
                                            'Sending signup data: ${widget.signupData.toJson()}');
                                        final response = await apiService
                                            .signup(widget.signupData.toJson());
                                        print('Signup response: $response');

                                        if (response['success'] == true) {
                                          if (!mounted) return;
                                          Navigator.pushNamed(
                                            context,
                                            Routes.signupStep3,
                                            arguments: widget.signupData,
                                          );
                                        } else {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  response['message'] ??
                                                      'Registration failed'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      } catch (e) {
                                        print('Signup error: $e');
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(e.toString()),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } finally {
                                        if (mounted) {
                                          setState(() => _isLoading = false);
                                        }
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.buttonBg,
                              foregroundColor: AppTheme.textColor2,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppTheme.textColor2),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Next',
                                        style: TextStyle(
                                          color: AppTheme.textColor2,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward, size: 20),
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
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.buttonBg,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            'Step 2 of 3',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
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
        ),
      ),
    );
  }
}
