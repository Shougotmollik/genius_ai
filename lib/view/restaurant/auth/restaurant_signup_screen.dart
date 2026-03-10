import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/auth_controller.dart';
import 'package:genius_ai/utils/form_validator.dart';
import 'package:genius_ai/view/widgets/auth_text_form_fileld.dart';
import 'package:genius_ai/view/widgets/primary_button.dart';
import 'package:get/get.dart';

class RestaurantSignupScreen extends StatefulWidget {
  const RestaurantSignupScreen({super.key});

  @override
  State<RestaurantSignupScreen> createState() => _RestaurantSignupScreenState();
}

class _RestaurantSignupScreenState extends State<RestaurantSignupScreen> {
  bool isChecked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthController _restaurantAuthController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/logo/logo_mini.png", fit: BoxFit.cover),

                  SizedBox(height: 20.h),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Sign up to access your account",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightText,
                    ),
                  ),
                  SizedBox(height: 54.h),

                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 8.h,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.text,
                          ),
                        ),

                        AuthTextFormField(
                          hintText: "Enter your name",
                          controller: _nameController,
                          isPassword: false,
                          prefixIconPath: "assets/icons/person.svg",
                          validator: FormValidator.validateName,
                        ),
                        Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.text,
                          ),
                        ),

                        AuthTextFormField(
                          hintText: "Enter your email",
                          controller: _emailController,
                          isPassword: false,
                          prefixIconPath: "assets/icons/email.svg",
                          validator: FormValidator.validateEmail,
                        ),
                        Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.text,
                          ),
                        ),

                        AuthTextFormField(
                          hintText: "Enter you password",
                          controller: _passwordController,
                          isPassword: true,
                          prefixIconPath: "assets/icons/password.svg",
                          validator: FormValidator.validatePassword,
                        ),
                        Text(
                          "Re-type Password",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.text,
                          ),
                        ),

                        AuthTextFormField(
                          hintText: "Enter you password",
                          controller: _confirmPasswordController,
                          isPassword: true,
                          prefixIconPath: "assets/icons/password.svg",
                          validator: FormValidator.validatePassword,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 60.h),
                  Obx(
                    () => CustomElevatedButton(
                      btnText: "Sign Up",
                      isLoading: _restaurantAuthController.isLoading.value,
                      onTap: _signUp,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  Align(
                    alignment: Alignment.center,
                    child: Text.rich(
                      TextSpan(
                        text: "Already have an account? ",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.lightText,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(RouteNames.restaurantSignUp);
                              },
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 44.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signUp() {
    FormValidator.validateAndProceed(_formKey, () async {
      final data = await _restaurantAuthController.signup(
        name: _nameController.text,
        emailAddress: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        mode: "restaurant_chef",
      );

      if (data != null) {
        Get.toNamed(RouteNames.barSignupOtpVerification, arguments: data);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
