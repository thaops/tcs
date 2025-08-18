// import 'package:get/get.dart';
// import 'package:tcs_flutter/common/Services/api_endpoints.dart';
// import 'package:tcs_flutter/common/constants/http_status_codes.dart';
// import 'package:tcs_flutter/common/model/role_map_model.dart';
// import 'package:tcs_flutter/common/repositoty/dio_api.dart';
// import 'package:tcs_flutter/common/widgets/custom_select.dart';
// import 'package:tcs_flutter/feature/presentation/filter_user/model/user_list_model.dart';


// class BuildDateTask extends GetxController {
//   DioApi dioApi = DioApi();

//   List<TaskPriorityData>? taskTypeData;
//   List<TaskValidStates>? taskvalidstates;
//   RxList<ProjeckTask>? projeckTask = <ProjeckTask>[].obs;
//   RoleMapModel? roleMapModels;
//   RxList<Item> roleItems = <Item>[].obs;
//   final userList = <UserListModel>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _fetchRole();
//     _fetchUserList();
//     _fetchProjeckTask();
//     addData();
//   }

//   void addData() {
//     taskvalidstates = [
//       TaskValidStates(valid: 'backlog', value: 'Backlog'),
//       TaskValidStates(valid: 'in-progress', value: 'Inprogress'),
//       TaskValidStates(valid: 'done', value: 'Done'),
//       TaskValidStates(valid: 'pending', value: 'Pending'),
//     ];
//     taskTypeData = [
//       TaskPriorityData(priority: '1', value: 'New'),
//       TaskPriorityData(priority: '2', value: 'Change'),
//       TaskPriorityData(priority: '4', value: 'Bug'),
//       TaskPriorityData(priority: '8', value: 'Support'),
//       TaskPriorityData(priority: '16', value: 'Milestone'),
//     ];
//   }

//   Future<void> _fetchUserList() async {
//     try {
//       final response = await dioApi.get(
//         ApiEndpoints.users,
//       );
//       if (response.statusCode != HttpStatusCodes.STATUS_CODE_OK) {
//         return;
//       }
//       userList.value = (response.data['data'] as List)
//           .map((userJson) => UserListModel.fromJson(userJson))
//           .toList();
//       Map<String, List<UserListModel>> departmentMap =
//           userList.fold({}, (map, user) {
//         map
//             .putIfAbsent(user.department ?? 'Unknown Department', () => [])
//             .add(user);
//         return map;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _fetchProjeckTask() async {
//     try {
//       final response = await dioApi.post(ApiEndpoints.projects, data: {});
//       if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
//         final data = response.data['data'] as List<dynamic>;
//         projeckTask?.value = data
//             .map<ProjeckTask>((json) => ProjeckTask.fromJson(json))
//             .toList();
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }

//   Future<void> _fetchRole() async {
//     try {
//       final response = await dioApi.post(ApiEndpoints.role, data: {});
//       if (response.statusCode == HttpStatusCodes.STATUS_CODE_OK) {
//         final data = response.data['data'];
//         roleMapModels = RoleMapModel.fromJson(data);
//         roleItems.value =
//             roleMapModels?.roleMapToReversedItemList(roleMapModels) ?? [];
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }
// }
