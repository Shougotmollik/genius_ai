import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart' show AppColors;
import 'package:genius_ai/controller/bar/ingredient_controller.dart';
import 'package:genius_ai/model/ingredient_catergory.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

class RestaurantAddIngredientDialog extends StatefulWidget {
  const RestaurantAddIngredientDialog({super.key});

  @override
  State<RestaurantAddIngredientDialog> createState() =>
      _RestaurantAddIngredientDialogState();
}

class _RestaurantAddIngredientDialogState
    extends State<RestaurantAddIngredientDialog> {
  final IngredientController controller = Get.find<IngredientController>();

  // Controllers for form data
  IngredientCategory? selectedCategory;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController currentStockController = TextEditingController();
  final TextEditingController minStockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close Button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.red),
                ),
              ),

              _label("Ingredient Name"),
              _textField(hint: "Type Ingredient Name", ctr: nameController),

              SizedBox(height: 12.h),

              /// Unit & Price
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label("Unit"),
                        _textField(hint: "e.g. Kg", ctr: unitController),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label("Price / Unit"),
                        _textField(
                          hint: "Price",
                          ctr: priceController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              _label("Current Stock"),
              _textField(
                hint: "Enter Current Stock",
                ctr: currentStockController,
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 12.h),

              _label("Minimum Stock"),
              _textField(
                hint: "Type Minimum Stock",
                ctr: minStockController,
                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 12.h),

              /// Category Dropdown
              _label("Category"),
              Obx(
                () => DropdownButtonFormField<IngredientCategory>(
                  value: selectedCategory,
                  hint: const Text("Select Category"),
                  items: controller.categoryList.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat.name));
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => selectedCategory = value),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 12.h),

              // Special Checkbox
              Row(
                children: [
                  Obx(
                    () => Checkbox(
                      value: controller.isSpecial.value,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      onChanged: (value) {
                        controller.isSpecial.value = value ?? false;
                      },
                    ),
                  ),
                  Text(
                    "Is it special?",
                    style: TextStyle(fontSize: 14.sp, color: AppColors.text),
                  ),
                ],
              ),

              SizedBox(height: 12.h),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Or",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: AppColors.lightText,
                  ),
                ),
              ),

              // Excel Upload Box
              GestureDetector(
                onTap: () {
                  // Logic for file picker would go here
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: DottedBorder(
                    options: RectDottedBorderOptions(
                      color: AppColors.primary,
                      strokeWidth: 2.w,
                      dashPattern: const [10, 8],
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/excel.svg',
                            width: 32.w,
                            height: 32.w,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Click here to upload ingredient',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.text,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Max. File Size: 10MB',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.text,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Action Buttons
              Row(
                spacing: 18.w,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(
                            color: AppColors.border,
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.lightText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        // Validation logic
                        if (nameController.text.isEmpty ||
                            selectedCategory == null) {
                          AppSnackbar.show(
                            message: "Please fill required fields",
                            type: SnackType.error,
                          );
                          return;
                        }

                        bool success = await controller.postIngredient(
                          name: nameController.text.trim(),
                          categoryId: selectedCategory!.id,
                          unit: unitController.text.trim(),
                          price: priceController.text.trim(),
                          currentStock:
                              int.tryParse(currentStockController.text) ?? 0,
                          minStock: int.tryParse(minStockController.text) ?? 0,
                          isSpecial: controller.isSpecial.value,
                        );

                        if (success) {
                          Navigator.pop(context);
                        }
                      },
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Center(
                            child: controller.isLoading.value
                                ? SizedBox(
                                    height: 20.w,
                                    width: 20.w,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: AppColors.surface,
                                        size: 20.w,
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(
                                        "Add",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.surface,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _textField({
    required String hint,
    TextEditingController? ctr,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: ctr,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
