import 'package:flutter/foundation.dart';

/// Utility class để log API calls một cách tập trung
class ApiLogger {
  static void logApiCall({
    required String apiName,
    required String url,
    required String method,
    Map<String, dynamic>? requestData,
    Map<String, dynamic>? queryParams,
    List<String>? attachmentFiles,
    String? leaveId,
    String? userId,
  }) {
    if (kDebugMode) {
      debugPrint('=== $apiName API CALL ===');
      debugPrint('URL: $url');
      debugPrint('Method: $method');

      if (leaveId != null) debugPrint('Leave ID: $leaveId');
      if (userId != null) debugPrint('User ID: $userId');
      if (requestData != null) debugPrint('Request Data: $requestData');
      if (queryParams != null) debugPrint('Query Params: $queryParams');
      if (attachmentFiles != null)
        debugPrint('Attachment Files: ${attachmentFiles.length}');

      debugPrint('${'=' * (apiName.length + 15)}');
    }
  }

  static void logApiResponse({
    required String apiName,
    required int statusCode,
    required dynamic responseData,
    String? errorMessage,
  }) {
    if (kDebugMode) {
      debugPrint('=== $apiName API RESPONSE ===');
      debugPrint('Status Code: $statusCode');

      if (errorMessage != null) {
        debugPrint('Error: $errorMessage');
      } else {
        debugPrint('Response Data: $responseData');
      }

      debugPrint('${'=' * (apiName.length + 18)}');
    }
  }

  static void logApiError({
    required String apiName,
    required String error,
    String? url,
    String? method,
  }) {
    if (kDebugMode) {
      debugPrint('=== $apiName API ERROR ===');
      if (url != null) debugPrint('URL: $url');
      if (method != null) debugPrint('Method: $method');
      debugPrint('Error: $error');
      debugPrint('${'=' * (apiName.length + 12)}');
    }
  }
}
