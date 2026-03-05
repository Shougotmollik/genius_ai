import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/theme/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.btnText,
    required this.onTap,
    this.isLoading = false,
  });

  final String btnText;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isLoading
              ? AppColors.primary.withValues(alpha: 0.6)
              : AppColors.primary,
          borderRadius: BorderRadius.circular(80.r),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 24.h,
                  width: 24.h,
                  child: CircularProgressIndicator(
                    color: AppColors.surface,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  btnText,
                  style: TextStyle(
                    color: AppColors.surface,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
