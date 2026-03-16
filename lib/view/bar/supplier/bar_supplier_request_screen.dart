import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/supplier_controller.dart';
import 'package:genius_ai/model/supplier.dart';
import 'package:genius_ai/view/widgets/info_highlighter_card.dart';
import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BarSupplierRequestScreen extends StatefulWidget {
  const BarSupplierRequestScreen({super.key});

  @override
  State<BarSupplierRequestScreen> createState() =>
      _BarSupplierRequestScreenState();
}

class _BarSupplierRequestScreenState extends State<BarSupplierRequestScreen> {
  int selectedIndex = 0;
  final SupplierController controller = Get.find<SupplierController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Back Button
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
                  "My Request",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  "See all your requests",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightText,
                  ),
                ),
                SizedBox(height: 24.h),
                Obx(
                  () => Row(
                    spacing: 18.w,
                    children: [
                      Expanded(
                        child: InfoHighlighterCard(
                          title: "Approved",
                          value:
                              controller
                                  .supplierRequestSummary
                                  .value
                                  ?.approved ??
                              0,
                          color: const Color(0xff_43A047),
                          iconPath: "assets/icons/approve.svg",
                        ),
                      ),
                      Expanded(
                        child: InfoHighlighterCard(
                          title: "Pending",
                          value:
                              controller
                                  .supplierRequestSummary
                                  .value
                                  ?.pending ??
                              0,
                          color: Color(0xff_FF8F0F),
                          iconPath: "assets/icons/pending.svg",
                        ),
                      ),
                    ],
                  ),
                ),

                // Tabs Row
                Row(
                  children: [
                    buildTab(
                      title: "All",
                      isSelected: selectedIndex == 0,
                      onTap: () {
                        setState(() => selectedIndex = 0);
                        controller.fetchSupplierRequests(status: "");
                      },
                    ),
                    buildTab(
                      title: "Approved",
                      isSelected: selectedIndex == 1,
                      onTap: () {
                        setState(() => selectedIndex = 1);
                        controller.fetchSupplierRequests(status: "approved");
                      },
                    ),
                    buildTab(
                      title: "Pending",
                      isSelected: selectedIndex == 2,
                      onTap: () {
                        setState(() => selectedIndex = 2);
                        controller.fetchSupplierRequests(status: "pending");
                      },
                    ),
                  ],
                ),
                SizedBox(height: 18.h),

                // Dynamic Content List
                Obx(() {
                  if (controller.isLoading.value &&
                      controller.supplierRequestList.isEmpty) {
                    return Center(
                      child: Skeletonizer(
                        enabled: controller.isLoading.value,
                        child: InventoryCard(
                          item: Supplier(
                            name: "",
                            phone: "",
                            address: "",
                            contractStartDate: "",
                            contractEndDate: "",
                            approvalStatus: "",
                          ),
                        ),
                      ),
                    );
                  }
                  if (controller.supplierRequestList.isEmpty) {
                    return Center(
                      child: Text(
                        "No requests found.",
                        style: TextStyle(color: AppColors.lightText),
                      ),
                    );
                  }
                  return Column(
                    children: controller.supplierRequestList
                        .map(
                          (item) => Padding(
                            padding: EdgeInsets.only(bottom: 18.h),
                            child: Skeletonizer(
                              enabled: controller.isLoading.value,
                              child: InventoryCard(item: item),
                            ),
                          ),
                        )
                        .toList(),
                  );
                }),
                SizedBox(height: 20.h),
              ],
            ),
          ),
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
}

class InventoryCard extends StatelessWidget {
  final Supplier item;
  const InventoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Logic for conditional colors
    final bool isApproved = item.approvalStatus?.toLowerCase() == 'approved';
    final Color statusColor = isApproved
        ? const Color(0xFF4CAF50)
        : const Color(0xFFFF8F0F);
    final Color statusBg = isApproved
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFF3E0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.25),
            blurRadius: 16.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  item.approvalStatus?.capitalizeFirst ?? "",
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.file_download_outlined,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Data Rows
          _buildDataRow('Supplier Name', item.name ?? 'N/A'),
          const SizedBox(height: 8),
          _buildDataRow('Phone Number', item.phone ?? 'N/A'),
          const SizedBox(height: 8),
          _buildDataRow('Address', item.address ?? 'N/A'),
          const SizedBox(height: 8),
          _buildDataRow('Contract Start', item.contractStartDate ?? 'N/A'),
          const SizedBox(height: 8),
          _buildDataRow('Contract End', item.contractEndDate ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 15)),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF2D2D2D),
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}
