import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/model/inventory_item.dart';

class RestaurantIngredientInventoryCard extends StatelessWidget {
  final InventoryItem item;

  const RestaurantIngredientInventoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isApproved = item.status.toLowerCase() == 'approved';

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          24.r,
        ), // Softer corners as per image
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 16.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: isApproved
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  item.status,
                  style: TextStyle(
                    color: isApproved
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFFF9800),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.file_download_outlined,
                  color: Colors.blue,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Title and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D2D2D),
                ),
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(color: Colors.black, fontSize: 18.sp),
                  children: [
                    TextSpan(
                      text: '\$${item.price}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '/kg',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Data Rows
          _buildDataRow('Category', item.category),
          SizedBox(height: 8.h),
          _buildDataRow('Current Stock', item.currentStock),
          SizedBox(height: 8.h),
          _buildDataRow('Minimun Stock', item.minStock),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey, fontSize: 15.sp),
        ),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF2D2D2D),
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
          ),
        ),
      ],
    );
  }
}
