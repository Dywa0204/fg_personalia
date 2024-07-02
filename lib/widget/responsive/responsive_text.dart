import 'package:flutter/material.dart';

import '../../utils/general_helper.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;

  const ResponsiveText(
      this.text, {
        Key? key,
        this.style,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.softWrap
      }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double fontSize = style?.fontSize ?? 14;
    return Text(
      text,
      style: style?.copyWith(fontSize: GeneralHelper.calculateSize(context, fontSize)),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}
