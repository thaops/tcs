import 'package:flutter/material.dart';

class LeaveTextFill extends StatelessWidget {
  const LeaveTextFill({
    super.key,
    required TextEditingController textController,
  }) : _textController = textController;

  final TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      decoration: InputDecoration(
        labelText: 'Ý kiến lãnh đạo',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: 'Ý kiến của công ty......',
        contentPadding: const EdgeInsets.symmetric(
            vertical: 15, horizontal: 20), // Tạo padding bên trong
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide:
              BorderSide(color: Colors.blue, width: 2), // Viền xanh khi focus
        ),
      ),
      maxLines: null,
      minLines: 5, // Ít nhất 5 dòng
    );
  }
}
