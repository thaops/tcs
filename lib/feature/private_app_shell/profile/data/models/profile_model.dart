class Profile {
  // Các thuộc tính khác
  final String? id;
  final String? fullName;
  final String? email;
  final String? address;
  final String? tel;
  final String? department;
  final String? departmentId;
  final DateTime? workStartDate;
  final String? avatarUrl;

  Profile({
     this.id,
     this.fullName,
     this.email,
     this.address,
     this.tel,
     this.department,
     this.departmentId,
     this.workStartDate,
     this.avatarUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      tel: json['tel'] ?? '',
      department: json['department'] ?? '',
      departmentId: json['departmentId'] ?? '',
      workStartDate: json['workStartDate'] != null ? DateTime.parse(json['workStartDate']) : null,
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Profile(id: $id, fullName: $fullName, email: $email, address: $address, tel: $tel, department: $department, departmentId: $departmentId, workStartDate: $workStartDate, avatarUrl: $avatarUrl)';
  }
}
