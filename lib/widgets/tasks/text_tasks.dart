import 'package:flutter/material.dart';
import 'package:tcs_flutter/src/config/constants/color/colors.dart';

import 'package:tcs_flutter/styles/gogbal_styles.dart';

class TextTasks extends StatelessWidget {
  final String? text1;
  final String? text2;
  final IconData? icon;
  const TextTasks({
    Key? key,
    required this.text1,
    required this.text2,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? priorityColor;
    switch (text2) {
      case 'high':
        priorityColor = high;
        break;
      case 'medium':
        priorityColor = medium;
        break;
      case 'low':
        priorityColor = low;
        break;
      default:
        priorityColor = Colors.black87;
    }

    Color? titleColor;
    switch (text2) {
      case 'in-progress':
        titleColor = in_progress;
        break;
      case 'backlog':
        titleColor = backlog;
        break;
      case 'done':
        titleColor = done;
        break;
      case 'pending':
        titleColor = pending;
        break;
      default:
        priorityColor = Colors.black87;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text1 ?? '',
          style: GogbalStyles.bodyText2,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            if (icon != null) Icon(icon),
            SizedBox(width: icon != null ? 8 : 0),
            Text(text2 ?? '',
                style: GogbalStyles.bodyText1.copyWith(
                    color: text1 == 'Trạng thái' ? titleColor : priorityColor))
          ],
        )
      ],
    );
  }
}
