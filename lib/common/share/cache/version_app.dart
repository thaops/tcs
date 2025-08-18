import 'package:shared_preferences/shared_preferences.dart';

class VersionApp {
  final SharedPreferences _prefs;

  VersionApp(this._prefs); 

  static Future<VersionApp> create() async {
    final prefs = await SharedPreferences.getInstance();
    return VersionApp(prefs);
  }

  Future<void> saveVersion(String version) async {
    await _prefs.setString('version', version); 
  }

  Future<String> getVersion() async {
    String? token = _prefs.getString('version'); 
    return token ?? ''; 
  }
  Future<void> deleteVersion() async {
    await _prefs.remove('version'); 
  }

  Future<void> saveLastCheckTime(DateTime time) async {
    await _prefs.setString('lastCheckTime', time.toIso8601String()); 
  }

  Future<DateTime?> getLastCheckTime() async {
    String? time = _prefs.getString('lastCheckTime'); 
    return time != null ? DateTime.parse(time) : null; 
  }

  Future<void> deleteLastCheckTime() async {
    await _prefs.remove('lastCheckTime'); 
  }

  deleteAll() async {
    await _prefs.clear(); 
  }

  @override
  String toString() {
    return _prefs.getString('version') ?? '';
  }

}
