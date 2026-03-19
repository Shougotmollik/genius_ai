import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/ingredient_controller.dart';
import 'package:genius_ai/model/ingredient.dart';
import 'package:genius_ai/view/restaurant/upload/ingredients/restaurant_add_ingredient_dialog.dart';
import 'package:genius_ai/view/restaurant/upload/ingredients/restaurant_ingredient_info_card.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RestaurantIngredientScreen extends StatefulWidget {
  const RestaurantIngredientScreen({super.key});

  @override
  State<RestaurantIngredientScreen> createState() =>
      _RestaurantIngredientScreenState();
}

class _RestaurantIngredientScreenState
    extends State<RestaurantIngredientScreen> {
  int selectedIndex = 0;

  final IngredientController controller = Get.find<IngredientController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar with back button
                GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                    width: 36,
                    height: 36,
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
                  "Ingredients",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  "Manage your ingredients from here.",
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
                Row(
                  children: [
                    buildTab(
                      title: "All",
                      isSelected: selectedIndex == 0,
                      onTap: () {
                        setState(() => selectedIndex = 0);
                        controller.isSpecialTab.value = false;
                      },
                    ),
                    buildTab(
                      title: "Others",
                      isSelected: selectedIndex == 1,
                      onTap: () {
                        setState(() => selectedIndex = 1);
                        controller.isSpecialTab.value = true;
                      },
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                buildTabContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTabContent() {
    return Obx(() {
      //Loading State
      if (controller.isLoading.value && controller.ingredientList.isEmpty) {
        return Column(
          children: List.generate(
            3,
            (index) => Skeletonizer(
              enabled: true,
              child: RestaurantIngredientsInfoCard(
                ingredient: Ingredient(
                  approvalStatus: "",
                  name: "",
                  categoryName: "",
                  minimumStock: 00,
                  unit: "",
                  currentStock: 00,
                  pricePerUnit: "",
                ),
              ),
            ),
          ),
        );
      }

      //Empty State
      if (controller.ingredientList.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: Text(
              "No ingredients found.",
              style: TextStyle(color: AppColors.lightText),
            ),
          ),
        );
      }

      return Column(
        children: controller.ingredientList
            .map(
              (ingredient) =>
                  RestaurantIngredientsInfoCard(ingredient: ingredient),
            )
            .toList(),
      );
    });
  }

  Widget buildTab({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 2.w,
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.text,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final TextEditingController searchController = TextEditingController();

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
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: "Search Ingredients",
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
          Obx(
            () => controller.searchQuery.value.isNotEmpty
                ? GestureDetector(
                    onTap: () {
                      controller.searchQuery.value = '';
                    },
                    child: const Icon(Icons.close, size: 20),
                  )
                : const SizedBox(),
          ),
        ],
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
                builder: (context) => const RestaurantAddIngredientDialog(),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppColors.primary),
                    SizedBox(width: 8.w),
                    Text(
                      "Add Ingredients",
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
              Get.toNamed(RouteNames.barIngredientRequestScreen);
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
                  children: [
                    Icon(Icons.shopping_cart, color: AppColors.primary),
                    SizedBox(width: 8.w),
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
}
