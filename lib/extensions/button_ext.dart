import 'package:flutter/material.dart';

extension ElevatedButtonExtensions on ElevatedButton {
  ElevatedButton fullWidth() => ElevatedButton(
    style: (style ?? const ButtonStyle()).copyWith(
      minimumSize: MaterialStateProperty.all(const Size(double.infinity, 48)),
    ),
    onPressed: onPressed,
    child: child!,
  );
}

extension TextButtonExtensions on TextButton {
  TextButton withIcon(Icon icon) => TextButton.icon(
    onPressed: onPressed,
    icon: icon,
    label: child!,
  );
}