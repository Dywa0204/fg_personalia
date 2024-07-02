import 'package:fgsdm/utils/general_helper.dart';
import 'package:flutter/material.dart';

class ResponsiveIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;

  const ResponsiveIcon(
      this.icon, {
        Key? key,
        this.size,
        this.color,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double iconSize = size ?? 24; // Default font size
    return Icon(
      icon,
      size: GeneralHelper.calculateSize(context, iconSize),
      color: color,
    );
  }
}
