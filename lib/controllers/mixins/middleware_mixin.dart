import 'package:tcs_flutter/controllers/base/base_controller.dart';

mixin ControllerMiddleware on BaseController {
  final List<Future Function()> _beforeActions = [];
  final List<Future Function()> _afterActions = [];

  void addBeforeAction(Future Function() action) {
    _beforeActions.add(action);
  }

  void addAfterAction(Future Function() action) {
    _afterActions.add(action);
  }

  Future<void> executeWithMiddleware(Future Function() action) async {
    try {
      for (final beforeAction in _beforeActions) {
        await beforeAction();
      }
      await action();
      for (final afterAction in _afterActions) {
        await afterAction();
      }
    } catch (e) {
      setStatus(ControllerStatus.error, error: e.toString());
    }
  }
}