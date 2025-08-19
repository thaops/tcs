import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/img/img.dart';

class BackgroundFillView extends StatelessWidget {
  final Widget child;
  const BackgroundFillView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBackgroud(),
        child,
      ],
    );
  }
}

  Positioned _buildBackgroud() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(Img.backgroudLogin),
          fit: BoxFit.cover,
        )),
      ),
    );
  }