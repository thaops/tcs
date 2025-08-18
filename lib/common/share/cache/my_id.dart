import 'package:shared_preferences/shared_preferences.dart';

class MyId {
  final SharedPreferences _prefs;

  MyId(this._prefs); 

  static Future<MyId> create() async {
    final prefs = await SharedPreferences.getInstance();
    return MyId(prefs);
  }

  Future<void> saveMyId(String myId) async {
    await _prefs.setString('myId', myId); 
  }

  Future<String> getMyId() async {
    String? token = _prefs.getString('myId'); 
    return token ?? ''; 
  }
  Future<void> deleteMyId() async {
    await _prefs.remove('myId'); 
  }

  Future<void> saveMyName(String myName) async {
    await _prefs.setString('myName', myName); 
  }

  Future<String> getMyName() async {
    String? token = _prefs.getString('myName'); 
    return token ?? ''; 
  }

  Future<void> deleteMyName() async {
    await _prefs.remove('myName'); 
  }
  deleteAll() async {
    await _prefs.clear(); 
  }

}
