import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tcs_flutter/common/Services/api_endpoints.dart';
import 'package:tcs_flutter/common/constants/http_status_codes.dart';
import 'package:tcs_flutter/common/repositoty/dio_api.dart';
import 'package:tcs_flutter/common/share/cache/my_id.dart';
import 'package:tcs_flutter/src/api/models/profile_model.dart';
import 'package:tcs_flutter/src/api/models/sprint_model.dart';
import 'package:tcs_flutter/src/api/models/users_model.dart';
import 'package:tcs_flutter/src/config/constants/url/url.dart';
import 'package:tcs_flutter/src/services/lib/services/auth_service.dart';

class ApiService extends ChangeNotifier {
  bool _isVision = true;

  bool get isVision => _isVision;

  void setIsVision(bool vision) {
    _isVision = vision;
    notifyListeners();
  }

  String? _projectId;
  String? get projectId => _projectId;
  void setProjectId(project) {
    _projectId = project;
    notifyListeners();
  }

  String _accessTokenId = '';
  String get accessTokenId => _accessTokenId;

  void setAccessTokenId(String token) {
    _accessTokenId = token;
    notifyListeners();
  }

  Future<String> getBaseUrl(BuildContext context) async {
    return await BaseUrlProvider.getBaseUrl(context);
  }

  Future<String?> _getAccessToken() async {
    final authService = AuthService();
    return await authService.getAccessToken();
  }



  Future<List<UserModel>?> getUsers(BuildContext context) async {
    final accessToken = await _getAccessToken();
    final baseUrl = await getBaseUrl(context);
    final String url = '$baseUrl/users?page=1&pageSize=9999';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> usersJson = jsonResponse['data'];
        List<UserModel> users =
            usersJson.map((userJson) => UserModel.fromJson(userJson)).toList();

        return users;
      } else {
        print('Failed to load users');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List<Sprint>?> getSprint(String project, BuildContext context) async {
    final accessToken = await _getAccessToken();
    final baseUrl = await getBaseUrl(context);
    final String url =
        '$baseUrl/sprints?project=$project&page=1&pageSize=9999&startDate=2023-12-04&endDate=2222-12-31';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> sprintsJson = jsonResponse['data'];
        List<Sprint> sprints = sprintsJson
            .map((sprintJson) => Sprint.fromJson(sprintJson))
            .toList();
        return sprints;
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<void> getProfile(DioApi dioApi) async {
    MyId myId = await MyId.create();
    try {
      final response = await dioApi.get(
        ApiEndpoints.profile,
      );
      if (response.data["statusCode"] == HttpStatusCodes.STATUS_CODE_OK) {
        final taskJson = response.data["data"];
        myId.saveMyId(taskJson['id']);
        myId.saveMyName(taskJson['fullName']);
      } else {
        print('Failed to load task');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
