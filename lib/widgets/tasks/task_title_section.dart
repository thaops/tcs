import 'package:flutter/material.dart';

class TaskTitleSection extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String title;
  final double screenWidth;

  TaskTitleSection({
    required this.controller,
    required this.label,
    required this.title,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground),
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
          onTap: () {
            print('Tiêu đề công việc nhấp vào');
          },
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: TextField(
              controller: controller,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
                ),
              ),
              maxLines: null,
              minLines: 3,
            ),
          ),
        ),
      ],
    );
  }
}
