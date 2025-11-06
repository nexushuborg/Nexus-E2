import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_service.dart';

class TokenRefreshInterceptor {
  static ApiService? _apiService;

  static void initialize(ApiService apiService) {
    _apiService = apiService;
  }

  static Future<http.Response> intercept(
    Future<http.Response> Function() requestCallback,
    ApiService apiService,
  ) async {
    try {
      final response = await requestCallback();

      // Check if token expired
      if (response.statusCode == 401) {
        try {
          // Try to parse response body to check for specific error
          final body = json.decode(response.body);
          if (body['message']?.toString().toLowerCase().contains('expired') == true ||
              body['error']?.toString().toLowerCase().contains('expired') == true) {
            // Attempt token refresh
            final refreshResult = await apiService.regenerateAccessToken();
            
            // Verify refresh result has required data
            if (refreshResult != null && 
                refreshResult['accessToken'] != null && 
                refreshResult['accessToken'].toString().isNotEmpty) {
              
              // Set the new token
              await apiService.setAuthToken(refreshResult['accessToken']);
              
              // Retry the original request with new token
              return await requestCallback();
            }
          }
        } catch (e) {
          // Log refresh error but don't throw - return original response
          print('Token refresh failed: $e');
        }
      }
      return response;
    } catch (e) {
      // If the original request fails, propagate the error
      rethrow;
    }
  }
}
