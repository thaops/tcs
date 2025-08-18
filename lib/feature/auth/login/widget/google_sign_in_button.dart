import 'package:flutter/material.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String iconPath;

  GoogleSignInButton({required this.onPressed, required this.text, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.colorBackgroundGoogle,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10),
              Text(
                text,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
