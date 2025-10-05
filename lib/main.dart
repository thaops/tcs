import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tcs_flutter/common/Services/device_udid.dart';
import 'package:tcs_flutter/common/Services/network_controller.dart';
import 'package:tcs_flutter/common/Services/services.dart';
import 'package:tcs_flutter/common/share/auth/sign_out_clear.dart';
import 'package:tcs_flutter/common/utils/check_awaiting_approval.dart';
import 'package:tcs_flutter/common/utils/check_awaiting_services.dart';
import 'package:tcs_flutter/common/utils/navigation_utils.dart';
import 'package:tcs_flutter/core/configs/theme/app_theme.dart';
import 'package:tcs_flutter/router/app_router.dart';
import 'package:tcs_flutter/router/deep_link_handler.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

Future<bool> _isIPad() async {
  if (kIsWeb) return false;

  final deviceInfo = DeviceInfoPlugin();
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    final iosInfo = await deviceInfo.iosInfo;
    return iosInfo.model.toLowerCase().contains('ipad');
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    final mediaQuery = MediaQueryData.fromWindow(
      WidgetsBinding.instance.window,
    );
    final shortestSide = mediaQuery.size.shortestSide;
    return shortestSide >= 600;
  }
  return false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  final appLinks = AppLinks();
  final initialDeepLink = await appLinks.getInitialLink();
  await _initializeServices();
  MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  print("ssss${MediaQueryData.fromWindow(WidgetsBinding.instance.window)}");

  runApp(
    CalendarControllerProvider(
      controller: EventController(),
      child: MyApp(initialDeepLink: initialDeepLink),
    ),
  );
}

Future<void> _initializeServices() async {
  await Hive.initFlutter();

  // Kiểm tra xem có môi trường được set thủ công không
  final savedBaseUrl = GetStorage().read<String>('base_url');
  final isManualEnv =
      GetStorage().read<bool>('manual_environment_set') ?? false;

  if (savedBaseUrl != null && savedBaseUrl.isNotEmpty && isManualEnv) {
    // URL đã được set thủ công, giữ nguyên và không bị ghi đè
    print("Using manually set base URL: $savedBaseUrl");
  } else {
    // Chưa có URL thủ công, để Config tự động chọn dựa trên awaiting flag
    print("No manual URL set, using awaiting logic");
  }
  Get.put(NetworkController());

  try {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await generateUUID();
  } catch (e) {
    debugPrint('Lỗi khi khởi tạo ứng dụng: $e');
  }

  final serviceCheckawaiting =
      await CheckAwaitingServices.createCheckAwaitingServices();
  CheckAwaitingApproval checkAwaitingApproval = CheckAwaitingApproval();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appId = packageInfo.packageName;
  String appVersion = packageInfo.version;
  String appBuild = packageInfo.buildNumber;
  String platform = Platform.isIOS ? "iOS" : "Android";
  Uuid uuid = Uuid();

  bool result = await checkAwaitingApproval.checkAwaitingApproval(
    platform: platform,
    appId: appId,
    appBuild: appBuild,
    appVersion: appVersion,
    udid: uuid.v4(),
  );

  await serviceCheckawaiting.saveawaiting(result);
  await initializeDateFormatting('vi_VN', null);
  await Get.put(SignOutClear());
}

// Future<void> _loadUserData() async {
//   final controllerProfile = Get.put(ProfileLogic());
//   await controllerProfile.loadUserData();
// }

class MyApp extends StatefulWidget {
  final Uri? initialDeepLink;

  const MyApp({super.key, this.initialDeepLink});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final DeepLinkHandler _deepLinkHandler = DeepLinkHandler();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // OneSignalService().handlePendingNavigation();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _deepLinkHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isIPad(),
      builder: (context, snapshot) {
        final isIPad = snapshot.data ?? false;
        final designSize =
            isIPad
                ? const Size(768, 1024)
                : const Size(375, 812); //Size(375, 812)

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MainApp(initialDeepLink: widget.initialDeepLink);
          },
        );
      },
    );
  }
}

class MainApp extends StatefulWidget {
  final Uri? initialDeepLink;

  const MainApp({super.key, this.initialDeepLink});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: SplashScreen(initialDeepLink: widget.initialDeepLink),
      getPages: AppRouter.routes,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorKey: NavigationUtils.navigatorKey,
      onUnknownRoute: (settings) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed(AppRouter.main);
        });
        return GetPageRoute(
          settings: settings,
          page: () => const SizedBox.shrink(),
        );
      },
      unknownRoute: GetPage(
        name: '/unknown',
        page: () => SplashScreen(initialDeepLink: widget.initialDeepLink),
      ),
    );
  }
}

Future<void> generateUUID() async {
  DeviceUdid deviceUdid = await DeviceUdid.createDeviceUdid();
  var uuid = Uuid();
  deviceUdid.saveUdid(uuid.v4());
}

class SplashScreen extends StatefulWidget {
  final Uri? initialDeepLink;
  const SplashScreen({super.key, this.initialDeepLink});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasNavigated) {
      _hasNavigated = true;
      Future.microtask(() async {
        try {
          final service = await Services.create();
          final token = await service.getAccessToken();

          if (token.isNotEmpty) {
            await Get.offAllNamed(AppRouter.main);
          } else {
            await Get.offAllNamed(AppRouter.login);
          }
        } catch (e, st) {
          print('Lỗi SplashScreen: $e');
          print(st);
          await Get.offAllNamed(AppRouter.login);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(backgroundColor: Colors.white);
  }
}
