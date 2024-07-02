import 'package:fgsdm/screen/login_screen.dart';
import 'package:fgsdm/screen/main_screen.dart';
import 'package:fgsdm/screen/splash_screen.dart';
import 'package:fgsdm/utils/general_helper.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GeneralHelper.initializeFirstCamera();
  await GeneralHelper.initializeApp();

  await SentryFlutter.init(
        (options) {
      options.dsn = 'https://f69daa4498e66fb69b1902a1f0a3ff97@o4507530639310848.ingest.us.sentry.io/4507530930487296';
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(MyApp())
  );

  // runApp(MyApp());
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
