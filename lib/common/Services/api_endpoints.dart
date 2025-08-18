// lib/common/config/api_endpoints.dart
import 'package:tcs_flutter/common/Services/config.dart';

class ApiEndpoints {

    //notification
  static String notification  = "${Config.baseUrl}/device/onesignal-register";
  

  static String login = "${Config.baseUrl}/users/oauth2-google";
  static String loginUrlMicrosoft(int platform, int type) => "${Config.baseUrl}/users/get-redirect-url?platform=$platform&type=$type";
    static String loginMicrosoft = "${Config.baseUrl}/users/login-with-ms-token";


  static String loginFrame = "${Config.baseUrl}/users/login";

  //task
  static String productPagination(int page, int pageSize) =>
      "${Config.baseUrl}/projects?page=$page&pageSize=$pageSize";
  static String taskPagination(
      {int page = 1,
      int pageSize = 999,
      String? projectID = '',
      DateTime? startDate,
      DateTime? endDate,
      bool forMe = true}) {
    startDate ??= DateTime(2024, 12, 21);
    endDate ??= DateTime(2222, 12, 31);

    return "${Config.baseUrl}/tasks?project=$projectID&page=$page&pageSize=$pageSize&startDate=$startDate&endDate=$endDate&forMe=$forMe";
  }

  static String taskPaginationEvery = "${Config.baseUrl}/tasks/get-list-task2";

  static String taskPaginationDetail = "${Config.baseUrl}/tasks/get-task2";
  static String addTask() => "${Config.baseUrl}/tasks/create-task2";

  static String taskDetail(String taskID) => "${Config.baseUrl}/tasks/$taskID";

  static String updateTask(String taskID) => "${Config.baseUrl}/tasks/update-task2?id=$taskID";

  static String deleteTask = "${Config.baseUrl}/tasks/remove-task2";

  static String meetingDetail(String meetingID) =>
      "${Config.baseUrl}/weekworkingschedule/$meetingID";

  // profile
  static String profile = "${Config.baseUrl}/users/profile";

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

  static String employees = "${Config.baseUrl}/employees/get-list";
  

  // departments
  static String departments = "${Config.baseUrl}/departments/get-departments-with-employees";

  // /tasks/valid-priorities
  static String validPriorities = "${Config.baseUrl}/tasks/valid-priorities";

  ///tasks/valid-states
  static String validStates = "${Config.baseUrl}/tasks/valid-states";

  //projects
  static String projects = "${Config.baseUrl}/projectwbs/get-list-of-projects";

  //sprints
  static String sprints(String projectId) =>
      "${Config.baseUrl}/sprints?project=$projectId&page=1&pageSize=9999&startDate=2023-12-04&endDate=2222-12-31";
  //wbs
    static String getListOfWbs = "${Config.baseUrl}/projectwbs/get-list-of-wbs";
  static String wbs = "${Config.baseUrl}/projectwbs/get-wbs-for-task";
  static String boardDetail = "${Config.baseUrl}/projectwbs/get-wbs";
  static String updateBoardDetail (String taskId) => "${Config.baseUrl}/projectwbs/update-wbs?id=$taskId";
  static String addBoard = "${Config.baseUrl}/projectwbs/add-wbs";
  static String addComment = "${Config.baseUrl}/projectcomment/add";
  static String updateComment(String id) => "${Config.baseUrl}/projectcomment/update?id=$id";
  static String deleteComment = "${Config.baseUrl}/projectcomment/remove";
  static String replyComment = "${Config.baseUrl}/projectcomment/reply";
  static String deleteWbs = "${Config.baseUrl}/projectwbs/remove-wbs";
  static String getComment = "${Config.baseUrl}/projectcomment/get-list";
  // listofff
  static String listoff(DateTime firstDayOfMonth, DateTime lastDayOfMonth) => "${Config.baseUrl}/dayoff/list-day-off?pageIndex=1&pageSize=9999&fromDate=$firstDayOfMonth&toDate=$lastDayOfMonth&keyword=";
  static String getLeaveID(String leaveId) => "${Config.baseUrl}/dayoff/get-day-off/$leaveId";
  static String updateLeaveID(String leaveId) => "${Config.baseUrl}/dayoff/update-day-off/$leaveId";
  static String deleteLeaveID(String leaveId) => "${Config.baseUrl}/dayoff/delete-day-off/$leaveId";
  static String createLeaveID() => "${Config.baseUrl}/dayoff/add-day-off";
  static String getLeave = "${Config.baseUrl}/dayoff/list-category?pageIndex=1&pageSize=9999";
  static String approveLeave(String approveId) => "${Config.baseUrl}/dayoff/approve-day-off/$approveId";
  //kanban
  static String getKanban = "${Config.baseUrl}/projectwbs/get-list-of-task-kanban";
  static String updateKanban(String taskId) => "${Config.baseUrl}/tasks/update-task2?id=$taskId";

  

  // wbsKanban
  static String getWbs = "${Config.baseUrl}/projectwbs/get-list-of-wbs-kanban";
  static String updateWbs(String taskId) => "${Config.baseUrl}/projectwbs/update-wbs?id=$taskId";

  static String getWbsDetail = "${Config.baseUrl}/projectwbs/get-wbs";

  //report
  static String getListReport = "${Config.baseUrl}/reports/get-list";
  static String getReportDetail(String reportId) => "${Config.baseUrl}/reports/get-by-id/$reportId";
  static String reportType = "${Config.baseUrl}/reports/report-type";
  static String reportStatus = "${Config.baseUrl}/reports/report-status";
  static String addReport = "${Config.baseUrl}/reports/add";
  static String updateReport = "${Config.baseUrl}/reports/update";
  static String deleteReport = "${Config.baseUrl}/reports/remove";






  static String fetchListOff(
          DateTime firstDayOfMonth, DateTime lastDayOfMonth) =>
      "${Config.baseUrl}/dayoff/list-day-off?pageIndex=1&pageSize=9999&fromDate=$firstDayOfMonth&toDate=$lastDayOfMonth&keyword=";

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
