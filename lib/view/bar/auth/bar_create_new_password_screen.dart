import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/common/auth_controller.dart';
import 'package:genius_ai/utils/form_validator.dart';
import 'package:genius_ai/view/widgets/auth_text_form_fileld.dart';
import 'package:genius_ai/view/widgets/primary_button.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

class BarCreateNewPasswordScreen extends StatefulWidget {
  const BarCreateNewPasswordScreen({super.key});

  @override
  State<BarCreateNewPasswordScreen> createState() =>
      _BarCreateNewPasswordScreenState();
}

class _BarCreateNewPasswordScreenState
    extends State<BarCreateNewPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  late String userId;
  late String secretKey;

  final data = Get.arguments as Map<String, dynamic>;

  @override
  void initState() {
    userId = data["user_id"];
    secretKey = data["secret_key"];

    super.initState();
  }

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
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 12.h,
                  children: [
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
                      controller: _newPasswordController,
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
              SizedBox(height: 24),
              Obx(
                () => CustomElevatedButton(
                  btnText: 'Reset Password',
                  isLoading: _authController.isLoading.value,
                  onTap: () {
                    FormValidator.validateAndProceed(formKey, () async {
                      final success = await _authController.changePassword(
                        userId: userId,
                        secretKey: secretKey,
                        newPassword: _newPasswordController.text,
                        confirmPassword: _confirmPasswordController.text,
                      );
                      if (success) {
                        Get.toNamed(RouteNames.barNewPassSuccess);
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
