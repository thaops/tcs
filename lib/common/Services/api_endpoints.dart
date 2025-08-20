// lib/common/config/api_endpoints.dart
import 'package:tcs_flutter/common/Services/config.dart';

class ApiEndpoints {

    //notification
  static String notification  = "${Config.baseUrl}/device/onesignal-register";
  

  static String login = "${Config.baseUrl}/users/oauth2-google";
  static String loginUrlMicrosoft(int platform, int type) => "${Config.baseUrl}/login/get-redirect-url?platform=$platform&type=$type";
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

  static String employees = "${Config.baseUrl}/employee/get-list-employee?pageIndex=1&pageSize=9999";
  

  // departments
  static String departments = "${Config.baseUrl}/employee/get-list-employee-of-department";

  // listofff
  static String listoff(DateTime firstDayOfMonth, DateTime lastDayOfMonth) => "${Config.baseUrl}/dayoff/get-list-day-off?pageIndex=1&pageSize=9999&fromDate=$firstDayOfMonth&toDate=$lastDayOfMonth&keyword=";
  static String getLeaveID(String leaveId) => "${Config.baseUrl}/dayoff/get-detail-day-off/$leaveId";
  static String updateLeaveID(String leaveId) => "${Config.baseUrl}/dayoff/update-day-off/$leaveId";
  static String deleteLeaveID(String leaveId) => "${Config.baseUrl}/dayoff/delete-day-off/$leaveId";
  static String createLeaveID() => "${Config.baseUrl}/dayoff/add-day-off";
  static String getLeave = "${Config.baseUrl}/dayoff/get-list-category";
  static String approveLeave(String approveId) => "${Config.baseUrl}/dayoff/approve-day-off/$approveId";

  static String getListApprover(int? step, String? keyword) => "${Config.baseUrl}/dayoff/get-list-approval-orders";



  static String fetchListOff(
          DateTime firstDayOfMonth, DateTime lastDayOfMonth) =>
      "${Config.baseUrl}/dayoff/get-list-day-off?pageIndex=1&pageSize=9999&fromDate=$firstDayOfMonth&toDate=$lastDayOfMonth&keyword=";

  static String supportcenter(
      {int? status,
      DateTime? fromDate,
      DateTime? toDate,
      int? pageIndex,
      int? pageSize,
      String? keyword}) {
    fromDate ??= DateTime(2025, 1, 1, 0, 0, 0);
    toDate ??= DateTime(2025, 1, 31, 23, 59, 59);

    String formattedFromDate = fromDate.toIso8601String();
    String formattedToDate = toDate.toIso8601String();

    return "${Config.baseUrl}/supportcenter/get-list-request"
        "?status=$status"
        "&keyword=${keyword ?? ''}"
        "&fromDate=$formattedFromDate"
        "&toDate=$formattedToDate"
        "&pageIndex=$pageIndex"
        "&pageSize=$pageSize";
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

  static String typeSupport = "${Config.baseUrl}/supportcenter/get-type-support";


  // static String handlerSupport = "${Config.baseUrl}/supportcenter/get-list-handler?pageIndex=1&pageSize=99999";

static String listEmailContact = "${Config.baseUrl}/supportcenter/get-list-email-contact?projectId=&keyword=&isAll=true";

static String updateTypeSupport(String supportTypeId) => "${Config.baseUrl}/supportcenter/update-type-support/$supportTypeId";

static String transferHandler(String supportTransferId) => "${Config.baseUrl}/supportcenter/transfer-handler/$supportTransferId";

static String updateSupport(String supportId) => "${Config.baseUrl}/supportcenter/update-request/$supportId";

static String updateStatusSupport(String supportId) => "${Config.baseUrl}/supportcenter/update-status-request/$supportId";

static String createSupport = "${Config.baseUrl}/supportcenter/create-request";

}
