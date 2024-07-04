import 'package:fgsdm/constant/custom_colors.dart';
import 'package:fgsdm/screen/main_screen.dart';
import 'package:fgsdm/utils/general_helper.dart';
import 'package:fgsdm/widget/custom/custom_card.dart';
import 'package:fgsdm/widget/custom/custom_mini_button.dart';
import 'package:flutter/material.dart';

import '../controller/user.dart';
import '../model/user.dart';
import '../widget/custom/custom_form_field.dart';
import '../widget/custom/custom_snackbar.dart';
import '../widget/loading_dialog.dart';
import '../widget/responsive/responsive_icon.dart';
import '../widget/responsive/responsive_text.dart';

class SettingScreen extends StatefulWidget {
  final BuildContext context;
  final String username;
  const SettingScreen({Key? key, required this.context, required this.username}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  double _sizeValue = GeneralHelper.scalingPercentage;
  double _sizeValueTemp = GeneralHelper.scalingPercentage;
  bool _isAlert = GeneralHelper.isUseAlert;
  bool _isLockSalary = GeneralHelper.isLockSalary;

  TextEditingController passwordController = TextEditingController();
  final CustomFormFieldController formFieldController = CustomFormFieldController();
  final UserController userController = new UserController();

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

              CustomCard(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ResponsiveIcon(Icons.lock, color: Colors.black,),
                        SizedBox(width: 16,),
                        Expanded(
                          child: ResponsiveText(
                            "Gunakan password untuk melihat gaji",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                        SizedBox(width: 16,),
                        Switch(
                          value: _isLockSalary,
                          activeColor: CustomColor.success,
                          onChanged: (bool value) {
                            showDialog(
                              context: context,
                              builder: (context) => _passwordDialog(context)
                            );

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

  Widget _passwordDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Gunakan Password'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomFormField(
              obscureText: true,
              hint: "Password",
              prefixIcon: Icons.lock,
              suffixImage: "invisible",
              controller: passwordController,
              formFieldController: formFieldController,
              suffixIconCallback: () {
                bool isTextObscured = formFieldController.getObscureText() ?? false;
                formFieldController.setSuffixIcon(image: isTextObscured ? "visible" : "invisible");
                formFieldController.setObscureText(!isTextObscured);
              },
            ),
            SizedBox(height: 12,),
            Row(
              children: [
                Expanded(child: Container()),
                CustomMiniButton(
                  child: Text("Batal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),),
                  color: CustomColor.gray400,
                  onClick: () {
                    Navigator.of(context).pop();
                  },
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                ),
                CustomMiniButton(
                  child: Text("Oke", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14),),
                  color: CustomColor.success,
                  onClick: () {
                    _checkPassword();
                  },
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _checkPassword() async {
    try {
      String password = passwordController.text;

      if (password == "") {
        CustomSnackBar.of(context).show(
            message: "Harap isi password",
            onTop: true,
            showCloseIcon: true,
            prefixIcon: Icons.warning,
            backgroundColor: CustomColor.error
        );
      } else {
        LoadingDialog.of(context).show(message: "Tunggu Sebentar...", isDismissible: true);

        await userController.login(
            username: widget.username,
            password: password
        );

        FocusManager.instance.primaryFocus?.unfocus();

        LoadingDialog.of(context).hide();
        Navigator.of(context).pop();
        CustomSnackBar.of(context).show(
            message: "Berhasil!",
            onTop: true,
            showCloseIcon: true,
            prefixIcon: Icons.check_circle,
            backgroundColor: CustomColor.success
        );

        FocusManager.instance.primaryFocus?.unfocus();

        GeneralHelper.setLockSalary(!_isLockSalary);
        setState(() {
          _isLockSalary = !_isLockSalary;
        });
        passwordController.text = "";
      }
    } catch (error) {
      print(error);
      LoadingDialog.of(context).hide();
      CustomSnackBar.of(context).show(
          message: error.toString().contains("Password") ? "Gagal! Password salah" : error.toString(),
          onTop: true,
          showCloseIcon: true,
          prefixIcon: error.toString().contains("koneksi") ? Icons.wifi : Icons.warning,
          backgroundColor: CustomColor.error
      );
    }
  }
}
