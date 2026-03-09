import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/bar/recipe_controller.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

class BarAddRecipeDialog extends StatefulWidget {
  const BarAddRecipeDialog({super.key});

  @override
  State<BarAddRecipeDialog> createState() => _BarAddRecipeDialogState();
}

class _BarAddRecipeDialogState extends State<BarAddRecipeDialog> {
  // Main Form Controllers - All Empty
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();

  final RecipeController controller = Get.find<RecipeController>();

  // Ingredients List
  final List<IngredientRow> _ingredients = [];

  @override
  void initState() {
    super.initState();
    // Initialize with one empty row for the user to start with
    _addIngredientRow();
  }

  Future<void> _pickAndParseExcel() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      var bytes = result.files.single.bytes;
      if (bytes == null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        bytes = await file.readAsBytes();
      }

      if (bytes != null) {
        var excel = Excel.decodeBytes(bytes);
        List<IngredientRow> importedRows = [];

        for (var table in excel.tables.keys) {
          var sheet = excel.tables[table];
          if (sheet == null) continue;

          // Skip header row (i = 0), start at i = 1
          for (int i = 1; i < sheet.maxRows; i++) {
            var row = sheet.rows[i];
            if (row.isEmpty) continue;

            // value extractor
            String val(int index) {
              if (index >= row.length || row[index] == null) return "";
              var cV = row[index]!.value;
              // handle to string into filed
              return cV != null ? cV.toString() : "";
            }

            importedRows.add(
              IngredientRow(
                name: TextEditingController(text: val(0)),
                qty: TextEditingController(text: val(1)),
                unit: TextEditingController(text: val(2)),
                cost: TextEditingController(text: val(3)),
              ),
            );
          }
        }

        if (importedRows.isNotEmpty) {
          setState(() {
            _ingredients.clear();
            _ingredients.addAll(importedRows);
          });
        }
      }
    } catch (e) {
      debugPrint("Excel Parsing Error: $e");
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
        ),
      );
    });
  }

  void _removeIngredientRow(int index) {
    if (_ingredients.length > 1) {
      setState(() {
        _ingredients.removeAt(index);
      });
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
                    'Add Recipe',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red, size: 28.sp),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              _buildLabel('Recipe Name'),
              _buildTextField(_nameController, 1, hint: "e.g. Grilled Salmon"),

              _buildLabel('Avg. Time'),
              _buildTextField(_timeController, 1, hint: "30 min"),

              _buildLabel('Selling Cost'),
              _buildTextField(
                _costController,
                1,
                hint: "\$0.00",
                isNumber: true,
              ),

              _buildLabel('Instruction'),
              _buildTextField(
                _instructionController,
                4,
                hint: "Step by step instructions...",
              ),

              SizedBox(height: 24.h),

              // Ingredients Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Ingredients',
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
              Divider(color: AppColors.text, thickness: 1.w),

              //  Ingredients
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _ingredients.length,
                itemBuilder: (context, index) {
                  final item = _ingredients[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildTableField(item.name, "Name"),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          flex: 2,
                          child: _buildTableField(
                            item.qty,
                            "0",
                            isNumber: true,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          flex: 2,
                          child: _buildTableField(item.unit, "unit"),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          flex: 2,
                          child: _buildTableField(
                            item.cost,
                            "0",
                            isNumber: true,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red.shade400,
                            size: 20.sp,
                          ),
                          onPressed: () => _removeIngredientRow(index),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),
              Divider(color: AppColors.text, thickness: 1.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${_calculateTotal().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
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
                onTap: () {
                  _pickAndParseExcel();
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
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: StadiumBorder(),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                  SizedBox(width: 48.w),

                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        if (_nameController.text.isEmpty ||
                            _costController.text.isEmpty) {
                          AppSnackbar.show(
                            message: "Please fill in recipe name and cost",
                            type: SnackType.warning,
                          );
                          return;
                        }
                    
                        // Ingredients List
                        List<Map<String, dynamic>> ingredientData = _ingredients
                            .where((i) => i.name.text.isNotEmpty)
                            .map((i) {
                              return {
                                "ingredient": i.name.text,
                                "quantity": double.tryParse(i.qty.text) ?? 0.0,
                                "unit": i.unit.text,
                                "cost":
                                    double.tryParse(
                                      i.cost.text.replaceAll('\$', ''),
                                    ) ??
                                    0.0,
                              };
                            })
                            .toList();
                    
                        if (ingredientData.isEmpty) {
                          AppSnackbar.show(
                            message: "Please add at least one ingredient",
                            type: SnackType.warning,
                          );
                          return;
                        }
                    
                        bool success = await controller.postRecipe(
                          name: _nameController.text,
                          avgTime: _timeController.text,
                          instruction: _instructionController.text,
                          sellingCost: _costController.text,
                          ingredients: ingredientData,
                        );
                    
                        if (success) {
                          Navigator.pop(context);
                        }
                      },
                      icon: controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.add, color: Colors.white),
                      label: Text(
                        controller.isLoading.value ? "Adding..." : "Add",
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: const StadiumBorder(),
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
      padding: EdgeInsets.only(bottom: 6.h, top: 12.h),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black87,
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
        hintStyle: TextStyle(color: AppColors.lightText, fontSize: 13.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.border, width: 1.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.border, width: 1.w),
        ),
      ),
    );
  }

  Widget _buildTableField(
    TextEditingController controller,
    String hint, {
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      onChanged: (v) => setState(() {}),
      style: TextStyle(fontSize: 13.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.lightText, fontSize: 12.sp),
        contentPadding: EdgeInsets.symmetric(vertical: 8.h),
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

class IngredientRow {
  final TextEditingController name;
  final TextEditingController qty;
  final TextEditingController unit;
  final TextEditingController cost;

  IngredientRow({
    required this.name,
    required this.qty,
    required this.unit,
    required this.cost,
  });
}
