import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/common/design_system/tokens/app_sizes.dart';

extension TextExtensions on Text {
  /* ----------- Các phương thức cơ bản ----------- */
  Text _copyWith({
    String? data,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) {
    return Text(
      data ?? this.data!,
      style: style ?? this.style,
      strutStyle: strutStyle ?? this.strutStyle,
      textAlign: textAlign ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
      locale: locale ?? this.locale,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      maxLines: maxLines ?? this.maxLines,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
      selectionColor: selectionColor ?? this.selectionColor,
    );
  }

  /* ----------- Kích thước font ----------- */
  Text size(double size) => _copyWith(style: (style ?? TextStyle()).copyWith(fontSize: size.sp));
  
  Text get xSmall => size(AppSizes.fontSizeXSmall);
  Text get small => size(AppSizes.fontSizeSmall);
  Text get medium => size(AppSizes.fontSizeMedium);
  Text get large => size(AppSizes.fontSizeLarge);
  Text get xLarge => size(AppSizes.fontSizeXLarge);
  Text get xxLarge => size(AppSizes.fontSizeXXLarge);

  /* ----------- Màu sắc ----------- */
  Text color(Color color) => _copyWith(style: (style ?? TextStyle()).copyWith(color: color));
  
  Text get primaryColor => color(Colors.blue);
  Text get secondaryColor => color(Colors.green);
  Text get errorColor => color(Colors.red);
  Text get disabledColor => color(Colors.grey);

  /* ----------- Font Weight ----------- */
  Text weight(FontWeight weight) => _copyWith(style: (style ?? TextStyle()).copyWith(fontWeight: weight));
  
  Text get bold => weight(FontWeight.bold);
  Text get semiBold => weight(FontWeight.w600);
  Text get mediumWeight => weight(FontWeight.w500);
  Text get normal => weight(FontWeight.normal);
  Text get light => weight(FontWeight.w300);

  /* ----------- Text Overflow ----------- */
  Text get ellipsis => _copyWith(overflow: TextOverflow.ellipsis);
  Text get fade => _copyWith(overflow: TextOverflow.fade);
  Text get clip => _copyWith(overflow: TextOverflow.clip);
  Text get visible => _copyWith(overflow: TextOverflow.visible);

  /* ----------- Font Style ----------- */
  Text get italic => _copyWith(style: (style ?? TextStyle()).copyWith(fontStyle: FontStyle.italic));
  Text get underline => _copyWith(style: (style ?? TextStyle()).copyWith(decoration: TextDecoration.underline));
  Text get lineThrough => _copyWith(style: (style ?? TextStyle()).copyWith(decoration: TextDecoration.lineThrough));

  /* ----------- Max Lines ----------- */
  Text lines(int lines) => _copyWith(maxLines: lines);
  Text get singleLine => lines(1);
  Text get twoLines => lines(2);
  Text get threeLines => lines(3);

  /* ----------- Text Align ----------- */
  Text get alignLeft => _copyWith(textAlign: TextAlign.left);
  Text get alignRight => _copyWith(textAlign: TextAlign.right);
  Text get alignCenter => _copyWith(textAlign: TextAlign.center);
  Text get alignJustify => _copyWith(textAlign: TextAlign.justify);

  /* ----------- Letter Spacing & Height ----------- */
  Text letterSpacing(double spacing) => _copyWith(style: (style ?? TextStyle()).copyWith(letterSpacing: spacing));
  Text height(double height) => _copyWith(style: (style ?? TextStyle()).copyWith(height: height));

  /* ----------- Kết hợp với Container ----------- */
  Container toContainer() => Container(child: this);
}