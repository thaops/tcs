import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/common/constants/http_status_codes.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/feature/private_app_shell/user_list/model/user_department_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/user_list/model/user_list_model.dart';

class ItemFilter {
  final String id;
  final String name;

  ItemFilter({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemFilter && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => name; // Để hiển thị tên trong UI
}

class FilterUserController extends GetxController {
  DioApi dioApi = DioApi();
  Dio dio = Dio();
  final searchController = TextEditingController();
  final userList = <UserListModel>[].obs;
  final allUsers = <UserListModel>[].obs;
  final userDepartmentList = <UserDepartmentModel>[].obs;
  final userDepartmentListSearch = <UserDepartmentModel>[].obs;
  final RxList<ItemFilter> selectEmployeeIds = <ItemFilter>[].obs;
  final isLoading = false.obs;
  Timer? _debounce;
  final Map<String, String> employeeIdToDepartment = {};

  @override
  void onInit() {
    super.onInit();
    fetchUserList();
    searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 300), () {
        searchUser(searchController.text);
      });
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }

  void toggleEmployeeSelection(ItemFilter employee) {
    if (selectEmployeeIds.any((item) => item.id == employee.id)) {
      selectEmployeeIds.removeWhere((item) => item.id == employee.id);
    } else {
      selectEmployeeIds.add(employee);
    }
  }

  void toggleDepartmentSelection(String departmentName, bool isSelected) {
    final department = userDepartmentListSearch
        .firstWhereOrNull((dept) => dept.name == departmentName);
    if (department != null && department.employees != null) {
      for (var employee in department.employees!) {
        if (employee.id != null && employee.fullName != null) {
          final item = ItemFilter(id: employee.id!, name: employee.fullName!);
          if (isSelected) {
            if (!selectEmployeeIds.any((i) => i.id == item.id)) {
              selectEmployeeIds.add(item);
            }
          } else {
            selectEmployeeIds.removeWhere((i) => i.id == item.id);
          }
        }
      }
    }
  }

  bool isDepartmentSelected(String departmentName) {
    final department = userDepartmentListSearch
        .firstWhereOrNull((dept) => dept.name == departmentName);
    if (department == null || department.employees == null || department.employees!.isEmpty) {
      return false;
    }
    return department.employees!.every((employee) =>
        employee.id != null && selectEmployeeIds.any((item) => item.id == employee.id));
  }

  Future<void> fetchUserList() async {
    try {
      isLoading.value = true;
      final response = await dioApi.post(
        ApiEndpoints.departments,
        data: {"string": "string"}
      );
      if (response.statusCode != HttpStatusCodes.STATUS_CODE_OK) {
        Get.snackbar("Lỗi", "Không thể tải danh sách nhân viên");
        return;
      }
      final List<dynamic> departmentsJson = (response.data['data'] as List? ?? <dynamic>[]);
      userList.clear(); 
      final mappedDepartments = <UserDepartmentModel>[];
      employeeIdToDepartment.clear();
      for (final dept in departmentsJson) {
        if (dept is! Map<String, dynamic>) continue;
        final deptName = (dept['name'] as String?)?.trim() ?? 'Unknown Department';
        final employeesMap = dept['employees'];
        final seen = <String>{};
        final employees = <Employee>[];
        if (employeesMap is Map) {
          employeesMap.forEach((key, value) {
            final id = key?.toString() ?? '';
            final name = value?.toString() ?? 'Unknown';
            if (id.isNotEmpty && !seen.contains(id)) {
              seen.add(id);
              employees.add(Employee(
                id: id,
                fullName: name,
                email: '',
                avatarUrl: '',
              ));
              employeeIdToDepartment[id] = deptName;
            }
          });
        }
        employees.sort((a, b) {
          final an = removeDiacritics((a.fullName ?? '').toLowerCase());
          final bn = removeDiacritics((b.fullName ?? '').toLowerCase());
          return an.compareTo(bn);
        });
        mappedDepartments.add(UserDepartmentModel(
          name: deptName,
          employees: employees,
        ));
      }
      userDepartmentList.value = mappedDepartments;
      userDepartmentListSearch.assignAll(userDepartmentList);
    } catch (e) {
      Get.snackbar("Lỗi", "Đã xảy ra lỗi: $e");
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
      final filteredEmployees = department.employees!.where((employee) {
        final fullName = (employee.fullName ?? '').toLowerCase();
        final email = (employee.email ?? '').toLowerCase();
        final normalizedFullName = removeDiacritics(fullName);
        return normalizedFullName.contains(normalizedQuery) || email.contains(normalizedQuery);
      }).toList();
      return filteredEmployees.isNotEmpty;
    }).map((department) {
      final filteredEmployees = department.employees!.where((employee) {
        final fullName = (employee.fullName ?? '').toLowerCase();
        final email = (employee.email ?? '').toLowerCase();
        final normalizedFullName = removeDiacritics(fullName);
        return normalizedFullName.contains(normalizedQuery) || email.contains(normalizedQuery);
      }).toList();
      return UserDepartmentModel(
        name: department.name,
        employees: filteredEmployees,
      );
    }).toList();

    userDepartmentListSearch.assignAll(filteredDepartmentList);
  }

  String? departmentNameForEmployee(String? employeeId) {
    if (employeeId == null || employeeId.trim().isEmpty) return null;
    return employeeIdToDepartment[employeeId.trim()];
  }
}