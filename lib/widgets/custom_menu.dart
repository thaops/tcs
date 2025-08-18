import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


class MenuItem {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onTap;

  MenuItem({
    required this.icon,
    required this.text,
    required this.color,
    required this.onTap,
  });
}

class CustomMenu {
  Widget buildMenu({ required List<MenuItem> items}) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...items.map((item) => _buildMenuItem(
            item: item,
          )),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required MenuItem item,
  }) {
    return InkWell(
      onTap: () {
        Get.back(result: false);
        item.onTap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        child: Row(
          children: [
            Icon(item.icon, color: item.color, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              item.text,
              style: TextStyle(
                color: item.color,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}