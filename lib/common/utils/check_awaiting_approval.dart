import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class CheckAwaitingApproval {
  Dio dio = Dio();

  CheckAwaitingApproval() {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  Future<bool> checkAwaitingApproval({
    required String platform,
    required String appId,
    required String appBuild,
    required String appVersion,
    required String udid,
  }) async {
    try {
      print( " checkAwaitingApproval ${
        platform +
        appId +
        appBuild +
        appVersion +
        udid 
      }");
      final response = await dio.post(
        'https://dev2.crew.vn/api/user/checkawaitingapproval',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X_REQUEST_PLATFORM': platform,
            'X_APP_ID': appId,
            'X_APP_BUILD': appBuild,
            'X_APP_VERSION': appVersion,
            'X_REQUEST_UDID': udid,
          },
        ),
      );

      if (response.data['StatusCode'] == 200) {
        return response.data['Data']['IsWaitingApproval'];
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
