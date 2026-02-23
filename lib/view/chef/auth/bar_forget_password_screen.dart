import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/view/widgets/auth_text_form_fileld.dart';
import 'package:genius_ai/view/widgets/primary_button.dart';
import 'package:get/get.dart';

class BarForgetPasswordScreen extends StatefulWidget {
  const BarForgetPasswordScreen({super.key});

  @override
  State<BarForgetPasswordScreen> createState() =>
      _BarForgetPasswordScreenState();
}

class _BarForgetPasswordScreenState extends State<BarForgetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "Forget Password",
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: 200.w,
                  child: Text(
                    "Enter your email to change your password",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.lightText,
                    ),
                  ),
                ),
                SizedBox(height: 60.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12.h,
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
                      controller: TextEditingController(),
                      isPassword: false,
                      prefixIconPath: "assets/icons/email.svg",
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                CustomElevatedButton(
                  btnText: "Send Verification",
                  onTap: () {
                    Get.toNamed(RouteNames.barOtpVerification);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
