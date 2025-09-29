class Profile {
  final User? user;
  final List<String> permissions;

  Profile({this.user, this.permissions = const []});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      permissions:
          (json['permissions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': user?.toJson(), 'permissions': permissions};
  }
}

class User {
  final String? id;
  final int? hrId;
  final String? username;
  final String? email;
  final String? employeeCode;
  final String? phoneNumber;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? fullNameNoAccent;
  final String? firstNameUnsign;
  final String? lastNameUnsign;
  final bool? gender;
  final String? refreshToken;
  final String? avatar;
  final String? doB;
  final String? fullName;
  final bool? isDeleted;
  final String? createdDate;
  final String? updatedDate;
  final String? creator;
  final String? modifier;
  final String? createdById;
  final String? updatedById;
  // Thêm các field từ API response
  final String? address;
  final String? tel;
  final String? department;
  final String? departmentId;
  final String? workStartDate;
  final String? avatarUrl;
  // Thêm các field từ API thông thường
  final String? jobTitle;
  final String? jobTitleCode;

  final String? departmentName;
  final String? unitName;

  User({
    this.id,
    this.hrId,
    this.username,
    this.employeeCode,
    this.email,
    this.phoneNumber,
    this.password,
    this.firstName,
    this.lastName,
    this.fullNameNoAccent,
    this.firstNameUnsign,
    this.lastNameUnsign,
    this.gender,
    this.refreshToken,
    this.avatar,
    this.doB,
    this.fullName,
    this.isDeleted,
    this.createdDate,
    this.updatedDate,
    this.creator,
    this.modifier,
    this.createdById,
    this.updatedById,
    // Thêm các field mới
    this.address,
    this.tel,
    this.department,
    this.departmentId,
    this.workStartDate,
    this.avatarUrl,
    // Thêm các field từ API thông thường
    this.jobTitle,
    this.jobTitleCode,
    this.departmentName,
    this.unitName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      hrId: json['hrId'] is String ? int.tryParse(json['hrId']) : json['hrId'],
      username: json['username'] ?? '',
      employeeCode: json['employeeCode'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? json['tel'] ?? '', // Map tel từ API
      password: json['password'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullNameNoAccent: json['fullNameNoAccent'] ?? '',
      firstNameUnsign: json['firstNameUnsign'] ?? '',
      lastNameUnsign: json['lastNameUnsign'] ?? '',
      gender: json['gender'] ?? false,
      refreshToken: json['refreshToken'] ?? '',
      avatar: json['avatar'] ?? json['avatarUrl'] ?? '', // Map avatarUrl từ API
      doB: json['doB'],
      fullName: json['fullName'],
      isDeleted: json['isDeleted'] ?? false,
      createdDate:
          json['createdDate'] ??
          json['workStartDate'] ??
          '', // Map workStartDate
      updatedDate: json['updatedDate'],
      creator: json['creator'] ?? '',
      modifier: json['modifier'] ?? '',
      createdById: json['createdById'],
      updatedById: json['updatedById'],
      // Thêm các field mới
      address: json['address'],
      tel: json['tel'],
      department: json['department'],
      departmentId: json['departmentId'],
      workStartDate: json['workStartDate'],
      avatarUrl: json['avatarUrl'],
      // Thêm các field từ API thông thường
      jobTitle: json['jobTitle'],
      jobTitleCode: json['jobTitleCode'],
      departmentName: json['departmentName'] ?? '',
      unitName: json['unitName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hrId': hrId,
      'username': username,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'fullNameNoAccent': fullNameNoAccent,
      'firstNameUnsign': firstNameUnsign,
      'lastNameUnsign': lastNameUnsign,
      'gender': gender,
      'refreshToken': refreshToken,
      'avatar': avatar,
      'doB': doB,
      'fullName': fullName,
      'isDeleted': isDeleted,
      'createdDate': createdDate,
      'updatedDate': updatedDate,
      'creator': creator,
      'modifier': modifier,
      'createdById': createdById,
      'updatedById': updatedById,
      // Thêm các field mới
      'address': address,
      'tel': tel,
      'department': department,
      'departmentId': departmentId,
      'workStartDate': workStartDate,
      'avatarUrl': avatarUrl,
      // Thêm các field từ API thông thường
      'jobTitle': jobTitle,
      'jobTitleCode': jobTitleCode,
    };
  }
}
