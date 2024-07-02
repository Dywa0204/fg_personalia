import 'package:fgsdm/constant/custom_colors.dart';
import 'package:fgsdm/widget/responsive/responsive_container.dart';
import 'package:fgsdm/widget/responsive/responsive_icon.dart';
import 'package:fgsdm/widget/responsive/responsive_image.dart';
import 'package:fgsdm/widget/responsive/responsive_text.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double? borderRadius;
  final Color? textColor;
  final Color? color;
  final Color? rippleColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final String? prefixImage;
  final String? suffixImage;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Color? iconColor;
  final double? iconSize;
  final VoidCallback? onClick;

  CustomButton({
    Key? key,
    this.prefixImage,
    this.suffixImage,
    this.prefixIcon,
    this.suffixIcon,
    required this.text,
    this.borderRadius,
    this.color,
    this.rippleColor,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.textColor,
    this.onClick,
    this.iconColor,
    this.iconSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
          color: color ?? CustomColor.primary
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
          highlightColor: rippleColor ?? Colors.black.withOpacity(0.2),
          splashColor: rippleColor ?? Colors.black.withOpacity(0.2),
          onTap: onClick,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    if (prefixIcon != null || prefixImage != null) ResponsiveContainer(
                      width: 42,
                      height: 42,
                      margin: EdgeInsets.only(right: prefixIcon != null ? 4 : 16),
                      child: ( prefixIcon != null ?
                        ResponsiveIcon(prefixIcon ?? Icons.person, color: iconColor ?? Color(0xFF838383), size: iconSize,) :
                        ResponsiveImage("assets/icons/${prefixImage}.png")
                      ),
                    ),
                    if (prefixImage == null && prefixIcon == null) SizedBox(height: 42,),
                    Expanded(child: ResponsiveText(
                      text,
                      textAlign: textAlign ?? TextAlign.center,
                      style: TextStyle(
                        fontSize: fontSize ?? 18,
                        color: textColor ?? Colors.white,
                        fontWeight: fontWeight ?? FontWeight.w500,
                      ),
                    )),
                    if (suffixImage == null && suffixIcon == null) SizedBox(height: 42,),
                    if (suffixIcon != null || suffixImage != null) ResponsiveContainer(
                      width: 42,
                      height: 42,
                      margin: EdgeInsets.only(left: suffixIcon != null ? 4 : 16),
                      child: ( suffixIcon != null ?
                        ResponsiveIcon(suffixIcon ?? Icons.person, color: Color(0xFF838383),) :
                        ResponsiveImage("assets/icons/${suffixImage}.png")
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

