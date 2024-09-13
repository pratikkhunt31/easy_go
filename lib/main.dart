import 'package:easy_go/controller/notification.dart';
import 'package:easy_go/dataHandler/appData.dart';
import 'package:easy_go/locale_string.dart';
import 'package:easy_go/network_dependency.dart';
import 'package:easy_go/screens/home_view.dart';
import 'package:easy_go/screens/login/num_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/location_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FNotification().initNotification();
  Get.put(AppData());
  Get.put(LocationController());

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Load saved locale
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('languageCode');
  String? countryCode = prefs.getString('countryCode');

  runApp(MyApp(languageCode: languageCode, countryCode: countryCode));
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  final String? languageCode;
  final String? countryCode;

  const MyApp({Key? key, this.languageCode, this.countryCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Locale? initialLocale;
    if (languageCode != null) {
      initialLocale = Locale(languageCode!, countryCode);
    }

    return GetMaterialApp(
      translations: LocaleString(),
      locale: initialLocale,
      fallbackLocale:
          Locale('en', 'US'), // Default to English if no saved language
      debugShowCheckedModeBanner: false,
      home: AuthRedirect(),
    );
  }
}

class AuthRedirect extends StatefulWidget {
  @override
  _AuthRedirectState createState() => _AuthRedirectState();
}

class _AuthRedirectState extends State<AuthRedirect> {
  @override
  void initState() {
    super.initState();
    changeScreen();
  }

  void changeScreen() {
    Future.delayed(Duration(seconds: 2), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null && mounted) {
          Get.to(() => NumberScreen());
        } else {
          Get.off(() => HomeView());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              child: LoadingIndicator(
                indicatorType: Indicator.ballClipRotateMultiple,
                colors: [Color(0xFF0000FF)],
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
