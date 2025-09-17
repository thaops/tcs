import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

/// Dialog components cho leave request
class LeaveRequestDialogs {
  /// Hiển thị dialog xác nhận quyền truy cập thư viện ảnh
  static void showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Row(
              children: [
                Icon(
                  Icons.photo_library,
                  color: Color(0xFF3B82F6),
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  'Cần quyền truy cập',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ứng dụng cần quyền truy cập thư viện ảnh để lưu ảnh.',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Color(0xFFE5E7EB)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cách cấp quyền:',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '1. Nhấn "Cài đặt" bên dưới\n2. Tìm "Quyền" hoặc "Permissions"\n3. Bật "Ảnh" hoặc "Photos"\n4. Quay lại ứng dụng và thử tải lại',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Color(0xFF6B7280),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Hủy',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3B82F6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.r,
                    vertical: 10.r,
                  ),
                ),
                child: Text(
                  'Cài đặt',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  /// Hiển thị dialog thành công tải file
  static void showDownloadSuccessDialog(
    BuildContext context,
    String fileName,
    String filePath,
  ) {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF10B981), size: 24.sp),
                SizedBox(width: 12.w),
                Text(
                  'Tải thành công',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'File đã được tải về máy thành công!',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Color(0xFFBBF7D0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tên file:',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF059669),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        fileName,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Color(0xFF047857),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Vị trí:',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF059669),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Thư mục ứng dụng/Downloads',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Color(0xFF047857),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  '💡 File được lưu trong thư mục riêng của ứng dụng, không cần quyền truy cập bộ nhớ.',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Color(0xFF6B7280),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.r,
                    vertical: 10.r,
                  ),
                ),
                child: Text(
                  'Đóng',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  /// Hiển thị dialog loading khi tải file
  static void showLoadingDialog(BuildContext context, bool isImage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) => Center(
            child: Container(
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Color(0xFF3B82F6)),
                  SizedBox(height: 16.h),
                  Text(
                    isImage ? 'Đang lưu ảnh...' : 'Đang tải file...',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
