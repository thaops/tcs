import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfile extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  final String? title;
  final String? subtitle;
  const UserProfile(
      {super.key, this.icon, this.color, this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: Get.width,
        child: Row(children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color,
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          10.horizontalSpace,
          SizedBox(
            width: Get.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextWidget(
                  text: title ?? '',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                4.verticalSpace,
                TextWidget(
                  text: subtitle ?? '',
                  fontSize: 15,
                  minLines: 2,
                  maxLines: 2,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
            size: 16,
          ),
        ]),
      ),
    );
  }
}
