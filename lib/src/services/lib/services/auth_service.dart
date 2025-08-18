import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcs_flutter/common/Services/services.dart';
class AuthService {
  final Services _services = Services();

  AuthService() {
    initializeDevNpp(); // Gọi hàm khởi tạo giá trị ban đầu
  }

  Future<void> saveAccessTokenNpp(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

    Future<String?> getAccessTokenNpp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

    Future<void> clearAccessTokenNpp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
  }


  
  Future<void> saveDevNpp(bool currentDevMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('devNpp', currentDevMode);
  }

    Future<bool?> getDevNpp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('devNpp');
  }

    Future<void> clearDevNpp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('devNpp');
  }
  
  Future<void> initializeDevNpp() async {
    final bool? isDevNpp = await getDevNpp();
    SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('devNpp', isDevNpp ?? true); 
    
  }
  
  Future<void> signOut() async {
    await _services.deleteAccessToken();
  }
  Future<String?> getAccessToken() async {
    try {
      final services = await Services.create();
      final token = await services.getAccessToken();
      return token.isEmpty ? null : token;
    } catch (e) {
      print('Error fetching access token: $e');
      return null;
    }
  }
}
