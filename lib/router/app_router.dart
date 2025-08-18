import 'package:get/get.dart';
import 'package:tcs_flutter/feature/auth/login/binding/login_binding.dart';
import 'package:tcs_flutter/feature/auth/login/view/login_screen.dart';
import 'package:tcs_flutter/feature/auth/login_with_microsoft/login_with_microsoft.dart';
import 'package:tcs_flutter/feature/presentation/filter_user/filter_user_view.dart';

import 'package:tcs_flutter/feature/presentation/leave_management/view/leave_request_create_screen.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/view/leave_request_detail_screen.dart';
import 'package:tcs_flutter/feature/presentation/leave_management/view/leave_request_update_screen.dart';
import 'package:tcs_flutter/feature/presentation/profile/binding/profile_binding.dart';
import 'package:tcs_flutter/feature/presentation/profile/view/profile_screen.dart';
import 'package:tcs_flutter/main.dart';
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

  // Route con cho report
  static const report_view = '/report/report_view';
  static const report_detail = '/report/report_detail';
  static const report_coment = '/report/report_coment';
  static const report_create = '/report/report_create';
  static const report_update = '/report/report_update';

  // Route con cho board
  static const board_view = '/board/board_view';
  static const board_create = '/board/board_create';
  static const board_detail = '/board/board_detail';
  static const board_update = '/board/board_update';
  static const history_view = '/board/history_view';

  // Route con cho task
  static const task_management = '/task/task_management';
  static const task_every = '/task/task_every';
  static const task_detail = '/task/task_detail';
  static const task_option = '/task/task_option';
  static const task_create = '/task/task_create';
  static const task_update = '/task/task_update';
  static const task_kanban_view = '/task/task_kanban_view';
  static const timeline_view = '/task/timeline_view';

  // Route con cho leave
  static const leaveCreate = '/leave/leaveCreate';
  static const leaveUpdate = '/leave/leaveUpdate';
  static const leaveDetail = '/leave/leaveDetail';

  // Route con cho support
  static const support_detail = '/support/support_detail';
  static const support_create_step = '/support/support_create_step';

  static final List<GetPage> routes = [
    // Auth
    GetPage(
      name: login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: loginWithMicrosoft,
      page: () => LoginWithMicrosoft(),
    ),

    // Main
    GetPage(
      name: main,
      page: () => MainScreen(),
    ),

  
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
    GetPage(
      name: filter_user,
      page: () => FilterUserView(),
    ),
  ];
}