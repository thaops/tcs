import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/loading_overlay.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/logic/profile_logic.dart';
import 'package:tcs_flutter/feature/private_app_shell/profile/widget/summary_user_profile.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
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

    return Obx(
      () => LoadingOverlay(
        isLoading: controllerProfile.isLoadingSafe,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(),
          body: RefreshIndicator(
            onRefresh: () async {
              await controllerProfile.loadUserData();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_buildPersonalInfoSection(controllerProfile)],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(Icons.arrow_back_ios, color: AppColors.black),
      ),
      title: TextWidget(
        text: 'Thông tin cá nhân',
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      ),
      centerTitle: true,
    );
  }

  Widget _buildPersonalInfoSection(ProfileLogic controllerProfile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            if (controllerProfile.summaryData.isNotEmpty) {
              return Column(
                children:
                    controllerProfile.summaryData.map((data) {
                      return SummaryUserProfile(
                        title: data['title']?.toString() ?? '',
                        subtitle: data['subtitle']?.toString() ?? '',
                        textAlign: TextAlign.right,
                      );
                    }).toList(),
              );
            }

            return _buildFallbackPersonalInfo(controllerProfile);
          }),
        ],
      ),
    );
  }

  Widget _buildFallbackPersonalInfo(ProfileLogic controllerProfile) {
    final user = controllerProfile.profile.value?.user;
    if (user == null) {
      return Center(
        child: TextWidget(
          text: "Không có thông tin để hiển thị",
          color: AppColors.grey,
        ),
      );
    }

    return Column(
      children: [
        SummaryUserProfile(title: "Họ Tên", subtitle: user.fullName ?? ''),
        if ((user.email ?? '').isNotEmpty)
          SummaryUserProfile(title: "Email", subtitle: user.email!),
        if ((user.jobTitle ?? '').isNotEmpty)
          SummaryUserProfile(title: "Phòng ban", subtitle: user.jobTitle!),

        if ((user.hrId ?? 0) != 0)
          SummaryUserProfile(
            title: "Mã nhân viên",
            subtitle: user.hrId.toString(),
          ),
        if ((user.jobTitleCode ?? '').isNotEmpty)
          SummaryUserProfile(
            title: "Ngày bắt đầu",
            subtitle: (user.workStartDate ?? user.createdDate).toString(),
          ),
      ],
    );
  }
}
