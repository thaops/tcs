// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/widgets/custom_buttom.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class LeaveButtonBrowse extends StatefulWidget {
  const LeaveButtonBrowse({
    Key? key,
    required this.approver_on,
    required this.approver_off,
  }) : super(key: key);
  final Function approver_on;
  final Function approver_off;

  @override
  State<LeaveButtonBrowse> createState() => _LeaveButtonBrowseState();
}

class _LeaveButtonBrowseState extends State<LeaveButtonBrowse> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 30),
      child: Row(
        children: [
          Expanded(
            child: CustomButtom(
              onTap: () {
                widget.approver_off();
              },
              text: "Từ chối",
              colorBackground: Colors.white,
              colorText: AppColors.colorRed,
              boderRadius: 20,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: CustomButtom(
              onTap: () {
                widget.approver_on();
              },
              text: "Duyệt",
              colorBackground: AppColors.primary,
              colorText: AppColors.white,
              boderRadius: 20,
            ),
          ),
        ],
      ),
    );
  }
}
