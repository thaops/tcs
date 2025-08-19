import 'package:get_storage/get_storage.dart';

class Config {
  //https://napro-api.azurewebsites.net/api
  // https://coxe-api.azurewebsites.net/apiz
  // https://namphuong-dev.azurewebsites.net/
  static const String _baseUrlKey = 'base_url';
  // Default URLs
  static const String _defaultProdBaseUrl =
      "https://api-tcs-dev.azurewebsites.net/api";
      // "https://namphuong-api.azurewebsites.net/api";
  static const String _defaultDevBaseUrl =
      "https://namphuong-api-dev.azurewebsites.net/api";

  // Internal helper to compute current default based on awaiting flag
  static String _currentDefaultBaseUrl(GetStorage storage) {
    final bool awaiting = storage.read('awaiting') ?? false;
    return awaiting ? _defaultDevBaseUrl : _defaultProdBaseUrl;
  }

  static String get baseUrl {
    final storage = GetStorage();
    String? savedUrl = storage.read<String>(_baseUrlKey);
    if (savedUrl != null && savedUrl.isNotEmpty) return savedUrl;
    return _currentDefaultBaseUrl(storage);
  }

  static set baseUrl(String url) {
    final storage = GetStorage();
    final String currentDefault = _currentDefaultBaseUrl(storage);
    if (url == currentDefault) {
      storage.remove(_baseUrlKey);
    } else {
      storage.write(_baseUrlKey, url);
    }
  }
}
