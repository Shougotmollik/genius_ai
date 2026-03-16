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
import 'package:genius_ai/view/bar/profile/bar_account_setting_screen.dart';
import 'package:genius_ai/view/bar/profile/bar_edit_leave_request_screen.dart';
import 'package:genius_ai/view/bar/profile/bar_language_selection_screen.dart';
import 'package:genius_ai/view/bar/profile/bar_leave_history_screen.dart';
import 'package:genius_ai/view/bar/profile/bar_leave_request_screen.dart';
import 'package:genius_ai/view/bar/supplier/bar_supplier_request_screen.dart';
import 'package:genius_ai/view/bar/upload/ingredients/bar_ingredient_my_request_screen.dart';
import 'package:genius_ai/view/bar/upload/ingredients/bar_ingredient_screen.dart';
import 'package:genius_ai/view/bar/upload/menu/bar_menu_request_screen.dart';
import 'package:genius_ai/view/bar/upload/menu/bar_menu_screen.dart';
import 'package:genius_ai/view/bar/upload/recipe/bar_recipe_screen.dart';
import 'package:genius_ai/view/bar/upload/recipe/bar_recipe_my_request_screen.dart';
import 'package:genius_ai/view/onboarding/onboarding_screen.dart';
import 'package:genius_ai/view/onboarding/splash_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_create_new_password_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_forget_password_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_new_password_success_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_otp_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_signin_screen.dart';
import 'package:genius_ai/view/restaurant/auth/restaurant_signup_screen.dart';
import 'package:genius_ai/view/restaurant/profile/restaurant_account_setting_screen.dart';
import 'package:genius_ai/view/restaurant/profile/restaurant_edit_leave_request_screen.dart';
import 'package:genius_ai/view/restaurant/profile/restaurant_language_selection_screen.dart';
import 'package:genius_ai/view/restaurant/profile/restaurant_leave_history_screen.dart';
import 'package:genius_ai/view/restaurant/profile/restaurant_leave_request_screen.dart';
import 'package:genius_ai/view/restaurant/restaurant_main_nav_bar_screen.dart';
import 'package:genius_ai/view/restaurant/upload/ingredients/restaurant_ingredient_my_request_screen.dart';
import 'package:genius_ai/view/restaurant/upload/ingredients/restaurant_ingredient_screen.dart';
import 'package:genius_ai/view/restaurant/upload/menu/restaurant_menu_request_screen.dart';
import 'package:genius_ai/view/restaurant/upload/menu/restaurant_menu_screen.dart';
import 'package:genius_ai/view/restaurant/upload/recipe/recipe_my_request_screen.dart';
import 'package:genius_ai/view/restaurant/upload/recipe/restaurant_recipe_screen.dart';
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

    GetPage(
      name: RouteNames.barIngredientScreen,
      page: () => BarIngredientScreen(),
      binding: ControllerBinding(),
    ),

    GetPage(
      name: RouteNames.barIngredientRequestScreen,
      page: () => BarIngredientMyRequestScreen(),
      binding: ControllerBinding(),
    ),

    GetPage(
      name: RouteNames.barRecipeScreen,
      page: () => BarRecipeScreen(),
      binding: ControllerBinding(),
    ),

    GetPage(
      name: RouteNames.barRecipeRequestScreen,
      page: () => BarRecipeMyRequestScreen(),
      binding: ControllerBinding(),
    ),

    GetPage(
      name: RouteNames.barMenuScreen,
      page: () => BarMenuScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.barMenuRequestScreen,
      page: () => BarMenuRequestScreen(),
      binding: ControllerBinding(),
    ),

    GetPage(
      name: RouteNames.barSupplierRequestScreen,
      page: () => BarSupplierRequestScreen(),
      binding: ControllerBinding(),
    ),

    GetPage(
      name: RouteNames.barAccountSettings,
      page: () => BarAccountSettingScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.barLanguageSettings,
      page: () => BarLanguageSelectionScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.barLeaveRequest,
      page: () => BarLeaveRequestScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.barLeaveHistory,
      page: () => BarLeaveHistoryScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.barEditLeaveRequest,
      page: () => BarEditLeaveRequestScreen(),
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
    GetPage(
      name: RouteNames.restaurantIngredientScreen,
      page: () => RestaurantIngredientScreen(),
      binding: ControllerBinding(),
    ),

    GetPage(
      name: RouteNames.restaurantIngredientRequestScreen,
      page: () => RestaurantIngredientMyRequestScreen(),
      binding: ControllerBinding(),
    ),

    GetPage(
      name: RouteNames.restaurantRecipeScreen,
      page: () => RestaurantRecipeScreen(),
      binding: ControllerBinding(),
    ),

    GetPage(
      name: RouteNames.restaurantRecipeRequestScreen,
      page: () => RestaurantRecipeMyRequestScreen(),
      binding: ControllerBinding(),
    ),

    GetPage(
      name: RouteNames.restaurantMenuScreen,
      page: () => RestaurantMenuScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.restaurantMenuRequestScreen,
      page: () => RestaurantMenuRequestScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.restaurantAccountSettings,
      page: () => RestaurantAccountSettingScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.restaurantLanguageSettings,
      page: () => RestaurantLanguageSelectionScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.restaurantLeaveRequest,
      page: () => RestaurantLeaveRequestScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.restaurantLeaveHistory,
      page: () => RestaurantLeaveHistoryScreen(),
      binding: ControllerBinding(),
    ),
    GetPage(
      name: RouteNames.restaurantEditLeaveRequest,
      page: () => RestaurantEditLeaveRequestScreen(),
      binding: ControllerBinding(),
    ),
  ];
}
