import 'dayoff_model.dart';

class Employee {
  final String id;
  final String employeeCode;
  final String? fullName;
  final String? departmentName;
  final String? unionName;
  final List<DayOff> dayOffs;

  // Legacy fields for backward compatibility
  final String? employeeId;
  final String? department;
  final String? avatarUrl;
  final DateTime? fromDate;
  final DateTime? toDate;
  final dynamic totalDay;
  final String? categoryId;
  final String? category;
  final int? status;
  final String? statusLabel;
  final DateTime? approvalDate;
  final DateTime? lastApprovalDate;
  final String? reason;
  final String? note;
  final DateTime? createdDate;
  final bool? isDeleted;

  Employee({
    required this.id,
    required this.employeeCode,
    this.fullName,
    this.departmentName,
    this.unionName,
    this.dayOffs = const [],

    // Legacy fields
    this.employeeId,
    this.department,
    this.avatarUrl,
    this.fromDate,
    this.toDate,
    this.totalDay,
    this.categoryId,
    this.category,
    this.status,
    this.statusLabel,
    this.approvalDate,
    this.lastApprovalDate,
    this.reason,
    this.note,
    this.createdDate,
    this.isDeleted,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    // Known mapping: departmentId (UUID) -> department name
    const Map<String, String> _departmentIdToName = {
      'e5dc9202-25ad-49de-b5c9-16852378f1bd': 'Bộ phận quản lý',
      '45126c87-7c7b-4885-a6fb-17b2b1ad3190': 'Phòng dự án',
      '32106856-63c8-4a61-8799-59434f018d4b': 'Phòng kỹ thuật',
      'fb1df35f-0276-4226-8da1-685bbc6519f2': 'Văn phòng',
      'c3dce574-b18f-419d-94c1-09f4937c99c3': 'Parttime',
    };

    bool _looksLikeUuid(String s) {
      final v = s.toLowerCase();
      // simple UUID v4-ish check
      return RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',
          ).hasMatch(v) ||
          RegExp(
            r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
          ).hasMatch(v);
    }

    // Robust department parsing: support String, Map, or fallback from departmentId
    String? _parseDepartment(dynamic raw, Map<String, dynamic> source) {
      // 1) If raw is a non-empty String and not a UUID, assume it's a name
      if (raw is String && raw.trim().isNotEmpty && !_looksLikeUuid(raw)) {
        return raw.trim();
      }
      // 2) If raw is a Map with name-like keys
      if (raw is Map) {
        final dyn = raw;
        final byName = dyn['name'] ?? dyn['departmentName'] ?? dyn['label'];
        if (byName is String && byName.trim().isNotEmpty) return byName.trim();
        // or an id in map
        final byId = dyn['id']?.toString();
        if (byId != null && _departmentIdToName.containsKey(byId)) {
          return _departmentIdToName[byId];
        }
      }
      // 3) Try departmentId at root
      final depId = source['departmentId']?.toString();
      if (depId != null && depId.isNotEmpty) {
        final mapped = _departmentIdToName[depId];
        if (mapped != null && mapped.isNotEmpty) return mapped;
      }
      // 4) If root department is a UUID string, map via known table
      if (raw is String && _looksLikeUuid(raw)) {
        final mapped = _departmentIdToName[raw];
        if (mapped != null && mapped.isNotEmpty) return mapped;
      }
      // 5) Alternative name keys at root
      final alt =
          (source['departmentName'] as String?) ??
          (source['deptName'] as String?);
      if (alt != null && alt.trim().isNotEmpty) return alt.trim();
      return null;
    }

    DateTime? _safeParse(String? v) {
      if (v == null || v.isEmpty) return null;
      try {
        return DateTime.parse(v);
      } catch (_) {
        return null;
      }
    }

    final String? depName = _parseDepartment(json['department'], json);

    // Parse dayOffs array
    List<DayOff> dayOffsList = [];
    if (json['dayOffs'] is List) {
      dayOffsList =
          (json['dayOffs'] as List)
              .map((dayOffJson) => DayOff.fromJson(dayOffJson))
              .toList();
    }

    return Employee(
      id: json['id'] ?? '',
      employeeCode: json['employeeCode'] ?? '',
      fullName: json['fullName'] ?? '',
      departmentName: json['departmentName'] ?? depName,
      unionName: json['unionName'] ?? '',
      dayOffs: dayOffsList,

      // Legacy fields for backward compatibility
      employeeId: json['employeeId'] ?? json['employeeCode'] ?? '',
      department: depName,
      avatarUrl: json['avatarUrl'],
      fromDate: _safeParse(json['fromDate']?.toString()),
      toDate: _safeParse(json['toDate']?.toString()),
      totalDay:
          (json['totalDay'] is double)
              ? json['totalDay']
              : (json['totalDay']?.toInt() ?? 0),
      categoryId: json['categoryId'],
      category: json['category'] ?? '',
      status: json['status'] ?? 0,
      statusLabel: json['statusLabel'] ?? '',
      approvalDate: _safeParse(json['approvalDate']?.toString()),
      lastApprovalDate: _safeParse(json['lastApprovalDate']?.toString()),
      reason: json['reason'] ?? '',
      note: json['note'],
      createdDate: _safeParse(json['createdDate']?.toString()),
      isDeleted: json['isDeleted'] ?? false,
    );
  }

  @override
  String toString() {
    return 'Employee{id: $id, employeeCode: $employeeCode, fullName: $fullName, '
        'departmentName: $departmentName, unionName: $unionName, dayOffs: ${dayOffs.length} items, '
        'employeeId: $employeeId, department: $department, avatarUrl: $avatarUrl, '
        'fromDate: $fromDate, toDate: $toDate, totalDay: $totalDay, '
        'categoryId: $categoryId, category: $category, status: $status, statusLabel: $statusLabel, '
        'approvalDate: $approvalDate, lastApprovalDate: $lastApprovalDate, reason: $reason, '
        'note: $note, createdDate: $createdDate, isDeleted: $isDeleted}';
  }
}
