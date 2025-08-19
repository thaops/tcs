import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/common/widgets/widgets/custom_menu.dart';

class MenuUtils {
   Future<void> customMenu(BuildContext context, List<MenuItem> items) async {
    showMenu(
      context: context,
      color: Colors.white,
      clipBehavior: Clip.none,
      position: RelativeRect.fromLTRB(60.h, 60.h, 0.h, 0.h),
      items: [
        PopupMenuItem(
          child: CustomMenu().buildMenu(
           items :items,
          ),
        ),
      ],
    );
  }

}