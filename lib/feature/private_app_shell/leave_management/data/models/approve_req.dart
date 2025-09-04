class ApproveReq {
  final String categoryId;
  final int status;
  final String? note;

  ApproveReq({
    required this.categoryId,
    required this.status,
     this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      "categoryId": categoryId,
      "status": status,
      "note": note,
    };
  }
}
