import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/view/bar/supplier/product/bar_add_purchase_dialog.dart';
import 'package:genius_ai/view/bar/supplier/product/bar_product_request_screen.dart';
import 'package:genius_ai/view/bar/supplier/product/bar_supplier_product_info_card.dart';
import 'package:get/get.dart';

class BarProductSupplierScreen extends StatefulWidget {
  const BarProductSupplierScreen({super.key});

  @override
  State<BarProductSupplierScreen> createState() =>
      _BarProductSupplierScreenState();
}

class _BarProductSupplierScreenState extends State<BarProductSupplierScreen> {
  bool isSelected = true;
  int selectedIndex = 0;
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
                "All Products",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
              Text(
                "Here is the list of all purchased product",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightText,
                ),
              ),
              SizedBox(height: 24.h),
              _buildSearchBar(),
              SizedBox(height: 12.h),
              _buildActionButtonSection(),
              SizedBox(height: 12.h),
              Row(
                children: [
                  buildTab(
                    title: "All",
                    isSelected: selectedIndex == 0,
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                  ),
                  buildTab(
                    title: "Others",
                    isSelected: selectedIndex == 1,
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
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
    );
  }

  Widget buildTabContent() {
    switch (selectedIndex) {
      case 0:
        return Column(
          children: List.generate(3, (index) => BarSupplierProductInfoCard()),
        );
      case 1:
        return Column(
          children: List.generate(1, (index) => BarSupplierProductInfoCard()),
        );
      default:
        return SizedBox();
    }
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
              decoration: InputDecoration(
                hintText: "Search Products",
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
                builder: (context) => const BarAddPurchaseDialog(),
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
                      "Add Purchase",
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
              Get.to(BarProductRequestScreen());
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
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.primary,
                    ),
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
