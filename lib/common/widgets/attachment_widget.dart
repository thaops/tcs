import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class AttachmentWidget extends StatefulWidget {
  final String label;
  final List<String> attachmentIds;
  final Function(List<String>) onAttachmentsChanged;
  final Function(List<Map<String, dynamic>>)? onAttachmentFilesChanged;
  final Function(String)? onAttachmentDeleted; // Callback khi file bị xóa
  final bool isEnabled;
  final int maxFiles;
  final List<String> allowedExtensions;
  final List<Map<String, dynamic>>? existingAttachmentFiles;

  const AttachmentWidget({
    Key? key,
    required this.label,
    required this.attachmentIds,
    required this.onAttachmentsChanged,
    this.onAttachmentFilesChanged,
    this.onAttachmentDeleted,
    this.isEnabled = true,
    this.maxFiles = 5,
    this.allowedExtensions = const ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    this.existingAttachmentFiles,
  }) : super(key: key);

  @override
  State<AttachmentWidget> createState() => _AttachmentWidgetState();
}

class _AttachmentWidgetState extends State<AttachmentWidget> {
  List<AttachmentFile> _attachments = [];

  @override
  void initState() {
    super.initState();
    _initializeAttachments();
  }

  void _initializeAttachments() {
    // Khởi tạo danh sách file từ existingAttachmentFiles hoặc attachmentIds
    if (widget.existingAttachmentFiles != null &&
        widget.existingAttachmentFiles!.isNotEmpty) {
      _attachments =
          widget.existingAttachmentFiles!
              .map(
                (file) => AttachmentFile(
                  id: file['id'] ?? '',
                  name: file['name'] ?? 'File đính kèm',
                  size: file['size'] ?? 0,
                  path: file['path'],
                  url: file['url'],
                ),
              )
              .toList();
    } else {
      _attachments =
          widget.attachmentIds
              .map(
                (id) => AttachmentFile(id: id, name: 'File đính kèm', size: 0),
              )
              .toList();
    }
  }

  Future<void> _pickFiles() async {
    if (!widget.isEnabled) return;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: widget.allowedExtensions,
        allowMultiple: true,
      );

