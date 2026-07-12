import 'package:dsage/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OrderIdCard extends StatelessWidget {
  const OrderIdCard({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryOrange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryOrange, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Número de Pedido',
            style: TextStyle(color: AppTheme.onSurfaceVariant, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            '#$orderId',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryOrange,
            ),
          ),
        ],
      ),
    );
  }
}
