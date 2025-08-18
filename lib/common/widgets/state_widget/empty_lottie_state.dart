import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tcs_flutter/common/img/img.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class EmptyLottieState extends StatelessWidget {

  const EmptyLottieState({super.key});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Center(
        child: 
            Lottie.asset(
              Img.emptyIcon,
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.5,
              fit: BoxFit.contain,
              frameRate: const FrameRate(60),
              repeat: true,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.error,
                size: 100,
                color: AppColors.primary,
              ),
            )
      ),
    );
  }
}