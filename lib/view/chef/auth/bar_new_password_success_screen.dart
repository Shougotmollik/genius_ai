import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/view/widgets/primary_button.dart';
import 'package:get/get.dart';

class BarNewPasswordSuccessScreen extends StatefulWidget {
  const BarNewPasswordSuccessScreen({super.key});

  @override
  State<BarNewPasswordSuccessScreen> createState() =>
      _BarNewPasswordSuccessScreenState();
}

class _BarNewPasswordSuccessScreenState
    extends State<BarNewPasswordSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 100.h),

              ScaleTransition(
                scale: _scaleAnimation,
                child: SvgPicture.asset(
                  "assets/icons/success.svg",
                  height: 180.h,
                  width: 180.w,
                ),
              ),

              SizedBox(height: 48.h),

              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Text(
                        "Congratulations!",
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        width: 280.w,
                        child: Text(
                          "Password Reset successful! You’ll be redirected to the sign in screen now",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.lightText,
                          ),
                        ),
                      ),

                      SizedBox(height: 48.h),
                      CustomElevatedButton(
                        btnText: "Sign In",
                        onTap: () {
                          Get.offAllNamed(RouteNames.barSignIn);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
