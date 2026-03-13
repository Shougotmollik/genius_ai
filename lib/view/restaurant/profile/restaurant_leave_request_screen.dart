import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/controller/user_controller.dart';
import 'package:genius_ai/utils/app_snackbar.dart';
import 'package:get/get.dart';

class RestaurantLeaveRequestScreen extends StatefulWidget {
  const RestaurantLeaveRequestScreen({super.key});

  @override
  State<RestaurantLeaveRequestScreen> createState() =>
      _RestaurantLeaveRequestScreenState();
}

class _RestaurantLeaveRequestScreenState
    extends State<RestaurantLeaveRequestScreen> {
  String? _selectedLeaveType = 'Casual';
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _reasonController = TextEditingController();
  final UserController controller = Get.find<UserController>();

  final List<String> _leaveTypes = [
    'Casual',
    'Sick',
    'Annual',
    'Maternity',
    'Paternity',
    'Unpaid',
    "Emergency",
    "Others",
  ];

  final _dateFormat = 'mm/dd/yyyy';

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? now)
          : (_endDate ?? _startDate ?? now),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2196F3),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _onApply() async {
    if (_selectedLeaveType == null) {
      AppSnackbar.show(
        message: "Please select a leave type.",
        type: SnackType.warning,
      );
      return;
    }
    if (_startDate == null) {
      AppSnackbar.show(
        message: "Please select a start date.",
        type: SnackType.warning,
      );
      return;
    }
    if (_endDate == null) {
      AppSnackbar.show(
        message: "Please select an end date.",
        type: SnackType.warning,
      );
      return;
    }
    if (_reasonController.text.isEmpty) {
      AppSnackbar.show(
        message: "Please enter your reason.",
        type: SnackType.warning,
      );
      return;
    }
    final bool isSuccess = await controller.sendLeaveRequest(
      leaveType: _selectedLeaveType.toString(),
      startDate: _formatDate(_startDate),
      endDate: _formatDate(_endDate),
      reason: _reasonController.text,
    );
    if (isSuccess) {
      Get.back();
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                spacing: 18.w,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  Text(
                    "Leave Request",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Leave Type
                    Text(
                      'Leave Type',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedLeaveType,
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          hint: const Text(
                            'Select Leave Type',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                          items: _leaveTypes
                              .map(
                                (t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(
                                    t,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) =>
                              setState(() => _selectedLeaveType = val),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Start Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Start Date',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.text,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _pickDate(isStart: true),
                          child: const Icon(
                            Icons.calendar_month,
                            size: 20,
                            color: AppColors.lightText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickDate(isStart: true),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _startDate != null
                              ? _formatDate(_startDate)
                              : 'mm/dd/yyyy',
                          style: TextStyle(
                            fontSize: 14,
                            color: _startDate != null
                                ? Colors.black87
                                : Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // End Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'End Date',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.text,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _pickDate(isStart: false),
                          child: const Icon(
                            Icons.calendar_month,
                            size: 20,
                            color: AppColors.lightText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickDate(isStart: false),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _endDate != null
                              ? _formatDate(_endDate)
                              : 'mm/dd/yyyy',
                          style: TextStyle(
                            fontSize: 14,
                            color: _endDate != null
                                ? Colors.black87
                                : Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      'Reason',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _reasonController,
                        maxLines: 5,
                        style: const TextStyle(fontSize: 14),
                        decoration: const InputDecoration(
                          hintText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).maybePop(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFBDBDBD)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: _onApply,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2196F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                elevation: 0,
                              ),
                              child: controller.isLoading.value
                                  ? SizedBox(
                                      height: 18.w,
                                      width: 18.w,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white70,
                                      ),
                                    )
                                  : const Text(
                                      'Apply',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
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
            ],
          ),
        ),
      ),
    );
  }
}
