import 'package:flutter/material.dart';
import 'package:genius_ai/config/theme/app_colors.dart';
import 'package:genius_ai/model/supplier.dart';

class BarSupplierCard extends StatelessWidget {
  const BarSupplierCard({
    super.key,
    required this.onTap,
    required this.supplier,
  });
  final VoidCallback onTap;

  final Supplier supplier;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.25),
              blurRadius: 16.0,
              spreadRadius: 0.0,
              offset: const Offset(0.0, 4.0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Title
            Text(
              supplier.name ?? 'N/A',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A2138),
              ),
            ),
            const SizedBox(height: 24),

            // Contact Information Rows
            _buildContactRow(
              Icons.phone_outlined,
              supplier.phone ?? 'N/A',
            ),
            const SizedBox(height: 16),
            _buildContactRow(
              Icons.mail_outline,
              supplier.email ?? 'N/A',
            ),
            const SizedBox(height: 16),
            _buildContactRow(
              Icons.location_on_outlined,
              supplier.address ?? 'N/A',
            ),

            const SizedBox(height: 28),

            // Action Button
            SizedBox(
              width: double.infinity,

              child: TextButton(
                onPressed: onTap,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                ),
                child: const Text(
                  'View Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 22),
        const SizedBox(width: 16),
        Text(
          label,
          style: TextStyle(
            fontSize: 17,
            color: Colors.grey[700],
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
