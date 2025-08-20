class Approver {
  final String id;
  final int hrId;
  final String fullName;
  final String email;
  final String groupName;
  final int step;

  Approver({
    required this.id,
    required this.hrId,
    required this.fullName,
    required this.email,
    required this.groupName,
    required this.step,
  });

  factory Approver.fromJson(Map<String, dynamic> json) {
    return Approver(
      id: json['id'] as String,
      hrId: json['hrId'] as int,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      groupName: json['groupName'] as String,
      step: json['step'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hrId': hrId,
      'fullName': fullName,
      'email': email,
      'groupName': groupName,
      'step': step,
    };
  }
}
