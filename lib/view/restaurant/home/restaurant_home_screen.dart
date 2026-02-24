import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/view/restaurant/home/restaurant_recipe_card.dart';
import 'package:genius_ai/view/widgets/info_highlighter_card.dart';
import 'package:genius_ai/view/bar/home/bar_recipe_card.dart';

class RestaurantHomeScreen extends StatefulWidget {
  const RestaurantHomeScreen({super.key});

  @override
  State<RestaurantHomeScreen> createState() => _RestaurantHomeScreenState();
}

class _RestaurantHomeScreenState extends State<RestaurantHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBarSection(),
                SizedBox(height: 24.h),
                _buildBannerSection(),
                SizedBox(height: 24.h),

                InfoHighlighterCard(
                  title: "Total Recipes",
                  value: 20,
                  color: const Color(0xff_F08000),
                  iconPath: "assets/icons/recipe.svg",
                ),
                SizedBox(height: 18.h),
                Row(
                  spacing: 18.w,
                  children: [
                    Expanded(
                      child: InfoHighlighterCard(
                        title: "Low Stock",
                        value: 15,
                        color: Color(0xff_CB2020),
                        iconPath: "assets/icons/alert.svg",
                      ),
                    ),
                    Expanded(
                      child: InfoHighlighterCard(
                        title: "Avg Food Cost",
                        value: 20,
                        color: const Color(0xff_43A047),
                        iconPath: "assets/icons/graph-increase.svg",
                      ),
                    ),
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

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 18.w,
                    children: List.generate(3, (index) => RestaurantRecipeCard()),
                  ),
                ),
                SizedBox(height: 18.h),
              ],
            ),
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
