import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/common/Services/services.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/common/utils/show_dialog_set_url.dart';
import 'package:tcs_flutter/router/app_router.dart';
import 'package:tcs_flutter/src/api/api_service.dart';
import 'package:tcs_flutter/src/api/models/apiResponse_model.dart';
import 'package:tcs_flutter/src/services/lib/services/auth_service.dart';

class LoginController extends GetxController {
  DioApi dioApi = DioApi();
  Dio dio = Dio();
  
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();
  final ApiService apiService = ApiService();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  RxInt tapCount = 0.obs;
  final baseUrlController = TextEditingController();
  RxBool isLoadingMicrosoft = false.obs;
  RxString? microsoftRedirectUrl = RxString('');
  StreamSubscription? _sub;
  RxBool isFetchingUrl = false.obs;
  String url = '';

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    _sub?.cancel();
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> fetchMicrosoftRedirectUrl(BuildContext context) async {
    if (isFetchingUrl.value) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          const Center(child: CircularProgressIndicator()),
    );
    isFetchingUrl.value = true;
    isLoadingMicrosoft.value = true;

    try {
      final response = await dio.get(
        ApiEndpoints.loginUrlMicrosoft(0, 1),
      );
      print(response.data);
      print(ApiEndpoints.loginUrlMicrosoft(0, 1));
      Navigator.pop(context);
      if (response.statusCode == 200) {
        microsoftRedirectUrl?.value = response.data['data']['url'];
        goMicrosoftLogin();
      } else {
        Get.snackbar("Thông báo", "Lấy URL thất bại: ${response.statusCode}");
      }
    } catch (e) {
      print("Lỗi fetchMicrosoftRedirectUrl: $e");
      Get.snackbar("Thông báo", "Lỗi xác thực: $e");
    } finally {
      isLoadingMicrosoft.value = false;
      isFetchingUrl.value = false;
    }
  }

  Future<void> goMicrosoftLogin() async {
    Get.toNamed(AppRouter.loginWithMicrosoft, arguments: {
      'url': microsoftRedirectUrl?.value,
    })?.then((value) {
      if(value == false){
        Get.snackbar("Thông báo", "Đăng nhập thất bại");
        return;
      }
      if (value != null) {
        loginWithMicrosoftCode(value['code'], Get.context!);
      }
    });
  }

  Future<void> loginWithMicrosoftCode(String code, BuildContext context) async {
    Services services = await Services.create();
    isLoadingMicrosoft.value = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          const Center(child: CircularProgressIndicator()),
    );
    try {
      final response = await dio.post(
        ApiEndpoints.loginMicrosoft,
        data: {
          'token': code,
        },
      );
      if (response.statusCode == 200) {
        final accessToken = response.data['data']['accessToken'].toString();
        saveLoginRouter(services, accessToken, context);
      } else {
        Get.snackbar("Thông báo", "Đăng nhập thất bại: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Thông báo", "Lỗi khi đăng nhập: $e");
    } finally {
      isLoadingMicrosoft.value = false;
      Navigator.pop(context);
    }
  }

  Future<void> loginFramework(BuildContext context) async {
    Services services = await Services.create();
    try {
      if (passwordController.text.isEmpty || usernameController.text.isEmpty) {
        Get.snackbar("Thông báo", "Vui lòng nhập tài khoản");
        return;
      }
      if (passwordController.text != "123456") {
        Get.snackbar("Thông báo", "Tài khoản không đúng");
        return;
      }
      final response = await dioApi.post(ApiEndpoints.loginFrame, data: {
        "userName": usernameController.text,
        "password": passwordController.text
      });
      if (response.data['statusCode'] == 500) {
        Get.snackbar("Thông báo", "Tài khoản không đúng");
        return;
      }
      var accessTokenId = response.data['data']['accessToken'].toString();
      if (response.data['statusCode'] == 200) {
        saveLoginRouter(services, accessTokenId, context);
      }
    } catch (e) {
      print("Lỗi loginFramework: $e");
      Get.snackbar("Thông báo", "Lỗi khi đăng nhập: $e");
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    Services services = await Services.create();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          const Center(child: CircularProgressIndicator()),
    );
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        Navigator.pop(context);
        Get.snackbar("Thông báo", "Không thể lấy access token");
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      String? accessToken = googleAuth.accessToken;
      if (accessToken == null) {
        Navigator.pop(context);
        Get.snackbar("Thông báo", "Không thể lấy access token");
        return;
      }
      print("Google accessToken: $accessToken");
      var response = await Login(accessToken);
      if (response.statusCode != 200) {
        await googleSignIn.signOut();
        Navigator.pop(context);
        Get.snackbar("Thông báo", "Xác thực thất bại");
        return;
      }
      var accessTokenId = response.accessToken.toString();
      saveLoginRouter(services, accessTokenId, context);
    } catch (e) {
      print("Lỗi loginWithGoogle: $e");
      Navigator.pop(context);
      Get.snackbar("Thông báo", "Có lỗi xảy ra: $e");
    }
  }

  void showConfigDialog() {
    ShowDialogSetUrl().showConfigDialog(
      baseUrlController: baseUrlController,
      dioApi: dioApi,
      tapCount: tapCount,
    );
  }

  void saveLoginRouter(
      Services services, String accessTokenId, BuildContext context) async {
    if (accessTokenId.isEmpty) {
      return;
    }
    await services.saveAccessToken(accessTokenId);
    await apiService.getProfile(dioApi);

    Navigator.pop(context);
    Get.offAllNamed(AppRouter.main);
  }

  Future<ApiResponse> Login(String token) async {
    DioApi dioApi = DioApi();
    final response = await dioApi.post(
      ApiEndpoints.login,
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {'token': token},
    );
    print('Response: ${response.data}');
    if (response.statusCode == 200) {
      return ApiResponse.fromJson(response.data);
    } else {
      return ApiResponse(
        statusCode: response.statusCode ?? 500,
        message: 'Request failed with status: ${response.statusCode}',
        totalRecord: 0,
        data: null,
      );
    }
  }
}
