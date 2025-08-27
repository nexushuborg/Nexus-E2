import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:8000';

  static Future<http.Response> signupStep1({required String fullName}) async {
    final url = Uri.parse('$baseUrl/api/teacher/signup/step1');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'fullName': fullName}),
    );
    return response;
  }

  static Future<http.Response> signupStep1Full({
    required String fullName,
    required String gender,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/api/teacher/signup/step1');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'gender': gender,
        'email': email,
        'password': password,
      }),
    );
    return response;
  }

  // Register teacher
  static Future<http.Response> registerTeacher({
    required String fullName,
    required String email,
    required String password,
    required String designation,
    required String gender,
    required List<String> departments,
    required List<String> subjects,
    required List<String> sections,
  }) async {
    final url = Uri.parse('$baseUrl/api/teacher/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        'email': email,
        'password': password,
        'designation': designation,
        'gender': gender,
        'departments': departments,
        'subjects': subjects,
        'sections': sections,
      }),
    );
    return response;
  }

  // Verify OTP
  static Future<http.Response> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final url = Uri.parse('$baseUrl/api/teacher/verify-auth-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
      }),
    );
    return response;
  }

  // Resend OTP
  static Future<http.Response> resendOtp({
    required String email,
  }) async {
    final url = Uri.parse('$baseUrl/api/teacher/resend-auth-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return response;
  }

  // Fetch departments and subjects
  static Future<http.Response> getDepartmentsAndSubjects() async {
    final url = Uri.parse('$baseUrl/api/teacher/get-all-subjects-and-department');
    return await http.get(url);
  }

  // Fetch sections
  static Future<http.Response> getSections() async {
    final url = Uri.parse('$baseUrl/api/teacher/get-all-sections');
    return await http.get(url);
  }
}
