import 'dart:async';

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
import 'package:tcs_flutter/router/one_signal_service.dart';

class LoginController extends GetxController {
  DioApi dioApi = DioApi();
  Dio dio = Dio();

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
    super.onClose();
  }

  Future<void> fetchMicrosoftRedirectUrl(BuildContext context) async {
    if (isFetchingUrl.value) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) =>
              const Center(child: CircularProgressIndicator()),
    );
    isFetchingUrl.value = true;
    isLoadingMicrosoft.value = true;

    try {
      print(
        "ApiEndpoints.loginUrlMicrosoft(0, 1): ${ApiEndpoints.loginUrlMicrosoft(0, 1)}",
      );
      final response = await dio.get(ApiEndpoints.loginUrlMicrosoft(0, 1));
      Navigator.pop(context);
      print(response.data);
      print(ApiEndpoints.loginUrlMicrosoft(0, 1));

      if (response.statusCode == response.data['statusCode']) {
        microsoftRedirectUrl?.value = response.data['data']['url'];
        print(microsoftRedirectUrl?.value);
        goMicrosoftLogin();
      } else {
        Get.snackbar("Thông báo", "Lấy URL thất bại: ${response.statusCode}");
      }
    } catch (e) {
      print("Lỗi fetchMicrosoftRedirectUrl: $e");
      Navigator.pop(context);
    } finally {
      // Navigator.pop(context);
      isLoadingMicrosoft.value = false;
      isFetchingUrl.value = false;
    }
  }

  Future<void> goMicrosoftLogin() async {
    // Kiểm tra GetX context trước khi navigation
    if (Get.context == null) {
      print("❌ GetX context is null, cannot navigate to Microsoft login");
      Get.snackbar("Lỗi", "Không thể đăng nhập. Vui lòng thử lại.");
      return;
    }

    try {
      Get.toNamed(
        AppRouter.loginWithMicrosoft,
        arguments: {'url': microsoftRedirectUrl?.value},
      )?.then((value) {
        print("valueMS: $value");
        if (value == false) {
          Get.snackbar("Thông báo", "Đăng nhập thất bại");
          return;
        }
        if (value != null) {
          print("valueMS: $value");
          // Kiểm tra context trước khi gọi loginWithMicrosoftCode
          if (Get.context != null) {
            loginWithMicrosoftCode(value['code'], Get.context!);
          } else {
            print("❌ GetX context is null in callback");
            Get.snackbar(
              "Lỗi",
              "Không thể hoàn tất đăng nhập. Vui lòng thử lại.",
            );
          }
        }
      });
    } catch (e) {
      print("❌ Error navigating to Microsoft login: $e");
      Get.snackbar(
        "Lỗi",
        "Không thể mở trang đăng nhập Microsoft. Vui lòng thử lại.",
      );
    }
  }

  Future<void> loginWithMicrosoftCode(String code, BuildContext context) async {
    print("codesss: $code");
    Services services = await Services.create();
    isLoadingMicrosoft.value = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (BuildContext context) =>
              const Center(child: CircularProgressIndicator()),
    );
    try {
      final response = await dio.post(
        ApiEndpoints.loginMicrosoft,
        data: {'token': code},
      );
      print("response.datasss: ${response.data}");
      if (response.statusCode == 200) {
        final accessToken = response.data['data']['accessToken'].toString();
        saveLoginRouter(services, accessToken, context);
      } else {
        Get.snackbar("Thông báo", "Đăng nhập thất bại Vui lòng thử lại");
      }
    } catch (e) {
      print("Lỗi loginWithMicrosoftCode: $e");
      Get.snackbar("Thông báo", "Đăng nhập thất bại Vui lòng thử lại");
    } finally {
      isLoadingMicrosoft.value = false;
      Navigator.pop(context);
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
    Services services,
    String accessTokenId,
    BuildContext context,
  ) async {
    if (accessTokenId.isEmpty) {
      return;
    }
    await services.saveAccessToken(accessTokenId);
    await apiService.getProfile(dioApi);

    // Đăng ký lại push token sau khi đăng nhập thành công
    try {
      final oneSignalService = OneSignalService();
      await oneSignalService.retryRegisterTokenAfterLogin();
    } catch (e) {
      print("Lỗi khi đăng ký lại push token sau đăng nhập: $e");
    }

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
