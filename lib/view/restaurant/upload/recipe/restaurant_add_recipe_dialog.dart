import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/recipe_controller.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

class RestaurantAddRecipeDialog extends StatefulWidget {
  const RestaurantAddRecipeDialog({super.key});

  @override
  State<RestaurantAddRecipeDialog> createState() =>
      _RestaurantAddRecipeDialogState();
}

class _RestaurantAddRecipeDialogState extends State<RestaurantAddRecipeDialog> {
  final RecipeController controller = Get.find<RecipeController>();

  //  Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _instructionController = TextEditingController();

  // Ingredient Rows for the UI
  final List<IngredientRow> _ingredients = [];

  // Batch data storage
  List<Map<String, dynamic>> _batchRecipes = [];

  @override
  void initState() {
    super.initState();
    _addIngredientRow();
  }

  Future<void> _pickAndParseExcel() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );

      if (result == null || result.files.isEmpty) return;

      var bytes = File(result.files.single.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var table = excel.tables.keys.first;
      var sheet = excel.tables[table];
      if (sheet == null) return;

      Map<String, Map<String, dynamic>> groupedRecipes = {};

      // Memory variables to "remember" info for rows where columns A-E are empty
      String lastRecipeName = "";
      String lastDesc = "";
      String lastTime = "";
      String lastInstr = "";
      String lastSellCost = "";

      for (int i = 1; i < sheet.maxRows; i++) {
        var row = sheet.rows[i];
        if (row.isEmpty) continue;

        String getVal(int index) {
          if (index >= row.length || row[index] == null) return "";
          var val = row[index]!.value;
          return val == null ? "" : val.toString().trim();
        }

        //MAPPING BASED ON YOUR SCREENSHOT ---
        String currentName = getVal(0); // Col A
        String currentDesc = getVal(1); // Col B
        String currentTime = getVal(2); // Col C
        String currentPrice = getVal(3); // Col D (Price/Selling Cost)
        String currentInstr = getVal(4); // Col E (Instructions)

        // Only update "Memory" if the current cell is NOT empty
        if (currentName.isNotEmpty) lastRecipeName = currentName;
        if (currentDesc.isNotEmpty) lastDesc = currentDesc;
        if (currentTime.isNotEmpty) lastTime = currentTime;
        if (currentPrice.isNotEmpty) lastSellCost = currentPrice;
        if (currentInstr.isNotEmpty) lastInstr = currentInstr;

        // Skip row if we haven't even found the first recipe name yet
        if (lastRecipeName.isEmpty) continue;

        // Initialize the recipe in our map if it's the first time we see this name
        if (!groupedRecipes.containsKey(lastRecipeName)) {
          groupedRecipes[lastRecipeName] = {
            "name": lastRecipeName,
            "description": lastDesc,
            "avg_time":
                int.tryParse(lastTime.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0,
            "instruction": lastInstr,
            "selling_cost": lastSellCost.replaceAll(
              RegExp(r'[^0-9.]'),
              '',
            ), // Removes "$" and extra dots
            "outlet_type": "restaurant",
            "ingredients": <Map<String, dynamic>>[],
          };
        }

        // Add the Ingredient data (Cols F, G, H, I)
        String ingName = getVal(5);
        if (ingName.isNotEmpty) {
          (groupedRecipes[lastRecipeName]!["ingredients"] as List).add({
            "ingredient": ingName,
            "quantity": double.tryParse(getVal(6)) ?? 0.0,
            "unit": getVal(7),
            "cost":
                double.tryParse(getVal(8).replaceAll(RegExp(r'[^0-9.]'), '')) ??
                0.0,
          });
        }
      }

      if (groupedRecipes.isNotEmpty) {
        setState(() {
          _batchRecipes = groupedRecipes.values.toList();
          _fillUiWithFirstRecipe(); // Sync the UI with the first recipe found
        });
        AppSnackbar.show(
          message: "Successfully loaded ${_batchRecipes.length} recipes",
          type: SnackType.success,
        );
      }
    } catch (e) {
      debugPrint("Excel Parsing Error: $e");
      AppSnackbar.show(
        message: "Check Excel format: Col D should be Price, Col E Instruction",
        type: SnackType.error,
      );
    }
  }

  void _fillUiWithFirstRecipe() {
    if (_batchRecipes.isEmpty) return;
    var first = _batchRecipes.first;

    // Fill Header Controllers
    _nameController.text = first['name'];
    _descriptionController.text = first['description'];
    _timeController.text = first['avg_time'].toString();
    _costController.text = first['selling_cost'];
    _instructionController.text = first['instruction'];

    // Fill Ingredient Table
    _ingredients.clear();
    for (var ing in first['ingredients']) {
      _ingredients.add(
        IngredientRow(
          name: TextEditingController(text: ing['ingredient']),
          qty: TextEditingController(text: ing['quantity'].toString()),
          unit: TextEditingController(text: ing['unit']),
          cost: TextEditingController(text: ing['cost'].toString()),
        ),
      );
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
      setState(() => _ingredients.removeAt(index));
    }
  }

  double _calculateTotal() {
    double total = 0;
    for (var item in _ingredients) {
      total += double.tryParse(item.cost.text) ?? 0;
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

              _buildLabel('Recipe Name'),
              _buildTextField(_nameController, 1, hint: "e.g. Grilled Salmon"),

              _buildLabel('Recipe Description'),
              _buildTextField(
                _descriptionController,
                2,
                hint: "Description...",
              ),

              _buildLabel('Avg. Time (min)'),
              _buildTextField(_timeController, 1, hint: "10", isNumber: true),

              _buildLabel('Selling Cost'),
              _buildTextField(_costController, 1, hint: "0.00", isNumber: true),

              _buildLabel('Instruction'),
              _buildTextField(
                _instructionController,
                3,
                hint: "Instructions...",
              ),

              SizedBox(height: 24.h),

              // Ingredients Table
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _addIngredientRow,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add Row'),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(flex: 3, child: _buildTableHeader('Name')),
                  Expanded(flex: 2, child: _buildTableHeader('Qty')),
                  Expanded(flex: 2, child: _buildTableHeader('Unit')),
                  Expanded(flex: 2, child: _buildTableHeader('Cost')),
                  SizedBox(width: 40.w),
                ],
              ),
              const Divider(),

              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _ingredients.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final item = _ingredients[index];
                  return Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildTableField(item.name, "Name"),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        flex: 2,
                        child: _buildTableField(item.qty, "0", isNumber: true),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        flex: 2,
                        child: _buildTableField(item.unit, "unit"),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        flex: 2,
                        child: _buildTableField(item.cost, "0", isNumber: true),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red,
                        ),
                        onPressed: () => _removeIngredientRow(index),
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Cost:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${_calculateTotal().toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('OR'),
                ),
              ),

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

              // Actions
              Row(
                spacing: 18.w,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : _submitRecipe,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: controller.isLoading.value
                            ? SizedBox(
                                height: 18.h,
                                width: 18.w,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, color: Colors.white),
                                  const Text(
                                    "Add",
                                    style: TextStyle(color: Colors.white),
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
        ),
      ),
    );
  }

  Future<void> _submitRecipe() async {
    // 1. Build the recipe currently shown in the Dialog UI
    Map<String, dynamic> currentUiRecipe = {
      "name": _nameController.text.trim(),
      "description": _descriptionController.text.trim(),
      "avg_time": int.tryParse(_timeController.text) ?? 0,
      "instruction": _instructionController.text.trim(),
      "selling_cost": _costController.text.trim(),
      "outlet_type": "restaurant",
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
    };

    if (currentUiRecipe["name"].isEmpty) {
      AppSnackbar.show(
        message: "Recipe name is required",
        type: SnackType.warning,
      );
      return;
    }

    // 2. Prepare the final list
    List<Map<String, dynamic>> finalPayload = [];

    if (_batchRecipes.isNotEmpty) {
      // Replace the first item of batch with current UI data (in case user edited it)
      _batchRecipes[0] = currentUiRecipe;
      finalPayload = _batchRecipes;
    } else {
      finalPayload = [currentUiRecipe];
    }

    // 3. Send to API
    bool success = await controller.postRecipe(recipes: finalPayload);
    if (success) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  // UI Helpers (Labels, Textfields, etc.)
  Widget _buildLabel(String label) => Padding(
    padding: EdgeInsets.only(bottom: 4.h, top: 10.h),
    child: Text(
      label,
      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
    ),
  );

  Widget _buildTableHeader(String title) => Text(
    title,
    textAlign: TextAlign.center,
    style: TextStyle(color: Colors.grey, fontSize: 11.sp),
  );

  Widget _buildTextField(
    TextEditingController controller,
    int maxLines, {
    String? hint,
    bool isNumber = false,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: null,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
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
      onChanged: (_) => setState(() {}),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4.r)),
      ),
    );
  }
}

class IngredientRow {
  final TextEditingController name, qty, unit, cost;
  IngredientRow({
    required this.name,
    required this.qty,
    required this.unit,
    required this.cost,
  });
}