      if (result != null) {
        List<AttachmentFile> newFiles =
            result.files.map((file) {
              return AttachmentFile(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                name: file.name,
                size: file.size,
                path: file.path,
              );
            }).toList();

        // Kiểm tra giới hạn số file
        if (_attachments.length + newFiles.length > widget.maxFiles) {
          _showSnackBar('Chỉ được đính kèm tối đa ${widget.maxFiles} file');
          return;
        }

        setState(() {
          _attachments.addAll(newFiles);
        });

        // Cập nhật danh sách ID
        List<String> newIds = _attachments.map((file) => file.id).toList();
        widget.onAttachmentsChanged(newIds);

        // Cập nhật danh sách file thực tế
        if (widget.onAttachmentFilesChanged != null) {
          List<Map<String, dynamic>> allFiles =
              _attachments
                  .map(
                    (file) => {
                      'id': file.id,
                      'path': file.path,
                      'name': file.name,
                      'size': file.size,
                      'url': file.url,
                    },
                  )
                  .toList();
          widget.onAttachmentFilesChanged!(allFiles);
        }
      }
    } catch (e) {
      _showSnackBar('Lỗi khi chọn file: $e');
    }
  }

  void _removeAttachment(int index) {
    final removedAttachment = _attachments[index];

    setState(() {
      _attachments.removeAt(index);
    });

    // Thông báo file bị xóa nếu có originalId (file hiện có từ server)
    if (widget.onAttachmentDeleted != null && removedAttachment.url != null) {
      // Đây là file hiện có từ server, cần thông báo để xóa
      widget.onAttachmentDeleted!(removedAttachment.id);
    }

    // Cập nhật danh sách ID
    List<String> newIds = _attachments.map((file) => file.id).toList();
    widget.onAttachmentsChanged(newIds);

    // Cập nhật danh sách file thực tế
    if (widget.onAttachmentFilesChanged != null) {
      List<Map<String, dynamic>> remainingFiles =
          _attachments
              .map(
                (file) => {
                  'id': file.id,
                  'path': file.path,
                  'name': file.name,
                  'size': file.size,
                  'url': file.url,
                },
              )
              .toList();
      widget.onAttachmentFilesChanged!(remainingFiles);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  bool _isImageFile(String fileName) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    final extension = fileName.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  Widget _buildImagePreview(AttachmentFile attachment) {
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.grey.shade200,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: _buildImageContent(attachment),
      ),
    );
  }

  Widget _buildImageContent(AttachmentFile attachment) {
    // Ưu tiên hiển thị ảnh từ file local (file mới được chọn)
    if (attachment.path != null) {
      return Image.file(
        File(attachment.path!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder();
        },
      );
    }

    // Hiển thị ảnh từ URL (attachment hiện có từ server)
    if (attachment.url != null && attachment.url!.isNotEmpty) {
      return Image.network(
        attachment.url!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildImagePlaceholder();
        },
      );
    }

    // Fallback: hiển thị placeholder
    return _buildImagePlaceholder();
  }

  Widget _buildFilePreview(AttachmentFile attachment) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            _getFileIcon(attachment.name),
            color: AppColors.primary,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextWidget(
                text: _truncateFileName(attachment.name),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.black,
                maxLines: 1,
              ),
              if (attachment.size > 0)
                TextWidget(
                  text: _formatFileSize(attachment.size),
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: 120.w,
      height: 120.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Icon(Icons.image, color: Colors.grey.shade400, size: 30.sp),
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'txt':
        return Icons.text_snippet;
      case 'zip':
      case 'rar':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _truncateFileName(String fileName) {
    if (fileName.length <= 15) return fileName;
    final extension = fileName.split('.').last;
    final nameWithoutExt = fileName.substring(0, fileName.lastIndexOf('.'));
    if (nameWithoutExt.length <= 12) return fileName;
    return '${nameWithoutExt.substring(0, 12)}...$extension';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: widget.label,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        SizedBox(height: 10.h),

        // Nút thêm file
        if (widget.isEnabled && _attachments.length < widget.maxFiles)
          GestureDetector(
            onTap: _pickFiles,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.attach_file,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  TextWidget(
                    text: 'Thêm file đính kèm',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),

        SizedBox(height: 8.h),

        // Danh sách file đã chọn với preview ảnh
        if (_attachments.isNotEmpty) ...[
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: List.generate(_attachments.length, (index) {
              final attachment = _attachments[index];
              final isImage = _isImageFile(attachment.name);

              return Container(
                margin: EdgeInsets.only(right: 8.w, bottom: 8.h),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Container chính cho ảnh/file
                    Container(
                      padding: isImage ? EdgeInsets.zero : EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color:
                            isImage ? Colors.transparent : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                        border:
                            isImage
                                ? null
                                : Border.all(color: Colors.grey.shade200),
                      ),
                      child:
                          isImage
                              ? _buildImagePreview(attachment)
                              : _buildFilePreview(attachment),
                    ),
                    // Nút xóa với background tròn - đặt ngoài container chính
                    if (widget.isEnabled)
                      Positioned(
                        top: -8.h,
                        right: -8.w,
                        child: GestureDetector(
                          onTap: () => _removeAttachment(index),
                          child: Container(
                            width: 28.w,
                            height: 28.h,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],

        // Thông tin giới hạn
        if (widget.isEnabled)
          Padding(
            padding: EdgeInsets.only(top: 4.h),
            child: TextWidget(
              text:
                  'Tối đa ${widget.maxFiles} file. Định dạng: ${widget.allowedExtensions.join(', ')}',
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
            ),
          ),
      ],
    );
  }
}

class AttachmentFile {
  final String id;
  final String name;
  final int size;
  final String? path;
  final String? url;

  AttachmentFile({
    required this.id,
    required this.name,
    required this.size,
    this.path,
    this.url,
  });
}
