import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/widgets/styles/gogbal_styles.dart';
import 'package:tcs_flutter/src/config/constants/color/colors.dart';

class TextTasksRow extends StatelessWidget {
  final String? text1;
  final String? text2;
  const TextTasksRow({Key? key, required this.text1, required this.text2})
    : super(key: key);

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
      case 'Đang xử lý':
        titleColor = Color.fromARGB(255, 158, 158, 4);
        break;
      case 'Đang chờ xử lý':
        titleColor = grey;
        break;
      case 'Đã duyệt':
        titleColor = done;
        break;
      case 'Từ chối':
        titleColor = pending;
        break;
      default:
        titleColor = Colors.black87;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('$text1:' ?? '', style: GogbalStyles.bodyText2),
        SizedBox(width: 10),
        Text(
          text2 ?? '',
          style: GogbalStyles.bodyText1.copyWith(
            color: text1 == 'Trạng thái' ? titleColor : priorityColor,
          ),
        ),
      ],
    );
  }
}
