class UserListModel {
  final String? id;
  final String? fullName;
  final String? avatarUrl;
  final String? department;          // Tên phòng ban nếu API trả ra string
  final List<String>? departmentIds; // API hiện trả mảng id phòng ban
  final int? userType;
  final String? userTypeLabel;
  final String? bankInfo;            // Ghép bankName - bankAccount nếu không có bankInfo
  final String? email;
  final String? tel;                 // Map từ phone
  final String? startDate;
  final String? cccd;
  final String? licenseDate;
  final String? licensePlace;
  final String? signedDate;
  final String? expiredDate;
  final bool? isDeleted;

  // Một số field phụ hay gặp trong JSON mẫu (tuỳ dùng)
  final double? kpi;
  final bool? gender;
  final String? birthday; // giữ dạng String ISO cho an toàn hiển thị

  const UserListModel({
    this.id,
    this.fullName,
    this.avatarUrl,
    this.department,
    this.departmentIds,
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
    this.kpi,
    this.gender,
    this.birthday,
  });

  /// Map linh hoạt cho cả 2 dạng:
  /// - Dạng cũ: fullName, tel, bankInfo, department (string)
  /// - Dạng mới: firstname/lastname, phone, bankName/bankAccount, departments (list)
  factory UserListModel.fromJson(Map<String, dynamic> json) {
    // fullName: ưu tiên field có sẵn; nếu không có thì ghép firstname + lastname
    String? _fullName = (json['fullName'] as String?)?.trim();
    if (_fullName == null || _fullName.isEmpty) {
      final fn = (json['firstname'] as String?)?.trim();
      final ln = (json['lastname'] as String?)?.trim();
      // Theo thứ tự VN: Họ + Tên -> lastname firstname
      final combined = [ln, fn].where((e) => e != null && e!.isNotEmpty).join(' ');
      _fullName = combined.isNotEmpty ? combined : null;
    }

    // tel: ưu tiên "tel", fallback "phone"
    final _tel = (json['tel'] ?? json['phone'])?.toString();

    // bankInfo: ưu tiên sẵn có; nếu không có thì ghép bankName - bankAccount
    String? _bankInfo = (json['bankInfo'] as String?);
    if (_bankInfo == null || _bankInfo.trim().isEmpty) {
      final bankName = (json['bankName'] as String?)?.trim();
      final bankAccount = (json['bankAccount'] as String?)?.trim();
      final parts = [bankName, bankAccount].where((e) => e != null && e!.isNotEmpty).toList();
      if (parts.isNotEmpty) _bankInfo = parts.join(' - ');
    }

    // department: nếu API chỉ trả list id thì giữ null để không hiển thị sai
    String? _department;
    final depRaw = json['department'];
    if (depRaw is String && depRaw.trim().isNotEmpty) {
      _department = depRaw.trim();
    }

    // departmentIds từ "departments": [...]
    List<String>? _departmentIds;
    final deps = json['departments'];
    if (deps is List) {
      _departmentIds = deps.whereType<String>().toList();
    }

    // userType: an toàn cho cả int và string số
    int? _userType;
    final ut = json['userType'];
    if (ut is int) {
      _userType = ut;
    } else if (ut != null) {
      _userType = int.tryParse(ut.toString());
    }

    // kpi: double an toàn
    double? _kpi;
    final k = json['kpi'];
    if (k is num) _kpi = k.toDouble();
    if (k is String) _kpi = double.tryParse(k);

    return UserListModel(
      id: (json['id'] ?? '').toString(),
      fullName: _fullName ?? 'Unknown',
      avatarUrl: (json['avatarUrl'] ?? '').toString(),
      department: _department,                 // để null nếu không có tên phòng ban thật
      departmentIds: _departmentIds,           // giữ id list nếu cần dùng sau
      userType: _userType ?? 0,
      userTypeLabel: (json['userTypeLabel'] as String?) ?? 'Unknown Type',
      bankInfo: _bankInfo ?? 'No Bank Info',
      email: (json['email'] as String?) ?? 'No Email',
      tel: _tel ?? 'No Phone',
      startDate: (json['startDate'] as String?) ?? 'No Start Date',
      cccd: (json['cccd'] as String?) ?? 'No CCCD',
      licenseDate: (json['licenseDate'] as String?) ?? 'No License Date',
      licensePlace: (json['licensePlace'] as String?) ?? 'No License Place',
      signedDate: (json['signedDate'] as String?) ?? 'No Signed Date',
      expiredDate: (json['expiredDate'] as String?) ?? 'No Expiry Date',
      isDeleted: (json['isDeleted'] as bool?) ?? false,
      kpi: _kpi,
      gender: json['gender'] is bool ? json['gender'] as bool : null,
      birthday: json['birthday'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'avatarUrl': avatarUrl,
      'department': department,
      'departments': departmentIds,
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
      'kpi': kpi,
      'gender': gender,
      'birthday': birthday,
    };
  }

  UserListModel copyWith({
    String? id,
    String? fullName,
    String? avatarUrl,
    String? department,
    List<String>? departmentIds,
    int? userType,
    String? userTypeLabel,
    String? bankInfo,
    String? email,
    String? tel,
    String? startDate,
    String? cccd,
    String? licenseDate,
    String? licensePlace,
    String? signedDate,
    String? expiredDate,
    bool? isDeleted,
    double? kpi,
    bool? gender,
    String? birthday,
  }) {
    return UserListModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      department: department ?? this.department,
      departmentIds: departmentIds ?? this.departmentIds,
      userType: userType ?? this.userType,
      userTypeLabel: userTypeLabel ?? this.userTypeLabel,
      bankInfo: bankInfo ?? this.bankInfo,
      email: email ?? this.email,
      tel: tel ?? this.tel,
      startDate: startDate ?? this.startDate,
      cccd: cccd ?? this.cccd,
      licenseDate: licenseDate ?? this.licenseDate,
      licensePlace: licensePlace ?? this.licensePlace,
      signedDate: signedDate ?? this.signedDate,
      expiredDate: expiredDate ?? this.expiredDate,
      isDeleted: isDeleted ?? this.isDeleted,
      kpi: kpi ?? this.kpi,
      gender: gender ?? this.gender,
      birthday: birthday ?? this.birthday,
    );
  }
}
