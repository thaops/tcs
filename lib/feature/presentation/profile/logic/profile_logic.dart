import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/common/Services/config.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/common/utils/date_utils.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/presentation/filter_user/controller/filter_user_controller.dart';
import 'package:tcs_flutter/feature/presentation/user_list/controller/user_controller.dart';
import 'package:tcs_flutter/feature/presentation/user_list/model/user_list_model.dart';
import 'package:tcs_flutter/router/app_router.dart';
import 'package:tcs_flutter/src/services/lib/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/presentation/profile/data/models/profile_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tcs_flutter/common/share/auth/sign_out_clear.dart';

class ProfileLogic extends GetxController {
  final SignOutClear _signOutClear = Get.find<SignOutClear>();
  DioApi dioApi = DioApi();
  final AuthService _authService = AuthService();
  final controllerUserlist = Get.put(FilterUserController());

  Profile? profile;
  int _clickCount = 0;
  final isloading = false.obs;
  var userProfileData = <Map<String, dynamic>>[].obs;
  var summaryData = <Map<String, dynamic>>[].obs;
  var user = Rx<UserListModel?>(null);
  var userId = Rx<String?>(
    Get.arguments is String ? Get.arguments as String : null,
  );

  RxString? version = ''.obs;
  RxInt tapCount = 0.obs;
  final baseUrlController = TextEditingController();

  onInit() {
    super.onInit();
    userProfileData.clear();
    getProfile();
    initPackageInfo();
    user.value = null;
    ever(controllerUserlist.userList, (_) {
      if (controllerUserlist.userList.isNotEmpty) {
        userProfileData.clear();
        loadUserData();
      }
    });
  }


  Future<void> initPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    version?.value = packageInfo.version.toString();
  }

  Future<void> loadData() async {
    final controllerUserlist = Get.find<UserController>();
    final controllerProfile = Get.find<ProfileLogic>();
    controllerUserlist.isLoading.value = true;
    await controllerProfile.loadUserData();
    controllerUserlist.isLoading.value = false;
  }

  Future<void> loadUserData() async {
    user.value = null;
    final String userId = Get.arguments ?? profile?.id ?? '';
    try {
      controllerUserlist.isLoading.value = true;

      if (controllerUserlist.isLoading.value && userId.isNotEmpty) {
        user.value = controllerUserlist.userList.firstWhere(
          (user) => user.id == userId,
          orElse: () => UserListModel(
              id: '',
              tel: '',
              email: '',
              userTypeLabel: '',
              signedDate: '',
              expiredDate: '',
              cccd: '',
              licensePlace: ''),
        );

        if (user.value?.id != '') {
          String email = '';
          if (user.value?.email != null) {
            email = getParsedEmail(user.value!.email);
          }

          userProfileData.value = [
            {
              'title': "Số Điện Thoại",
              'subtitle': user.value?.tel.toString() ?? '',
              'icon': Icons.phone,
              'color': AppColors.colorCall,
              'onTap': () => _phoneCall(user.value!.tel!),
            },
            {
              'title': "Email",
              'subtitle': email,
              'icon': Icons.email,
              'color': AppColors.colorEmail,
              'onTap': () async {
                sendEmail(email);
              },
            },
          ];

          summaryData.value = [
            {
              'title': "Ngày bắt đầu",
              'subtitle': DateUtilsCustom.formatStringDate(
                  user.value?.signedDate ?? ''),
            },
            {
              'title': "Ngày Kết thúc",
              'subtitle': DateUtilsCustom.formatStringDate(
                  user.value?.expiredDate ?? ''),
            },
            {
              'title': "Chức vụ",
              'subtitle': user.value?.userTypeLabel.toString() ?? '',
            },
            {
              'title': "CCCD",
              'subtitle': user.value?.cccd.toString() ?? '',
            },
            {
              'title': "Nơi cấp",
              'subtitle': user.value?.licensePlace.toString() ?? '',
            },
          ];
        } else {
          print('No valid user found with ID: $userId');
        }
      } else {
        print('User list is empty or userId is invalid.');
      }
    } catch (e) {
      print(e);
    } finally {
      controllerUserlist.isLoading.value = false;
    }
  }

