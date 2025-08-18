// import 'package:NPP/src/api/api_service.dart';
// import 'package:NPP/src/api/models/project_model.dart';
// import 'package:NPP/src/feature/bottom_navigation/home/data/models/home_task_model.dart';
// import 'package:NPP/src/feature/bottom_navigation/home/data/repositories/home_repository.dart';
// import 'package:NPP/src/services/lib/services/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';

// class HomeController extends GetxController {
//   final ApiService apiService = ApiService();
//   final AuthService authService = AuthService();
//   HomeRepository homeRepository = HomeRepository();
//   DateTime today = DateTime.now();
//   DateTime? startDate;
//   DateTime? endDate;

//   var selectedDays = <DateTime>[];
//   var tasks = <Task>[];
//   var projectList = <Project>[];
//   var project = '';
//   var isSwitched = false;

//   final DateFormat dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss.SSS');
//   final DateFormat dateFormatD = DateFormat('dd-MM-yyyy');

//   Future<void> fetchProjects(BuildContext context) async {
//     try {
//       final response = await apiService.getProject(context);
//       if (response != null) {
//         projectList = response;
//       } else {
//         print('Access token is missing.');
//       }
//     } catch (e) {
//       print('Error fetching projects: $e');
//     }
//   }
  

//   Future<void> fetchTasks(BuildContext context) async {
//     try {
//       if (startDate != null && endDate != null) {
//          project ??= '';
//         var fetchedTasks = await homeRepository.fetchTasks(
//             startDate!, endDate!, project!, isSwitched, context);
//         tasks = fetchedTasks;
//       }
//     } catch (e) {
//       print('Error fetching tasks: $e');
//       tasks.clear();
//     }
//   }

//   void onDaySelected(DateTime selectedDay) {
//     if (startDate == null) {
//       startDate = selectedDay;
//       selectedDays.clear();
//       selectedDays.add(selectedDay);
//     } else if (selectedDays.contains(selectedDay)) {
//       selectedDays.remove(selectedDay);
//     } else {
//       if (selectedDays.length >= 2) {
//         selectedDays.clear();
//       }
//       selectedDays.add(selectedDay);
//     }
//     selectedDays.sort((a, b) => a.compareTo(b));

//     if (selectedDays.isNotEmpty) {
//       startDate = DateTime(selectedDays.first.year, selectedDays.first.month,
//           selectedDays.first.day, 0, 0, 0);
//       endDate = DateTime(selectedDays.last.year, selectedDays.last.month,
//           selectedDays.last.day, 23, 59, 59);
//     } else {
//       startDate = null;
//       endDate = null;
//     }
//   }

//   void toggleSwitch(bool value) {
//     isSwitched = value;
//   }



//     Future<List<Task>> fetchTasks(DateTime startDate, DateTime endDate,
//       String project, bool _isSwitched, BuildContext context) async {
//     final accessToken = await _getAccessToken();
//     if (accessToken == null) {
//       throw Exception('Access token is missing');
//     }

//     final String baseUrl = await getBaseUrl(context);
//     final String url =
//         '$baseUrl/tasks?project=$project&page=1&pageSize=50&StartDate=${startDate.toIso8601String()}&EndDate=${endDate.toIso8601String()}&ForMe=$_isSwitched';
//     try {
//       final response = await dio.get(
//         url,
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $accessToken',
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         final responseData = response.data;
//         final taskDataList = responseData['data'] as List<dynamic>;
//         final tasks = taskDataList
//             .expand((item) => (item['tasks'] as List<dynamic>))
//             .map((json) => Task.fromJson(json))
//             .toList();

//         return tasks;
//       } else {
//         throw Exception('Failed to load tasks');
//       }
//     } catch (e) {
//       print('Error fetching tasks: $e');
//       return [];
//     }
//   }

// }