import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/view/restaurant/upload/ingredients/restaurant_ingredient_screen.dart';
import 'package:genius_ai/view/restaurant/upload/menu/restaurant_menu_screen.dart';
import 'package:genius_ai/view/restaurant/upload/recipe/restaurant_recipe_screen.dart';
import 'package:genius_ai/view/widgets/upload_card.dart';
import 'package:get/get.dart';

class RestaurantUploadScreen extends StatefulWidget {
  const RestaurantUploadScreen({super.key});

  @override
  State<RestaurantUploadScreen> createState() => _RestaurantUploadScreenState();
}

class _RestaurantUploadScreenState extends State<RestaurantUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload Documents",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
              Text(
                "Upload your recipe, menu or ingredients",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightText,
                ),
              ),

              SizedBox(height: 24.h),

              UploadCard(
                groupImage: "assets/icons/ingredients_group.svg",
                iconPath: "assets/icons/ingredients_icon.svg",
                outlineImage: "assets/icons/ingredients_outline.svg",
                title: "Ingredients",
                color: const Color(0xff_43A047),
                onTap: () {
                Get.toNamed(RouteNames.restaurantIngredientScreen);
                },
              ),
              SizedBox(height: 18.h),
              UploadCard(
                groupImage: "assets/icons/recipe_group.svg",
                iconPath: "assets/icons/recipe_icon.svg",
                outlineImage: "assets/icons/recipe_outline.svg",
                title: "Recipe",
                color: const Color(0xff_D53DD8),
                onTap: () {
                  Get.to(RestaurantRecipeScreen());
                },
              ),
              SizedBox(height: 18.h),
              UploadCard(
                groupImage: "assets/icons/menu_group.svg",
                iconPath: "assets/icons/menu_icon.svg",
                outlineImage: "assets/icons/menu_outline.svg",
                title: "Menu",
                color: const Color(0xff_FF8F0F),
                onTap: () {
                  Get.to(RestaurantMenuScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
