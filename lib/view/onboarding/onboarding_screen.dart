import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/view/widgets/primary_button.dart';
import 'package:get/get.dart';

enum UserRole { barChef, restaurantChef }

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  UserRole? selectedRole;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 80.h),
              Text(
                "Select a User type",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                "Select your role and start your work",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightText,
                ),
              ),
              SizedBox(height: 54.h),
              _buildTitle(imagePath: "assets/icons/beer.png", title: "Bar"),
              SizedBox(height: 18.h),
              _buildRoleCard(
                imagePath: "assets/icons/chef.png",
                title: "Chef",
                role: UserRole.barChef,
              ),
              SizedBox(height: 24.h),
              _buildTitle(
                imagePath: "assets/icons/restaurant.png",
                title: "Restaurant",
              ),
              SizedBox(height: 18.h),
              _buildRoleCard(
                imagePath: "assets/icons/cooking_chef.png",
                title: "Chef",
                role: UserRole.restaurantChef,
              ),
              const Spacer(),
              CustomElevatedButton(
                btnText: "Continue",
                onTap: () {
                  if (UserRole.barChef == selectedRole) {
                    Get.toNamed(RouteNames.barSignIn);
                  } else if (UserRole.restaurantChef == selectedRole) {
                    Get.toNamed(RouteNames.restaurantSignIn);
                  }
                },
              ),
              SizedBox(height: 44.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String imagePath,
    required String title,
    required UserRole role,
  }) {
    final bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Container(
        height: 105.h,
        width: 165.w,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.25),
              blurRadius: 4.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 18.h,
          children: [
            Image.asset(imagePath, width: 48.w, height: 48.h),
            Text(
              title,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle({required String title, required String imagePath}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 6.w,
      children: [
        Image.asset(imagePath, width: 28.w, height: 28.h, fit: BoxFit.cover),
        Text(
          title,
          style: TextStyle(
            color: AppColors.secondaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
