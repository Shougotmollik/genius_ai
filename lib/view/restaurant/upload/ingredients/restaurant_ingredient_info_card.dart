import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/view/bar/upload/ingredients/bar_add_ingredient_purechase_dialog.dart';
import 'package:genius_ai/view/bar/upload/ingredients/bar_edit_ingredient_dialog.dart';
import 'package:genius_ai/view/widgets/delete_dialog_widget.dart';

class RestaurantIngredientsInfoCard extends StatefulWidget {
  const RestaurantIngredientsInfoCard({super.key});

  @override
  State<RestaurantIngredientsInfoCard> createState() => _RestaurantIngredientsInfoCardState();
}

class _RestaurantIngredientsInfoCardState extends State<RestaurantIngredientsInfoCard> {
  String _selectedStatusType = 'Good';
  final List<String> _leaveTypes = ["Good", "Low", "None"];

  // Status → Color
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Good':
        return Colors.green;
      case 'Low':
        return Colors.orange;
      case 'None':
        return Colors.red;
      default:
        return AppColors.border;
    }
  }

  // Status Badge
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
          // Edit / Delete
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const BarEditIngredientDialog(),
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
                        title: "Are you sure you want to delete it ?",
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

          //Mark Missing + Status Dropdown
          Row(
            children: [
              Expanded(child: _outlineChip("Mark Missing")),
              SizedBox(width: 80.w),
              Expanded(child: _statusDropdown()),
            ],
          ),

          SizedBox(height: 12.h),

          //Ingredient name & price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sugar Syrup",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
              Text(
                "\$100/kg",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.text,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          //DETAILS
          Column(
            children: [
              IngredientDetailRow(title: "Current Stock", value: "20 kg"),
              IngredientDetailRow(title: "Minimum Stock", value: "2 kg"),
              IngredientDetailRow(title: "Category", value: "Others"),

              // STATUS ROW WITH BADGE
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
                    _statusBadge(_selectedStatusType),
                  ],
                ),
              ),

              IngredientDetailRow(title: "Price", value: "\$100/kg"),
              Row(
                spacing: 18.w,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border, width: 1.w),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Center(
                        child: Row(
                          spacing: 5.w,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/export.svg",
                              height: 24.w,
                              width: 24.w,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "Export",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.lightText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Center(
                        child: Row(
                          spacing: 5.w,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/icons/download.svg",
                              height: 24.w,
                              width: 24.w,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "Import",
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
              ),
            ],
          ),

          // SizedBox(height: 18.h),

          // ! Add to Purchase
          if (_selectedStatusType == 'None') ...[
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const BarAddIngredientPurchaseDialog(),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Center(
                  child: Row(
                    spacing: 5.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: AppColors.primary, size: 24.w),
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

  Widget _iconButton({required Color bgColor, required String icon}) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: SvgPicture.asset(icon, height: 18.h, width: 18.w),
    );
  }

  Widget _outlineChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 12.sp, color: AppColors.lightText),
        ),
      ),
    );
  }

  Widget _statusDropdown() {
    return Container(
      height: 32.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatusType,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _leaveTypes
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: TextStyle(fontSize: 12.sp)),
                ),
              )
              .toList(),
          onChanged: (val) {
            setState(() => _selectedStatusType = val!);
          },
        ),
      ),
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
