import 'package:fgsdm/constant/custom_colors.dart';
import 'package:fgsdm/widget/responsive/responsive_text.dart';
import 'package:flutter/material.dart';

class CustomLoadingList extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? backgroundColor;
  const CustomLoadingList(this.text, {Key? key, this.textColor, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: CustomColor.primary
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
          SizedBox(width: 16,),
          ResponsiveText(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 13
            ),
          )
        ],
      ),
    );
  }
}
