import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/common/Services/config.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/common/share/cache/my_id.dart';
import 'package:tcs_flutter/common/utils/date_utils.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/router/app_router.dart';
import 'package:tcs_flutter/src/services/lib/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/data/models/profile_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tcs_flutter/common/share/auth/sign_out_clear.dart';

class ProfileLogic extends GetxController {
  final SignOutClear _signOutClear = Get.find<SignOutClear>();
  DioApi dioApi = DioApi();
  final AuthService _authService = AuthService();

  Profile? profile;
  int _clickCount = 0;
  final isloading = false.obs;
  final userProfileData = <Map<String, dynamic>>[].obs;
  final summaryData = <Map<String, dynamic>>[].obs;
  final userId = Rx<String?>(
    Get.arguments is String ? Get.arguments as String : null,
  );

  final RxString version = ''.obs;
  final RxInt tapCount = 0.obs;
  final baseUrlController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    userProfileData.clear();
    getProfile();
    initPackageInfo();
  }

  Future<void> initPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version.toString();
  }

  Future<void> loadUserData() async {
    try {
      final u = profile?.user;
      if (u != null && u.id.isNotEmpty) {
        final email = (u.email).toString();

        userProfileData.value = [
          if ((u.phoneNumber ?? '').isNotEmpty)
            {
              'title': "Số Điện Thoại",
              'subtitle': u.phoneNumber!,
              'icon': Icons.phone,
              'color': AppColors.colorCall,
              'onTap': () => _phoneCall(u.phoneNumber!),
            },
          if (email.isNotEmpty)
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
          if ((u.createdDate).toString().isNotEmpty)
            {
              'title': "Ngày bắt đầu",
              'subtitle': DateUtilsCustom.formatStringDate(u.createdDate),
            },
            
        ];
      }
    } catch (e) {
      print(e);
    } finally {}
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
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> getProfile() async {
    MyId myId = await MyId.create();

    try {
      isloading.value = true;
      final respon = await dioApi.get(ApiEndpoints.profile);
      print("respon.profile: ${respon.data}");
      final data = (respon.data ?? {})['data'] ?? {};
      profile = Profile.fromJson(data as Map<String, dynamic>);
      myId.saveMyId(profile?.user?.id ?? '');

      await loadUserData();
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
        final currentDev = await _authService.getDevNpp() ?? true;

        await _authService.saveDevNpp(!currentDev);

        // final newDevMode = await _authService.getDevNpp() ?? true;

        await _authService.clearAccessTokenNpp();

        await _authService.signOut();
        Get.offAllNamed(AppRouter.login);
      }
      _clickCount = 0;
    }
  }

  Future<bool?> _showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
  ) {
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
    final Email emailToSend = Email(recipients: [email], isHTML: false);

    try {
      await FlutterEmailSender.send(emailToSend);
      print("Email sent successfully.");
    } catch (error) {
      print("Error sending email: $error");
    }
  }

  String? extractAccountNumber(String input) {
    final regExp = RegExp(r'\d+');
    final match = regExp.firstMatch(input);
    return match?.group(0);
  }

  String extractLetters(String input) {
    final regExp = RegExp(r'[a-zA-Z]+');
    final matches = regExp.allMatches(input);
    final result = matches.map((match) => match.group(0)!).join(' ');
    return result;
  }

  void showConfigDialog() {
    if (tapCount.value == 5) {
      baseUrlController.text = Config.baseUrl;
      String initialBaseUrl = Config.baseUrl;
      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Developer Settings",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
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
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
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
                                'Info',
                                'No changes made to Base URL',
                              );
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
      final m = RegExp(
        r'^(.*T\d{2}:\d{2}:\d{2})(?:\.(\d+))?(Z|[+\-].*)?$',
      ).firstMatch(iso.trim());
      if (m != null) {
        final head = m.group(1) ?? '';
        final frac = m.group(2);
        final tz = m.group(3) ?? '';
        String rebuilt;
        if (frac == null || frac.isEmpty) {
          rebuilt = '$head$tz';
        } else {
          final trimmed =
              frac.length > 6 ? frac.substring(0, 6) : frac.padRight(6, '0');
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
