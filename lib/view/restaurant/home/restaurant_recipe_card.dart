import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/model/home.dart';
import 'package:genius_ai/view/restaurant/home/restaurant_recipe_details_screen.dart';
import 'package:get/get.dart';

class RestaurantRecipeCard extends StatelessWidget {
  const RestaurantRecipeCard({super.key, required this.recipe});
  final HomeRecipe recipe;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(RestaurantRecipeDetailsScreen());
      },
      child: Container(
        height: 235.h,
        width: 195.w,
        margin: EdgeInsets.symmetric(vertical: 16.h, horizontal: 0.w),
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
                child: Image.asset(
                  "assets/image/receipe.jpg",
                  width: double.infinity,
                  height: 110.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 08.h),

              Expanded(
                child: Text(
                  recipe.name ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Text(
                recipe.description ?? "",
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
                    "\$${recipe.totalCost}",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  // Text(
                  //   "cost",
                  //   textAlign: TextAlign.end,
                  //   style: TextStyle(
                  //     color: AppColors.text,
                  //     fontSize: 14.sp,
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
