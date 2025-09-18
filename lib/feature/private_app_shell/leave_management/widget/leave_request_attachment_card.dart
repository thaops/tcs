import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Attachment card widget hiển thị danh sách file đính kèm
class LeaveRequestAttachmentCard extends StatelessWidget {
  final List<dynamic>? attachments;
  final Function(dynamic) onDownloadAttachment;
  final Function(dynamic) onShowImageGallery;

  const LeaveRequestAttachmentCard({
    Key? key,
    required this.attachments,
    required this.onDownloadAttachment,
    required this.onShowImageGallery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (attachments?.isEmpty != false) {
      return SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 16.h),
            ...(attachments?.map(
                  (attachment) => _buildAttachmentItem(attachment),
                ) ??
                []),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Color(0xFF8B5CF6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.attach_file, color: Color(0xFF8B5CF6), size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Text(
          "Tài liệu đính kèm",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
          decoration: BoxDecoration(
            color: Color(0xFF8B5CF6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            "${attachments?.length ?? 0} file",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8B5CF6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentItem(dynamic attachment) {
    final isImage = _isImageFile(attachment.type);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: isImage ? () => onShowImageGallery(attachment) : null,
            child: Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color:
                    isImage
                        ? Color(0xFF3B82F6).withOpacity(0.1)
                        : Color(0xFF6B7280).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child:
                  isImage
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: CachedNetworkImage(
                          imageUrl: attachment.url ?? '',
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Icon(
                                Icons.image,
                                color: Color(0xFF3B82F6),
                                size: 20.sp,
                              ),
                          errorWidget:
                              (context, url, error) => Icon(
                                Icons.image,
                                color: Color(0xFF3B82F6),
                                size: 20.sp,
                              ),
                        ),
                      )
                      : Icon(
                        Icons.insert_drive_file,
                        color: Color(0xFF6B7280),
                        size: 20.sp,
                      ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attachment.name ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.r,
                        vertical: 2.r,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFF6B7280).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        attachment.type?.toUpperCase() ?? 'FILE',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      _formatFileSize(attachment.size),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: IconButton(
              icon: Icon(Icons.download, color: Color(0xFF3B82F6), size: 20.sp),
              onPressed: () => onDownloadAttachment(attachment),
            ),
          ),
        ],
      ),
    );
  }

  bool _isImageFile(String? type) {
    if (type == null) return false;
    final lowerType = type.toLowerCase();
    return lowerType == '.jpg' ||
        lowerType == '.jpeg' ||
        lowerType == '.png' ||
        lowerType == '.gif';
  }

  String _formatFileSize(int? size) {
    if (size == null) return '';
    if (size < 1024) return '${size} B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
