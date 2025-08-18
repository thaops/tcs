import 'package:get/get.dart';

class SearchFunc {
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

  void search({
    String? query = '',
    required dynamic departmentListSearch,
    required dynamic departmentList,
  }) {
    if (query!.isEmpty) {
      departmentListSearch.value = List.from(departmentList.value);
    }

    String normalizedQuery = removeDiacritics(query.toLowerCase());

    var filteredDepartmentList = departmentListSearch.where((department) {
      var filteredEmployees = department.employees!.where((employee) {
        String normalizedFullName =
            removeDiacritics(employee.fullName!.toLowerCase());
        return normalizedFullName.contains(normalizedQuery);
      }).toList();

      if (filteredEmployees.isNotEmpty) {
        department.employees = filteredEmployees;
        return true;
      }

      return false;
    }).toList();

  departmentListSearch.assignAll(filteredDepartmentList);
  }
}
