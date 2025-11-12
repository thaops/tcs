class NotificationModel {
  final String id;
  final String source;
  final String sourceId;
  final String title;
  final String content;
  final bool isRead;
  final bool isPinned;
  final bool isSaved;
  final DateTime createdDate;

  NotificationModel({
    required this.id,
    required this.source,
    required this.sourceId,
    required this.title,
    required this.content,
    required this.isRead,
    required this.isPinned,
    required this.isSaved,
    required this.createdDate,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    DateTime _safeParse(String? v) {
      if (v == null || v.isEmpty) return DateTime.now();
      try {
        return DateTime.parse(v);
      } catch (e) {
        return DateTime.now();
      }
    }

    return NotificationModel(
      id: json['id']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      sourceId: json['sourceId']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      isRead: json['isRead'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      isSaved: json['isSaved'] as bool? ?? false,
      createdDate: _safeParse(json['createdDate']?.toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source,
      'sourceId': sourceId,
      'title': title,
      'content': content,
      'isRead': isRead,
      'isPinned': isPinned,
      'isSaved': isSaved,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    String? id,
    String? source,
    String? sourceId,
    String? title,
    String? content,
    bool? isRead,
    bool? isPinned,
    bool? isSaved,
    DateTime? createdDate,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      source: source ?? this.source,
      sourceId: sourceId ?? this.sourceId,
      title: title ?? this.title,
      content: content ?? this.content,
      isRead: isRead ?? this.isRead,
      isPinned: isPinned ?? this.isPinned,
      isSaved: isSaved ?? this.isSaved,
      createdDate: createdDate ?? this.createdDate,
    );
  }
}

class NotificationListResponse {
  final int statusCode;
  final String message;
  final int totalRecord;
  final List<NotificationModel> data;

  NotificationListResponse({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    required this.data,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    return NotificationListResponse(
      statusCode: json['statusCode'] as int? ?? 200,
      message: json['message']?.toString() ?? '',
      totalRecord: json['totalRecord'] as int? ?? 0,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (e) => NotificationModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class NotificationDetailResponse {
  final int statusCode;
  final String message;
  final int totalRecord;
  final NotificationModel data;

  NotificationDetailResponse({
    required this.statusCode,
    required this.message,
    required this.totalRecord,
    required this.data,
  });

  factory NotificationDetailResponse.fromJson(Map<String, dynamic> json) {
    return NotificationDetailResponse(
      statusCode: json['statusCode'] as int? ?? 200,
      message: json['message']?.toString() ?? '',
      totalRecord: json['totalRecord'] as int? ?? 0,
      data: NotificationModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
