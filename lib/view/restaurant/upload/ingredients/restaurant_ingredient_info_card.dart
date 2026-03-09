import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/model/ingredient.dart'; // Ensure this model is imported
import 'package:genius_ai/view/bar/upload/ingredients/bar_add_ingredient_purechase_dialog.dart';
import 'package:genius_ai/view/bar/upload/ingredients/bar_edit_ingredient_dialog.dart';
import 'package:genius_ai/view/widgets/delete_dialog_widget.dart';
import 'package:get/get_utils/get_utils.dart';

class RestaurantIngredientsInfoCard extends StatefulWidget {
  const RestaurantIngredientsInfoCard({super.key, required this.ingredient});

  final Ingredient ingredient; // Added dynamic ingredient parameter

  @override
  State<RestaurantIngredientsInfoCard> createState() =>
      _RestaurantIngredientsInfoCardState();
}

class _RestaurantIngredientsInfoCardState
    extends State<RestaurantIngredientsInfoCard> {
  bool isMissing = false;

  // Status → Color mapping
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Good':
        return Colors.green;
      case 'Low':
        return Colors.orange;
      case 'None':
        return Colors.red;
      default:
        return AppColors.lightText;
    }
  }

  // Status Badge Widget
  Widget _statusBadge(String status) {
    final color = _getStatusColor(status);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
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
        children: [
          // Edit / Delete Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => BarEditIngredientDialog(
                      id: widget.ingredient.id.toString(), // Dynamic ID
                    ),
                  );
                },
                child: _iconButton(
                  bgColor: const Color(0xffF0B100).withValues(alpha: 0.2),
                  icon: "assets/icons/pen_edit.svg",
                ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return DeleteDialogWidget(
                        title: "Are you sure you want to delete it?",
                      );
                    },
                  );
                },
                child: _iconButton(
                  bgColor: const Color(0xffFAE9E9),
                  icon: "assets/icons/delete.svg",
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Ingredient Name & Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.ingredient.name?.capitalize ?? "Unknown",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
              Text(
                "\$${widget.ingredient.pricePerUnit}/${widget.ingredient.unit}",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Details List
          Column(
            children: [
              IngredientDetailRow(
                title: "Current Stock",
                value:
                    "${widget.ingredient.currentStock} ${widget.ingredient.unit}",
              ),
              IngredientDetailRow(
                title: "Minimum Stock",
                value:
                    "${widget.ingredient.minimumStock} ${widget.ingredient.unit}",
              ),
              IngredientDetailRow(
                title: "Category",
                value: widget.ingredient.categoryName ?? "N/A",
              ),

              // Status Badge Row
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.text,
                      ),
                    ),
                    _statusBadge(
                      widget.ingredient.status?.capitalizeFirst ?? "None",
                    ),
                  ],
                ),
              ),

              IngredientDetailRow(
                title: "Price",
                value:
                    "\$${widget.ingredient.pricePerUnit}/${widget.ingredient.unit}",
              ),

              SizedBox(height: 12.h),

              // Export / Import Buttons
              Row(
                spacing: 18.w,
                children: [
                  Expanded(
                    child: _actionButton(
                      title: "Export",
                      icon: "assets/icons/export.svg",
                      isPrimary: false,
                    ),
                  ),
                  Expanded(
                    child: _actionButton(
                      title: "Import",
                      icon: "assets/icons/download.svg",
                      isPrimary: true,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Add to Purchase Button (Only shows if status is 'None')
          if (widget.ingredient.status?.capitalizeFirst == 'None') ...[
            SizedBox(height: 18.h),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const BarAddIngredientPurchaseDialog(),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: AppColors.primary, size: 22.w),
                      SizedBox(width: 5.w),
                      Text(
                        "Add to Purchase",
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
          ],
        ],
      ),
    );
  }

  // Helper for Export/Import style buttons
  Widget _actionButton({
    required String title,
    required String icon,
    required bool isPrimary,
  }) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: isPrimary
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.surface,
        border: isPrimary
            ? null
            : Border.all(color: AppColors.border, width: 1.w),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon, height: 20.w, width: 20.w),
            SizedBox(width: 5.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isPrimary ? AppColors.primary : AppColors.lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton({required Color bgColor, required String icon}) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: SvgPicture.asset(icon, height: 18.h, width: 18.w),
    );
  }
}

class IngredientDetailRow extends StatelessWidget {
  final String title;
  final String value;

  const IngredientDetailRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.text,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
