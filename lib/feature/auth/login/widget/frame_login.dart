import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tcs_flutter/common/img/img.dart';
import 'package:tcs_flutter/common/utils/check_awaiting_services.dart';
import 'package:tcs_flutter/common/widgets/custom_text_field.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/auth/login/controller/login_controller.dart';
import 'package:tcs_flutter/feature/auth/login/widget/google_sign_in_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class FrameLogin extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordControllerl;
  final LoginController controllerLogin;
  FrameLogin(
      {super.key,
      required this.usernameController,
      required this.passwordControllerl,
      required this.controllerLogin});

  @override
  Widget build(BuildContext context) {
    CheckAwaitingServices checkAwaitingServices =
        CheckAwaitingServices(GetStorage());
    return FutureBuilder<bool>(
        future: checkAwaitingServices.getawaiting(),
        builder: (context, snapshot) {
          bool awaiting = snapshot.data ?? false;
          if (awaiting) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:24.0, vertical: 44),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: usernameController,
                      hintText: 'Username',
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      controller: passwordControllerl,
                      hintText: 'Password',
                      suffixIcon: Icons.visibility,
                      obscureText: true,
                      maxLines: 1,
                    ),
                    SizedBox(height: 35),
                    Container(
                      width: Get.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          controllerLogin.loginFramework(context);
                        },
                        child: Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          } else {
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
                // SizedBox(height: 16.h),
                // GoogleSignInButton(
                //   text: 'Đăng nhập với Google',
                //   iconPath: Img.google,
                //   onPressed: () async {
                //     controllerLogin.loginWithGoogle(context);
                //   },
                // ),
              ],
            );
          }
        });
  }
}
