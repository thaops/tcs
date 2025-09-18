// lib/common/config/api_endpoints.dart
import 'package:tcs_flutter/common/Services/config.dart';

class ApiEndpoints {
  //notification
  static String notification = "${Config.baseUrl}/device/onesignal-register";

  static String login = "${Config.baseUrl}/users/oauth2-google";
  static String loginUrlMicrosoft(int platform, int type) =>
      "${Config.baseUrl}/login/get-redirect-url?platform=$platform&type=$type";
  static String loginMicrosoft = "${Config.baseUrl}/login/login-with-ms-token";

  static String loginFrame = "${Config.baseUrl}/users/login";

  //task

  // profile
  static String profile = "${Config.baseUrl}/user/get-info-mine";

  static String role = "${Config.baseUrl}/tasks/get-role-for-task";

  // user
  static String users =
      "${Config.baseUrl}/users?userStatus=1&page=1&pageSize=9999";

  static String usersWith({
    int? userStatus,
    int page = 1,
    int pageSize = 99999,
    bool? isAll,
    String? keyword,
  }) {
    final params = <String, String>{
      'page': page.toString(),
      'pageSize': pageSize.toString(),
    };
    if (userStatus != null) params['userStatus'] = userStatus.toString();
    if (isAll != null) params['isAll'] = isAll.toString();
    if (keyword != null && keyword.isNotEmpty) params['keyword'] = keyword;
    final query = params.entries.map((e) => "${e.key}=${e.value}").join('&');
    return "${Config.baseUrl}/users?$query";
  }

  static String employees =
      "${Config.baseUrl}/employee/get-list-employee?pageIndex=1&pageSize=9999";

  // departments
  static String departments =
      "${Config.baseUrl}/employee/get-list-employee-of-department";

  // listoff - ensure ISO8601 and URL-encoded
  static String listoff(DateTime firstDayOfMonth, DateTime lastDayOfMonth) {
    final from = Uri.encodeComponent(firstDayOfMonth.toIso8601String());
    final to = Uri.encodeComponent(lastDayOfMonth.toIso8601String());
    return "${Config.baseUrl}/dayoff/get-list-day-off?pageIndex=1&pageSize=9999&fromDate=$from&toDate=$to&keyword=";
  }

  static String listoffV2 =
      "${Config.baseUrl}/dayoff/get-list-day-off-schedule";
  static String listoffListView =
      "${Config.baseUrl}/dayoff/get-list-day-off-list-view";

  static String getLeaveIDV2(String leaveId) =>
      "${Config.baseUrl}/dayoffv2/get-detail-day-off-v2/$leaveId";
  static String updateLeaveIDV2(String leaveId) =>
      "${Config.baseUrl}/dayoffv2/update-day-off-v2/$leaveId";
  static String deleteLeaveIDV2(String leaveId) =>
      "${Config.baseUrl}/dayoffv2/delete-day-off-v2/$leaveId";
  static String createLeaveIDV2() =>
      "${Config.baseUrl}/dayoffv2/add-day-off-v2";
  static String getLeaveV2 = "${Config.baseUrl}/dayoffv2/get-list-category-v2";
  static String approveLeaveV2(String approveId) =>
      "${Config.baseUrl}/dayoffv2/approve-day-off-v2/$approveId";
  static String getListApproverV2(int? step, String? keyword) =>
      "${Config.baseUrl}/dayoffv2/get-list-approval-orders-v2";
  static String getListApprovalByUserV2(String leaveOffId) =>
      "${Config.baseUrl}/dayoffv2/get-list-approval-by-v2/$leaveOffId";

  // Leave comments endpoints
  static String getLeaveCommentsV2(String dayOffId) =>
      "${Config.baseUrl}/dayoffv2/get-list-day-off-comments-v2/$dayOffId";
  static String addLeaveCommentV2 =
      "${Config.baseUrl}/dayoffv2/add-day-off-comment-v2";

  static String fetchListOff(
    DateTime firstDayOfMonth,
    DateTime lastDayOfMonth,
  ) {
    final from = Uri.encodeComponent(firstDayOfMonth.toIso8601String());
    final to = Uri.encodeComponent(lastDayOfMonth.toIso8601String());
    return "${Config.baseUrl}/dayoff/get-list-day-off?pageIndex=1&pageSize=9999&fromDate=$from&toDate=$to&keyword=";
  }

  static String supportcenterDetail(String supportId) =>
      "${Config.baseUrl}/supportcenter/get-detail-request?id=$supportId";

  static String messageSupport =
      "${Config.baseUrl}/supportcenter/create-message";

  //lave
  static String leavePagination =
      "${Config.baseUrl}/dayoff/list-category?pageIndex=1&pageSize=9999";
  //careateleave
  static String careateleave = "${Config.baseUrl}/dayoff/add-day-off";
  //updateleave
  static String updateleave(String leaveId) =>
      "${Config.baseUrl}/dayoff/update-day-off/$leaveId";

  //SupportCenter

  //  static String supportcenter(
  //     {int? status,
  //     DateTime? fromDate,
  //     DateTime? toDate,
  //     int? pageIndex,
  //     int? pageSize,
  //     String? keyword}) {
  //   fromDate ??= DateTime(2025, 1, 1, 0, 0, 0);
  //   toDate ??= DateTime(2025, 1, 31, 23, 59, 59);

  //   String formattedFromDate = fromDate.toIso8601String();
  //   String formattedToDate = toDate.toIso8601String();

  //   return "${Config.baseUrl}/get-list-request"
  //       "?status=$status"
  //       "&keyword=${keyword ?? ''}"
  //       "&fromDate=$formattedFromDate"
  //       "&toDate=$formattedToDate"
  //       "&pageIndex=$pageIndex"
  //       "&pageSize=$pageSize";
  // }

  // static String supportcenterDetail(String supportId) =>
  //     "${Config.baseUrl}/get-detail-request?id=$supportId";

  // static String messageSupport = "${Config.baseUrl}/create-message";
  static String projectSupport =
      "${Config.baseUrl}/supportcenter/get-list-project?page=1&pageSize=9999";

  static String typeSupport =
      "${Config.baseUrl}/supportcenter/get-type-support";

  // static String handlerSupport = "${Config.baseUrl}/supportcenter/get-list-handler?pageIndex=1&pageSize=99999";

  static String listEmailContact =
      "${Config.baseUrl}/supportcenter/get-list-email-contact?projectId=&keyword=&isAll=true";

  static String updateTypeSupport(String supportTypeId) =>
      "${Config.baseUrl}/supportcenter/update-type-support/$supportTypeId";

  static String transferHandler(String supportTransferId) =>
      "${Config.baseUrl}/supportcenter/transfer-handler/$supportTransferId";

  static String updateSupport(String supportId) =>
      "${Config.baseUrl}/supportcenter/update-request/$supportId";

  static String updateStatusSupport(String supportId) =>
      "${Config.baseUrl}/supportcenter/update-status-request/$supportId";

  static String createSupport =
      "${Config.baseUrl}/supportcenter/create-request";

  // apple Test
  static String usersProfileApple = "${Config.baseUrl}/users/profile";

  static String listoffApple(
    DateTime firstDayOfMonth,
    DateTime lastDayOfMonth,
  ) {
    final from = Uri.encodeComponent(firstDayOfMonth.toIso8601String());
    final to = Uri.encodeComponent(lastDayOfMonth.toIso8601String());
    return "${Config.baseUrl}/dayoff/list-day-off?pageIndex=1&pageSize=9999&fromDate=$from&toDate=$to&keyword=";
  }
}
