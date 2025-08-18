import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/app_bar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'microsoft_controller.dart';

class LoginWithMicrosoft extends StatelessWidget {
  const LoginWithMicrosoft({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Login with Microsoft',
        isTitleCenter: false,
      ),
      body: GetBuilder<MicrosoftController>(
        init: MicrosoftController(),
        builder: (controller) =>
            WebViewWidget(controller: controller.webViewController)),
    );
  }
}
