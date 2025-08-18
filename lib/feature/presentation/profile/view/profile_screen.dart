import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tcs_flutter/common/img/img.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/presentation/profile/logic/profile_logic.dart';
import 'package:flutter/material.dart';
import 'package:tcs_flutter/feature/presentation/profile/widget/summary_user_profile.dart';
import 'package:tcs_flutter/feature/presentation/profile/widget/user_profile.dart';
import 'package:tcs_flutter/feature/presentation/qr_bank/qr_bank.dart';
import 'package:tcs_flutter/feature/presentation/user_list/controller/user_controller.dart';
import 'package:tcs_flutter/src/api/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/common/utils/date_utils.dart';

class ProfileScreen extends StatefulWidget {
  final bool? flag;
  ProfileScreen({super.key, this.flag});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String avatar =
      "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png";

  Future<void> _phoneCall(String phoneNumber) async {
    launchUrl(Uri.parse('tel:$phoneNumber'));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controllerProfile = Get.find<ProfileLogic>();

      controllerProfile.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controllerUserlist = Get.put(UserController());
    final controllerProfile = Get.put(ProfileLogic());
    final apiService = Get.put(ApiService());

    final isVision = apiService.isVision;
    final String userId = Get.arguments ?? controllerProfile.profile?.id ?? '';

    return Obx(
      () => LoadingOverlay(
        isLoading: controllerUserlist.isLoading.value,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(controllerProfile, context),
          body: RefreshIndicator(
            onRefresh: () async {
              await controllerUserlist.fetchUserList();
              await controllerProfile.loadUserData();
            },
            child: Obx(
              () => LoadingOverlay(
                isLoading: controllerProfile.isloading.value,
                child: SingleChildScrollView(
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Stack(
                              children: [
                                _buildInformationContact(controllerProfile),
                                Positioned(
                                  top: 0,
                                  left: Get.width / 2 - 80,
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
                                  left: Get.width / 2 - 60,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: CircleAvatar(
                                      key: ValueKey(
                                        controllerProfile.user.value?.avatarUrl ??
                                            controllerProfile.profile?.avatarUrl,
                                      ),
                                      radius: 50,
                                      backgroundImage: NetworkImage(
                                        controllerProfile.user.value?.avatarUrl ??
                                            controllerProfile.profile?.avatarUrl ??
                                            avatar,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        24.verticalSpace,
                        _buildPersonalInformation(controllerUserlist, userId,
                            controllerProfile, context, isVision),
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
      UserController controllerUserlist,
      String userId,
      ProfileLogic controllerProfile,
      BuildContext context,
      bool isVision) {
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
          padding: const EdgeInsets.symmetric(horizontal: 26),
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
              SizedBox(
                width: Get.width,
                child: GestureDetector(
                  onTap: () {
                    final matches = controllerUserlist.userList
                        .where((u) => u.id == userId);
                    if (matches.isNotEmpty) {
                      final user = matches.first;
                      final bankInfo = user.bankInfo ?? '';
                      if (bankInfo.contains("TPBank")) {
                        String accountNumber = controllerProfile
                                .extractAccountNumber(bankInfo) ??
                            'Không có số tài khoản';
                        Get.to(QrBank(accountNumber: accountNumber));
                      }
                    } else {
                      // Không có UserListModel tương ứng, bỏ qua tap
                    }
                  },
                  child: SummaryUserProfile(
                    title: controllerProfile.extractLetters(
                        controllerProfile.user.value?.bankInfo ?? ''),
                    subtitle: controllerProfile.extractAccountNumber(
                            controllerProfile.user.value?.bankInfo ?? '') ??
                        'Không có số tài khoản',
                  ),
                ),
              ),
              ...(() {
                if (controllerProfile.summaryData.isNotEmpty) {
                  return controllerProfile.summaryData;
                }
                // Fallback từ Profile khi không có summaryData từ UserController
                final p = controllerProfile.profile;
                final List<Map<String, dynamic>> fallback = [];
                if (p != null) {
                  if ((p.address ?? '').isNotEmpty) {
                    fallback.add({'title': 'Địa chỉ', 'subtitle': p.address!});
                  }
                  if ((p.department ?? '').isNotEmpty) {
                    fallback.add({'title': 'Phòng ban', 'subtitle': p.department!});
                  }
                  if ((p.tel ?? '').isNotEmpty) {
                    fallback.add({'title': 'Số điện thoại', 'subtitle': p.tel!});
                  }
                  if ((p.email ?? '').isNotEmpty) {
                    fallback.add({'title': 'Email', 'subtitle': p.email!});
                  }
                  if (p.workStartDate != null) {
                    fallback.add({
                      'title': 'Ngày làm việc',
                      'subtitle': DateUtilsCustom.formatDate(p.workStartDate),
                    });
                  }
                }
                return fallback;
              }() as List<Map<String, dynamic>>).map((data) {
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
                                controllerProfile.tapCount++;
                                controllerProfile.showConfigDialog();
                              },
                              child: Center(
                                child: TextWidget(
                                  text: isVision
                                      ? "@NPP - Phiên bản - ${controllerProfile.version?.value}"
                                      : "@NPP - Phiên bản - dev",
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
          width: Get.width,
          decoration: BoxDecoration(
            color: AppColors.colorbackgroundProfile,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              40.verticalSpace,
              Center(
                child: TextWidget(
                  color: AppColors.black,
                  fontSize: 18,
                  text: controllerProfile.user.value?.fullName ??
                      (controllerProfile.profile?.fullName ?? ''),
                  fontWeight: FontWeight.w600,
                ),
              ),
              4.verticalSpace,
              Center(
                child: TextWidget(
                  text: controllerProfile.user.value?.department ??
                      (controllerProfile.profile?.department ?? ''),
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w400,
                ),
              ),
              widget.flag == true
                  ? _buildContact(controllerProfile)
                  : SizedBox(),
            ]),
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
          if (controllerProfile.userProfileData.isNotEmpty) {
            return controllerProfile.userProfileData;
          }
          // Fallback từ Profile nếu chưa có dữ liệu từ UserController
          final List<Map<String, dynamic>> fallback = [];
          final tel = controllerProfile.profile?.tel;
          final email = controllerProfile.profile?.email;
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
        }() as List<Map<String, dynamic>>).map((data) {
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
        leading: widget.flag != true
            ? SizedBox()
            : IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                )),
        title: TextWidget(
            text: 'Trang cá nhân', fontSize: 16, fontWeight: FontWeight.w500),
        centerTitle: true,
        actions: [
          widget.flag == true
              ? Container(width: 0)
              : IconButton(
                  icon: Icon(
                    Icons.logout,
                    color: AppColors.colorRed,
                  ),
                  onPressed: () {
                    controllerProfile.signOut(context);
                  },
                )
        ]);
  }
}
