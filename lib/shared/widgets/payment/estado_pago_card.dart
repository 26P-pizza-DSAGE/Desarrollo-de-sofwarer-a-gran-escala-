import 'package:dsage/shared/controllers/logic_pant_pago.dart';
import 'package:dsage/theme/app_theme.dart';
import 'package:flutter/material.dart';

class EstadoPagoCard extends StatelessWidget {
  const EstadoPagoCard({super.key, required this.controller});

  final LogicPantPago controller;

  @override
  Widget build(BuildContext context) {
    final estado = controller.estPago;
    final color = controller.getStatusColor(estado);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estado del Pago',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    switch (estado) {
                      PaymentStatus.pending => Icons.schedule,
                      PaymentStatus.processing => Icons.hourglass_empty,
                      PaymentStatus.confirmed => Icons.check_circle,
                      PaymentStatus.rejected => Icons.cancel,
                    },
                    color: color,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.getStatusText(estado),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        switch (estado) {
                          PaymentStatus.pending =>
                            'Esperando confirmación de pago',
                          PaymentStatus.processing =>
                            'Tu pago está siendo procesado',
                          PaymentStatus.confirmed =>
                            'Tu pago fue confirmado exitosamente',
                          PaymentStatus.rejected =>
                            'Hubo un problema con tu pago',
                        },
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (estado == PaymentStatus.processing)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: LinearProgressIndicator(
                  minHeight: 4,
                  backgroundColor: AppTheme.outlineVariant,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
