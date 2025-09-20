// Model riêng cho Apple để tránh conflict với code cũ
class AppleProfile {
  final AppleUser? user;
  final List<String> permissions;

  AppleProfile({this.user, this.permissions = const []});

  factory AppleProfile.fromJson(Map<String, dynamic> json) {
    return AppleProfile(
      user: json['user'] != null ? AppleUser.fromJson(json['user']) : null,
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

class AppleUser {
  final String? id;
  final int? hrId;
  final String? username;
  final String? email;
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

  AppleUser({
    this.id,
    this.hrId,
    this.username,
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
  });

  factory AppleUser.fromJson(Map<String, dynamic> json) {
    return AppleUser(
      id: json['id'] ?? '',
      hrId: json['hrId'] is String ? int.tryParse(json['hrId']) : json['hrId'],
      username: json['username'] ?? '',
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
    };
  }
}
