import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/common/constants/http_status_codes.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/common/widgets/custom_select.dart';
import 'package:tcs_flutter/feature/presentation/user_list/model/user_department_model.dart';
import 'package:tcs_flutter/feature/presentation/user_list/model/user_list_model.dart';

class UserController extends GetxController {
  DioApi dioApi = DioApi();
  Dio dio = Dio();
  final searchController = TextEditingController();
  final userList = <UserListModel>[].obs;
  // Cache all users from the last API fetch
  final allUsers = <UserListModel>[].obs;
  final userDepartmentList = <UserDepartmentModel>[].obs;
  final userDepartmentListSearch = <UserDepartmentModel>[].obs;

  final isLoading = false.obs;
  // Last error message to display
  final errorMessage = ''.obs;
  // Current selected department filter (UUID or empty for all)
  final departmentId = ''.obs;

  final userType = ''.obs;

  // Map UUID department IDs to display names
  static const Map<String, String> departmentIdToName = {
    'e5dc9202-25ad-49de-b5c9-16852378f1bd': 'Bộ phận quản lý',
    '45126c87-7c7b-4885-a6fb-17b2b1ad3190': 'Phòng dự án',
    '32106856-63c8-4a61-8799-59434f018d4b': 'Phòng kỹ thuật',
    'fb1df35f-0276-4226-8da1-685bbc6519f2': 'Văn phòng',
    'c3dce574-b18f-419d-94c1-09f4937c99c3': 'Parttime',
  };

  static const List<Map<String, String>> entriesUserType = [
         {
            "0": "Nhân viên chính thức"
        },
        {
            "1": "Nhân viên thử việc"
        },
        {
            "2": "Thực tập sinh"
        },
        {
            "3": "Nghỉ việc"
        }
  ];

  // Build items for CustomSelect (prepend "Tất cả")
  List<Item> get departmentItems {
    final items = departmentIdToName.entries
        .map((e) => Item(id: e.key, name: e.value))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return [Item(id: '', name: 'Tất cả'), ...items];
  }

  List<Item> get userTypeItems {
    final items = entriesUserType
        .expand((m) => m.entries)
        .map((e) => Item(id: e.key, name: e.value))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return [Item(id: '', name: 'Tất cả'), ...items];
  }

  List<String> _resolveDepartmentNames(UserListModel user) {
    final Set<String> names = {};

    // Include explicit department string if provided
    final depStr = user.department?.trim();
    if (depStr != null && depStr.isNotEmpty) names.add(depStr);

    // Map all departmentIds to names
    final ids = user.departmentIds;
    if (ids != null && ids.isNotEmpty) {
      for (final id in ids) {
        final name = departmentIdToName[id];
        if (name != null && name.isNotEmpty) names.add(name);
      }
    }

    // If nothing matched, fallback to Parttime
    if (names.isEmpty) names.add('Parttime');
    return names.toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchUserList();

    searchController.addListener(() {
      searchUser(searchController.text);
    });

    // Rebuild grouped list locally when filters change
    ever<String>(departmentId, (_) => applyFilters());
    ever<String>(userType, (_) => applyFilters());
  }

