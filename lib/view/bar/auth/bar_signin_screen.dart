import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/common/auth_controller.dart';
import 'package:genius_ai/utils/form_validator.dart';
import 'package:genius_ai/view/widgets/auth_text_form_fileld.dart';
import 'package:genius_ai/view/widgets/primary_button.dart';
import 'package:get/get.dart';

class BarSigninScreen extends StatefulWidget {
  const BarSigninScreen({super.key});

  @override
  State<BarSigninScreen> createState() => _BarSigninScreenState();
}

class _BarSigninScreenState extends State<BarSigninScreen> {
  bool isChecked = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthController _barAuthController = Get.find<AuthController>();

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
                    "Sign In",
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "Sign in to access your account",
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
                          "Email",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.text,
                          ),
                        ),

                        AuthTextFormField(
                          hintText: "Enter you email",
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
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        checkColor: AppColors.surface,
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        splashRadius: 0,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),

                      Text(
                        "Remember me",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.text,
                        ),
                      ),

                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(RouteNames.barForgetPassword);
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 60.h),
                  Obx(
                    () => CustomElevatedButton(
                      btnText: "Sign In",
                      onTap: _signIn,
                      isLoading: _barAuthController.isLoading.value,
                    ),
                  ),
                  SizedBox(height: 24.h),

                  Align(
                    alignment: Alignment.center,
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.lightText,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed(RouteNames.barSignUp);
                              },
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() {
    FormValidator.validateAndProceed(_formKey, () async {
      final bool isVerified = await _barAuthController.login(
        emailAddress: _emailController.text,
        password: _passwordController.text,
        mode: "bar_chef",
      );

      if (isVerified) {
        Get.offAllNamed(RouteNames.barMainNavBarScreen);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
