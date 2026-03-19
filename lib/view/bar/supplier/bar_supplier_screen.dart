import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/route/route_names.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/supplier_controller.dart';
import 'package:genius_ai/model/price_comparison.dart';
import 'package:genius_ai/view/bar/supplier/bar_add_supplier_dialog.dart';
import 'package:genius_ai/view/bar/supplier/bar_comparison_card.dart';
import 'package:genius_ai/view/bar/supplier/bar_supplier_details_card.dart';
import 'package:genius_ai/view/bar/supplier/suplier_card.dart';
import 'package:genius_ai/view/bar/supplier/bar_supplier_price_alert_card.dart';
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
  // final List<String> _comparisonTypes = [
  //   'Tomato',
  //   'Cucumber',
  //   'Lettuce',
  //   'Potato',
  //   'Onion',
  //   'Carrot',
  // ];
  String? _selectedComparisonType;

  final SupplierController controller = Get.find<SupplierController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSupplierPriceComparison(
        productName: _selectedComparisonType,
      );
    });
  }

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
                  Get.toNamed(RouteNames.barProductSupplierScreen);
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
              Obx(
                () => Skeletonizer(
                  enabled: controller.isLoading.value,
                  child: InfoHighlighterCard(
                    title: "Active Suppliers",
                    value:
                        controller
                            .supplierOverviewSummary
                            .value
                            ?.activeSupplier ??
                        0,
                    color: const Color(0xff_43A047),
                    iconPath: "assets/icons/supplier.svg",
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Obx(
                () => Skeletonizer(
                  enabled: controller.isLoading.value,
                  child: InfoHighlighterCard(
                    title: "Price Alerts",
                    value:
                        controller
                            .supplierOverviewSummary
                            .value
                            ?.priceAlertSupplier ??
                        0,
                    color: const Color(0xff_CB2020),
                    iconPath: "assets/icons/alert.svg",
                  ),
                ),
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
                      controller.getSupplierPriceAlert();
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
            Obx(() {
              if (controller.isLoading.value &&
                  controller.supplierPriceComparison.isEmpty) {
                return Skeletonizer(
                  enabled: true,
                  child: ComparisonCard(
                    priceComparison: SupplierPriceComparison(
                      productName: '',
                      bestPrice: '',
                      suppliers: [],
                      supplierName: '',
                    ),
                  ),
                );
              }
              if (controller.supplierPriceComparison.isEmpty) {
                return const Center(
                  child: Text("No comparison data available"),
                );
              }
              return Column(
                children: controller.supplierPriceComparison.map((data) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: ComparisonCard(priceComparison: data),
                  );
                }).toList(),
              );
            }),
          ],
        );
      case 2:
        return Obx(() {
          final history = controller.priceHistoryResponse.value;

          if (controller.isLoading.value && history == null) {
            return Column(
              children: [
                _buildDropdownMenu(),
                SizedBox(height: 50.h),
                const Center(child: CircularProgressIndicator()),
              ],
            );
          }

          if (history == null) {
            return Column(
              children: [
                _buildDropdownMenu(),
                SizedBox(height: 50.h),
                const Center(
                  child: Text("Select a product to view price trends"),
                ),
              ],
            );
          }

          final List<Color> supplierColors = [
            const Color(0xff43A047), // Green
            const Color(0xff3B82F6), // Blue
            const Color(0xff8B5CF6), // Purple
          ];

          return Column(
            children: [
              _buildDropdownMenu(),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${history.productName} (Per ${history.data.isNotEmpty ? history.data[0].unit : 'unit'}) - Price Trend",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                      ),
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

              // 3. Dynamic Chart
              SurfaceChart(history: history),

              SizedBox(height: 16.h),

              // 4. Dynamic Legend (SpineText)
              Wrap(
                spacing: 16.w,
                runSpacing: 8.h,
                alignment: WrapAlignment.center,
                children: history.data.asMap().entries.map((entry) {
                  return SpineText(
                    title: entry.value.supplierName,
                    color: supplierColors[entry.key % supplierColors.length],
                  );
                }).toList(),
              ),

              SizedBox(height: 24.h),

              // 5. Dynamic History Cards
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.data.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final supplier = history.data[index];
                  final bool isIncrease = supplier.trend == "increase";
                  final bool isDecrease = supplier.trend == "decrease";

                  // Logic for colors based on trend
                  Color cardColor = const Color(0xff1C398E); // Default blue
                  Color bgColor = const Color(0xffEFF6FF);

                  if (isIncrease) {
                    cardColor = const Color(0xffCB2020);
                    bgColor = const Color(0xffFFF1F1);
                  } else if (isDecrease) {
                    cardColor = const Color(0xff004F3B);
                    bgColor = const Color(0xffECFDF5);
                  }

                  return SupplierHistoryCard(
                    title: supplier.supplierName,
                    subtitle:
                        "${supplier.trend.capitalizeFirst} (${supplier.changePercentage}%)",
                    price: supplier.latestPrice.toStringAsFixed(2),
                    color: cardColor,
                    backgroundColor: bgColor,
                  );
                },
              ),
            ],
          );
        });
      case 3:
        return Obx(() {
          if (controller.isLoading.value && controller.priceAlertList.isEmpty) {
            return Skeletonizer(
              enabled: true,
              child: BarSupplierPriceAlertCard(
                title: "",
                supplier: "",
                previousPrice: 0.0,
                currentPrice: 0.0,
                percentage: "0",
                trend: AlertTrend.increase,
              ),
            );
          }
          if (controller.priceAlertList.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: const Center(child: Text("No price alerts found")),
            );
          }
          return Column(
            children: controller.priceAlertList.map((alert) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: BarSupplierPriceAlertCard(
                  title: alert.productName,
                  supplier: alert.supplierName,

                  previousPrice:
                      double.tryParse(alert.previousPrice.toString()) ?? 0.0,
                  currentPrice:
                      double.tryParse(alert.currentPrice.toString()) ?? 0.0,
                  percentage: alert.changePercentage.toString(),

                  trend:
                      (double.tryParse(alert.currentPrice.toString()) ?? 0) >=
                          (double.tryParse(alert.previousPrice.toString()) ?? 0)
                      ? AlertTrend.increase
                      : AlertTrend.decrease,
                ),
              );
            }).toList(),
          );
        });
      default:
        return SizedBox();
    }
  }

  Widget _buildDropdownMenu() {
    return Obx(() {
      if (_selectedComparisonType != null &&
          !controller.supplierAvailableProduct.contains(
            _selectedComparisonType,
          )) {
        _selectedComparisonType = null;
      }

      return Skeletonizer(
        enabled: controller.isLoading.value,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border, width: 1.w),
            borderRadius: BorderRadius.circular(50.r),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value:
                  (controller.supplierAvailableProduct.contains(
                    _selectedComparisonType,
                  ))
                  ? _selectedComparisonType
                  : null,
              dropdownColor: Colors.white,
              isExpanded: true,
              hint: const Text(
                'Select Product',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: controller.supplierAvailableProduct
                  .map(
                    (t) => DropdownMenuItem<String>(
                      value: t,
                      child: Row(
                        children: [
                          Text(
                            t,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.lightText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4.w),
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
              onChanged: (val) {
                setState(() {
                  _selectedComparisonType = val;
                });
                controller.getSupplierPriceComparison(productName: val);
                controller.getPriceHistory(productName: val!);
              },
            ),
          ),
        ),
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
