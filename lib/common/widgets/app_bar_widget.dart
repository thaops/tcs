import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/design_system/tokens/app_sizes.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double? heightAppBar;
  final bool? isTrueBack;
  final IconData? iconRightfirst;
  final IconData? iconRightSecond;
  final Color? colorfirst;
  final Color? colorSecond;
  final bool? isBack;
  final SizedBox? sizeBox;

  final bool? isTitleCenter;
  final Function()? functionfirst;
  final Function()? functionSecond;

  final IconData? iconRightthird;
  final Color? colorThird;
  final Function()? functionThird;

  final Color? backgroundColor;

  final String? image;

  final Widget? badgeIcon;

  const AppBarWidget({
    super.key,
    this.title,
    this.heightAppBar = 45,
    this.isTrueBack,
    this.iconRightfirst,
    this.iconRightSecond,
    this.colorfirst,
    this.colorSecond,
    this.functionfirst,
    this.functionSecond,
    this.iconRightthird,
    this.colorThird,
    this.functionThird,
    this.isBack = true,
    this.backgroundColor,
    this.sizeBox,
    this.image,
    this.isTitleCenter = true,
    this.badgeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // toolbarHeight: heightAppBar,
      backgroundColor: backgroundColor ?? AppColors.white,
      surfaceTintColor: Colors.transparent,
      leading:
          isBack == false
              ? sizeBox
              : IconButton(
                onPressed: () {
                  Get.back(result: isTrueBack ?? false);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.black,
                  size: AppSizes.iconMedium,
                ),
              ),
      centerTitle: isTitleCenter,
      title:
          title == null
              ? Image.asset(image!, fit: BoxFit.cover, width: 100)
              : TextWidget(
                text: title!,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
      actions: [
        badgeIcon != null ? badgeIcon! : const SizedBox(),
        iconRightthird != null
            ? IconButton(
              onPressed: () {
                functionThird?.call();
              },
              icon: Icon(iconRightthird, color: colorThird),
            )
            : const SizedBox(),

        iconRightSecond != null
            ? IconButton(
              onPressed: () {
                functionSecond?.call();
              },
              icon: Icon(
                iconRightSecond,
                color: colorSecond,
                size: AppSizes.iconMedium,
              ),
            )
            : const SizedBox(),
        iconRightfirst != null
            ? IconButton(
              onPressed: () {
                functionfirst?.call();
              },
              icon: Icon(
                iconRightfirst,
                color: colorfirst,
                size: AppSizes.iconMedium,
              ),
            )
            : SizedBox(),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(heightAppBar ?? kToolbarHeight);
}
