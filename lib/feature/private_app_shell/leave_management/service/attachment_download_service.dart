import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'dart:io';

/// Service xử lý download và lưu file attachments
class AttachmentDownloadService {
  static final AttachmentDownloadService _instance =
      AttachmentDownloadService._internal();
  factory AttachmentDownloadService() => _instance;
  AttachmentDownloadService._internal();

  /// Download attachment và lưu vào thiết bị
  Future<Map<String, dynamic>> downloadAttachment(
    dynamic attachment,
    BuildContext context,
  ) async {
    if (attachment?.url == null || attachment.url.isEmpty) {
      return {
        'success': false,
        'error': 'URL không hợp lệ',
        'fileName': '',
        'filePath': '',
      };
    }

    final isImage = _isImageFile(attachment.type);

    try {
      bool success = false;
      String fileName = '';
      String filePath = '';

      if (isImage) {
        // For images, save to gallery
        final result = await _saveImageToGallery(attachment);
        success = result['success'] as bool;
        fileName = result['fileName'] as String;
        filePath = result['filePath'] as String;
      } else {
        // For other files, save to app directory
        final result = await _saveFileToAppDirectory(attachment);
        success = result['success'] as bool;
        fileName = result['fileName'] as String;
        filePath = result['filePath'] as String;
      }

      return {'success': success, 'fileName': fileName, 'filePath': filePath};
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'fileName': '',
        'filePath': '',
      };
    }
  }

  /// Lưu ảnh vào thư viện ảnh
  Future<Map<String, dynamic>> _saveImageToGallery(dynamic attachment) async {
    try {
      // Check if Gal has access to photos
      final hasAccess = await Gal.hasAccess();
      if (!hasAccess) {
        final granted = await Gal.requestAccess();
        if (!granted) {
          return {
            'success': false,
            'fileName': '',
            'filePath': '',
            'error': 'Không có quyền truy cập thư viện ảnh',
          };
        }
      }

      // Download image to temp directory first
      final directory = await getTemporaryDirectory();
      final fileName =
          attachment.name ??
          'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final tempPath = '${directory.path}/$fileName';

      // Download image
      final dio = Dio();
      await dio.download(attachment.url, tempPath);

      // Save to gallery using Gal
      await Gal.putImage(tempPath);

      // Clean up temp file
      try {
        await File(tempPath).delete();
      } catch (e) {
        print('Error deleting temp file: $e');
      }

      return {
        'success': true,
        'fileName': fileName,
        'filePath': 'Thư viện ảnh',
      };
    } catch (e) {
      return {
        'success': false,
        'fileName': '',
        'filePath': '',
        'error': e.toString(),
      };
    }
  }

  /// Lưu file vào thư mục ứng dụng
  Future<Map<String, dynamic>> _saveFileToAppDirectory(
    dynamic attachment,
  ) async {
    try {
      // Get app documents directory
      final directory = await getApplicationDocumentsDirectory();

      // Create downloads folder in app directory
      final downloadsPath = Directory('${directory.path}/Downloads');
      if (!await downloadsPath.exists()) {
        await downloadsPath.create(recursive: true);
      }

      // Generate file name
      final fileName =
          attachment.name ??
          'attachment_${DateTime.now().millisecondsSinceEpoch}';
      final filePath = '${downloadsPath.path}/$fileName';

      // Download file using Dio
      final dio = Dio();
      await dio.download(
        attachment.url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).toStringAsFixed(0);
            print('Download progress: $progress%');
          }
        },
      );

      return {
        'success': true,
        'fileName': fileName,
        'filePath': 'Thư mục ứng dụng/Downloads',
      };
    } catch (e) {
      return {
        'success': false,
        'fileName': '',
        'filePath': '',
        'error': e.toString(),
      };
    }
  }

  /// Kiểm tra file có phải là ảnh không
  bool _isImageFile(String? type) {
    if (type == null) return false;
    final lowerType = type.toLowerCase();
    return lowerType == '.jpg' ||
        lowerType == '.jpeg' ||
        lowerType == '.png' ||
        lowerType == '.gif';
  }
}
