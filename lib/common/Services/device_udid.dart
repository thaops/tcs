import 'package:shared_preferences/shared_preferences.dart';

class DeviceUdid {
  final SharedPreferences _prefs;

  DeviceUdid(this._prefs); // Tiêm phụ thuộc cho SharedPreferences

  static Future<DeviceUdid> createDeviceUdid() async {
    final prefs = await SharedPreferences.getInstance();
    return DeviceUdid(prefs);
  }

  Future<void> saveUdid(String udid) async {
    await _prefs.setString('udid', udid); // Lưu udid
  }

  Future<String> getUdid() async {
    String? token = _prefs.getString('udid'); // Lấy udid
    return token ?? ''; // Trả về udid hoặc chuỗi rỗng
  }
  Future<void> deleteUdid() async {
    await _prefs.remove('udid'); // Xóa udid
  }
}
