import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';

class BarHomeScreen extends StatefulWidget {
  const BarHomeScreen({super.key});

  @override
  State<BarHomeScreen> createState() => _BarHomeScreenState();
}

class _BarHomeScreenState extends State<BarHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBarSection(),
              SizedBox(height: 24.h),
              _buildBannerSection(),
              SizedBox(height: 24.h),

              InfoHighlighterCard(),
              SizedBox(height: 18.h),
              Row(
                spacing: 18.w,
                children: [
                  Expanded(child: InfoHighlighterCard()),
                  Expanded(child: InfoHighlighterCard()),
                ],
              ),

              SizedBox(height: 24.h),
              Text(
                "Recent Recipes",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSection() {
    return Container(
      width: double.infinity,
      height: 135.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        image: const DecorationImage(
          image: AssetImage("assets/image/banner_image.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Stack(
          children: [
            Container(color: Colors.black.withValues(alpha: 0.5)),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Smarter Kitchens Start Here",
                    style: TextStyle(
                      color: AppColors.surface,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      "One intelligent platform to manage costs, recipes, inventory, staff, and performance",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.surface,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarSection() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Chef!",
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.text,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Tuesday, Feb 7, 2025",
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.lightText,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Spacer(),
        SvgPicture.asset(
          "assets/icons/notification.svg",
          height: 36.w,
          width: 36.h,
        ),
        SizedBox(width: 10.w),

        ClipRRect(
          borderRadius: BorderRadius.circular(100.r),
          child: Image.asset(
            "assets/image/profile.jpg",
            height: 40.w,
            width: 40.w,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class InfoHighlighterCard extends StatelessWidget {
  const InfoHighlighterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0XFF_FEE1B6),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Stack(
        children: [
          SvgPicture.asset(
            "assets/image/recipes_wave.svg",
            fit: BoxFit.cover,
            width: double.infinity,
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total Recipes",
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "0",
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Color(0xff_F08000).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Color(0xff_F08000).withValues(alpha: 0.25),
                      width: 1.w,
                    ),
                  ),
                  child: SvgPicture.asset(
                    "assets/icons/recipe.svg",
                    height: 20.w,
                    width: 20.w,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
