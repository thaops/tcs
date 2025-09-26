import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

/// Dialog chọn loại attachment (ảnh hoặc file)
class AttachmentSelectionDialog {
  static Future<List<AttachmentFile>?> show(
    BuildContext context, {
    required List<String> allowedExtensions,
    required int maxFiles,
  }) async {
    return await showDialog<List<AttachmentFile>>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                TextWidget(
                  text: "Chọn loại đính kèm",
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
                SizedBox(height: 8.h),
                TextWidget(
                  text: "Bạn muốn đính kèm ảnh hay file?",
                  fontSize: 14.sp,
                  color: Colors.grey.shade600,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),

                // Options
                Row(
                  children: [
                    // Chọn ảnh
                    Expanded(
                      child: _buildOptionButton(
                        context: context,
                        icon: Icons.photo_library,
                        title: "Chọn ảnh",
                        subtitle: "",
                        color: Colors.blue,
                        onTap:
                            () => _handleImageSelection(
                              context,
                              allowedExtensions,
                              maxFiles,
                            ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Chọn file
                    Expanded(
                      child: _buildOptionButton(
                        context: context,
                        icon: Icons.attach_file,
                        title: "Chọn file",
                        subtitle: "",
                        color: AppColors.primary,
                        onTap:
                            () => _handleFileSelection(
                              context,
                              allowedExtensions,
                              maxFiles,
                            ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Cancel button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: TextWidget(
                      text: "Hủy",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build option button
  static Widget _buildOptionButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32.sp),
            SizedBox(height: 8.h),
            TextWidget(
              text: title,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Handle image selection
  static Future<void> _handleImageSelection(
    BuildContext context,
    List<String> allowedExtensions,
    int maxFiles,
  ) async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        List<AttachmentFile> attachmentFiles =
            images.map((image) {
              return AttachmentFile(
                id:
                    DateTime.now().millisecondsSinceEpoch.toString() +
                    images.indexOf(image).toString(),
                name: image.name,
                size: 0, // ImagePicker không cung cấp size
                path: image.path,
              );
            }).toList();

        Navigator.of(context).pop(attachmentFiles);
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Lỗi khi chọn ảnh: $e');
    }
  }

  /// Handle file selection
  static Future<void> _handleFileSelection(
    BuildContext context,
    List<String> allowedExtensions,
    int maxFiles,
  ) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        List<AttachmentFile> attachmentFiles =
            result.files.map((file) {
              return AttachmentFile(
                id:
                    DateTime.now().millisecondsSinceEpoch.toString() +
                    result.files.indexOf(file).toString(),
                name: file.name,
                size: file.size,
                path: file.path,
              );
            }).toList();

        Navigator.of(context).pop(attachmentFiles);
      }
    } catch (e) {
      _showErrorSnackBar(context, 'Lỗi khi chọn file: $e');
    }
  }

  /// Show error snackbar
  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

/// Attachment file model
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
