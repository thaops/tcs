// import 'package:npp/controllers/base/base_controller.dart';
// import 'package:npp/controllers/plugins/controller_plugin.dart';
// import '../mixins/analytics_mixin.dart';

// class AnalyticsPlugin implements ControllerPlugin {
//   @override
//   Future<void> beforeAction(BaseController controller) async {
//     if (controller is AnalyticsMixin) {
//       AnalyticsMixin.trackEvent('action_started');
//     }
//   }

//   @override
//   Future<void> afterAction(BaseController controller) async {
//     if (controller is AnalyticsMixin) {
//       AnalyticsMixin.trackEvent('action_completed');
//     }
//   }

//   @override
//   Future<void> onError(BaseController controller, dynamic error) async {
//     if (controller is AnalyticsMixin) {
//       AnalyticsMixin.trackEvent('action_error', {'error': error.toString()});
//     }
//   }
// }