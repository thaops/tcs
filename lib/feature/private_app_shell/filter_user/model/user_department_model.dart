class UserDepartmentModel {
  String? name;
  List<Employee>? employees;

  UserDepartmentModel({
    this.name,
    this.employees,
  });

  // Phương thức khởi tạo từ JSON
  factory UserDepartmentModel.fromJson(Map<String, dynamic> json) {
    return UserDepartmentModel(
      name: json['name'] ?? '', // Kiểm tra null
      employees: (json['employees'] as List?)?.map((e) => Employee.fromJson(e)).toList() ?? [], // Kiểm tra null và xử lý danh sách
    );
  }

  // Phương thức chuyển về JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name ?? '', // Kiểm tra null
      'employees': employees?.map((e) => e.toJson()).toList() ?? [], // Kiểm tra null
    };
  }

  // Ghi đè phương thức toString để hiển thị chi tiết phòng ban
  @override
  String toString() {
    return 'Department: ${name ?? ''}, Employees: ${employees?.length ?? 0}';
  }
}

class Employee {
  String? id;
  String? fullName;
  String? email;
  String? avatarUrl;

  Employee({
    this.id,
    this.fullName,
    this.email,
    this.avatarUrl,
  });

  // Phương thức khởi tạo từ JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'] ?? '', // Kiểm tra null
      fullName: json['fullName'] ?? 'e', // Kiểm tra null
      email: json['email'] ?? '', // Kiểm tra null
      avatarUrl: json['avatarUrl'] ?? '', // Kiểm tra null
    );
  }

  // Phương thức chuyển về JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id ?? '', // Kiểm tra null
      'fullName': fullName ?? '', // Kiểm tra null
      'email': email ?? '', // Kiểm tra null
      'avatarUrl': avatarUrl ?? '', // Kiểm tra null
    };
  }

  // Ghi đè phương thức toString để hiển thị chi tiết nhân viên
  @override
  String toString() {
    return 'Employee(id: ${id ?? 'Unknown'}, fullName: ${fullName ?? 'Unknown'}, email: ${email ?? 'Unknown'})';
  }
}
