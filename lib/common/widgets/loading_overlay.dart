import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tcs_flutter/common/img/img.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final bool isTwoLoading;
  final Color backgroundColor;
  final double backgroundOpacity;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.isTwoLoading = false,
    this.backgroundColor = Colors.black,
    this.backgroundOpacity = 0.1,
  }) : super(key: key);

  bool get _showOverlay => isLoading || isTwoLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        AnimatedOpacity(
          opacity: _showOverlay ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300), // Thời gian hiệu ứng
          curve: Curves.easeInOut, // Đường cong mượt mà
          child:
              _showOverlay
                  ? RepaintBoundary(
                    child: IgnorePointer(
                      ignoring: !_showOverlay,
                      child: Container(
                        color: backgroundColor.withOpacity(backgroundOpacity),
                        child:
                            isLoading
                                ? Center(
                                  child: RepaintBoundary(
                                    child: Container(
                                      height: (MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.18)
                                          .clamp(100, 200),
                                      width: (MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.35)
                                          .clamp(150, 300),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Semantics(
                                        label: 'Đang tải',
                                        child: Center(
                                          child: Lottie.asset(
                                            Img.loading_lottie,
                                            width: (MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.25)
                                                .clamp(80, 150),
                                            height: (MediaQuery.of(
                                                      context,
                                                    ).size.width *
                                                    0.25)
                                                .clamp(80, 150),
                                            fit: BoxFit.contain,
                                            frameRate: FrameRate(60),
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              debugPrint(
                                                'Lottie error: $error',
                                              );
                                              return const CircularProgressIndicator(
                                                color: Colors.blue,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                : null,
                      ),
                    ),
                  )
                  : null,
        ),
      ],
    );
  }
}
