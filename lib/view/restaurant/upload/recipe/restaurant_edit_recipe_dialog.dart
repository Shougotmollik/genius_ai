import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/bar/recipe_controller.dart';
import 'package:genius_ai/model/recipe.dart';
import 'package:get/get.dart';

class RestaurantEditRecipeDialog extends StatefulWidget {
  const RestaurantEditRecipeDialog({super.key, required this.recipe});
  final Recipe recipe;

  @override
  State<RestaurantEditRecipeDialog> createState() =>
      _RestaurantEditRecipeDialogState();
}

class _RestaurantEditRecipeDialogState
    extends State<RestaurantEditRecipeDialog> {
  late TextEditingController _nameController;
  late TextEditingController _timeController;
  late TextEditingController _costController;
  late TextEditingController _instructionController;
  List<IngredientRow> _ingredients = [];

  final RecipeController controller = Get.find<RecipeController>();

  @override
  void initState() {
    super.initState();
    // Pre-fill controllers with existing data
    _nameController = TextEditingController(text: widget.recipe.name);
    _timeController = TextEditingController(
      text: widget.recipe.avgTime?.toString(),
    );
    _costController = TextEditingController(text: widget.recipe.sellingCost);
    _instructionController = TextEditingController(
      text: widget.recipe.instruction,
    );

    // Pre-fill ingredients list from the model
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
  }

  void _addIngredientRow({
    String name = '',
    String qty = '',
    String unit = '',
    String cost = '',
  }) {
    setState(() {
      _ingredients.add(
        IngredientRow(
          name: TextEditingController(text: name),
          qty: TextEditingController(text: qty),
          unit: TextEditingController(text: unit),
          cost: TextEditingController(text: cost),
          onChanged: () => setState(() {}),
        ),
      );
    });
  }

  double _calculateTotal() {
    double total = 0;
    for (var item in _ingredients) {
      // Strips '$' if present and parses to double
      String cleanCost = item.cost.text.replaceAll('\$', '');
      total += double.tryParse(cleanCost) ?? 0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Edit Recipe',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildLabel('Recipe Name'),
              _buildTextField(_nameController, 1),

              _buildLabel('Avg. Time'),
              _buildTextField(_timeController, 1),

              _buildLabel('Selling Cost'),
              _buildTextField(_costController, 1),

              _buildLabel('Instruction'),
              _buildTextField(_instructionController, 4),

              const SizedBox(height: 24),

              // Ingredients Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add Ingredients',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  TextButton.icon(
                    onPressed: () => _addIngredientRow(),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFE3F2FD),
                      foregroundColor: const Color(0xFF2196F3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Table Headers
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Name',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Quantity',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Unit',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Cost',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Dynamic List of Ingredients
              ..._ingredients
                  .map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(flex: 3, child: _buildTableField(item.name)),
                          const SizedBox(width: 8),
                          Expanded(flex: 2, child: _buildTableField(item.qty)),
                          const SizedBox(width: 8),
                          Expanded(flex: 2, child: _buildTableField(item.unit)),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: _buildTableField(item.cost, isPrefix: true),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              const SizedBox(height: 16),
              Divider(color: Colors.grey.shade300, thickness: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(color: AppColors.primary, fontSize: 16),
                  ),
                  Text(
                    '\$${_calculateTotal().toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: Text('Or', style: TextStyle(color: Colors.grey)),
                ),
              ),

              // Upload Box
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
              Row(
                spacing: 18.w,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border, width: 1.w),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
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
                    child: Obx(
                      () => GestureDetector(
                        onTap: () async {
                          List<Map<String, dynamic>> ingredientMaps =
                              _ingredients.map((item) {
                                return {
                                  "ingredient": item.name.text,
                                  "quantity": item.qty.text,
                                  "unit": item.unit.text,
                                  "cost": item.cost.text
                                      .replaceAll('\$', '')
                                      .trim(),
                                };
                              }).toList();
                          bool success = await controller.updateRecipe(
                            id: widget.recipe.id!,
                            name: _nameController.text,
                            avgTime: _timeController.text,
                            instruction: _instructionController.text,
                            sellingCost: _costController.text,
                            ingredients: ingredientMaps,
                          );
                          if (success) {
                            Navigator.pop(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Center(
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
      child: Text(
        label,
        style: const TextStyle(color: Colors.black54, fontSize: 14),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, int? maxLines) {
    return TextField(
      controller: controller,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        isDense: true,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildTableField(
    TextEditingController controller, {
    bool isPrefix = false,
  }) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      onChanged: (v) => setState(() {}),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
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

// Custom Painter for the Dashed Border
class DashedRectPainter extends CustomPainter {
  final Color color;
  DashedRectPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 5, dashSpace = 3, startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    RRect rrect = RRect.fromLTRBAndCorners(
      0,
      0,
      size.width,
      size.height,
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: const Radius.circular(12),
      bottomRight: const Radius.circular(12),
    );
    canvas.drawRRect(
      rrect,
      paint,
    ); // Note: For a true dashed effect on RRect, a path-based approach is usually needed, but this provides the clean outline.
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
