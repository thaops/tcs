import 'package:get/get.dart';
import 'package:tcs_flutter/feature/public_app_shell/auth/login/binding/login_binding.dart';
import 'package:tcs_flutter/feature/public_app_shell/auth/login/view/login_screen.dart';
import 'package:tcs_flutter/feature/public_app_shell/auth/login_with_microsoft/login_with_microsoft.dart';
import 'package:tcs_flutter/feature/private_app_shell/filter_user/filter_user_view.dart';

import 'package:tcs_flutter/feature/private_app_shell/leave_management/view/leave_request_create_screen.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/view/leave_request_detail_screen.dart';
import 'package:tcs_flutter/feature/private_app_shell/leave_management/view/leave_request_update_screen.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/binding/profile_binding.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/binding/my_annual_leave_binding.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/binding/summary_day_off_binding.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/view/profile_screen.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/view/profile_detail_screen.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/view/profile_annual_goals_screen.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/view/summary_day_off_screen.dart';
import 'package:tcs_flutter/router/bottom_navigation_main.dart';

class AppRouter {
  // Route cha
  static const auth = '/auth';
  static const report = '/report';
  static const board = '/board';
  static const task = '/task';
  static const leave = '/leave';
  static const support = '/support';
  static const main = '/main';
  static const profile = '/profile';
  static const filter_user = '/filter_user';
  static const splash = '/splash';

  // Route con cho auth
  static const login = '/auth/login';
  static const loginWithMicrosoft = '/auth/loginWithMicrosoft';

  // Route con cho leave
  static const leaveCreate = '/leave/leaveCreate';
  static const leaveUpdate = '/leave/leaveUpdate';
  static const leaveDetail = '/leave/leaveDetail';

  static const profileAnnualGoals = '/profile/annualGoals';
  static const profileDetail = '/profile/detail';
  static const summaryDayOff = '/profile/summaryDayOff';

  static final List<GetPage> routes = [
    // Auth
    GetPage(name: login, page: () => LoginScreen(), binding: LoginBinding()),
    GetPage(name: loginWithMicrosoft, page: () => LoginWithMicrosoft()),

    // Main
    GetPage(name: main, page: () => MainScreen()),

    // Leave
    GetPage(
      name: leaveCreate,
      page: () => ListoffAddScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: leaveUpdate,
      page: () => LeaveRequestUpdateScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: leaveDetail,
      page: () => ListoffDetail(),
      transition: Transition.rightToLeft,
    ),

    // Độc lập
    GetPage(
      name: profile,
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(name: filter_user, page: () => FilterUserView()),
    GetPage(
      name: profileDetail,
      page: () => ProfileDetailScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: profileAnnualGoals,
      page: () => ProfileAnnualGoalsScreen(),
      binding: MyAnnualLeaveBinding(),
    ),
    GetPage(
      name: summaryDayOff,
      page: () => SummaryDayOffScreen(),
      binding: SummaryDayOffBinding(),
    ),
  ];
}
