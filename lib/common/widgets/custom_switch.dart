import 'package:flutter/material.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String textOn;
  final String textOff;

  CustomSwitch({
    required this.value,
    required this.onChanged,
    this.textOn = "On",
    this.textOff = "Off",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 70,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: value ? AppColors.primary : Colors.grey.shade300,
        ),
        child: Stack(
          children: [
            Align(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: value ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  value ? textOn : textOff,
                  style: TextStyle(
                    color: value ? Colors.white : Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
