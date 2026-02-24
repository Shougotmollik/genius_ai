import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/view/bar/home/bar_recipe_details_screen.dart';
import 'package:get/get.dart';

class BarRecipeCard extends StatelessWidget {
  const BarRecipeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(BarRecipeDetailsScreen());
      },
      child: Container(
        height: 235.h,
        width: 195.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.25),
              blurRadius: 16.r,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset("assets/image/mocktail.jpg"),
              ),
              SizedBox(height: 08.h),
      
              Text(
                "Mocktail",
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
      
              Text(
                "Traditional Italian pizza made by native Italians and with some",
                maxLines: 2,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.lightText,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 06.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 4.w,
                children: [
                  Text(
                    "\$20",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "cost",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