  Future<void> fetchUserList() async {
    try {
      isLoading.value = true;

      final response = await dioApi.post(
        ApiEndpoints.employees,
        data: {
          "departmentIds": departmentId.value.isNotEmpty ? [departmentId.value] : [],
          "status": true,
        },
      );
      print("response.data: ${response.data}");

      // Handle HTTP-level errors
      if (response.statusCode != HttpStatusCodes.STATUS_CODE_OK) {
        final msg = 'Không thể tải danh sách nhân viên (HTTP ${response.statusCode}).';
        errorMessage.value = msg;
        allUsers.clear();
        userList.clear();
        userDepartmentList.clear();
        userDepartmentListSearch.clear();
        return;
      }

      // Handle API-level error structure
      final body = response.data as Map<String, dynamic>?;
      final apiStatus = body?['statusCode'] as int?;
      final apiMessage = body?['message']?.toString();
      final data = body?['data'];
      if ((apiStatus != null && apiStatus != 200) || data == null) {
        final msg = apiMessage ?? 'Bạn không có quyền hoặc dữ liệu không khả dụng.';
        errorMessage.value = msg;
        allUsers.clear();
        userList.clear();
        userDepartmentList.clear();
        userDepartmentListSearch.clear();
        return;
      }

      final fetched = (data as List)
          .map((userJson) => UserListModel.fromJson(userJson))
          .toList();
      allUsers.value = fetched;
      userList.value = fetched; // keep backward compatibility if used elsewhere
      print("userList (cached): ${allUsers.length}");
      // Clear previous error (if any) on success
      errorMessage.value = '';
      applyFilters();
    } catch (e) {
      print(e);
      final msg = 'Đã xảy ra lỗi khi tải danh sách nhân viên.';
      errorMessage.value = msg;
      allUsers.clear();
      userList.clear();
      userDepartmentList.clear();
      userDepartmentListSearch.clear();
    } finally {
      isLoading.value = false;
    }
  }

  String removeDiacritics(String str) {
    var withDiacritics =
        'àáảãạâầấẩẫậăằắẳẵặèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđ';
    var withoutDiacritics =
        'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';

    for (int i = 0; i < withDiacritics.length; i++) {
      str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
    }
    return str;
  }

  void searchUser(String query) {
    if (query.isEmpty) {
      userDepartmentListSearch.assignAll(userDepartmentList);
      return;
    }

    String normalizedQuery = removeDiacritics(query.toLowerCase());

    var filteredDepartmentList = userDepartmentList.where((department) {
      if (department.employees == null) return false;

      var filteredEmployees = department.employees!.where((employee) {
        if (employee.fullName == null) return false;
        String normalizedFullName = removeDiacritics(employee.fullName!.toLowerCase());
        return normalizedFullName.contains(normalizedQuery);
      }).toList();

      if (filteredEmployees.isNotEmpty) {
        return true;
      }
      return false;
    }).map((department) {
      var filteredEmployees = department.employees!.where((employee) {
        String normalizedFullName = removeDiacritics(employee.fullName!.toLowerCase());
        return normalizedFullName.contains(normalizedQuery);
      }).toList();

      return UserDepartmentModel(
        name: department.name,
        employees: filteredEmployees,
      );
    }).toList();

    userDepartmentListSearch.assignAll(filteredDepartmentList);
  }

  // Apply local filters (departmentId, userType) and rebuild grouped data
  void applyFilters() {
    // 1) Filter by userType (if set)
    final int? selectedType = userType.value.isNotEmpty ? int.tryParse(userType.value) : null;
    Iterable<UserListModel> filtered = allUsers;
    if (selectedType != null) {
      filtered = filtered.where((u) => u.userType == selectedType);
    }

    // 2) Filter by departmentId (if set)
    if (departmentId.value.isNotEmpty) {
      final depId = departmentId.value;
      filtered = filtered.where((u) => (u.departmentIds ?? const []) .contains(depId));
    }

    // 3) Group by resolved department names (may be multiple per user)
    final Map<String, List<UserListModel>> departmentMap =
        filtered.fold(<String, List<UserListModel>>{}, (map, user) {
      final depNames = _resolveDepartmentNames(user);
      for (final depName in depNames) {
        (map[depName] ??= <UserListModel>[]).add(user);
      }
      return map;
    });

    // 4) Build UserDepartmentModel list
    final grouped = departmentMap.entries.map((entry) {
      return UserDepartmentModel(
        name: entry.key,
        employees: entry.value.map((user) {
          return Employee(
            id: user.id ?? '',
            fullName: user.fullName ?? 'Unknown',
            email: user.email ?? 'No Email',
            avatarUrl: user.avatarUrl ?? '',
          );
        }).toList(),
      );
    }).toList();

    userDepartmentList.value = grouped;
    userDepartmentListSearch.assignAll(userDepartmentList);
  }
}
