import 'package:flutter/material.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/services/local_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _moveToNextScreen() async {
    // Get tokens
    final accessToken = await LocalStorage.access_token.get();
    final refreshToken = await LocalStorage.refresh_token.get();
    final userRole = await LocalStorage.role.get();

    if (accessToken != null &&
        accessToken.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty) {
      // Navigate based on user role
      switch (userRole) {
        case 'bar_chef':
          Navigator.pushReplacementNamed(
            context,
            RouteNames.barMainNavBarScreen,
          );
          break;
        case 'restaurant_chef':
          Navigator.pushReplacementNamed(
            context,
            RouteNames.restaurantMainNavBarScreen,
          );
          break;
        default:
          Navigator.pushReplacementNamed(context, RouteNames.onBoarding);
      }
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.onBoarding);
    }
  }

  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Image.asset("assets/logo/logo.png")));
  }
}
