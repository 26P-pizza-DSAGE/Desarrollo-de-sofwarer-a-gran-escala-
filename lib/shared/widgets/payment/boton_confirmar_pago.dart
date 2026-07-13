import 'package:dsage/shared/controllers/logic_pant_pago.dart';
import 'package:dsage/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BotonConfirmarPago extends StatelessWidget {
  const BotonConfirmarPago({super.key, required this.controller, required this.onPressed});

  final LogicPantPago controller;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.estPago == PaymentStatus.processing ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryOrange,
          disabledBackgroundColor: AppTheme.outlineVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: controller.estPago == PaymentStatus.processing
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'Procesando...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            : Text(
                controller.estPago == PaymentStatus.confirmed
                    ? 'Pago Confirmado ✓'
                    : 'Confirmar Pago - \$${controller.total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
