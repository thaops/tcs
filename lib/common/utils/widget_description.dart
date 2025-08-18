import 'dart:convert';

import 'package:fleather/fleather.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/common/design_system/tokens/app_sizes.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class WidgetDescription {
  static Widget buildDescription(TextEditingController controller,
      FleatherController controllerFleather, bool isUpdate) {
// List<Map<String, dynamic>> document;
//     try {
//       if (controller.text.isNotEmpty) {
//         document = BlocknoteConverter.blocknoteToFleatherDelta(
//             jsonDecode(controller.text));
//       } else {
//         document = [
//           {'insert': '\n'}
//         ];
//       }
//     } catch (e) {
//       debugPrint('Error parsing JSON: $e');
//       document = [
//         {'insert': '\n'}
//       ];
//     }

//     controllerFleather =
//         FleatherController(document: ParchmentDocument.fromJson(document));
    return IntrinsicHeight(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.paddingMedium),
        child: Container(
          padding: EdgeInsets.all(AppSizes.paddingSmall.w),
          height: isUpdate ? 500.h : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium.r),
            border: Border.all(color: Colors.grey.shade400, width: 0.5.w),
            color: isUpdate ? AppColors.white : Colors.grey.shade200,
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              children: [
                isUpdate
                    ? FleatherToolbar.basic(controller: controllerFleather)
                    : Container(),
                Expanded(
                  child: FleatherEditor(
                      readOnly: !isUpdate, controller: controllerFleather),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
