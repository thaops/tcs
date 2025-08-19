import 'package:flutter/material.dart';
import 'package:tcs_flutter/common/extensions/widget_ext.dart';

extension ColumnExtensions on Column {
  Column spacedVertically(double space) => Column(
    key: key,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    crossAxisAlignment: crossAxisAlignment,
    textDirection: textDirection,
    verticalDirection: verticalDirection,
    textBaseline: textBaseline,
    children: children.map((child) => child.py(space)).toList(),
  );
}

extension RowExtensions on Row {
  Row spacedHorizontally(double space) => Row(
    key: key,
    mainAxisAlignment: mainAxisAlignment,
    mainAxisSize: mainAxisSize,
    crossAxisAlignment: crossAxisAlignment,
    textDirection: textDirection,
    verticalDirection: verticalDirection,
    textBaseline: textBaseline,
    children: children.map((child) => child.px(space)).toList(),
  );
}

// Extension cho ListView thông thường
extension ListViewChildrenExtensions on ListView {
  static List<Widget>? _getChildren(ListView listView) {
    try {
      final dynamic original = listView;
      return original.children as List<Widget>?;
    } catch (_) {
      return null;
    }
  }

  ListView withBouncingPhysics() {
    final children = _getChildren(this);
    if (children != null) {
      return ListView(
        key: key,
        scrollDirection: scrollDirection,
        reverse: reverse,
        controller: controller,
        primary: primary,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: shrinkWrap,
        padding: padding,
        itemExtent: itemExtent,
        cacheExtent: cacheExtent,
        children: children,
      );
    }
    return this;
  }
}

// Extension cho ListView.builder
extension ListViewBuilderExtensions on ListView {
  static int? _getItemCount(ListView listView) {
    try {
      final dynamic original = listView;
      final v = original.itemCount;
      if (v == null) return null;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    } catch (_) {
      return null;
    }
  }

  static IndexedWidgetBuilder? _getItemBuilder(ListView listView) {
    try {
      final dynamic original = listView;
      return original.itemBuilder as IndexedWidgetBuilder?;
    } catch (_) {
      return null;
    }
  }

  ListView withBuilderBouncingPhysics() {
    final itemCount = _getItemCount(this);
    final itemBuilder = _getItemBuilder(this);
    
    if (itemCount != null && itemBuilder != null) {
      return ListView.builder(
        key: key,
        scrollDirection: scrollDirection,
        reverse: reverse,
        controller: controller,
        primary: primary,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: shrinkWrap,
        padding: padding,
        itemExtent: itemExtent,
        cacheExtent: cacheExtent,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );
    }
    return this;
  }
}

// Extension cho ListView.separated
extension ListViewSeparatedExtensions on ListView {
  static IndexedWidgetBuilder? _getSeparatorBuilder(ListView listView) {
    try {
      final dynamic original = listView;
      return original.separatorBuilder as IndexedWidgetBuilder?;
    } catch (_) {
      return null;
    }
  }

  ListView withSeparatedBouncingPhysics() {
    final itemCount = ListViewBuilderExtensions._getItemCount(this);
    final itemBuilder = ListViewBuilderExtensions._getItemBuilder(this);
    final separatorBuilder = _getSeparatorBuilder(this);
    
    if (itemCount != null && itemBuilder != null && separatorBuilder != null) {
      return ListView.separated(
        key: key,
        scrollDirection: scrollDirection,
        reverse: reverse,
        controller: controller,
        primary: primary,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: shrinkWrap,
        padding: padding,
        cacheExtent: cacheExtent,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: separatorBuilder,
      );
    }
    return this;
  }
}