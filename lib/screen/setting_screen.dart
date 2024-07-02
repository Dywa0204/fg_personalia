import 'package:fgsdm/constant/custom_colors.dart';
import 'package:fgsdm/screen/main_screen.dart';
import 'package:fgsdm/utils/general_helper.dart';
import 'package:fgsdm/widget/custom/custom_card.dart';
import 'package:flutter/material.dart';

import '../widget/responsive/responsive_icon.dart';
import '../widget/responsive/responsive_text.dart';

class SettingScreen extends StatefulWidget {
  final BuildContext context;
  const SettingScreen({Key? key, required this.context}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  double _sizeValue = GeneralHelper.scalingPercentage;
  double _sizeValueTemp = GeneralHelper.scalingPercentage;
  bool _isAlert = GeneralHelper.isUseAlert;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.secondary,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      if (_sizeValue != _sizeValueTemp) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
                      }
                    },
                    child: ResponsiveIcon(Icons.arrow_back, color: Colors.black, size: 28),
                  ),
                  SizedBox(width: 16,),
                  Expanded(
                    child: ResponsiveText(
                      "Pengaturan",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24,),
              
              CustomCard(
                child: Column(
                  children: [
                    Row(
                      children: [
                        ResponsiveIcon(Icons.aspect_ratio_rounded, color: Colors.black,),
                        SizedBox(width: 16,),
                        Expanded(
                          child: ResponsiveText(
                            "Ukuran Antarmuka Aplikasi",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        ResponsiveText(
                          _sizeValue.round().toString() + "%",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8,),
                    Slider(
                      value: _sizeValue,
                      max: 100,
                      divisions: 10,
                      onChanged: (double value) {
                        GeneralHelper.setScalingSize(value);
                        GeneralHelper.isSettingUpdate = (_sizeValue != _sizeValueTemp);
                        setState(() {
                          _sizeValue = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24,),

              CustomCard(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveIcon(Icons.crisis_alert_outlined, color: Colors.black,),
                        SizedBox(width: 16,),
                        Expanded(
                          child: ResponsiveText(
                            "Selalu tampilkan peringatan saat berada diluar radius kantor",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        SizedBox(width: 16,),
                        Switch(
                          value: _isAlert,
                          activeColor: CustomColor.success,
                          onChanged: (bool value) {
                            GeneralHelper.setUseAlert(value);
                            setState(() {
                              _isAlert = value;
                            });
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24,),
            ],
          ),
        ),
      ),
    );
  }
}
