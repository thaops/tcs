class DayOff {
  final String id;
  final String employeeCode;
  final String fullName;
  final String categoryCode;
  final String reason;
  final DateTime fromDate;
  final DateTime toDate;
  final String bgColor;
  final String textColor;
  final DateTime createdDate;
  final String createdName;
  final DateTime? updatedDate;
  final String updater;

  DayOff({
    required this.id,
    required this.employeeCode,
    required this.fullName,
    required this.categoryCode,
    required this.reason,
    required this.fromDate,
    required this.toDate,
    required this.bgColor,
    required this.textColor,
    required this.createdDate,
    required this.createdName,
    this.updatedDate,
    required this.updater,
  });

  factory DayOff.fromJson(Map<String, dynamic> json) {
    DateTime _safeParse(String? v) {
      if (v == null || v.isEmpty) return DateTime.now();
      try {
        return DateTime.parse(v);
      } catch (_) {
        return DateTime.now();
      }
    }

    return DayOff(
      id: json['id'] ?? '',
      employeeCode: json['employeeCode'] ?? '',
      fullName: json['fullName'] ?? '',
      categoryCode: json['categoryCode'] ?? '',
      reason: json['reason'] ?? '',
      fromDate: _safeParse(json['fromDate']?.toString()),
      toDate: _safeParse(json['toDate']?.toString()),
      bgColor: json['bgColor'] ?? '',
      textColor: json['textColor'] ?? '',
      createdDate: _safeParse(json['createdDate']?.toString()),
      createdName: json['createdName'] ?? '',
      updatedDate:
          json['updatedDate'] != null
              ? _safeParse(json['updatedDate']?.toString())
              : null,
      updater: json['updater'] ?? '',
    );
  }

  @override
  String toString() {
    return 'DayOff{id: $id, employeeCode: $employeeCode, fullName: $fullName, '
        'categoryCode: $categoryCode, reason: $reason, fromDate: $fromDate, '
        'toDate: $toDate, bgColor: $bgColor, textColor: $textColor, '
        'createdDate: $createdDate, createdName: $createdName, '
        'updatedDate: $updatedDate, updater: $updater}';
  }
}
