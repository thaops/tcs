import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/common/design_system/tokens/app_sizes.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class LoadingWidget extends StatelessWidget {
  final Widget? child;
  const LoadingWidget({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child ?? _builLoading();
  }

  ListView _builLoading() {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: AppSizes.paddingMedium.w),
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.symmetric(
      horizontal: AppSizes.paddingSmall,
      vertical: AppSizes.paddingMedium,
    ),
    itemCount: 5, 
    itemBuilder: (context, index) {
      return Shimmer(
        color: AppColors.grey.withOpacity(0.3),
        child: Container(
          margin: EdgeInsets.only(bottom: AppSizes.paddingSmall.w),
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.paddingSmall.w,
            vertical: AppSizes.paddingSmall.w,
          ),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: AppSizes.fontSizeXLarge.h,
                color: Colors.grey[300],
              ),
              SizedBox(height: AppSizes.paddingXSmall.w),
              Row(
                children: [
                  Container(
                    width: 100.w,
                    height: 20.h,
                    color: Colors.grey[300],
                  ),
                  SizedBox(width: AppSizes.paddingSmall.w),
                  Container(
                    width: 80.w,
                    height: 20.h,
                    color: Colors.grey[300],
                  ),
                ],
              ),
              SizedBox(height: AppSizes.paddingXSmall.w),
              Container(
                width: 150.w,
                height: 16.h,
                color: Colors.grey[300],
              ),
              SizedBox(height: AppSizes.paddingSmall.w),
              Divider(
                color: AppColors.grey,
                thickness: 0.5.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100.w,
                    height: 16.h,
                    color: Colors.grey[300],
                  ),
                  Container(
                    width: 80.w,
                    height: 16.h,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
  }
}