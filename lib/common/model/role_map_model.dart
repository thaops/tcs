import 'package:tcs_flutter/common/widgets/custom_select.dart';

class RoleMapModel {
  final String? office;
  final String? sale;
  final String? ba;
  final String? design;
  final String? api;
  final String? web;
  final String? ios;
  final String? android;
  final String? tester;
  final String? review;
  final String? golive;
  final String? other;

  RoleMapModel({
    this.office,
    this.sale,
    this.ba,
    this.design,
    this.api,
    this.web,
    this.ios,
    this.android,
    this.tester,
    this.review,
    this.golive,
    this.other,
  });

  factory RoleMapModel.fromJson(Map<String, dynamic> json) {
    return RoleMapModel(
      office: json['office'] as String?,
      sale: json['sale'] as String?,
      ba: json['BA'] as String?, // Key viết hoa
      design: json['design'] as String?,
      api: json['api'] as String?,
      web: json['web'] as String?,
      ios: json['iOS'] as String?, // Key viết hoa
      android: json['android'] as String?,
      tester: json['tester'] as String?,
      review: json['review'] as String?,
      golive: json['golive'] as String?,
      other: json['other'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'office': office,
      'sale': sale,
      'BA': ba,
      'design': design,
      'api': api,
      'web': web,
      'iOS': ios,
      'android': android,
      'tester': tester,
      'review': review,
      'golive': golive,
      'other': other,
    };
  }

    List<Item> roleMapToReversedItemList(RoleMapModel? roleMap) {
    if (roleMap == null) return [];

    return [
    if (roleMap.office != null) Item(id: (roleMap.office!).toLowerCase(), name: (roleMap.office!)),
    if (roleMap.sale != null) Item(id: (roleMap.sale!).toLowerCase(), name: (roleMap.sale!)),
    if (roleMap.ba != null) Item(id: (roleMap.ba!).toLowerCase(), name: (roleMap.ba!)),
    if (roleMap.design != null) Item(id: (roleMap.design!).toLowerCase(), name: (roleMap.design!)),
    if (roleMap.api != null) Item(id: (roleMap.api!).toLowerCase(), name: (roleMap.api!)),
    if (roleMap.web != null) Item(id: (roleMap.web!).toLowerCase(), name: (roleMap.web!)),
    if (roleMap.ios != null) Item(id: (roleMap.ios!).toLowerCase(), name: (roleMap.ios!)),
    if (roleMap.android != null) Item(id: (roleMap.android!).toLowerCase(), name: (roleMap.android!)),
    if (roleMap.tester != null) Item(id: (roleMap.tester!).toLowerCase(), name: (roleMap.tester!)),
    if (roleMap.review != null) Item(id: (roleMap.review!).toLowerCase(), name: (roleMap.review!)),
    if (roleMap.golive != null) Item(id: (roleMap.golive!).toLowerCase(), name: (roleMap.golive!)),
    if (roleMap.other != null) Item(id: (roleMap.other!).toLowerCase(), name: (roleMap.other!)),
  ];
}
}
