import 'package:tcs_flutter/src/Api/models/apiResponse_model.dart';

abstract class AuthRepositoryInterface {
  Future<ApiResponse> loginWithGoogle(String token);
  Future<ApiResponse> loginWithMicrosoft(String code);
  Future<ApiResponse> loginWithFramework(String username, String password);
  Future<String?> fetchMicrosoftRedirectUrl();
  Future<void> saveAccessToken(String token);
}