import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tcs_flutter/common/img/img.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/logic/profile_logic.dart';
import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/widget/summary_user_profile.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/widget/user_profile.dart';
import 'package:tcs_flutter/src/api/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  final bool? flag;
  ProfileScreen({super.key, this.flag});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _phoneCall(String phoneNumber) async {
    launchUrl(Uri.parse('tel:$phoneNumber'));
  }

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller một cách an toàn
    if (!Get.isRegistered<ProfileLogic>()) {
      Get.put(ProfileLogic());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra an toàn controller
    if (!Get.isRegistered<ProfileLogic>()) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final controllerProfile = Get.find<ProfileLogic>();
    final apiService = Get.put(ApiService());

    final isVision = apiService.isVision;
    final String userId =
        Get.arguments ?? controllerProfile.profile.value?.user?.id ?? '';

    return Obx(
      () => LoadingOverlay(
        isLoading: controllerProfile.isLoadingSafe,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(controllerProfile, context),
          body: RefreshIndicator(
            onRefresh: () async {
              await controllerProfile.loadUserData();
            },
            child: Obx(
              () => LoadingOverlay(
                isLoading: controllerProfile.isLoadingSafe,
                child: SingleChildScrollView(
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Stack(
                            children: [
                              _buildInformationContact(controllerProfile),
                              Positioned(
                                top: 0,
                                left:
                                    MediaQuery.of(context).size.width / 2 - 80,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Lottie.asset(
                                    fit: BoxFit.cover,
                                    height: 140,
                                    Img.roundAvatar,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 17,
                                left:
                                    MediaQuery.of(context).size.width / 2 - 60,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Obx(() {
                                    final avatarUrl =
                                        controllerProfile
                                            .profile
                                            .value
                                            ?.user
                                            ?.avatarUrl ??
                                        controllerProfile
                                            .profile
                                            .value
                                            ?.user
                                            ?.avatar;
                                    print("UI - avatarUrl: $avatarUrl");
                                    return CircleAvatar(
                                      key: ValueKey(avatarUrl),
                                      radius: 50,
                                      backgroundImage:
                                          avatarUrl != null &&
                                                  avatarUrl.isNotEmpty
                                              ? NetworkImage(avatarUrl)
                                              : Image.asset(
                                                Img.avatarDefault,
                                              ).image,
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                        24.verticalSpace,
                        _buildPersonalInformation(
                          userId,
                          controllerProfile,
                          context,
                          isVision,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildPersonalInformation(
    String userId,
    ProfileLogic controllerProfile,
    BuildContext context,
    bool isVision,
  ) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 26.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.verticalSpace,
              TextWidget(
                text: "THÔNG TIN",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
              16.verticalSpace,
              // SizedBox(
              //   width: Get.width,
              //   child: GestureDetector(
              //     onTap: () {

              //     },
              //     child: SummaryUserProfile(
              //       title: controllerProfile.extractLetters(
              //           controllerProfile.profile?.bankInfo ?? ''),
              //       subtitle: controllerProfile.extractAccountNumber(
              //               controllerProfile.profile?.bankInfo ?? '') ??
              //           'Không có số tài khoản',
              //     ),
              //   ),
              // ),
              ...(() {
                print(
                  "UI - summaryData length: ${controllerProfile.summaryData.length}",
                );
                if (controllerProfile.summaryData.isNotEmpty) {
                  return controllerProfile.summaryData;
                }
                // Fallback từ Profile khi không có summaryData từ UserController
                final p = controllerProfile.profile.value?.user;
                final List<Map<String, dynamic>> fallback = [];
                if (p != null) {
                  if ((p.phoneNumber ?? '').isNotEmpty) {
                    fallback.add({
                      'title': 'Số điện thoại',
                      'subtitle': p.phoneNumber!,
                    });
                  }
                  if ((p.email)!.isNotEmpty) {
                    fallback.add({'title': 'Email', 'subtitle': p.email});
                  }
                }
                return fallback;
              }()).map((data) {
                return SummaryUserProfile(
                  title: data['title'].toString(),
                  subtitle: data['subtitle'].toString(),
                );
              }).toList(),
              SizedBox(height: 10),
              widget.flag == true
                  ? Container()
                  : Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: GestureDetector(
                      onTap: () => controllerProfile.onVision(context),
                      child: FutureBuilder<void>(
                        future: controllerProfile.initPackageInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return GestureDetector(
                            onTap: () {
                              controllerProfile.tapCount.value =
                                  controllerProfile.tapCountSafe + 1;
                              controllerProfile.showConfigDialog();
                            },
                            child: Center(
                              child: TextWidget(
                                text:
                                    isVision
                                        ? "@TCS - Phiên bản - ${controllerProfile.versionSafe}"
                                        : "@TCS - Phiên bản - dev",
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500,
                                color: AppColors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildInformationContact(ProfileLogic controllerProfile) {
    return Column(
      children: [
        80.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppColors.colorbackgroundProfile,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                40.verticalSpace,
                Center(
                  child: Obx(() {
                    final fullName =
                        controllerProfile.profile.value?.user?.fullName ??
                        controllerProfile.profile.value?.user?.username ??
                        '';
                    print("UI - fullName: $fullName");
                    print(
                      "UI - profile.value: ${controllerProfile.profile.value}",
                    );
                    print(
                      "UI - user: ${controllerProfile.profile.value?.user}",
                    );
                    return TextWidget(
                      color: AppColors.black,
                      fontSize: 18,
                      text: fullName,
                      fontWeight: FontWeight.w600,
                    );
                  }),
                ),
                4.verticalSpace,
                Center(
                  child: TextWidget(
                    text: '',
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                _buildContact(controllerProfile),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Column _buildContact(ProfileLogic controllerProfile) {
    return Column(
      children: [
        TextWidget(
          text: "Liên hệ",
          textAlign: TextAlign.start,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.grey.withOpacity(0.8),
        ),
        8.verticalSpace,
        ...(() {
          print(
            "UI - userProfileData length: ${controllerProfile.userProfileData.length}",
          );
          if (controllerProfile.userProfileData.isNotEmpty) {
            return controllerProfile.userProfileData;
          }
          // Fallback từ Profile nếu chưa có dữ liệu từ UserController
          final List<Map<String, dynamic>> fallback = [];
          final tel = controllerProfile.profile.value?.user?.phoneNumber;
          final email = controllerProfile.profile.value?.user?.email;
          if (tel != null && tel.isNotEmpty) {
            fallback.add({
              'title': 'Số Điện Thoại',
              'subtitle': tel,
              'icon': Icons.phone,
              'color': AppColors.colorCall,
              'onTap': () => _phoneCall(tel),
            });
          }
          if (email != null && email.isNotEmpty) {
            fallback.add({
              'title': 'Email',
              'subtitle': email,
              'icon': Icons.email,
              'color': AppColors.colorEmail,
              'onTap': () async {
                final uri = Uri(scheme: 'mailto', path: email);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
              },
            });
          }
          return fallback;
        }()).map((data) {
          return GestureDetector(
            onTap: data['onTap'] as void Function()?,
            child: UserProfile(
              title: data['title'].toString(),
              icon: data['icon'] as IconData,
              subtitle: data['subtitle'].toString(),
              color: data['color'] as Color,
            ),
          );
        }).toList(),
      ],
    );
  }

  AppBar _buildAppBar(ProfileLogic controllerProfile, BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading:
          widget.flag != true
              ? SizedBox()
              : IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
      title: TextWidget(
        text: 'Trang cá nhân',
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      centerTitle: true,
      actions: [
        widget.flag == true
            ? Container(width: 0)
            : IconButton(
              icon: Icon(Icons.logout, color: AppColors.colorRed),
              onPressed: () {
                controllerProfile.signOut(context);
              },
            ),
      ],
    );
  }
}
