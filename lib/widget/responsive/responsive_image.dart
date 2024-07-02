import 'package:fgsdm/utils/general_helper.dart';
import 'package:flutter/material.dart';

class ResponsiveImage extends StatelessWidget {
  final String name;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const ResponsiveImage(
      this.name, {
        Key? key,
        this.width,
        this.height,
        this.fit
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageWidth = width ?? double.infinity;
    double imageHeight = height ?? double.infinity;
    return Image.asset(
      name,
      width: width != null ? GeneralHelper.calculateSize(context, imageWidth) : null,
      height: height != null ? GeneralHelper.calculateSize(context, imageHeight) : null,
      fit: fit,
    );
  }
}
