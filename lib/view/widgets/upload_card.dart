import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';

class UploadCard extends StatelessWidget {
  const UploadCard({
    super.key,
    required this.groupImage,
    required this.outlineImage,
    required this.title,
    required this.iconPath,
    required this.color,
    required this.onTap,
  });

  final String groupImage;
  final String outlineImage;
  final String title;
  final String iconPath;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.25),
            blurRadius: 16.r,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: -12.w,
            top: 0,
            bottom: 40.w,
            child: SvgPicture.asset(groupImage),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 50.w,
            child: SvgPicture.asset(outlineImage),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      width: 28.w,
                      height: 28.h,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),

                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.lightText,
                  ),
                ),
                SizedBox(height: 10.h),

                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 6.w,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/upload_icon.svg",
                            color: AppColors.surface,
                          ),
                          Text(
                            "Upload",
                            style: TextStyle(
                              color: AppColors.surface,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
