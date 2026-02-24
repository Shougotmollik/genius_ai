import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:genius_ai/config/theme/app_colors.dart';

class InfoHighlighterCard extends StatelessWidget {
  const InfoHighlighterCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
    required this.iconPath,
  });

  final String title;
  final int value;
  final Color color;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Stack(
        children: [
          SvgPicture.asset(
            "assets/image/recipes_wave.svg",
            fit: BoxFit.cover,
            width: double.infinity,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "$value",
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: color.withValues(alpha: 0.25),
                      width: 1.w,
                    ),
                  ),
                  child: SvgPicture.asset(iconPath, height: 20.w, width: 20.w),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
