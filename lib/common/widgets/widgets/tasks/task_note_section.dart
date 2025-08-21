import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/common/widgets/custom_text_field.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';

class TaskNoteSection extends StatelessWidget {
  final TextEditingController controllerNote;
  final String label;
  final String note;
  final double screenWidth;
  final bool isEnabled;

  TaskNoteSection({
    required this.label,
    required this.note,
    required this.screenWidth,
    required this.controllerNote,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
         text:  label,
         fontSize: 16.sp,
         fontWeight: FontWeight.w600,

        ),
         SizedBox(height: 10.h),
        CustomTextField(
          controller: controllerNote,
          hintText: note,
          maxLines: 4,
          borderRadius: 24,
          textCapitalization: TextCapitalization.sentences,
          isEnabled: isEnabled,
        ),
      ],
    );
  }
}
