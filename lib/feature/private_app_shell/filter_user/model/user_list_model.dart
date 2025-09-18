class UserListModel {
  final String? id;
  final String? fullName;
  late final String? avatarUrl;
  final String? department;
  final int? userType;
  final String? userTypeLabel;
  final String? bankInfo;
  final String? email;
  final String? tel;
  final String? startDate;
  final String? cccd;
  final String? licenseDate;
  final String? licensePlace;
  final String? signedDate;
  final String? expiredDate;
  final bool? isDeleted;

  UserListModel({
     this.id,
     this.fullName,
     this.avatarUrl,
     this.department,
     this.userType,
     this.userTypeLabel,
     this.bankInfo,
     this.email,
     this.tel,
     this.startDate,
     this.cccd,
     this.licenseDate,
     this.licensePlace,
     this.signedDate,
     this.expiredDate,
     this.isDeleted,
  });

  // Phương thức từ JSON
  factory UserListModel.fromJson(Map<String, dynamic> json) {
    return UserListModel(
      id: json['id'] ?? '', // Kiểm tra null
      fullName: json['fullName'] ?? '', // Kiểm tra null
      avatarUrl: json['avatarUrl'] ?? '', // Kiểm tra null
      department: (((json['department'] as String?)?.trim().isNotEmpty) ?? false)
          ? (json['department'] as String).trim()
          : null, // keep null instead of ' Department'
      userType: json['userType'] ?? 0, // Kiểm tra null
      userTypeLabel: json['userTypeLabel'] ?? '', // Kiểm tra null
      bankInfo: json['bankInfo'] ?? '', // Kiểm tra null
      email: json['email'] ?? 'No Email', // Kiểm tra null
      tel: json['tel'] ?? '', // Kiểm tra null
      startDate: json['startDate'] ?? '', // Kiểm tra null
      cccd: json['cccd'] ?? '', // Kiểm tra null
      licenseDate: json['licenseDate'] ?? '', // Kiểm tra null
      licensePlace: json['licensePlace'] ?? '', // Kiểm tra null
      signedDate: json['signedDate'] ?? '', // Kiểm tra null
      expiredDate: json['expiredDate'] ?? '', // Kiểm tra null
      isDeleted: json['isDeleted'] ?? false, // Kiểm tra null
    );
  }

  get avatar => null;

  set value(UserListModel value) {}

  // Phương thức chuyển về JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'department': department,
      'userType': userType,
      'userTypeLabel': userTypeLabel,
      'bankInfo': bankInfo,
      'email': email,
      'tel': tel,
      'startDate': startDate,
      'cccd': cccd,
      'licenseDate': licenseDate,
      'licensePlace': licensePlace,
      'signedDate': signedDate,
      'expiredDate': expiredDate,
      'isDeleted': isDeleted,
    };
  }
}
