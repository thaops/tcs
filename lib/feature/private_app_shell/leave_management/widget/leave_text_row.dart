// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/common/widgets/styles/gogbal_styles.dart';
import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';

class LeaveTextRow extends StatelessWidget {
  final String? mission;
  final String? name;
  const LeaveTextRow({Key? key, this.mission, this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: "${mission ?? ''}",
          fontSize: 13.0.sp,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        Expanded(
          child: TextWidget(
            text: "$name",
            maxLines: 4,
            fontSize: 13.0.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
