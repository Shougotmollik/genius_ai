import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/theme/app_colors.dart';

enum AlertTrend { increase, decrease }

class BarSupplierAlertCard extends StatelessWidget {
  final String title;
  final String supplier;
  final double previousPrice;
  final double currentPrice;
  final String percentage;
  final AlertTrend trend;

  const BarSupplierAlertCard({
    super.key,
    required this.title,
    required this.supplier,
    required this.previousPrice,
    required this.currentPrice,
    required this.percentage,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    // Determine colors based on trend
    final bool isIncrease = trend == AlertTrend.increase;
    final Color trendColor = isIncrease
        ? const Color(0xFF2196F3)
        : const Color(0xFFC62828);
    final Color bgColor = isIncrease
        ? const Color(0xFFE3F2FD)
        : const Color(0xFFFCE4EC);
    final IconData trendIcon = isIncrease
        ? Icons.trending_up
        : Icons.trending_down;

    return Container(
      padding: EdgeInsets.all(12.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFCDD2)),
            ),
            child: const Text(
              'Sudden Change is visible',
              style: TextStyle(
                color: Color(0xFFD32F2F),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            '$title - Price ${isIncrease ? 'Increase' : 'Decrease'}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D1B2A),
            ),
          ),
          const SizedBox(height: 4),

          // Supplier
          Text(
            'Supplier: $supplier',
            style: const TextStyle(fontSize: 15, color: Color(0xFF5F6D7E)),
          ),
          const SizedBox(height: 16),

          // Price Row
          Row(
            children: [
              Text(
                'Previous: \$${previousPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, color: Color(0xFF5F6D7E)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(trendIcon, color: trendColor, size: 20),
              ),
              Text(
                'Current: \$${currentPrice.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, color: Color(0xFF5F6D7E)),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Percentage Box
          Center(
            child: Container(
              width: 120,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    '${isIncrease ? '+' : '-'}$percentage%',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: trendColor,
                    ),
                  ),
                  Text(
                    isIncrease ? 'Increase' : 'Decrease',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5F6D7E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
