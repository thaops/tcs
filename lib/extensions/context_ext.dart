import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // MediaQuery
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;

  // Theme
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  Color get primaryColor => Theme.of(this).colorScheme.primary;

  // Navigation
  // void pop<T>([T? result]) => Navigator.of(this).pop(result);
  // Future<T?> push(Widget page) => Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
}