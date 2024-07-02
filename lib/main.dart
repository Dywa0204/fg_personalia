import 'package:fgsdm/screen/login_screen.dart';
import 'package:fgsdm/screen/main_screen.dart';
import 'package:fgsdm/screen/splash_screen.dart';
import 'package:fgsdm/utils/general_helper.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GeneralHelper.initializeFirstCamera();
  await GeneralHelper.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SDM',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        fontFamily: "Poppins",
      ),
      home: FutureBuilder<bool>(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          } else {
            if (snapshot.data == true) {
              return MainScreen();
            } else {
              return LoginScreen();
            }
          }
        },
      ),
    );
  }

  Future<bool> _initializeApp() async {
    await Future.delayed(Duration(seconds: 3));
    return _checkLoginStatus();
  }
  Future<bool> _checkLoginStatus() async {
    String userToken = await GeneralHelper.preferences.getString('userToken') ?? "";
    return !userToken.isEmpty;
  }
}
