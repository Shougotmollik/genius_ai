import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/utils/app_snackbar.dart';

class RestaurantAddPurchaseDialog extends StatefulWidget {
  const RestaurantAddPurchaseDialog({super.key});

  @override
  State<RestaurantAddPurchaseDialog> createState() =>
      _RestaurantAddPurchaseDialogState();
}

class _RestaurantAddPurchaseDialogState
    extends State<RestaurantAddPurchaseDialog> {
  // Batch Purchases
  List<Map<String, dynamic>> _batchPurchases = [];

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController dateController = TextEditingController(
    text: "12/12/25",
  );

  String? selectedSupplier = "Ocean Fresh Ltd";
  String? selectedCategory = "Other";

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
        _batchPurchases.clear();

        for (int i = 1; i < rows.length; i++) {
          var row = rows[i];

          _batchPurchases.add({
            "product_name": row[0]?.value.toString().trim() ?? "",
            "price": row[1]?.value.toString().trim() ?? "0",
            "quantity": row[4]?.value.toString().trim() ?? "0",
            "unit": row[2]?.value.toString().trim() ?? "",
            "supplier_name": row[5]?.value.toString().trim() ?? "",
            "category_name": row[3]?.value.toString().trim() ?? "",
            "purchase_date": row[6]?.value.toString().trim() ?? "",
          });
        }

        if (_batchPurchases.isNotEmpty) {
          var first = _batchPurchases.first;
          nameController.text = first['product_name'];
          priceController.text = first['price'];
          quantityController.text = first['quantity'];
          unitController.text = first['unit'];

          setState(() {
            if (first['supplier_name'].toString().isNotEmpty) {
              selectedSupplier = first['supplier_name'].toString();
            }
            if (first['category_name'].toString().isNotEmpty) {
              selectedCategory = first['category_name'].toString();
            }
            if (first['purchase_date'].toString().isNotEmpty) {
              dateController.text = first['purchase_date'].toString();
            }
          });
        }

        AppSnackbar.show(
          message: "${_batchPurchases.length} purchases loaded successfully",
          type: SnackType.success,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(context),
              const SizedBox(height: 20),
              _fieldLabel("Product Name"),
              _textField("Enter product name", controller: nameController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _columnField(
                      "Price",
                      "00.0",
                      controller: priceController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _columnField(
                      "Quantity",
                      "00",
                      controller: quantityController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _fieldLabel("Unit"),
              _textField("Unit name", controller: unitController),
              const SizedBox(height: 16),
              _fieldLabel("Supplier Name"),
              _dropdownField(
                selectedSupplier ?? "Ocean Fresh Ltd",
                onChanged: (val) {
                  if (val != null) setState(() => selectedSupplier = val);
                },
              ),
              const SizedBox(height: 16),
              _fieldLabel("Category"),
              _dropdownField(
                selectedCategory ?? "Other",
                onChanged: (val) {
                  if (val != null) setState(() => selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),
              _fieldLabel("Purchase Date"),
              _dateField("12/12/25", controller: dateController),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Or",
                    style: TextStyle(
                      color: AppColors.lightText,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
              Text(
                "Upload Product",
                style: TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 8.h),
              // Upload Box
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
                            _batchPurchases.isNotEmpty
                                ? 'Uploaded ${_batchPurchases.length} purchases'
                                : 'Click here to upload',
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
              const SizedBox(height: 32),
              _actionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Add Purchase",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: Colors.red, size: 28),
        ),
      ],
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _textField(String hint, {TextEditingController? controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _columnField(
    String label,
    String hint, {
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        _textField(hint, controller: controller),
      ],
    );
  }

  Widget _dropdownField(String value, {ValueChanged<String?>? onChanged}) {
    List<String> items = [
      "Ocean Fresh Ltd",
      "Other",
      "Seafood",
      "Supplier A",
      "Supplier B",
      "Meat",
      "Vegetables",
      "Liquid",
      "Powder",
      "Solid",
    ];
    if (!items.contains(value)) items.insert(0, value);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _dateField(String date, {TextEditingController? controller}) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          String formattedDate =
              "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year.toString().substring(2)}";
          setState(() {
            controller?.text = formattedDate;
          });
        }
      },
      decoration: InputDecoration(
        hintText: date,
        suffixIcon: const Icon(
          Icons.calendar_month_outlined,
          color: Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add),
                Text(" Add", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
