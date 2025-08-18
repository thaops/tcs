import 'package:get/get.dart';
import 'package:tcs_flutter/controllers/base/base_controller.dart';

mixin FormMixin on BaseController {
  final RxBool isFormValid = false.obs;
  final RxBool isSubmitting = false.obs;

  void validateForm();

  Future<void> submitForm();

  void setFormValid(bool valid) {
    isFormValid.value = valid;
  }

  void setSubmitting(bool submitting) {
    isSubmitting.value = submitting;
  }
}