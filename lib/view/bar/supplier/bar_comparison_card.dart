import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/model/price_comparison.dart';

class ComparisonCard extends StatelessWidget {
  const ComparisonCard({super.key, required this.priceComparison});
  final SupplierPriceComparison priceComparison;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.25),
            blurRadius: 16.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${priceComparison.productName} (per ${priceComparison.suppliers.isNotEmpty ? priceComparison.suppliers.first.unit : 'unit'})',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 20),

          Column(
            children: priceComparison.suppliers.map((supplier) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildPriceItem(
                  company: supplier.supplierName,
                  price: supplier.latestPrice,
                  isBestPrice: supplier.isBestPrice,
                  trend: _getTrendIcon(supplier.trend),
                  trendColor: _getTrendColor(supplier.trend),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Helper to map API string trends
  IconData? _getTrendIcon(String? trend) {
    switch (trend) {
      case 'increasing':
        return Icons.trending_up;
      case 'decreasing':
        return Icons.trending_down;
      default:
        return null;
    }
  }

  // Helper to map API string trends to Colors
  Color? _getTrendColor(String? trend) {
    switch (trend) {
      case 'increasing':
        return Colors.red;
      case 'decreasing':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildPriceItem({
    required String company,
    required String price,
    bool isBestPrice = false,
    IconData? trend,
    Color? trendColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isBestPrice ? const Color(0xFFE8F5EE) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isBestPrice
              ? const Color(0xFF4DB67E)
              : const Color(0xFFEEEEEE),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                company,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.text,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (trend != null) Icon(trend, color: trendColor, size: 20.r),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$$price',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.text,
            ),
          ),
          if (isBestPrice) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF00A36C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Best Price',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
