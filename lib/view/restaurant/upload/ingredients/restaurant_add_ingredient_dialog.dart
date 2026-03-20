import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart' show AppColors;
import 'package:genius_ai/controller/ingredient_controller.dart';
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
  // Batch Ingredients
  List<Map<String, dynamic>> _batchIngredients = [];

  Future<void> _downloadSampleExcel() async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Template'];
      excel.delete('Sheet1'); // Remove default sheet

      // Add Headers matching React Template
      sheetObject.appendRow([
        TextCellValue("ID"),
        TextCellValue("Ingredient Name"),
        TextCellValue("Price / Unit"),
        TextCellValue("Unit"),
        TextCellValue("Category"),
        TextCellValue("Outlet Type"),
        TextCellValue("Current Stock"),
        TextCellValue("Minimum Stock"),
        TextCellValue("Is Special (true/false)"),
      ]);

      // Use first available category or "Meats"
      String sampleCategory = controller.categoryList.isNotEmpty
          ? controller.categoryList.first.name
          : "Meats";

      // Add Sample Data
      sheetObject.appendRow([
        TextCellValue(""), // ID
        TextCellValue("Sample Chicken"),
        TextCellValue("15.00"),
        TextCellValue("KG"),
        TextCellValue(sampleCategory),
        TextCellValue("Restaurant"),
        TextCellValue("100"),
        TextCellValue("20"),
        TextCellValue("false"),
      ]);

      var fileBytes = excel.encode();
      if (fileBytes != null) {
        String? outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Sample Template',
          fileName: 'ingredient_template.xlsx',
          type: FileType.custom,
          allowedExtensions: ['xlsx'],
          bytes: Uint8List.fromList(fileBytes),
        );

        if (outputFile != null) {
          AppSnackbar.show(
            message: "Template saved successfully!",
            type: SnackType.success,
          );
        }
      }
    } catch (e) {
      AppSnackbar.show(
        message: "Failed to download template: $e",
        type: SnackType.error,
      );
    }
  }

  Future<void> _pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      var bytes = File(result.files.single.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      var table = excel.tables.keys.first;
      var rows = excel.tables[table]!.rows;

      if (rows.length > 1) {
        _batchIngredients.clear();

        for (int i = 1; i < rows.length; i++) {
          var row = rows[i];

          // Updated Indices for 9-column structure
          String catName = row[4]?.value.toString().trim() ?? "";
          String rawUnit = row[3]?.value.toString().trim() ?? "";
          String rawPrice = row[2]?.value.toString().trim() ?? "0";
          String name = row[1]?.value.toString().trim() ?? "";
          int currentStock = int.tryParse(row[6]?.value.toString() ?? "0") ?? 0;
          int minStock = int.tryParse(row[7]?.value.toString() ?? "0") ?? 0;
          bool isSpecial = row[8]?.value.toString().toLowerCase() == "true";

          // Normalize Unit
          String normalizedUnit = rawUnit.toLowerCase() == "kg"
              ? "kg"
              : rawUnit;

          _batchIngredients.add({
            "name": name,
            "category": catName,
            "outlet_type": "restaurant",
            "unit": normalizedUnit,
            "price_per_unit": rawPrice,
            "current_stock": currentStock,
            "minimum_stock": minStock,
            "is_special": isSpecial,
          });
        }

        // Sync first item to UI
        if (_batchIngredients.isNotEmpty) {
          var first = _batchIngredients.first;
          nameController.text = first['name'];
          unitController.text = first['unit'];
          priceController.text = first['price_per_unit'];
          currentStockController.text = first['current_stock'].toString();
          minStockController.text = first['minimum_stock'].toString();

          setState(() {
            // Find the category object based on the Name from Excel to update dropdown
            selectedCategory = controller.categoryList.firstWhereOrNull(
              (c) =>
                  c.name.toLowerCase().trim() ==
                  first['category'].toString().toLowerCase(),
            );
          });
        }

        AppSnackbar.show(
          message:
              "${_batchIngredients.length} ingredients loaded successfully",
          type: SnackType.success,
        );
      }
    }
  }

  final IngredientController controller = Get.find<IngredientController>();

  // Controllers
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

              GestureDetector(
                onTap: _downloadSampleExcel,

                child: Container(
                  width: double.infinity.w,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: Text(
                      "Download sample file to import data",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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

              // Excel Upload Box
              GestureDetector(
                onTap: () {
                  _pickExcelFile();
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
                            _batchIngredients.isNotEmpty
                                ? 'You have uploaded ${_batchIngredients.length} ingredients'
                                : 'Click here to upload ingredient',
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
                        List<Map<String, dynamic>> payload = [];

                        if (_batchIngredients.isNotEmpty) {
                          // Sync UI edits to the first item in the batch
                          _batchIngredients[0] = {
                            "name": nameController.text.trim(),
                            "category":
                                selectedCategory?.name ??
                                "", // CHANGED: Use name
                            "outlet_type": "restaurant",
                            "unit": unitController.text.trim(),
                            "price_per_unit": priceController.text.trim(),
                            "current_stock":
                                int.tryParse(currentStockController.text) ?? 0,
                            "minimum_stock":
                                int.tryParse(minStockController.text) ?? 0,
                            "is_special": controller.isSpecial.value,
                          };
                          payload = _batchIngredients;
                        } else {
                          // Manual entry
                          payload = [
                            {
                              "name": nameController.text.trim(),
                              "category":
                                  selectedCategory?.name ??
                                  "", // CHANGED: Use name
                              "outlet_type": "restaurant",
                              "unit": unitController.text.trim(),
                              "price_per_unit": priceController.text.trim(),
                              "current_stock":
                                  int.tryParse(currentStockController.text) ??
                                  0,
                              "minimum_stock":
                                  int.tryParse(minStockController.text) ?? 0,
                              "is_special": controller.isSpecial.value,
                            },
                          ];
                        }

                        bool success = await controller.postIngredient(
                          ingredients: payload,
                        );
                        if (success) Navigator.pop(context);
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
