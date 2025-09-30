import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/common/Services/config.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/common/share/cache/my_id.dart';
import 'package:tcs_flutter/common/utils/check_awaiting_services.dart';
import 'package:tcs_flutter/common/utils/date_utils.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/router/app_router.dart';
import 'package:tcs_flutter/src/services/lib/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/data/models/profile_model.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/data/models/apple_profile_model.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tcs_flutter/common/share/auth/sign_out_clear.dart';

class ProfileLogic extends GetxController {
  late final SignOutClear _signOutClear;
  DioApi dioApi = DioApi();
  final AuthService _authService = AuthService();

  final profile = Rx<Profile?>(null);
  int _clickCount = 0;
  final isloading = false.obs;
  final userProfileData = <Map<String, dynamic>>[].obs;
  final summaryData = <Map<String, dynamic>>[].obs;
  final userId = Rx<String?>(
    Get.arguments is String ? Get.arguments as String : null,
  );

  final RxString version = ''.obs;
  final RxInt tapCount = 0.obs;

  // Getter an toàn để tránh lỗi null check
  bool get isLoadingSafe => isloading.value;
  String get versionSafe => version.value;
  int get tapCountSafe => tapCount.value;
  final baseUrlController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // SignOutClear đã được khởi tạo trong main.dart
    _signOutClear = Get.find<SignOutClear>();

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
      final u = profile.value?.user;

      if (u != null && u.id!.isNotEmpty) {
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
          if ((u.tel ?? '').isNotEmpty && u.tel != u.phoneNumber)
            {
              'title': "Điện thoại khác",
              'subtitle': u.tel!,
              'icon': Icons.phone_android,
              'color': AppColors.colorCall,
              'onTap': () => _phoneCall(u.tel!),
            },
        ];

        summaryData.value = [
          if ((u.fullName ?? '').isNotEmpty)
            {'title': "Họ Tên", 'subtitle': u.fullName!},
          if ((u.email ?? '').isNotEmpty)
            {'title': "Email", 'subtitle': u.email!},
          if ((u.jobTitle ?? '').isNotEmpty)
            {'title': "Chức vụ", 'subtitle': u.jobTitle!},
          if ((u.departmentName ?? '').isNotEmpty)
            {'title': "Phòng ban", 'subtitle': u.departmentName!},
          if ((u.unitName ?? '').isNotEmpty)
            {'title': "Tổ đội", 'subtitle': u.unitName!},

          if ((u.employeeCode ?? '') != '')
            {'title': "Mã nhân viên", 'subtitle': u.employeeCode!},
          if ((u.workStartDate ?? u.createdDate ?? '').toString().isNotEmpty)
            {
              'title': "Ngày bắt đầu",
              'subtitle': DateUtilsCustom.formatStringDate(
                u.workStartDate ?? u.createdDate,
              ),
            },
          if ((u.address ?? '').isNotEmpty)
            {'title': "Địa chỉ", 'subtitle': u.address!},
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
    final checkAwaitingServices = CheckAwaitingServices(GetStorage());
    final ischeckApple = await checkAwaitingServices.getawaiting();
    MyId myId = await MyId.create();

    try {
      isloading.value = true;
      final endpoint =
          ischeckApple ? ApiEndpoints.usersProfileApple : ApiEndpoints.profile;

      final respon = await dioApi.get(endpoint);
      final data = (respon.data ?? {})['data'] ?? {};
      print("datasss: $data");
      myId.saveMyId(data['user']['id']);

      if (data == null || data.isEmpty) {
        if (ischeckApple) {
          final regularRespon = await dioApi.get(ApiEndpoints.profile);
          final regularData = (regularRespon.data ?? {})['data'] ?? {};
          if (regularData != null && regularData.isNotEmpty) {
            profile.value = Profile(
              user: User.fromJson(regularData as Map<String, dynamic>),
            );

            await loadUserData();
          }
        }
        return;
      }
      // Parse dữ liệu user theo cấu trúc API
      if (ischeckApple) {
        final appleProfile = AppleProfile(
          user: AppleUser.fromJson(data as Map<String, dynamic>),
        );
        profile.value = Profile(
          user: User(
            id: appleProfile.user?.id,
            hrId: appleProfile.user?.hrId,
            username: appleProfile.user?.username,
            email: appleProfile.user?.email,
            phoneNumber: appleProfile.user?.phoneNumber,
            password: appleProfile.user?.password,
            firstName: appleProfile.user?.firstName,
            lastName: appleProfile.user?.lastName,
            fullNameNoAccent: appleProfile.user?.fullNameNoAccent,
            firstNameUnsign: appleProfile.user?.firstNameUnsign,
            lastNameUnsign: appleProfile.user?.lastNameUnsign,
            gender: appleProfile.user?.gender,
            refreshToken: appleProfile.user?.refreshToken,
            avatar: appleProfile.user?.avatar,
            doB: appleProfile.user?.doB,
            fullName: appleProfile.user?.fullName,
            isDeleted: appleProfile.user?.isDeleted,
            createdDate: appleProfile.user?.createdDate,
            updatedDate: appleProfile.user?.updatedDate,
            creator: appleProfile.user?.creator,
            modifier: appleProfile.user?.modifier,
            createdById: appleProfile.user?.createdById,
            updatedById: appleProfile.user?.updatedById,
            address: appleProfile.user?.address,
            tel: appleProfile.user?.tel,
            department: appleProfile.user?.department,
            departmentId: appleProfile.user?.departmentId,
            workStartDate: appleProfile.user?.workStartDate,
            avatarUrl: appleProfile.user?.avatarUrl,
          ),
          permissions: appleProfile.permissions,
        );
      } else {
        final userData = data['user'] as Map<String, dynamic>?;
        if (userData != null) {
          profile.value = Profile(
            user: User.fromJson(userData),
            permissions:
                (data['permissions'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList() ??
                [],
          );
        } else {
          print("No user data found in normal API response");
        }
      }

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

  /// Reset profile data về trạng thái ban đầu
  void resetProfile() {
    profile.value = null;
    isloading.value = false;
    userProfileData.clear();
    summaryData.clear();
    userId.value = null;
  }
}
