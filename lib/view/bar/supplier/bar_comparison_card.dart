import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:genius_ai/config/theme/app_colors.dart';

class ComparisonCard extends StatelessWidget {
  const ComparisonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          const Text(
            'Tomato (per kg)',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 20),

          // Best Price Card
          _buildPriceItem(
            company: 'Ocean Fresh Ltd.',
            price: '35.00',
            isBestPrice: true,
          ),

          const SizedBox(height: 12),

          // Other Price Cards
          _buildPriceItem(
            company: 'Coastal Seafood',
            price: '32.50',
            trend: Icons.trending_up,
            trendColor: Colors.red,
          ),

          const SizedBox(height: 12),

          _buildPriceItem(
            company: 'Marine Supply Co.',
            price: '38.00',
            trend: Icons.trending_down,
            trendColor: Colors.green,
          ),

          const SizedBox(height: 12),

          _buildPriceItem(
            company: 'Marine Supply Co.',
            price: '38.00',
            trend: Icons.trending_down,
            trendColor: Colors.green,
          ),
        ],
      ),
    );
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
        borderRadius: BorderRadius.circular(16),
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
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.text,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (trend != null) Icon(trend, color: trendColor, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '\$$price',
            style: const TextStyle(
              fontSize: 28,
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
