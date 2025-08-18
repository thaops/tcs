import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomUserList extends StatelessWidget {
  final String? department;
  final String? avatar;
  final String? name;
  final String? email;
  final Function? onTap;

  const CustomUserList({super.key, this.email, this.name, this.department, this.avatar, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => onTap!(),
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              avatar ?? '',
            ),  
          ),
          title: TextWidget(
            text: name ?? '',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          subtitle: TextWidget(
            text: email ?? '',
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 16.w), child: Divider()), // Thêm dòng kẻ giữa các nhân viên
      ],
    );
  }
}
