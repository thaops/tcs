import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/common/share/cache/version_app.dart';
import 'package:tcs_flutter/common/utils/custom_dialog.dart';
import 'package:tcs_flutter/common/utils/update_status_channel.dart';
import 'package:tcs_flutter/common/widgets/custom_snackbar.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';


class CheckUpdateInApp {
  String description = '''
Bản cập nhật có những tính năng mới:
- Tối ưu hiệu năng
- Cập nhật phiên bản mới trong app 
''';

  Future<void> checkUpdateAndroid({bool? showSnackbar = false}) async {
    final updateManager = UpdateManager();
    bool hasUpdate = await updateManager.checkForUpdate();
    if (hasUpdate) {
      await updateManager.startImmediateUpdate();
    }else{
      if (showSnackbar ?? false) {
        CustomSnackbar.show('Không có bản cập nhật mới');
      }
    }

  }

  Future<void> checkUpdateIos({bool? showSnackbar = false}) async {
  Dio dioApios = Dio();
  final versionApp = await VersionApp.create();

  try {
    final lastCheck = await versionApp.getLastCheckTime();
    if (lastCheck != null && DateTime.now().difference(lastCheck).inHours < 4) {
      if (showSnackbar ?? false) {
        CustomSnackbar.show('Vui lòng Thử lại sau vài giờ tới');
      }
      return; 
    }

    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    final countryCode = Platform.localeName.split('_').last.toLowerCase();
    const appId = '6738834768';
    final appStoreUrl = 'https://itunes.apple.com/lookup?id=$appId&country=$countryCode';

    final appData = await _fetchAppStoreData(dioApios, appStoreUrl);
    if (appData == null) {
      if (showSnackbar ?? false) {
        CustomSnackbar.show('Không thể kiểm tra cập nhật.');
      }
      return;
    }

    final latestVersion = appData['version'] as String? ?? '';
    final releaseNotes = appData['releaseNotes'] as String? ?? 'Không có ghi chú phát hành';
    final storeUrl = appData['trackViewUrl'] as String? ?? '';
    final avatar = appData['artworkUrl100'] as String? ?? '';
    final name = appData['trackName'] as String? ?? '';
    final contentAdvisoryRating = appData['contentAdvisoryRating'] as String? ?? '';
    final savedVersion = await versionApp.getVersion();

    if (savedVersion.isEmpty) {
      await versionApp.saveVersion(latestVersion);
    }

    if (_isUpdateNeeded(currentVersion, latestVersion)) {
      if (showSnackbar ?? false) {
        CustomSnackbar.show('Không có bản cập nhật mới');
      }
      await versionApp.deleteLastCheckTime();
      await versionApp.deleteVersion();
      await versionApp.saveVersion(latestVersion);
      await versionApp.saveLastCheckTime(DateTime.now());
      return;
    }



if(!_isUpdateNeeded(savedVersion, latestVersion)){
    final confirmed = await _showdialog(
      appName: name,
      currentVersion: currentVersion,
      latestVersion: latestVersion,
      releaseNotes: releaseNotes,
      appStoreUrl: storeUrl,
      avatar: avatar,
      description: description,
      contentAdvisoryRating: contentAdvisoryRating,
    );

    CustomDialog().showConfirmationDialog(
      child: _showdialog(
        appName: name,
        currentVersion: currentVersion,
        latestVersion: latestVersion,
        releaseNotes: releaseNotes,
        appStoreUrl: storeUrl,
        avatar: avatar,
        description: description,
        contentAdvisoryRating: contentAdvisoryRating,
      ),
      no: 'Cancel',
      yes: 'Update',
    ).then((value) {
      if (value ?? false) {
        onTapUpdate(storeUrl);
      }
    });
}



    await versionApp.saveLastCheckTime(DateTime.now());
  } catch (e) {
    if (e is DioException && e.type == DioExceptionType.connectionTimeout) {
      if (showSnackbar ?? false) {
        CustomSnackbar.show('Không có kết nối mạng. Vui lòng thử lại sau.');
      }
    } else {
      if (showSnackbar ?? false) {
        CustomSnackbar.show('Lỗi khi kiểm tra cập nhật: $e');
      }
    }
  }
}

Future<Map<String, dynamic>?> _fetchAppStoreData(Dio dio, String url) async {
  final response = await dio.get(
    url,
    options: Options(responseType: ResponseType.json),
  );

  if (response.statusCode != 200) {
    return null;
  }

  final data = response.data is String
      ? jsonDecode(response.data) as Map<String, dynamic>
      : response.data as Map<String, dynamic>;

  if ((data['resultCount'] as int? ?? 0) == 0) {
    return null;
  }

  return data['results'][0] as Map<String, dynamic>;
}

bool _isUpdateNeeded(String currentVersion, String latestVersion) {
  try {
    final current = Version.parse(currentVersion);
    final latest = Version.parse(latestVersion);
    return latest == current;
  } catch (e) {
    return true;
  }
}

  Future<void> onTapUpdate(String appStoreUrl) async {
    try {
      final uri = Uri.parse(appStoreUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

Container _showdialog(
   { required String appName,
    required String currentVersion,
    required String latestVersion,
    required String releaseNotes,
    required String appStoreUrl,
    required String avatar,
    required String description,
    required String contentAdvisoryRating}) {
  return Container(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextWidget(
          text: 'Update version ${latestVersion}',
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        TextWidget(
          paddingVertical: 8,
          text: "Anh chị vui lòng kiểm tra phiên bản mới nhất trên App Store",
          fontSize: 12,
          maxLines: 8,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
        TextWidget(
          text: description,
          fontSize: 12,
          maxLines: 20,
          fontWeight: FontWeight.w400,
          color: Colors.black.withOpacity(0.5),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: avatar,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, size: 40),
              ),
            ),
            SizedBox(width: 16.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget(
                  text: appName,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                Row(
                  children: [
                    TextWidget(
                      text: 'Độ tuổi',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextWidget(
                        text: contentAdvisoryRating,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),
      ],
    ),
  );
}
