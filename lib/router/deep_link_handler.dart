import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/utils/navigation_utils.dart';
import 'package:tcs_flutter/common/utils/notification_utils.dart';

class DeepLinkHandler {
  static final DeepLinkHandler _instance = DeepLinkHandler._internal();
  factory DeepLinkHandler() => _instance;
  DeepLinkHandler._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri?>? _sub;

  void init(BuildContext context) {
    debugPrint('Initializing DeepLinkHandler...');
    _sub?.cancel();

    _sub = _appLinks.uriLinkStream.where((uri) => uri != null).listen(
      (uri) {
        debugPrint('Received deep link from stream: $uri');
        processDeepLink(uri!, context);
      },
      onError: (err) => debugPrint('Deep link stream error: $err'),
      onDone: () => debugPrint('Deep link stream closed'),
    );
  }

  Future<void> processDeepLink(Uri uri, BuildContext context) async {
 
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (uri.scheme == 'com.namphuongso.npp' && uri.host == 'verify') {
        final type = uri.queryParameters['action'];
        final id = uri.queryParameters['id'];

        if (type == null || id == null) {
          debugPrint('Missing action or id in deep link: $uri');
          return;
        }

        final notificationType = NotificationUtils.getNotificationType(type);
        if (notificationType == null) {
          debugPrint('Invalid notification type: $type');
          return;
        }

        debugPrint('Processing deep link: $type, $id');
        await NavigationUtils.navigateByNotificationType(
          type: notificationType,
          id: id,
        );
      }
    });
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }

}
