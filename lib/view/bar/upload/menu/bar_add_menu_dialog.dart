import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/menu_controller.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

class BarAddMenuDialog extends StatefulWidget {
  const BarAddMenuDialog({super.key});

  @override
  State<BarAddMenuDialog> createState() => _BarAddMenuDialogState();
}

class _BarAddMenuDialogState extends State<BarAddMenuDialog> {
  // --- Controllers & State ---
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  late TextEditingController _dishController;
  final FocusNode _dishFocusNode = FocusNode();

  String _selectedType = "Lunch";

  final BarMenuController _controller = Get.find<BarMenuController>();

  List<String> _selectedDishes = [];

  @override
  void initState() {
    super.initState();
    if (_controller.dishList.isNotEmpty) {
      _selectedDishes = [_controller.dishList.first.name.toString()];
    } else {
      _selectedDishes = [];
    }
  }

  // --- Batch Menus from Excel ---
  List<Map<String, dynamic>> _batchMenus = [];

  // --- Excel Upload Logic ---
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
        _batchMenus.clear();

        for (int i = 1; i < rows.length; i++) {
          var row = rows[i];

          final String menuName = row[0]?.value.toString().trim() ?? "";
          final String menuType = row[1]?.value.toString().trim() ?? "Lunch";
          final String dishesRaw = row[2]?.value.toString().trim() ?? "";
          final String totalCost = row[3]?.value.toString().trim() ?? "0";

          // Dishes are comma-separated in the Excel cell
          final List<String> dishes = dishesRaw
              .split(',')
              .map((d) => d.trim())
              .where((d) => d.isNotEmpty)
              .toList();

          _batchMenus.add({
            "name": menuName,
            "menu_type": menuType.toUpperCase(),
            "dishes": dishes,
            "outlet_type": "bar",
            "total_cost":
                double.tryParse(totalCost.replaceAll(RegExp(r'[^\d.]'), '')) ??
                0,
          });
        }

        // Sync first item to UI fields
        if (_batchMenus.isNotEmpty) {
          final first = _batchMenus.first;

          setState(() {
            _nameController.text = first['name'];
            _costController.text = first['total_cost'].toString();
            _selectedType = _validType(
              (first['menu_type'] ?? first['type'] ?? 'Lunch').toString(),
            );
            _selectedDishes
              ..clear()
              ..addAll(List<String>.from(first['dishes']));
          });
        }

        AppSnackbar.show(
          message: "${_batchMenus.length} menu(s) loaded successfully",
          type: SnackType.success,
        );
      }
    }
  }

  /// Ensures the type from Excel matches one of the valid dropdown options.
  String _validType(String value) {
    const validTypes = ["Lunch", "Dinner", "Breakfast"];
    return validTypes.firstWhere(
      (t) => t.toLowerCase() == value.toLowerCase(),
      orElse: () => "Lunch",
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    _dishFocusNode.dispose();
    super.dispose();
  }

  // --- Dish Logic ---
  void _addDish(String value) {
    final trimmed = value.trim();
    if (trimmed.isNotEmpty && !_selectedDishes.contains(trimmed)) {
      setState(() {
        _selectedDishes.add(trimmed);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 24.h),

              _buildLabel("Menu Name"),
              _buildTextField(_nameController, "Enter menu name"),
              SizedBox(height: 16.h),

              _buildLabel("Types"),
              _buildDropdown(["Lunch", "Dinner", "Breakfast"], _selectedType, (
                val,
              ) {
                setState(() => _selectedType = val!);
              }),
              SizedBox(height: 16.h),

              _buildLabel("Select Dishes"),
              _buildSelectDishSection(),
              SizedBox(height: 16.h),

              _buildLabel("Total Cost"),
              _buildTextField(_costController, "0.00", isPrice: true),
              SizedBox(height: 16.h),

              const Center(
                child: Text(
                  "Or",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              SizedBox(height: 16.h),

              // --- Excel Upload Box (now functional) ---
              GestureDetector(
                onTap: _pickExcelFile,
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
                      padding: EdgeInsets.all(16.r),
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
                          SizedBox(height: 12.h),
                          Text(
                            'Click here to upload menu',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.text,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Max. File Size: 10MB',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.text,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          // Show loaded batch count
                          if (_batchMenus.isNotEmpty) ...[
                            SizedBox(height: 6.h),
                            Text(
                              '${_batchMenus.length} menu(s) loaded',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 32.h),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Add Menu',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2D2D2D),
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.close, color: Colors.red, size: 28),
        ),
      ],
    );
  }

  Widget _buildSelectDishSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE8E8E8)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedDishes.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: _selectedDishes
                    .map(
                      (dish) => Chip(
                        label: Text(dish, style: TextStyle(fontSize: 12.sp)),
                        onDeleted: () =>
                            setState(() => _selectedDishes.remove(dish)),
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        side: BorderSide.none,
                      ),
                    )
                    .toList(),
              ),
            ),

          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              final suggestions = _controller.dishList
                  .map((dish) => dish.name.toString())
                  .where((dishName) => !_selectedDishes.contains(dishName));
              if (textEditingValue.text.isEmpty) return suggestions;
              return suggestions.where(
                (option) => option.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                ),
              );
            },
            onSelected: (String selection) {
              _addDish(selection);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _dishController.clear();
              });
            },
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  _dishController = controller;
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      hintText: "Search or type new dish...",
                      border: InputBorder.none,
                      isDense: true,
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          _addDish(controller.text);
                          controller.clear();
                          focusNode.requestFocus();
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      _addDish(value);
                      controller.clear();
                      onFieldSubmitted();
                      focusNode.requestFocus();
                    },
                  );
                },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    constraints: BoxConstraints(maxHeight: 200.h),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF555555),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool isPrice = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: isPrice ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: isPrice
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: const Text(
                  '\$',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFF0091FF)),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    List<String> items,
    String current,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE8E8E8)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: current,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          items: items
              .map(
                (String item) =>
                    DropdownMenuItem(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              side: const BorderSide(color: Color(0xFFE0E0E0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Obx(
            () => ElevatedButton(
              onPressed: () async {
                List<Map<String, dynamic>> payload = [];

                if (_batchMenus.isNotEmpty) {
                  _batchMenus[0] = {
                    "name": _nameController.text,
                    "menu_type": _selectedType.toUpperCase(),
                    "outlet_type": "bar",
                    "total_cost": _costController.text.trim(),
                    "dishes": List<String>.from(_selectedDishes),
                  };
                  payload = _batchMenus;
                } else {
                  payload = [
                    {
                      "name": _nameController.text,
                      "menu_type": _selectedType.toLowerCase(),
                      "outlet_type": "bar",
                      "total_cost": _costController.text.trim(),
                      "dishes": List<String>.from(_selectedDishes),
                    },
                  ];
                }

                await _controller.addMenu(menu: payload);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0091FF),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
                elevation: 0,
              ),
              child: _controller.isLoading.value
                  ? SizedBox(
                      height: 18.w,
                      width: 18.w,
                      child: const CircularProgressIndicator(
                        color: Colors.white54,
                      ),
                    )
                  : Text(
                      "+ Add",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
