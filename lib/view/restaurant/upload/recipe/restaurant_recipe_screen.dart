import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/recipe_controller.dart';
import 'package:genius_ai/model/recipe.dart';
import 'package:genius_ai/view/bar/upload/recipe/bar_recipe_info_card.dart';
import 'package:genius_ai/view/restaurant/upload/recipe/restaurant_add_recipe_dialog.dart';
import 'package:genius_ai/view/restaurant/upload/recipe/restaurant_recipe_info_card.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RestaurantRecipeScreen extends StatefulWidget {
  const RestaurantRecipeScreen({super.key});

  @override
  State<RestaurantRecipeScreen> createState() => _RestaurantRecipeScreenState();
}

class _RestaurantRecipeScreenState extends State<RestaurantRecipeScreen> {
  // Integrate the RecipeController
  final RecipeController controller = Get.put(RecipeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar with back button
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: Colors.black87,
                  ),
                ),
              ),

              SizedBox(height: 24.h),
              Text(
                "Recipes",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
              Text(
                "Manage your Recipes from here.",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightText,
                ),
              ),
              SizedBox(height: 24.h),
              _buildActionButtonSection(),
              SizedBox(height: 24.h),
              _buildSearchBar(),
              SizedBox(height: 12.h),

              // Reactive Recipe List
              Obx(() {
                if (controller.isLoading.value &&
                    controller.recipeList.isEmpty) {
                  return Column(
                    children: List.generate(
                      3,
                      (index) => Skeletonizer(
                        enabled: true,
                        child: BarRecipeInfoCard(
                          recipe: Recipe(id: 0, name: "Loading...", avgTime: 0),
                        ),
                      ),
                    ),
                  );
                }

                if (!controller.isLoading.value &&
                    controller.recipeList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: const Text("No Recipes Found"),
                    ),
                  );
                }

                return Column(
                  children: controller.recipeList.map((recipe) {
                    return Skeletonizer(
                      enabled: controller.isLoading.value,
                      child: RestaurantRecipeInfoCard(recipe: recipe,),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtonSection() {
    return Row(
      spacing: 24.w,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const RestaurantAddRecipeDialog(),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xffE6F4FF),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Center(
                child: Row(
                  spacing: 8.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppColors.primary),
                    Text(
                      "Add Recipes",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Using named route for consistency
              Get.toNamed(RouteNames.restaurantRecipeRequestScreen);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(color: const Color(0xffE9E9E9), width: 1.w),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.w,
                  children: [
                    Icon(Icons.shopping_cart, color: AppColors.primary),
                    Text(
                      "My Requests",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(color: AppColors.border, width: 1.w),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/icons/Search.svg",
            height: 20.h,
            width: 20.w,
            colorFilter: const ColorFilter.mode(
              AppColors.lightText,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              onChanged: (value) {
                controller.searchQuery.value = value;
                controller.getRecipe();
              },
              decoration: InputDecoration(
                hintText: "Search Recipes",
                hintStyle: TextStyle(
                  color: AppColors.lightText,
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
              style: TextStyle(fontSize: 14.sp, color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}
