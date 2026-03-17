import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/supplier_controller.dart';
import 'package:genius_ai/view/bar/supplier/bar_add_supplier_dialog.dart';
import 'package:genius_ai/view/bar/supplier/bar_comparison_card.dart';
import 'package:genius_ai/view/bar/supplier/bar_supplier_details_card.dart';
import 'package:genius_ai/view/bar/supplier/product/bar_product_supplier_screen.dart';
import 'package:genius_ai/view/bar/supplier/suplier_card.dart';
import 'package:genius_ai/view/bar/supplier/bar_supplier_alert_card.dart';
import 'package:genius_ai/view/bar/supplier/supplier_history_card.dart';
import 'package:genius_ai/view/bar/supplier/surface_chart.dart';
import 'package:genius_ai/view/widgets/info_highlighter_card.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BarSupplierScreen extends StatefulWidget {
  const BarSupplierScreen({super.key});

  @override
  State<BarSupplierScreen> createState() => _BarSupplierScreenState();
}

class _BarSupplierScreenState extends State<BarSupplierScreen> {
  bool isSelected = true;
  int selectedIndex = 0;
  final List<String> _comparisonTypes = [
    'Tomato',
    'Cucumber',
    'Lettuce',
    'Potato',
    'Onion',
    'Carrot',
  ];
  String? _selectedComparisonType = 'Tomato';

  final SupplierController controller = Get.find<SupplierController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Purchasing & Suppliers",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
              Text(
                "Manage suppliers and track price changes",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightText,
                ),
              ),
              SizedBox(height: 24.h),
              _buildActionButtonSection(),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () {
                  Get.to(BarProductSupplierScreen());
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    border: Border.all(color: Color(0xff_E9E9E9), width: 1.w),
                  ),
                  child: Center(
                    child: Text(
                      "View Product",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              InfoHighlighterCard(
                title: "Active Suppliers",
                value: 20,
                color: const Color(0xff_43A047),
                iconPath: "assets/icons/supplier.svg",
              ),
              SizedBox(height: 18.h),
              InfoHighlighterCard(
                title: "Price Alerts",
                value: 20,
                color: const Color(0xff_CB2020),
                iconPath: "assets/icons/alert.svg",
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  buildTab(
                    title: "Overview",
                    isSelected: selectedIndex == 0,
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                  ),
                  buildTab(
                    title: "Comparison",
                    isSelected: selectedIndex == 1,
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                  ),
                  buildTab(
                    title: "History",
                    isSelected: selectedIndex == 2,
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                  ),
                  buildTab(
                    title: "Alerts",
                    isSelected: selectedIndex == 3,
                    onTap: () {
                      setState(() {
                        selectedIndex = 3;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Obx(() => buildTabContent()),
              SizedBox(height: 24.h),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            SizedBox(height: 18.h),
            Column(
              spacing: 12.h,
              children: List.generate(controller.supplierList.length, (index) {
                return Skeletonizer(
                  enabled:
                      controller.isLoading.value &&
                      controller.supplierList.isEmpty,
                  child: BarSupplierCard(
                    supplier: controller.supplierList[index],
                    onTap: () async {
                      final supplierId = controller.supplierList[index].id;
                      if (supplierId != null) {
                        await controller.getSupplierDetails(
                          id: supplierId.toString(),
                        );

                        if (controller.supplierDetails.value != null) {
                          if (mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                insetPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: SupplierDetailCard(
                                  supplier: controller.supplierDetails.value!,
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                  ),
                );
              }),
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            _buildDropdownMenu(),
            SizedBox(height: 16.h),
            ComparisonCard(),
          ],
        );
      case 2:
        return Column(
          children: [
            _buildDropdownMenu(),
            SizedBox(height: 16.h),
            Row(
              children: [
                Text(
                  "$_selectedComparisonType(Per kg) - Price Trend ",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  "(Last 30 Days)",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            SurfaceChart(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SpineText(title: 'Ocean Fresh', color: Color(0xff_43A047)),
                SpineText(title: 'Coastal Seafood', color: Color(0xff_3B82F6)),
                SpineText(title: 'Marine Supply', color: Color(0xff_8B5CF6)),
              ],
            ),
            SizedBox(height: 16.h),
            SupplierHistoryCard(
              title: "Ocean Fresh",
              subtitle: "Stable (0%)",
              price: "45.50",
              color: Color(0xff_004F3B),
              backgroundColor: Color(0xff_ECFDF5),
            ),
            SizedBox(height: 24.h),
            SupplierHistoryCard(
              title: "Coastal Seafood",
              subtitle: "Stable (0%)",
              price: "45.50",
              color: Color(0xff_1C398E),
              backgroundColor: Color(0xff_EFF6FF),
            ),
            SizedBox(height: 24.h),
            SupplierHistoryCard(
              title: "Coastal Seafood",
              subtitle: "Stable (0%)",
              price: "45.50",
              color: Color(0xff_59168B),
              backgroundColor: Color(0xff_FAF5FF),
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            BarSupplierAlertCard(
              title: 'Cherry Tomatoes',
              supplier: 'Mediterranean Goods',
              previousPrice: 14.50,
              currentPrice: 16.50,
              percentage: '13.8',
              trend: AlertTrend.increase,
            ),
            const SizedBox(height: 16),
            BarSupplierAlertCard(
              title: 'Cherry Tomatoes',
              supplier: 'Mediterranean Goods',
              previousPrice: 14.50,
              currentPrice: 16.50,
              percentage: '13.8',
              trend: AlertTrend.decrease,
            ),
          ],
        );
      default:
        return SizedBox();
    }
  }

  Widget _buildDropdownMenu() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border, width: 1.w),
        borderRadius: BorderRadius.circular(50.r),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedComparisonType,
          dropdownColor: Colors.white,
          isExpanded: true,
          hint: const Text(
            'Select Leave Type',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: _comparisonTypes
              .map(
                (t) => DropdownMenuItem(
                  value: t,
                  child: Row(
                    spacing: 4.w,
                    children: [
                      Text(
                        t,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.lightText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      Text(
                        "(Per kg)",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.lightText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (val) => setState(() => _selectedComparisonType = val),
        ),
      ),
    );
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
              onChanged: (value) {
                controller.searchQuery.value = value;
                controller.getSupplier();
              },
              decoration: InputDecoration(
                hintText: "Search Suppliers",
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
                builder: (context) => const BarAddSupplierDialog(),
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
                      "Add Supplier",
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
              Get.toNamed(RouteNames.barSupplierRequestScreen);
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
}

class SpineText extends StatelessWidget {
  const SpineText({super.key, required this.title, required this.color});

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4.w,
      children: [
        SvgPicture.asset(
          "assets/icons/spine.svg",
          height: 12.h,
          width: 12.w,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        Text(
          title,

          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: color,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