String getParsedEmail(dynamic emailData) {
  if (emailData == null) return '';
  if (emailData is String) return emailData;
  if (emailData is Map && emailData.containsKey('value')) {
    final dynamic value = emailData['value'];
    return value is String ? value : '';
  }
  return '';
}



  Future<void> _phoneCall(String phoneNumber) async {
    launch('tel:$phoneNumber');
  }

  Future<void> getProfile() async {
    try {
      isloading.value = true;
      final respon = await dioApi.get(ApiEndpoints.profile);
      print("respon.data: ${respon.data}");
      profile = Profile(
        id: respon.data['data']['id'],
        fullName: respon.data['data']['fullName'] ?? '',
        email: respon.data['data']['email'] ?? '',
        address: respon.data['data']['address'] ?? '',
        tel: respon.data['data']['tel'] ?? '',
        department: respon.data['data']['department'] ?? '',
        departmentId: respon.data['data']['departmentId'] ?? '',
        workStartDate: _parseWorkStart(respon.data['data']['workStartDate'] as String?),
        avatarUrl: respon.data['data']['avatarUrl'] ?? '',
      );
    } catch (e) {
      print('Error fetching profile: $e');
    } finally {
      isloading.value = false;

    }
  }

  Future<void> signOut(BuildContext context) async {
    final shouldSignOut = await _showConfirmationDialog(
      context,
      'Xác nhận đăng xuất',
      'Bạn muốn đăng xuất không?',
    );

    if (shouldSignOut == true) {
      await _authService.clearAccessTokenNpp();
      await _signOutClear.signOut();
    }
  }

  Future<void> onVision(BuildContext context) async {
    _clickCount++;
    if (_clickCount == 5) {
      final shouldSignOut = await _showConfirmationDialog(
        context,
        'Xác nhận đổi sang dev',
        'Bạn có muốn đổi sang dev không?',
      );

      if (shouldSignOut == true) {
        bool currentDev = await _authService.getDevNpp() ?? true;

        await _authService.saveDevNpp(!currentDev);

        bool newDevMode = await _authService.getDevNpp() ?? true;

        await _authService.clearAccessTokenNpp();

        await _authService.signOut();
        Get.offAllNamed(AppRouter.login);
      }
      _clickCount = 0;
    }
  }

  Future<bool?> _showConfirmationDialog(
      BuildContext context, String title, String content) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Đồng ý'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> sendEmail(String email) async {
    print("sendEmail");
    final Email emailToSend = Email(
      recipients: [email],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(emailToSend);
      print("Email sent successfully.");
    } catch (error) {
      print("Error sending email: $error");
    }
  }

  String? extractAccountNumber(String input) {
    // Sử dụng biểu thức chính quy để tìm số tài khoản
    RegExp regExp = RegExp(r'\d+');
    Match? match = regExp.firstMatch(input);

    // Nếu tìm thấy, trả về số tài khoản
    return match?.group(0);
  }

  String extractLetters(String input) {
    // Sử dụng biểu thức chính quy để tìm chữ (không phải số)
    RegExp regExp = RegExp(r'[a-zA-Z]+');
    Iterable<Match> matches = regExp.allMatches(input);

    // Tạo một chuỗi kết hợp tất cả các đoạn chữ tìm thấy
    String result = matches.map((match) => match.group(0)!).join(' ');

    return result;
  }

  void showConfigDialog() {
    if (tapCount.value == 5) {
      baseUrlController.text = Config.baseUrl;
      String initialBaseUrl = Config.baseUrl;
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Developer Settings",
                    style: TextStyle(color: Colors.black, fontSize: 18)),
                SizedBox(height: 16),
                TextField(
                  controller: baseUrlController,
                  style: TextStyle(fontSize: 14, color: AppColors.black),
                  decoration: InputDecoration(
                    labelText: 'Base URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                            tapCount.value = 0;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Cancel",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18)),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: SizedBox(
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            String currentBaseUrl =
                                baseUrlController.text.trim();
                            if (currentBaseUrl != initialBaseUrl) {
                              Config.baseUrl = baseUrlController.text;
                              dioApi = DioApi();
                              Get.back();
                              tapCount.value = 0;
                              Get.snackbar('Success', 'Base URL updated');
                              await _authService.signOut();
                              await _authService.clearAccessTokenNpp();
                              Get.offAllNamed(AppRouter.login);
                            } else {
                              // Nếu không thay đổi, chỉ thông báo
                              Get.back();

                              Get.snackbar(
                                  'Info', 'No changes made to Base URL');
                              tapCount.value = 0;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Apply",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  DateTime? _parseWorkStart(String? iso) {
    if (iso == null || iso.isEmpty) return null;
    try {
      return DateTime.parse(iso);
    } catch (_) {
      // Chuẩn hoá phần thập phân (fractional seconds) tối đa 6 chữ số để phù hợp microseconds
      final m = RegExp(r'^(.*T\d{2}:\d{2}:\d{2})(?:\.(\d+))?(Z|[+\-].*)?$').firstMatch(iso.trim());
      if (m != null) {
        final head = m.group(1) ?? '';
        final frac = m.group(2); // chỉ chứa chữ số
        final tz = m.group(3) ?? '';
        String rebuilt;
        if (frac == null || frac.isEmpty) {
          rebuilt = '$head$tz';
        } else {
          final trimmed = frac.length > 6 ? frac.substring(0, 6) : frac.padRight(6, '0');
          rebuilt = '$head.$trimmed$tz';
        }
        try {
          return DateTime.parse(rebuilt);
        } catch (_) {
          return null;
        }
      }
      return null;
    }
  }
}
