import 'package:alarm/features/HomeScreen/HomeScreen.dart';
import 'package:alarm/features/OnboardingScreen/OnboardingScreen.dart';
import 'package:alarm/features/locationScreen/locationScreen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(
  DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => MyApp(), // Wrap your app
  ),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.oxygenTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      initialRoute: "/",
      getPages: [
        GetPage(name: "/", page: () => OnboardingScreen()),
        GetPage(name: "/home", page: () =>  HomePage()),
        GetPage(name: "/location", page: () =>  LocationScreen()),
      ],
    );
  }
}

