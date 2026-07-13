import 'package:dsage/shared/controllers/logic_pant_pago.dart';
import 'package:dsage/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistorialTransaccionesCard extends StatelessWidget {
  const HistorialTransaccionesCard({super.key, required this.controller});

  final LogicPantPago controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Historial de Transacciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...controller.histTrans.asMap().entries.map((entry) {
              return Column(
                children: [
                  _buildTransactionItem(entry.value, controller),
                  if (entry.key < controller.histTrans.length - 1)
                    const Divider(height: 16),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transaccion transaction, LogicPantPago controller) {
    final color = controller.getStatusColor(transaction.estado);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              transaction.metodo == PaymentMethod.card
                  ? Icons.credit_card
                  : Icons.payments,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.metodo == PaymentMethod.card ? 'Tarjeta' : 'Efectivo',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(transaction.fecha),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${transaction.monto.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  controller.getStatusText(transaction.estado),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
