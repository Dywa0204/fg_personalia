import 'package:fgsdm/utils/general_helper.dart';
import 'package:fgsdm/widget/responsive/responsive_container.dart';
import 'package:fgsdm/widget/responsive/responsive_icon.dart';
import 'package:fgsdm/widget/responsive/responsive_image.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatefulWidget {
  final String hint;
  final TextInputType? type;
  final bool? obscureText;
  final TextEditingController controller;
  final Color? backgroundColor;
  final Color? hintColor;
  final Color? textColor;
  final Color? iconColor;
  final String? prefixImage;
  final String? suffixImage;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? bottomView;
  final VoidCallback? suffixIconCallback;
  final CustomFormFieldController? formFieldController;
  final BorderRadius? borderRadius;
  final double? prefixMargin;
  final VoidCallback? onTap;
  final VoidCallback? onTapOutside;
  final int? minLines;
  final int? maxLines;
  final Function(String)? onChange;

  const CustomFormField({
    Key? key,
    required this.hint,
    this.type,
    this.obscureText,
    required this.controller,
    this.backgroundColor,
    this.hintColor,
    this.textColor,
    this.iconColor,
    this.prefixImage,
    this.suffixImage,
    this.prefixIcon,
    this.suffixIcon,
    this.bottomView,
    this.suffixIconCallback,
    this.formFieldController,
    this.borderRadius,
    this.prefixMargin,
    this.onTap,
    this.onTapOutside,
    this.minLines,
    this.maxLines,
    this.onChange,
  }) : super(key: key);

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  late IconData? suffixIcon;
  late String? suffixImage;
  late bool? obscureText;

  @override
  void initState() {
    super.initState();

    suffixIcon = widget.suffixIcon;
    suffixImage = widget.suffixImage;
    obscureText = widget.obscureText;

    widget.formFieldController?._attach(this);
  }

  @override
  void dispose() {
    widget.formFieldController?._detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.all(Radius.circular(8)),
        color: widget.backgroundColor ?? Color(0xEBECF0FF),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.prefixIcon != null || widget.prefixImage != null)
                ResponsiveContainer(
                  margin: EdgeInsets.only(top: 6),
                  width: 42,
                  height: 42,
                  child: widget.prefixIcon != null
                      ? ResponsiveIcon(
                    widget.prefixIcon ?? Icons.person,
                    color: widget.iconColor ?? Color(0xFF838383),
                  )
                      : ResponsiveImage("assets/icons/${widget.prefixImage}.png"),
                ),
              SizedBox(width: widget.prefixIcon != null ? 4 : 16),
              if (widget.prefixMargin != null) SizedBox(width: widget.prefixMargin,),
              Expanded(
                child: TextFormField(
                  onChanged: widget.onChange,
                  minLines: widget.minLines ?? 1,
                  maxLines: widget.maxLines ?? 1,
                  onTap: widget.onTap,
                  onTapOutside: (a) {
                    if (widget.onTapOutside != null) widget.onTapOutside!();
                  },
                  controller: widget.controller,
                  obscureText: obscureText ?? false,
                  style: TextStyle(
                    color: widget.textColor ?? Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: GeneralHelper.calculateSize(context, 14)
                  ),
                  keyboardType: widget.type ?? TextInputType.text,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: widget.hintColor ?? Color(0xFF838383),
                      fontSize: GeneralHelper.calculateSize(context, 14)
                    ),
                    border: InputBorder.none,
                    labelText: widget.hint,
                  ),
                ),
              ),
              SizedBox(width: suffixIcon != null ? 4 : 16),
              if (suffixIcon != null || suffixImage != null)
                InkWell(
                  onTap: widget.suffixIconCallback,
                  child: ResponsiveContainer(
                    width: 42,
                    height: 42,
                    child: suffixIcon != null
                        ? ResponsiveIcon(
                      suffixIcon!,
                      color: widget.iconColor ?? Color(0xFF838383),
                    )
                        : ResponsiveImage("assets/icons/$suffixImage.png"),
                  ),
                ),
            ],
          ),
          if (widget.bottomView != null)
            AnimatedSize(
              duration: Duration(milliseconds: 200),
              child: Container(
                child: widget.bottomView,
              ),
            )
        ],
      ),
    );
  }

  void setSuffixIcon({String? image, IconData? icon}) {
    setState(() {
      if (image != null) {
        suffixImage = image;
        suffixIcon = null;
      } else if (icon != null) {
        suffixIcon = icon;
        suffixImage = null;
      }
    });
  }

  bool? getObscureText() {
    return obscureText;
  }

  void setObscureText(bool value) {
    setState(() {
      obscureText = value;
    });
  }
}

class CustomFormFieldController {
  _CustomFormFieldState? _state;

  void _attach(_CustomFormFieldState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  void setSuffixIcon({String? image, IconData? icon}) {
    _state?.setSuffixIcon(image: image, icon: icon);
  }

  bool? getObscureText() {
    return _state?.getObscureText();
  }

  void setObscureText(bool obscureText) {
    _state?.setObscureText(obscureText);
  }
}
