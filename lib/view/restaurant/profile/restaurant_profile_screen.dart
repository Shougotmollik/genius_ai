import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/common/auth_controller.dart';
import 'package:genius_ai/view/restaurant/profile/restaurant_account_setting_screen.dart';
import 'package:genius_ai/view/restaurant/profile/restaurant_leave_request_screen.dart';
import 'package:genius_ai/view/widgets/log_out_dialog.dart';
import 'package:get/get.dart';

class RestaurantProfileScreen extends StatefulWidget {
  const RestaurantProfileScreen({super.key});

  @override
  State<RestaurantProfileScreen> createState() =>
      _RestaurantProfileScreenState();
}

class _RestaurantProfileScreenState extends State<RestaurantProfileScreen> {
  final AuthController _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: Image.asset(
                        'assets/image/profile.jpg',
                        height: 60.w,
                        width: 60.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Jhon Doe Smith',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'deshreen@gmail.com',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.lightText,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 20.sp,
                              color: AppColors.lightText,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Joined Since 2025',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.lightText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 4),
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    _SettingsTile(
                      icon: 'assets/icons/setting.svg',
                      label: 'Account Settings',
                      onTap: () {
                        Get.to(RestaurantAccountSettingScreen());
                      },
                    ),
                    _SettingsTile(
                      icon: 'assets/icons/language.svg',
                      label: 'Language',
                      onTap: () {},
                    ),

                    _SettingsTile(
                      icon: 'assets/icons/request.svg',
                      label: 'Leave Request',
                      onTap: () {
                        Get.to(RestaurantLeaveRequestScreen());
                      },
                    ),

                    _SettingsTile(
                      icon: 'assets/icons/setting.svg',
                      label: 'Logout',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => LogoutDialog(
                            onLogout: () async {
                              // Get.offAll(() => const OnboardingScreen());

                              final bool success = await _authController
                                  .logout();

                              if (success) {
                                Get.offAllNamed(RouteNames.onBoarding);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Settings Tile
class _SettingsTile extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 30.w,
              width: 30.w,
              colorFilter: const ColorFilter.mode(
                AppColors.text,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 16.sp),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.text,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
