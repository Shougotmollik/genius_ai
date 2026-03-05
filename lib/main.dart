import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/route/app_route.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/light_theme.dart';
import 'package:genius_ai/controller_binding.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Genius AI',
        getPages: AppRoute.pages,
        theme: lightTheme,
        initialRoute: RouteNames.splash,
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        initialBinding: ControllerBinding(),
      ),
    );
  }
}
