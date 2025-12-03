import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/img/img.dart';
import 'package:tcs_flutter/feature/public_app_shell/auth/login/controller/login_controller.dart';
import 'package:tcs_flutter/feature/public_app_shell/auth/login/widget/google_sign_in_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FrameLogin extends StatelessWidget {
  final LoginController controllerLogin;
  
  FrameLogin({
    super.key,
    required this.controllerLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Img.loginImg,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: EdgeInsets.only(
            top: 30.h,
            bottom: 40.h,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
              'Vui lòng đăng nhập Microsoft để sử dụng ứng dụng',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
        ),
        GoogleSignInButton(
          text: 'Đăng nhập với Microsoft',
          iconPath: Img.microssoft,
          onPressed: () async {
            controllerLogin.fetchMicrosoftRedirectUrl(context);
          },
        ),
      ],
    );
  }
}
