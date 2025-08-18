import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcs_flutter/common/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomUserFilter extends StatelessWidget {
  final String? department;
  final String? avatar;
  final String? name;
  final String? email;

  CustomUserFilter({super.key, this.email, this.name, this.department, this.avatar});

  @override
  Widget build(BuildContext context) {
    final String displayName = (name ?? '').trim();
    final bool hasValidAvatar = () {
      final url = avatar?.trim();
      if (url == null || url.isEmpty) return false;
      final uri = Uri.tryParse(url);
      return uri != null && (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
    }();

    String _initials(String fullName) {
      if (fullName.isEmpty) return '?';
      final parts = fullName.split(RegExp(r"\s+")).where((e) => e.isNotEmpty).toList();
      if (parts.isEmpty) return '?';
      if (parts.length == 1) return parts.first.characters.take(1).toString().toUpperCase();
      final first = parts.first.characters.take(1).toString();
      final last = parts.last.characters.take(1).toString();
      return (first + last).toUpperCase();
    }

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            backgroundImage: hasValidAvatar ? CachedNetworkImageProvider(avatar!.trim()) : null,
            child: hasValidAvatar
                ? null
                : Text(
                    _initials(displayName),
                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                  ),
          ),
          title: TextWidget(
            text: displayName,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          // subtitle: TextWidget(
          //   text: email ?? '',
          //   fontSize: 14.sp,
          //   fontWeight: FontWeight.w400,
          // ),
        ),
        Padding(padding: EdgeInsets.symmetric(horizontal: 16.w), child: Divider()), // Thêm dòng kẻ giữa các nhân viên
      ],
    );
  }
}
