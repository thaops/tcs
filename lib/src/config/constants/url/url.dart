import 'package:tcs_flutter/src/services/lib/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/Services/config.dart';


class BaseUrlProvider {
    Future<bool?> getDevNpp() async {
    final authService = AuthService();
    return await authService.getDevNpp();
  }
  static Future<String> getBaseUrl(BuildContext context) async {
    // Delegate to Config.baseUrl which already encapsulates awaiting/default logic
    return Config.baseUrl;
  }
}
