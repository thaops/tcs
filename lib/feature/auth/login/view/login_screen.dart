import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/img/img.dart';
import 'package:tcs_flutter/feature/auth/login/controller/login_controller.dart';
import 'package:tcs_flutter/feature/auth/login/widget/frame_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/widgets/background_fill_view.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controllerlogin = Get.find<LoginController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: SizedBox(
            height: screenHeight,
            width: screenWidth,
            child: BackgroundFillView(
              child: _buildActionLogin(controllerlogin),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildActionLogin(LoginController controllerlogin) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogo(controllerlogin),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FrameLogin(
              controllerLogin: controllerlogin,
              passwordControllerl: controllerlogin.passwordController,
              usernameController: controllerlogin.usernameController,
            ),
          ],
        ),
      ],
    );
  }

  GestureDetector _buildLogo(LoginController controllerlogin) {
    return GestureDetector(
        child: Padding(
          padding: EdgeInsets.only(
            top: 44.h,
            bottom: 90.h,
          ),
          child: Image.asset(
            Img.logo,
            width: 152.w,
            height: 80.h,
          ),
        ),
        onTap: () {
          controllerlogin.tapCount++;
          controllerlogin.showConfigDialog();
        });
  }
}
