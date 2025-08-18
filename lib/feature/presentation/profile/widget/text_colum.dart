import 'package:flutter/widgets.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextColum extends StatelessWidget {
  final String? text;
  final String? title;
  const TextColum({super.key, this.text, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextWidget(text: title ?? '', fontSize: 14, fontWeight: FontWeight.w300,),
          4.verticalSpace,
          TextWidget(text: text ?? '', fontSize: 16, fontWeight: FontWeight.bold,),
        ],
      ),
    );
  }
}