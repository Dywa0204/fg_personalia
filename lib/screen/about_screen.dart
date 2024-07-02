import 'package:fgsdm/constant/custom_colors.dart';
import 'package:fgsdm/constant/environment.dart';
import 'package:fgsdm/widget/custom/custom_button.dart';
import 'package:flutter/material.dart';

import '../widget/responsive/responsive_image.dart';
import '../widget/responsive/responsive_text.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_pattern.png"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 10
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResponsiveImage(
                    "assets/images/fg_logo.png",
                    width: double.infinity,
                  ),
                  SizedBox(height: 86,),
                  ResponsiveText(
                    "FG PERSONALIA",
                    style: TextStyle(
                        fontFamily: "LilitaOne",
                        fontWeight: FontWeight.w500,
                        fontSize: 39
                    ),
                  ),
                  SizedBox(height: 4,),
                  ResponsiveText(
                    APP_VERSION,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20
                    ),
                  ),
                ],
              ),
            ),
            Padding(padding: EdgeInsets.all(24),
              child: CustomButton(
                text: 'Kembali',
                color: CustomColor.primary,
                borderRadius: 32,
                onClick: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

}
