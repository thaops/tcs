import 'package:get_storage/get_storage.dart';

class CheckAwaitingServices {
  final GetStorage _storage;

  CheckAwaitingServices(this._storage);

  static Future<CheckAwaitingServices> createCheckAwaitingServices() async {
    return CheckAwaitingServices(GetStorage());
  }

  Future<void> saveawaiting(bool awaiting) async {
    await _storage.write('awaiting', awaiting); // Lưu awaiting
  }
  Future<bool> getawaiting() async {
    bool? awaiting = _storage.read('awaiting'); // Lấy awaiting
    return awaiting ?? false; // Trả về awaiting hoặc chuỗi rỗng
  }
  Future<void> deleteawaiting() async {
    await _storage.remove('awaiting'); // Xóa awaiting
  }
}
