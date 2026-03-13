import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart' show SvgPicture;
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/menu_controller.dart';
import 'package:genius_ai/model/menu.dart';
import 'package:genius_ai/view/bar/upload/menu/bar_add_menu_dialog.dart';
import 'package:genius_ai/view/restaurant/upload/menu/restaurant_add_menu_dialog.dart';
import 'package:genius_ai/view/restaurant/upload/menu/restaurant_menu_info_card.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class RestaurantMenuScreen extends StatefulWidget {
  const RestaurantMenuScreen({super.key});

  @override
  State<RestaurantMenuScreen> createState() => _RestaurantMenuScreenState();
}

class _RestaurantMenuScreenState extends State<RestaurantMenuScreen> {
  final BarMenuController controller = Get.find<BarMenuController>();
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
                "Menu",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
              Text(
                "Manage your Menu from here.",
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

              Obx(() {
                if (controller.isLoading.value) {
                  return Column(
                    children: List.generate(
                      3,
                      (index) => Skeletonizer(
                        enabled: true,
                        child: RestaurantMenuInfoCard(
                          menu: Menu(name: "", totalCost: "", menuType: ""),
                        ),
                      ),
                    ),
                  );
                }
                if (controller.menuList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: const Text("No Menu Found"),
                    ),
                  );
                }

                return Column(
                  children: List.generate(
                    controller.menuList.length,
                    (index) => Skeletonizer(
                      enabled: controller.isLoading.value,
                      child: RestaurantMenuInfoCard(
                        menu: controller.menuList[index],
                      ),
                    ),
                  ),
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
                builder: (context) => const RestaurantAddMenuDialog(),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xff_E6F4FF),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Center(
                child: Row(
                  spacing: 8.w,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: AppColors.primary),
                    Text(
                      "Add Menu",
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
              Get.toNamed(RouteNames.restaurantMenuRequestScreen);
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                border: Border.all(color: Color(0xff_E9E9E9), width: 1.w),
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
                controller.getMenu();
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
