import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/menu_controller.dart';
import 'package:get/get.dart';

class BarEditMenuDialog extends StatefulWidget {
  const BarEditMenuDialog({super.key, required this.id});
  final String id;

  @override
  State<BarEditMenuDialog> createState() => _BarEditMenuDialogState();
}

class _BarEditMenuDialogState extends State<BarEditMenuDialog> {
  final BarMenuController _controller = Get.find<BarMenuController>();

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _costController;
  late TextEditingController _dishSearchController;
  final FocusNode _dishFocusNode = FocusNode();

  // State
  String _selectedType = "Lunch";
  List<String> _selectedDishes = [];

  @override
  void initState() {
    super.initState();

    // 1. Find the existing menu from the controller's list by ID
    final menu = _controller.menuList.firstWhere(
      (element) => element.id.toString() == widget.id,
    );

    // 2. Initialize Controllers with preloaded data
    _nameController = TextEditingController(text: menu.name);
    _costController = TextEditingController(text: menu.totalCost.toString());
    _dishSearchController = TextEditingController();

    // 3. Preload Type and Dishes
    _selectedType = _validType(menu.menuType ?? "Lunch");

    if (menu.dishes != null) {
      // Create a fresh list from existing dishes
      _selectedDishes = menu.dishes!
          .map((dish) => dish.name.toString())
          .toList();
    }
  }

  /// Ensures the string from the database matches the dropdown options
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
    _dishSearchController.dispose();
    _dishFocusNode.dispose();
    super.dispose();
  }

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
              SizedBox(height: 32.h),

              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Helper Components ---

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Edit Menu',
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
              _dishSearchController.clear();
            },
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  _dishSearchController = controller;
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
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      _addDish(value);
                      controller.clear();
                      focusNode.requestFocus();
                    },
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
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
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
                // Create payload for updating
                List<Map<String, dynamic>> payload = [
                  {
                    "id": int.parse(widget.id),
                    "name": _nameController.text.trim(),
                    "menu_type": _selectedType.toLowerCase(),
                    "outlet_type": "bar",
                    "total_cost": _costController.text.trim(),
                    "dishes": _selectedDishes,
                  },
                ];

                final bool success = await _controller.updateMenu(
                  menu: payload,
                );
                if (success) {
                  Navigator.pop(context);
                }
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
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      "Update",
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
