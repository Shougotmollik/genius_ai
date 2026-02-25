import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/view/bar/upload/menu/bar_edit_menu_dialog.dart';
import 'package:genius_ai/view/bar/upload/recipe/bar_edit_recipe_dialog.dart';
import 'package:genius_ai/view/widgets/delete_dialog_widget.dart';

class MenuInfoCard extends StatefulWidget {
  const MenuInfoCard({super.key});

  @override
  State<MenuInfoCard> createState() => _MenuInfoCardState();
}

class _MenuInfoCardState extends State<MenuInfoCard> {
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
                    builder: (context) => const BarEditMenuDialog(),
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

          //Ingredient name & price
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Summer Special Menu",
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
              IngredientDetailRow(title: "Items", value: "7"),
              IngredientDetailRow(title: "Cost", value: "\$25"),
              IngredientDetailRow(title: "Type", value: "Lunch"),
              SizedBox(height: 8.h),
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
              fontWeight: FontWeight.w600,
              color: AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}
