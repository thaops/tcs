import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:get/get.dart';

/// Service xử lý hiển thị image gallery
class ImageGalleryService {
  static final ImageGalleryService _instance = ImageGalleryService._internal();
  factory ImageGalleryService() => _instance;
  ImageGalleryService._internal();

  /// Hiển thị image gallery với danh sách ảnh
  void showImageGallery(
    BuildContext context,
    List<dynamic> attachments,
    dynamic currentAttachment,
  ) {
    final imageUrls =
        attachments
            .where((att) => _isImageFile(att.type))
            .map((att) => att.url)
            .toList();

    final initialIndex = imageUrls.indexOf(currentAttachment.url);

    Get.to(
      Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            currentAttachment.name ?? 'Image',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: PhotoViewGallery.builder(
          itemCount: imageUrls.length,
          builder: (context, index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider(imageUrls[index]),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2.0,
            );
          },
          scrollPhysics: BouncingScrollPhysics(),
          backgroundDecoration: BoxDecoration(color: Colors.black),
          pageController: PageController(
            initialPage: initialIndex >= 0 ? initialIndex : 0,
          ),
        ),
      ),
    );
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
