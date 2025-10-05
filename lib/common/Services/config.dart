import 'package:get_storage/get_storage.dart';

class Config {
  //https://napro-api.azurewebsites.net/api
  // https://coxe-api.azurewebsites.net/apiz
  // https://namphuong-dev.azurewebsites.net/
  static const String _baseUrlKey = 'base_url';
  static const String _manualEnvKey = 'manual_environment_set';
  // Default URLs
  static const String _defaultProdBaseUrl =
      "https://api-tcs-uat.azurewebsites.net/api";
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
    bool isManualEnv = storage.read<bool>(_manualEnvKey) ?? false;

    // Ưu tiên cao nhất: URL được set thủ công
    if (savedUrl != null && savedUrl.isNotEmpty && isManualEnv) {
      print("Using manual environment: $savedUrl");
      return savedUrl;
    }
    // Chỉ fallback về awaiting logic khi chưa có URL thủ công
    return _currentDefaultBaseUrl(storage);
  }

  static set baseUrl(String url) {
    final storage = GetStorage();
    // Luôn lưu URL được set thủ công, không bị ghi đè bởi awaiting flag
    storage.write(_baseUrlKey, url);
    // Đánh dấu là môi trường được set thủ công
    storage.write(_manualEnvKey, true);
  }

  /// Reset về logic awaiting (xóa URL thủ công)
  static void resetToAwaitingLogic() {
    final storage = GetStorage();
    storage.remove(_baseUrlKey);
    storage.remove(_manualEnvKey);
  }

  /// Kiểm tra xem có URL thủ công không
  static bool hasManualUrl() {
    final storage = GetStorage();
    final savedUrl = storage.read<String>(_baseUrlKey);
    final isManualEnv = storage.read<bool>(_manualEnvKey) ?? false;
    return savedUrl != null && savedUrl.isNotEmpty && isManualEnv;
  }

  /// Clear manual environment flag (chỉ xóa flag, giữ URL)
  static void clearManualEnvFlag() {
    final storage = GetStorage();
    storage.remove(_manualEnvKey);
  }
}
