import 'package:get/get.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/logic/my_annual_leave_logic.dart';

class MyAnnualLeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyAnnualLeaveLogic>(() => MyAnnualLeaveLogic());
  }
}
