import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/model/inventory_item.dart';
import 'package:genius_ai/model/recipe_inventory_item.dart';
import 'package:genius_ai/view/widgets/info_highlighter_card.dart';

class RecipeMyRequestScreen extends StatefulWidget {
  const RecipeMyRequestScreen({super.key});

  @override
  State<RecipeMyRequestScreen> createState() => _RecipeMyRequestScreenState();
}

class _RecipeMyRequestScreenState extends State<RecipeMyRequestScreen> {
  int selectedIndex = 0;

  // Data List
  final List<RecipeInventoryItem> allItems = [
    RecipeInventoryItem(
      title: "Margarita",
      status: "Approved",
      cookingTime: "20",
      cost: "30",
    ),
    RecipeInventoryItem(
      title: "Margarita",
      status: "Pending",
      cookingTime: "20",
      cost: "30",
    ),
    RecipeInventoryItem(
      title: "Margarita",
      status: "Approved",
      cookingTime: "20",
      cost: "30",
    ),
    RecipeInventoryItem(
      title: "Margarita",
      status: "Pending",
      cookingTime: "20",
      cost: "30",
    ),
  ];

  // filter based on tab selection
  List<RecipeInventoryItem> get filteredItems {
    if (selectedIndex == 1) {
      return allItems.where((i) => i.status == "Approved").toList();
    }
    if (selectedIndex == 2) {
      return allItems.where((i) => i.status == "Pending").toList();
    }
    return allItems;
  }

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
                Row(
                  spacing: 18.w,
                  children: [
                    Expanded(
                      child: InfoHighlighterCard(
                        title: "Approved",
                        value: 02,
                        color: const Color(0xff_43A047),
                        iconPath: "assets/icons/approve.svg",
                      ),
                    ),
                    Expanded(
                      child: InfoHighlighterCard(
                        title: "Pending",
                        value: 02,
                        color: Color(0xff_FF8F0F),
                        iconPath: "assets/icons/pending.svg",
                      ),
                    ),
                  ],
                ),

                // Tabs Row
                Row(
                  children: [
                    buildTab(
                      title: "All",
                      isSelected: selectedIndex == 0,
                      onTap: () => setState(() => selectedIndex = 0),
                    ),
                    buildTab(
                      title: "Approved",
                      isSelected: selectedIndex == 1,
                      onTap: () => setState(() => selectedIndex = 1),
                    ),
                    buildTab(
                      title: "Pending",
                      isSelected: selectedIndex == 2,
                      onTap: () => setState(() => selectedIndex = 2),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),

                // 3. Dynamic Content List using your exact UI
                Column(
                  children: filteredItems
                      .map(
                        (item) => Padding(
                          padding: EdgeInsets.only(bottom: 18.h),
                          child: InventoryCard(item: item),
                        ),
                      )
                      .toList(),
                ),
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

// --- YOUR ORIGINAL UI DESIGN WITH DYNAMIC LOGIC ---
class InventoryCard extends StatelessWidget {
  final RecipeInventoryItem item;
  const InventoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // Logic for conditional colors
    final bool isApproved = item.status.toLowerCase() == 'approved';
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
        borderRadius: BorderRadius.circular(12.r), // Kept your 12.r
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
          // Header Row: Badge and Download Icon
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
                  item.status,
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
          const SizedBox(height: 16),

          // Title and Price Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
              // RichText(
              //   text: TextSpan(
              //     style: const TextStyle(color: Colors.black, fontSize: 18),
              //     children: [
              //       TextSpan(
              //         text: '\$${item.cost}',
              //         style: const TextStyle(fontWeight: FontWeight.bold),
              //       ),
              //       const TextSpan(
              //         text: '/kg',
              //         style: TextStyle(
              //           color: Colors.grey,
              //           fontWeight: FontWeight.normal,
              //           fontSize: 14,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 12),

          // Data Rows
          _buildDataRow('Cooking Time', "${item.cookingTime} min"),
          const SizedBox(height: 8),
          _buildDataRow('Cost', "\$${item.cost} "),
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
