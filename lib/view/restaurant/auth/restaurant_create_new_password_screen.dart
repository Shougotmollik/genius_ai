import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/view/widgets/auth_text_form_fileld.dart';
import 'package:genius_ai/view/widgets/primary_button.dart';
import 'package:get/route_manager.dart';

class RestaurantCreateNewPasswordScreen extends StatefulWidget {
  const RestaurantCreateNewPasswordScreen({super.key});

  @override
  State<RestaurantCreateNewPasswordScreen> createState() =>
      _RestaurantCreateNewPasswordScreenState();
}

class _RestaurantCreateNewPasswordScreenState
    extends State<RestaurantCreateNewPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 50.h),
              Text(
                "Create New Password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              Text(
                "Create a new unique password",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightText,
                ),
              ),
              SizedBox(height: 60.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 12.h,
                children: [
                  Text(
                    "Current Password",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),

                  AuthTextFormField(
                    hintText: "Enter you password",
                    controller: TextEditingController(),
                    isPassword: true,
                    prefixIconPath: "assets/icons/password.svg",
                  ),
                  Text(
                    "New Password",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),

                  AuthTextFormField(
                    hintText: "Enter you password",
                    controller: TextEditingController(),
                    isPassword: true,
                    prefixIconPath: "assets/icons/password.svg",
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
                    controller: TextEditingController(),
                    isPassword: true,
                    prefixIconPath: "assets/icons/password.svg",
                  ),
                ],
              ),
              SizedBox(height: 24),

              CustomElevatedButton(
                btnText: 'Reset Password',
                onTap: () {
                  Get.toNamed(RouteNames.restaurantNewPassSuccess);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
