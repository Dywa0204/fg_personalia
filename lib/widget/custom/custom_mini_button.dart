import 'package:fgsdm/constant/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomMiniButton extends StatefulWidget {
  final Widget child;
  final double? borderRadius;
  final Color? color;
  final Color? rippleColor;
  final VoidCallback? onClick;
  final EdgeInsets? padding;
  final Function(BuildContext)? onClickWithContext;
  final CustomMiniButtonController? controller;

  CustomMiniButton({Key? key, required this.child, this.borderRadius, this.color, this.rippleColor, this.onClick, this.padding, this.onClickWithContext, this.controller}) : super(key: key);

  @override
  State<CustomMiniButton> createState() => _CustomMiniButtonState();
}

class _CustomMiniButtonState extends State<CustomMiniButton> {
  @override
  void initState() {
    super.initState();

    widget.controller?._attach(this);
  }

  _refresh() {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 8)),
          color: widget.color ?? CustomColor.primary
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 8)),
          highlightColor: widget.rippleColor ?? Colors.black.withOpacity(0.2),
          splashColor: widget.rippleColor ?? Colors.black.withOpacity(0.2),
          onTap: widget.onClick ?? () {
            widget.onClickWithContext!(context);
          },
          child: Container(
            padding: widget.padding ?? EdgeInsets.all(8),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class CustomMiniButtonController {
  _CustomMiniButtonState? _state;

  void _attach(_CustomMiniButtonState state) {
    _state = state;
  }

  void _detach() {
    _state = null;
  }

  void refresh() {
    _state?._refresh();
  }
}

