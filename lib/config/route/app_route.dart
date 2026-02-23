import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/view/chef/auth/bar_create_new_password_screen.dart';
import 'package:genius_ai/view/chef/auth/bar_forget_password_screen.dart';
import 'package:genius_ai/view/chef/auth/bar_new_password_success_screen.dart';
import 'package:genius_ai/view/chef/auth/bar_otp_screen.dart';
import 'package:genius_ai/view/chef/auth/bar_signin_screen.dart';
import 'package:genius_ai/view/chef/auth/bar_signup_screen.dart';
import 'package:genius_ai/view/chef/bar_main_nav_bar_screen.dart';
import 'package:genius_ai/view/onboarding/onboarding_screen.dart';
import 'package:genius_ai/view/onboarding/splash_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_create_new_password_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_forget_password_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_new_password_success_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_otp_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_signin_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_signup_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoute {
  static final pages = [
    GetPage(name: RouteNames.splash, page: () => SplashScreen()),
    GetPage(name: RouteNames.onBoarding, page: () => OnboardingScreen()),

    // Bar
    GetPage(name: RouteNames.barSignIn, page: () => BarSigninScreen()),
    GetPage(name: RouteNames.barSignUp, page: () => BarSignupScreen()),
    GetPage(
      name: RouteNames.barForgetPassword,
      page: () => BarForgetPasswordScreen(),
    ),
    GetPage(
      name: RouteNames.barOtpVerification,
      page: () => BarOtpVerificationScreen(),
    ),
    GetPage(
      name: RouteNames.barCreateNewPassword,
      page: () => BarCreateNewPasswordScreen(),
    ),
    GetPage(
      name: RouteNames.barNewPassSuccess,
      page: () => BarNewPasswordSuccessScreen(),
    ),
    GetPage(
      name: RouteNames.barMainNavBarScreen,
      page: () => BarMainNavBarScreen(),
    ),

    // Restaurant
    GetPage(
      name: RouteNames.restaurantSignIn,
      page: () => RestaurantSigninScreen(),
    ),
    GetPage(
      name: RouteNames.restaurantSignUp,
      page: () => RestaurantSignupScreen(),
    ),
    GetPage(
      name: RouteNames.restaurantForgetPassword,
      page: () => RestaurantForgetPasswordScreen(),
    ),
    GetPage(
      name: RouteNames.restaurantOtpVerification,
      page: () => RestaurantOtpVerificationScreen(),
    ),
    GetPage(
      name: RouteNames.restaurantCreateNewPassword,
      page: () => RestaurantCreateNewPasswordScreen(),
    ),

    GetPage(
      name: RouteNames.restaurantNewPassSuccess,
      page: () => RestaurantNewPasswordSuccessScreen(),
    ),
  ];
}
