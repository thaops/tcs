class TaskRequesModel {
  final String assigneeId;
  final String description;
  final String startDate;
  final String finishDate;
  final bool force;
  final String? priority;
  final String? projectId;
  final String role;
  final String? state;
  final int type;
  final String wbsId;

  TaskRequesModel({
    required this.assigneeId,
    required this.description,
    required this.startDate,
    required this.finishDate,
    required this.force,
    required this.priority,
    required this.projectId,
    required this.role,
    required this.state,
    required this.type,
    required this.wbsId,
  });

  Map<String, dynamic> toJson() {
    return {
      'assigneeId': assigneeId,
      'description': description,
      'startDate': startDate,
      'finishDate': finishDate,
      'force': force,
      'priority': priority,
      'projectId': projectId,
      'role': role,
      'state': state,
      'type': type,
      'wbsId': wbsId,
    };
  }
}
