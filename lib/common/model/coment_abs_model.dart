abstract class CommentAbsModel {
  void deleteComment(String commentId, {String? parentId});
  Future<void> addComment({
    required String comment,
    required String tId,
    String? parentId,
  });
  Future<void> callDeleteComment(String commentId);
  Future<String> callAddComment(String comment, String tId);
  Future<void> updateComment({
    required String comment,
    required String id,
    required String tId,
    String? parentId,
  });

  Future<void> callUpdateComment(String comment, String id, String tId);
  Future<void> addReply({
    required String parentId,
    required String reply,
    required String tId,
  });
  Future<String> callAddReply(String parentId, String reply, String tId);
}
