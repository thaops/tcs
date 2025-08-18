import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/state_widget/empty_lottie_state.dart';

class BuildBodyStateWidget<T> extends StatelessWidget {
  final List<T> data; 
  final RxBool isLoading; 
  final RxBool? isError; 
  final Widget child;

  const BuildBodyStateWidget({
    super.key,
    required this.data,
    required this.isLoading,
    this.isError,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        if (isLoading.value) {
          return const SizedBox();
        }
        if (data.isEmpty) {
          return Center(
            child: EmptyLottieState(),
          );
        }
        return child;
      }),
    );
  }
}