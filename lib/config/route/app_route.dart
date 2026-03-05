import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/controller_binding.dart';
import 'package:genius_ai/view/bar/auth/bar_create_new_password_screen.dart';
import 'package:genius_ai/view/bar/auth/bar_forget_password_screen.dart';
import 'package:genius_ai/view/bar/auth/bar_new_password_success_screen.dart';
import 'package:genius_ai/view/bar/auth/bar_otp_screen.dart';
import 'package:genius_ai/view/bar/auth/bar_signin_screen.dart';
import 'package:genius_ai/view/bar/auth/bar_signup_screen.dart';
import 'package:genius_ai/view/bar/auth/bar_singup_otp_verification_screen.dart';
import 'package:genius_ai/view/bar/bar_main_nav_bar_screen.dart';
import 'package:genius_ai/view/onboarding/onboarding_screen.dart';
import 'package:genius_ai/view/onboarding/splash_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_create_new_password_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_forget_password_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_new_password_success_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_otp_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_signin_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_signup_screen.dart';
import 'package:genius_ai/view/restaurant/restaurant_main_nav_bar_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoute {
  static final pages = [
    GetPage(name: RouteNames.splash, page: () => SplashScreen()),
    GetPage(name: RouteNames.onBoarding, page: () => OnboardingScreen()),

    //! Bar
    GetPage(
      name: RouteNames.barSignIn,
      page: () => BarSigninScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.barSignUp,
      page: () => BarSignupScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.barForgetPassword,
      page: () => BarForgetPasswordScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.barSignupOtpVerification,
      page: () => BarSignupOtpVerificationScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.barOtpVerification,
      page: () => BarOtpVerificationScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.barCreateNewPassword,
      page: () => BarCreateNewPasswordScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.barNewPassSuccess,
      page: () => BarNewPasswordSuccessScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.barMainNavBarScreen,
      page: () => BarMainNavBarScreen(),
      binding: ControllerBinding(),
    ),

    //! Restaurant
    GetPage(
      name: RouteNames.restaurantSignIn,
      page: () => RestaurantSigninScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.restaurantSignUp,
      page: () => RestaurantSignupScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.restaurantForgetPassword,
      page: () => RestaurantForgetPasswordScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.restaurantOtpVerification,
      page: () => RestaurantOtpVerificationScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.restaurantCreateNewPassword,
      page: () => RestaurantCreateNewPasswordScreen(),
      binding: ControllerBinding(),
    ),

    GetPage(
      name: RouteNames.restaurantNewPassSuccess,
      page: () => RestaurantNewPasswordSuccessScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.restaurantMainNavBarScreen,
      page: () => RestaurantMainNavBarScreen(),
      binding: ControllerBinding(),
    ),
  ];
}
