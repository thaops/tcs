import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomPopupMenu extends StatelessWidget {
  final Function(String) optionMenu;
  final List<CupertinoActionSheetAction> actionSheetAction;

  const CustomPopupMenu({Key? key, required this.optionMenu, required this.actionSheetAction}) : super(key: key);

  void _showActionSheet(BuildContext context) {

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: actionSheetAction,
        // cancelButton: CupertinoActionSheetAction(
        //   isDefaultAction: true,
        //   child: const Text('Hủy'),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.more_horiz,
        color: CupertinoColors.systemGrey,
        size: 24,
      ),
      onPressed: () => _showActionSheet(context),
    );
  }
}