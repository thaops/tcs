
class Profile {
  final User? user;
  final List<String> permissions;

  Profile({this.user, this.permissions = const []});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      permissions: (json['permissions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'permissions': permissions,
    };
  }
}

class User {
  final String id;
  final int? hrId;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? fullNameNoAccent;
  final String? firstNameUnsign;
  final String? lastNameUnsign;
  final String? gender;
  final String? refreshToken;
  final String? avatar;
  final String? doB;
  final String? fullName;
  final bool isDeleted;
  final String createdDate;
  final String? updatedDate;
  final String? creator;
  final String? modifier;
  final String? createdById;
  final String? updatedById;

  User({
    required this.id,
    this.hrId,
    required this.username,
    required this.email,
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
    required this.isDeleted,
    required this.createdDate,
    this.updatedDate,
    this.creator,
    this.modifier,
    this.createdById,
    this.updatedById,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      hrId: json['hrId'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullNameNoAccent: json['fullNameNoAccent'],
      firstNameUnsign: json['firstNameUnsign'],
      lastNameUnsign: json['lastNameUnsign'],
      gender: json['gender'],
      refreshToken: json['refreshToken'],
      avatar: json['avatar'],
      doB: json['doB'],
      fullName: json['fullName'],
      isDeleted: json['isDeleted'] ?? false,
      createdDate: json['createdDate'] ?? '',
      updatedDate: json['updatedDate'],
      creator: json['creator'],
      modifier: json['modifier'],
      createdById: json['createdById'],
      updatedById: json['updatedById'],
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
    };
  }
}
