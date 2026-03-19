import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';

class RestaurantEditPurchaseDialog extends StatelessWidget {
  const RestaurantEditPurchaseDialog({super.key});

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
              _textField("Enter product name"),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _columnField("Price", "00.0")),
                  const SizedBox(width: 12),
                  Expanded(child: _columnField("Quantity", "00")),
                ],
              ),
              const SizedBox(height: 16),
              _fieldLabel("Unit"),
              _textField("Unit name"),
              const SizedBox(height: 16),
              _fieldLabel("Supplier Name"),
              _dropdownField("Ocean Fresh Ltd"),
              const SizedBox(height: 16),
              _fieldLabel("Category"),
              _dropdownField("Other"),
              const SizedBox(height: 16),
              _fieldLabel("Purchase Date"),
              _dateField("12/12/25"),
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
                            'Click here to upload',
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
              SizedBox(height: 16.h),
              Text(
                "Report(If find any problem with the product)",
                style: TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 8.h),
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
                            'assets/icons/image-upload.svg',
                            width: 32.w,
                            height: 32.w,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Click here to upload',
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
              // _uploadArea(
              //   "Upload Product",
              //   Icons.table_view_rounded,
              //   Colors.green,
              // ),
              const SizedBox(height: 16),
              // _uploadArea(
              //   "Report (If find any problem with the product)",
              //   Icons.image_outlined,
              //   Colors.grey,
              // ),
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
          "Edit Purchase",
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

  Widget _textField(String hint) {
    return TextField(
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

  Widget _columnField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_fieldLabel(label), _textField(hint)],
    );
  }

  Widget _dropdownField(String value) {
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
          items: [DropdownMenuItem(value: value, child: Text(value))],
          onChanged: (_) {},
        ),
      ),
    );
  }

  Widget _dateField(String date) {
    return TextField(
      readOnly: true,
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
            onPressed: () {},
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
              children: [Text("Save", style: TextStyle(fontSize: 16))],
            ),
          ),
        ),
      ],
    );
  }
}
