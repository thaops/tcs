// import 'dart:developer' as AnalyticsService;

// import 'package:npp/controllers/base/base_controller.dart';

// mixin AnalyticsMixin on BaseController {
//   // Declare screenName without initializing it here
//   late final String screenName;

//  static void trackEvent(String eventName, [Map<String, dynamic>? params]) {
//     AnalyticsService.log(eventName,); // Use AnalyticsService
//   }

//   @override
//   void onReady() {
//     super.onReady();
//     trackScreenView();
//   }

//   void trackScreenView() {
//     trackEvent('screen_view', {'screen_name': screenName});
//   }
// }