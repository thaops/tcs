// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:tcs_flutter/common/widgets/styles/gogbal_styles.dart';
import 'package:flutter/material.dart';

class LeaveTextRow extends StatelessWidget {
  final String? mission;
  final String? name;
  const LeaveTextRow({
    Key? key,
    this.mission,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${mission ?? ''}",
          style: GogbalStyles.textLeave1,
        ),
        Expanded(
          child: Text(
            "$name",
            style: GogbalStyles.textLeave2,
            softWrap: true,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
