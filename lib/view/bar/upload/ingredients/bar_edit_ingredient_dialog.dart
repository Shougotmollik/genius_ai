import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/theme/app_colors.dart' show AppColors;
import 'package:genius_ai/controller/ingredient_controller.dart';
import 'package:genius_ai/model/ingredient_catergory.dart';
import 'package:get/get.dart';

class BarEditIngredientDialog extends StatefulWidget {
  const BarEditIngredientDialog({super.key, required this.id});
  final String id;

  @override
  State<BarEditIngredientDialog> createState() =>
      _BarEditIngredientDialogState();
}

class _BarEditIngredientDialogState extends State<BarEditIngredientDialog> {
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
                        // if (selectedCategory == null) {
                        //   AppSnackbar.show(
                        //     message: "Please select a category",
                        //     type: SnackType.error,
                        //   );
                        //   return;
                        // }

                        // Payload setup matching Restaurant logic
                        List<Map<String, dynamic>> payload = [
                          {
                            "id": int.parse(widget.id),
                            "name": nameController.text.trim(),
                            "category": selectedCategory?.name ?? "",
                            "outlet_type": "bar",
                            "unit": unitController.text.trim(),
                            "price_per_unit": priceController.text.trim(),
                            "current_stock":
                                int.tryParse(currentStockController.text) ?? 0,
                            "minimum_stock":
                                int.tryParse(minStockController.text) ?? 0,
                            "is_special": controller.isSpecial.value,
                          },
                        ];

                        final bool success = await controller.updateIngredient(
                          ingredients: payload,
                        );

                        Navigator.pop(context);

                        // if (success) {
                        //   Navigator.pop(context);
                        // }
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
                                    height: 18.h,
                                    width: 18.w,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : Text(
                                    "Update",
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
