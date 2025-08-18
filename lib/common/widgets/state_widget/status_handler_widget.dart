import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/widgets/state_widget/empty_lottie_state.dart';
import 'package:tcs_flutter/controllers/base/base_controller.dart';
import 'package:tcs_flutter/common/widgets/state_widget/loading_widget.dart';

// ignore: must_be_immutable
class StatusHandlerWidget extends StatelessWidget {
  final ControllerStatus status;
  final String errorMessage;
  final VoidCallback onRetry;
  final Widget child;
  Widget? loadingWidget;

   StatusHandlerWidget({
    Key? key,
    required this.status,
    required this.errorMessage,
    required this.onRetry,
    required this.child,
    this.loadingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case ControllerStatus.loading:
        return LoadingWidget(child: loadingWidget,);
      case ControllerStatus.empty:
        return const EmptyLottieState();
      case ControllerStatus.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(errorMessage, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      case ControllerStatus.refreshing:
        return Stack(
          children: [
            child,
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        );
      case ControllerStatus.success:
      default:
        return child;
    }
  }
}
