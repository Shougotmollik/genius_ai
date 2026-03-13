import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/recipe_controller.dart';
import 'package:genius_ai/model/recipe.dart';
import 'package:get/get.dart';

class BarEditRecipeDialog extends StatefulWidget {
  const BarEditRecipeDialog({super.key, required this.recipe});
  final Recipe recipe;

  @override
  State<BarEditRecipeDialog> createState() => _BarEditRecipeDialogState();
}

class _BarEditRecipeDialogState extends State<BarEditRecipeDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _timeController;
  late TextEditingController _costController;
  late TextEditingController _instructionController;
  List<IngredientRow> _ingredients = [];

  final RecipeController controller = Get.find<RecipeController>();

  @override
  void initState() {
    super.initState();
    // Pre-fill controllers with existing bar recipe data
    _nameController = TextEditingController(text: widget.recipe.name);
    _descriptionController = TextEditingController(
      text: widget.recipe.description ?? "No description available",
    );
    _timeController = TextEditingController(
      text: widget.recipe.avgTime?.toString() ?? "",
    );
    _costController = TextEditingController(text: widget.recipe.sellingCost);
    _instructionController = TextEditingController(
      text: widget.recipe.instruction,
    );

    // Pre-fill ingredients list from the bar recipe model
    if (widget.recipe.ingredients != null) {
      _ingredients = widget.recipe.ingredients!.map((ing) {
        return IngredientRow(
          name: TextEditingController(text: ing.ingredient),
          qty: TextEditingController(text: ing.quantity),
          unit: TextEditingController(text: ing.unit),
          cost: TextEditingController(text: ing.cost),
          onChanged: () => setState(() {}),
        );
      }).toList();
    }

    // Fallback if no ingredients exist
    if (_ingredients.isEmpty) {
      _addIngredientRow();
    }
  }

  void _addIngredientRow() {
    setState(() {
      _ingredients.add(
        IngredientRow(
          name: TextEditingController(),
          qty: TextEditingController(),
          unit: TextEditingController(),
          cost: TextEditingController(),
          onChanged: () => setState(() {}),
        ),
      );
    });
  }

  void _removeIngredientRow(int index) {
    if (_ingredients.length > 1) {
      setState(() => _ingredients.removeAt(index));
    }
  }

  double _calculateTotal() {
    double total = 0;
    for (var item in _ingredients) {
      String cleanCost = item.cost.text.replaceAll('\$', '').trim();
      total += double.tryParse(cleanCost) ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Bar Recipe',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red, size: 30.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              _buildLabel('Recipe Name'),
              _buildTextField(_nameController, 1, hint: "e.g. Martini"),

              _buildLabel('Description'),
              _buildTextField(
                _descriptionController,
                2,
                hint: "Enter description...",
              ),

              _buildLabel('Avg. Time (min)'),
              _buildTextField(
                _timeController,
                1,
                hint: "e.g. 5",
                isNumber: true,
              ),

              _buildLabel('Selling Cost'),
              _buildTextField(_costController, 1, hint: "0.00", isNumber: true),

              _buildLabel('Instructions'),
              _buildTextField(
                _instructionController,
                4,
                hint: "Step-by-step prep...",
              ),

              SizedBox(height: 24.h),

              // Ingredients Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ingredients',
                    style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                  ),
                  TextButton.icon(
                    onPressed: _addIngredientRow,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFE3F2FD),
                      foregroundColor: const Color(0xFF2196F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Table Headers
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  children: [
                    Expanded(flex: 3, child: _buildTableHeader('Name')),
                    Expanded(flex: 2, child: _buildTableHeader('Qty')),
                    Expanded(flex: 2, child: _buildTableHeader('Unit')),
                    Expanded(flex: 2, child: _buildTableHeader('Cost')),
                    SizedBox(width: 30.w),
                  ],
                ),
              ),
              const Divider(),

              // Dynamic List of Ingredients
              ...List.generate(_ingredients.length, (index) {
                final item = _ingredients[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Expanded(flex: 3, child: _buildTableField(item.name)),
                      SizedBox(width: 8.w),
                      Expanded(flex: 2, child: _buildTableField(item.qty)),
                      SizedBox(width: 8.w),
                      Expanded(flex: 2, child: _buildTableField(item.unit)),
                      SizedBox(width: 8.w),
                      Expanded(flex: 2, child: _buildTableField(item.cost)),
                      IconButton(
                        onPressed: () => _removeIngredientRow(index),
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              }),

              SizedBox(height: 16.h),
              Divider(color: Colors.grey.shade300, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Cost',
                    style: TextStyle(color: AppColors.primary, fontSize: 16.sp),
                  ),
                  Text(
                    '\$${_calculateTotal().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Action Buttons
              Row(
                spacing: 18.w,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: StadiumBorder(),
                        side: BorderSide(color: AppColors.border, width: 1.w),
                        padding: EdgeInsets.all(12),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: AppColors.lightText,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : _updateRecipe,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: StadiumBorder(),
                          padding: EdgeInsets.all(12),
                        ),
                        child: controller.isLoading.value
                            ? SizedBox(
                                height: 20.h,
                                width: 20.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Update",
                                style: TextStyle(
                                  color: AppColors.surface,
                                  fontSize: 14.sp,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateRecipe() async {
    bool success = await controller.updateRecipe(
      recipes: [
        {
          "id": widget.recipe.id,
          "name": _nameController.text.trim(),
          "description": _descriptionController.text.trim(),
          "avg_time": int.tryParse(_timeController.text) ?? 0,
          "instruction": _instructionController.text.trim(),
          "selling_cost": _costController.text.trim(),
          "outlet_type": "bar",
          "ingredients": _ingredients
              .where((i) => i.name.text.isNotEmpty)
              .map(
                (i) => {
                  "ingredient": i.name.text.trim(),
                  "quantity": double.tryParse(i.qty.text) ?? 0.0,
                  "unit": i.unit.text.trim(),
                  "cost": double.tryParse(i.cost.text) ?? 0.0,
                },
              )
              .toList(),
        },
      ],
    );
    if (success) {
      Navigator.pop(context);
    }
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, top: 12.h),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTableHeader(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey, fontSize: 12.sp),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    int maxLines, {
    String? hint,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildTableField(
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      onChanged: (v) => setState(() {}),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: TextStyle(fontSize: 13.sp),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }
}

// Data Model to keep track of row controllers
class IngredientRow {
  final TextEditingController name;
  final TextEditingController qty;
  final TextEditingController unit;
  final TextEditingController cost;
  final VoidCallback onChanged;

  IngredientRow({
    required this.name,
    required this.qty,
    required this.unit,
    required this.cost,
    required this.onChanged,
  });
}
