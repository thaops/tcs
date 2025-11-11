import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart' as dioLib;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/Services/network_controller.dart';
import 'package:tcs_flutter/common/Services/services.dart';
import 'package:tcs_flutter/common/constants/http_status_codes.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tcs_flutter/common/share/auth/sign_out_clear.dart';
import 'package:uuid/uuid.dart';

class DioApi {
  NetworkController networkController = Get.put(NetworkController());
  static final RxBool _hasShownDialog = false.obs;

  final dioLib.Dio dio =
      dioLib.Dio()..options.validateStatus = (status) => status! < 500;

  Map<String, dynamic> header = {
    "X_API_ID": "VN_CREW_2017",
    'Content-Type': 'application/json',
    'Accept': 'application/json, text/plain, */*',
    'Accept-Language': 'vi-VN,vi;q=0.9,en-US;q=0.8,en;q=0.7',
    'Connection': 'keep-alive',
  };

  // Bộ nhớ cache
  static final Map<String, dynamic> _cache = {};
  static DateTime? _tokenCacheTime;

  /// Clear static cache (dùng khi đổi môi trường)
  static void clearStaticCache() {
    _cache.clear();
    _tokenCacheTime = null;
    print("✅ Đã clear static cache trong DioApi");
  }

  Future<void> _buildHeader() async {
    try {
      final services = await Services.create();
      final packageInfo = await _getPackageInfo();
      final deviceInfo = await _getDeviceInfo();
      final udid = await _getUdid();

      final accessToken = await _getAccessToken(services);
      header['Authorization'] = 'Bearer $accessToken';

      header['X_REQUEST_PLATFORM'] = deviceInfo['platform'];
      header['X_REQUEST_DEVICE_NAME'] = deviceInfo['deviceName'];
      header['X_REQUEST_OS_VERSION'] = deviceInfo['osVersion'];
      header['X_REQUEST_UDID'] = udid;
      header['X_APP_ID'] = "NPP";
      header['X_APP_BUILD'] = packageInfo['buildNumber'];
      header['X_APP_VERSION'] = packageInfo['version'];

      print('Header: $header');
    } catch (e) {
      print('Lỗi khi xây dựng header: $e');
    }
  }

  // Lấy thông tin gói ứng dụng từ cache hoặc mới
  Future<Map<String, dynamic>> _getPackageInfo() async {
    if (_cache.containsKey('packageInfo')) {
      return _cache['packageInfo'];
    }
    final packageInfo = await PackageInfo.fromPlatform();
    final info = {
      'buildNumber': packageInfo.buildNumber,
      'version': packageInfo.version,
    };
    _cache['packageInfo'] = info;
    return info;
  }

  // Lấy thông tin thiết bị từ cache hoặc mới
  Future<Map<String, dynamic>> _getDeviceInfo() async {
    if (_cache.containsKey('deviceInfo')) {
      return _cache['deviceInfo'];
    }
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    Map<String, dynamic> info;
    if (Platform.isAndroid) {
      final androidInfo = deviceInfo as AndroidDeviceInfo;
      info = {
        'platform': 'Android',
        'deviceName': androidInfo.model,
        'osVersion': androidInfo.version.release,
      };
    } else if (Platform.isIOS) {
      final iosInfo = deviceInfo as IosDeviceInfo;
      info = {
        'platform': 'iOS',
        'deviceName': iosInfo.name,
        'osVersion': iosInfo.systemVersion,
      };
    } else {
      info = {
        'platform': '',
        'deviceName': '',
        'osVersion': '',
      };
    }
    _cache['deviceInfo'] = info;
    return info;
  }

  // Lấy UDID từ cache hoặc sinh mới
  Future<String> _getUdid() async {
    if (_cache.containsKey('udid')) {
      return _cache['udid'];
    }
    final Uuid _uuid = Uuid();
    String udid = _uuid.v4();
    _cache['udid'] = udid;
    return udid;
  }

  // Lấy Access Token từ cache hoặc mới
  Future<String> _getAccessToken(Services services) async {
    // const tokenCacheDuration = Duration(hours: 1);
    // if (_cache.containsKey('accessToken') &&
    //     _tokenCacheTime != null &&
    //     DateTime.now().difference(_tokenCacheTime!) < tokenCacheDuration) {
    //   return _cache['accessToken'];
    // }
    final accessToken = await services.getAccessToken();
    // _cache['accessToken'] = accessToken;
    // _tokenCacheTime = DateTime.now();
    return accessToken;
  }

  Future<void> _checkNetwork() async {
    await networkController.checkInternet();
    if (!networkController.isOnline.value) {
      await _showNoNetworkDialog();
      throw Exception('No internet connection');
    }
  }

  Future<void> _showNoNetworkDialog() async {
    // Prevent showing multiple stacked dialogs
    if (_hasShownDialog.value || (Get.isDialogOpen == true)) {
      return;
    }
    _hasShownDialog.value = true;
    await Get.dialog(
      CupertinoAlertDialog(
        title: const Text('No Internet Connection'),
        content: const Text(
          'We couldn’t connect to the server. Please check your internet connection and try again.',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Close'),
            onPressed: () {
              Get.back();
              _hasShownDialog.value = false;
            },
          ),
        ],
      ),
      barrierDismissible: false,
    );
    // Ensure flag reset even if the dialog is dismissed programmatically
    _hasShownDialog.value = false;
  }

  Future<dioLib.Response> get(
    String url, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? data,
    dioLib.CancelToken? cancelToken,
  }) async {
    await _checkNetwork();
    await _buildHeader();
    try {
      final response = await dio.get(
        url,
        queryParameters: params,
        data: data,
        options: dioLib.Options(headers: header),
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<dioLib.Response> post(
    String url, {
    dynamic data,
    dioLib.Options? options,
  }) async {
    await _checkNetwork();
    await _buildHeader();
    try {
      final response = await dio.post(
        url,
        data: data,
        options: options ?? dioLib.Options(headers: header),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  Future<dioLib.Response> put(
    String url, {
    dynamic data,
    dioLib.Options? options,
  }) async {
    await _checkNetwork();
    await _buildHeader();
    try {
      final response = await dio.put(
        url,
        data: data,
        options: options ?? dioLib.Options(headers: header),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to update data: $e');
    }
  }

  Future<dioLib.Response> delete(
    String url, {
    Map<String, dynamic>? params,
  }) async {
    await _checkNetwork();
    await _buildHeader();
    try {
      final response = await dio.delete(
        url,
        queryParameters: params,
        options: dioLib.Options(headers: header),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }

  dioLib.Response _handleResponse(dioLib.Response response) {
    if (response.statusCode == HttpStatusCodes.STATUS_CODE_UNAUTHORIZED) {
      SignOutClear().signOut();
      throw Exception('Unauthorized');
    }
    return response;
  }
}
