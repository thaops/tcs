import 'package:flutter/material.dart';
import 'package:tcs_flutter/core/configs/theme/app_colors.dart';

class CustomColor {
  Color getColorFromHex(Object? color) {
    if (color == null) {
      return Color.fromARGB(255, 26, 9, 136);
    }

    final colorStr = color.toString().trim();

    if (colorStr.contains("linear-gradient")) {
      var gradient = parseGradient(colorStr);
      return gradient.colors.isNotEmpty ? gradient.colors.first : Colors.grey;
    }

    if (colorStr.startsWith("#")) {
      return _getColorFromHexCode(colorStr);
    }

    if (colorStr.startsWith("rgb(")) {
      return _parseRgb(colorStr);
    }

    if (colorStr.startsWith("rgba(")) {
      return _parseRgba(colorStr);
    }

    return Color.fromARGB(255, 26, 9, 136);
  }

  Color _getColorFromHexCode(String hexCode) {
    hexCode = hexCode.replaceAll("#", "");
    if (hexCode.length == 6) {
      hexCode = "FF$hexCode";
    }
    return Color(int.parse("0x$hexCode"));
  }

  Color _parseRgb(String rgbString) {
    final regex = RegExp(r'rgb\((\d+),\s*(\d+),\s*(\d+)\)');
    final match = regex.firstMatch(rgbString);
    if (match != null) {
      return Color.fromARGB(
        255,
        int.parse(match.group(1)!),
        int.parse(match.group(2)!),
        int.parse(match.group(3)!),
      );
    }
    return Color.fromARGB(255, 26, 9, 136);
  }

  Color _parseRgba(String rgbaString) {
    final regex = RegExp(r'rgba\((\d+),\s*(\d+),\s*(\d+),\s*([0-9.]+)\)');
    final match = regex.firstMatch(rgbaString);
    if (match != null) {
      final alpha = (double.parse(match.group(4)!) * 255).toInt();
      return Color.fromARGB(
        alpha,
        int.parse(match.group(1)!),
        int.parse(match.group(2)!),
        int.parse(match.group(3)!),
      );
    }
    return Color.fromARGB(255, 26, 9, 136);
  }

  LinearGradient parseGradient(String gradientString) {
    var regex = RegExp(r"rgba\((\d+),(\d+),(\d+),([0-9.]+)\)");
    var matches = regex.allMatches(gradientString);

    List<Color> colors = [];
    for (var match in matches) {
      int r = int.parse(match.group(1)!);
      int g = int.parse(match.group(2)!);
      int b = int.parse(match.group(3)!);
      double a = double.parse(match.group(4)!);
      colors.add(Color.fromRGBO(r, g, b, a));
    }

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }
   Color getColor(String stateName) {
    switch (stateName) {
      case "Backlog":
        return AppColors.colorBacklog;
      case "In-Progress":
        return AppColors.inProgress;
      case "Done":
        return AppColors.colorDoing;
      case "Waiting & Pending":
        return AppColors.colorWaitingAndPending;
      case "Specification":
        return AppColors.colorSpecification;
      case "Development":
        return AppColors.colorDevelopment;
      case "In-Review":
        return AppColors.colorInReview;
      default:
        return AppColors.colorBacklog;
    }
  }

  Color getColorPriority(String stateName){

    switch (stateName.toLowerCase()) {
      case "high":
        return const Color.fromARGB(255, 211, 114, 10);
      case "medium":
        return AppColors.colorMedium;
      case "normal":
        return AppColors.colorNormal;
      case "low":
        return AppColors.colorLow;
      default:
        return AppColors.colorBacklog;
    }
  }

     Color getColorLower(String stateName) {
    if(stateName.toLowerCase().contains("backlog")){
      return AppColors.colorBacklog;
    }
    if(stateName.toLowerCase().contains("in-progress")){
      return AppColors.inProgress;
    }
    if(stateName.toLowerCase().contains("done")){
      return AppColors.colorDoing;
    }
    if(stateName.toLowerCase().contains("pending")){
      return AppColors.colorWaitingAndPending;
    }
    if(stateName.toLowerCase().contains("specification")){
      return AppColors.colorSpecification;
    }
    if(stateName.toLowerCase().contains("dev")){
      return AppColors.colorDevelopment;
    }
    if(stateName.toLowerCase().contains("review")){
      return AppColors.colorInReview;
    }
    return AppColors.colorBacklog;
  }

    Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'dev':
        return Colors.orange;
      case 'pending':
        return Colors.yellow;
      case 'review':
        return Colors.blue;
      case 'backlog':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

    Color getStatusColorReport(String status) {
    switch (status) {
      case "dev":
        return Colors.blue[300]!;
      case "backlog":
        return Colors.yellow[300]!;
      case "done":
        return Colors.green[300]!;
      default:
        return Colors.blue[300]!;
    }
  }

}
