import 'package:get/get.dart';
import 'package:tcs_flutter/feature/presentation/profile/logic/profile_logic.dart';

class ProfileBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ProfileLogic>(() => ProfileLogic());
  }
}