import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1/student';
  static const String _tokenKey = 'auth_token';
  String? _accessToken;

  Future<void> setAuthToken(String token) async {
    _accessToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Headers with authorization
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  // Auth methods
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> signup(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-auth-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> resendOtp({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/resend-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return jsonDecode(response.body);
  }

  // Password reset methods
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password/request'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> forgotPasswordResendOtp({
    required String email,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password/resend-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> verifyForgotPasswordOtp({
    required String email,
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> resetPassword({
    required String newPassword,
    required String resetToken,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'new_password': newPassword,
        'reset_token': resetToken,
      }),
    );
    return jsonDecode(response.body);
  }

  // Profile methods
  Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> uploadProfileImage(File image) async {
    final request = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl/profile/upload-image'));
    request.headers.addAll(_headers);
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return jsonDecode(response.body);
  }

  // Student ID methods
  Future<Map<String, dynamic>> uploadStudentId(File idCard) async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/student/upload-id'));
    request.headers.addAll(_headers);
    request.files
        .add(await http.MultipartFile.fromPath('id_card', idCard.path));
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return jsonDecode(response.body);
  }

  // Subject methods
  Future<Map<String, dynamic>> getAllSubjects() async {
    final response = await http.get(
      Uri.parse('$baseUrl/subjects'),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getSubjectNotes({
    required String subjectId,
    String? category,
  }) async {
    final uri = Uri.parse('$baseUrl/subjects/$subjectId/notes').replace(
      queryParameters: category != null ? {'category': category} : null,
    );
    final response = await http.get(uri, headers: _headers);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> downloadNote({
    required String noteId,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notes/$noteId/download'),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }

  // Auth status methods
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    _accessToken = null;
  }

  Future<void> logoutAll() async {
    await http.post(
      Uri.parse('$baseUrl/auth/logout-all'),
      headers: _headers,
    );
    await logout();
  }

  // Password change methods
  Future<Map<String, dynamic>> requestPasswordReset() async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/request-password-reset'),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> verifyPasswordResetOtp({
    required String otp,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-password-reset-otp'),
      headers: _headers,
      body: jsonEncode({'otp': otp}),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> completePasswordReset({
    required String newPassword,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/complete-password-reset'),
      headers: _headers,
      body: jsonEncode({'new_password': newPassword}),
    );
    return jsonDecode(response.body);
  }

  Future regenerateAccessToken() async {}
}
