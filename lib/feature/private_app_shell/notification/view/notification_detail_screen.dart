import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tcs_flutter/common/widgets/app_bar_widget.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/notification/data/models/notification_model.dart';
import 'package:tcs_flutter/router/app_router.dart';

class NotificationDetailScreen extends StatelessWidget {
  const NotificationDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, dynamic>?;
    final notification = arguments?['notification'] as NotificationModel?;
    final sourceId = arguments?['sourceId'] as String?;

    if (notification == null) {
      return Scaffold(
        appBar: AppBarWidget(
          title: 'Chi tiết thông báo',
          isBack: true,
        ),
        body: Center(
          child: TextWidget(
            text: 'Không tìm thấy thông báo',
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget(
        title: 'Chi tiết thông báo',
        isBack: true,
        isTitleCenter: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (notification.isPinned)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.push_pin,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 4),
                    TextWidget(
                      text: 'Đã ghim',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            if (notification.isPinned) SizedBox(height: 16),
            TextWidget(
              text: notification.title,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: 4),
                TextWidget(
                  text: dateFormat.format(notification.createdDate),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade600,
                ),
                if (notification.source.isNotEmpty) ...[
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextWidget(
                      text: notification.source,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextWidget(
                text: notification.content,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: AppColors.black,
              ),
            ),
            if (sourceId != null && sourceId.isNotEmpty) ...[
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (notification.source == 'DayOff') {
                      Get.toNamed(
                        AppRouter.leaveDetail,
                        arguments: {'leaveId': sourceId},
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: TextWidget(
                    text: 'Xem chi tiết',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

