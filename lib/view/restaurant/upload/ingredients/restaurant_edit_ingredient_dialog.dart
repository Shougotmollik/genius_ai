import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart' show AppColors;
import 'package:genius_ai/controller/ingredient_controller.dart';
import 'package:genius_ai/model/ingredient_catergory.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

class RestaurantEditIngredientDialog extends StatefulWidget {
  const RestaurantEditIngredientDialog({super.key, required this.id});
  final String id; // Required ID to identify which ingredient to edit

  @override
  State<RestaurantEditIngredientDialog> createState() =>
      _RestaurantEditIngredientDialogState();
}

class _RestaurantEditIngredientDialogState
    extends State<RestaurantEditIngredientDialog> {
  final IngredientController controller = Get.find<IngredientController>();

  late TextEditingController nameController;
  late TextEditingController unitController;
  late TextEditingController priceController;
  late TextEditingController currentStockController;
  late TextEditingController minStockController;
  IngredientCategory? selectedCategory;

  @override
  void initState() {
    super.initState();
    // 1. Find existing data from the controller's list
    final ingredient = controller.ingredientList.firstWhere(
      (element) => element.id.toString() == widget.id,
    );

    // 2. Initialize controllers with current values
    nameController = TextEditingController(text: ingredient.name);
    unitController = TextEditingController(text: ingredient.unit);
    priceController = TextEditingController(text: ingredient.pricePerUnit);
    currentStockController = TextEditingController(
      text: ingredient.currentStock.toString(),
    );
    minStockController = TextEditingController(
      text: ingredient.minimumStock.toString(),
    );

    // 3. Set the initial category match
    selectedCategory = controller.categoryList.firstWhereOrNull(
      (cat) => cat.name == ingredient.categoryName,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    unitController.dispose();
    priceController.dispose();
    currentStockController.dispose();
    minStockController.dispose();
    super.dispose();
  }

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

              _label("Edit Ingredient"),
              _textField(ctr: nameController),

              SizedBox(height: 12.h),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label("Unit"),
                        _textField(ctr: unitController),
                      ],
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label("Price / Unit"),
                        _textField(ctr: priceController),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              _label("Current Stock"),
              _textField(ctr: currentStockController),

              SizedBox(height: 12.h),

              _label("Minimum Stock"),
              _textField(ctr: minStockController),

              SizedBox(height: 12.h),

              /// Dynamic Category Dropdown
              _label("Category"),
              Obx(
                () => _dropdown<IngredientCategory>(
                  value: selectedCategory,
                  items: controller.categoryList.map((category) {
                    return DropdownMenuItem<IngredientCategory>(
                      value: category,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() => selectedCategory = newValue);
                  },
                ),
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

              // Upload Box (Placeholder)
              GestureDetector(
                onTap: () {},
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
                            'assets/icons/image-upload.svg',
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
                        if (selectedCategory == null) {
                          AppSnackbar.show(
                            message: "Please select a category",
                            type: SnackType.error,
                          );
                          return;
                        }

                        bool success = await controller.updateIngredient(
                          id: int.parse(widget.id),
                          name: nameController.text.trim(),
                          categoryId: selectedCategory!.id,
                          unit: unitController.text.trim(),
                          price: priceController.text.trim(),
                          currentStock:
                              int.tryParse(currentStockController.text) ?? 0,
                          minStock: int.tryParse(minStockController.text) ?? 0,
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
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  )
                                : Text(
                                    "Save",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.surface,
                                    ),
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

  Widget _textField({required TextEditingController ctr}) {
    return TextFormField(
      controller: ctr,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
