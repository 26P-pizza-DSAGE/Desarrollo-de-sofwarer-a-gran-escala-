import 'package:dsage/shared/controllers/logic_pant_pago.dart';
import 'package:dsage/shared/widgets/detalle_pantalla_pago.dart';
import 'package:flutter/material.dart';

class FormularioFacturacionCard extends StatelessWidget {
  const FormularioFacturacionCard({super.key, required this.controller});

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
              'Datos de Facturación',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CampoTextoPersonalizado(
              controller: controller.contNombre,
              label: 'Nombre Completo',
              icon: Icons.person,
            ),
            const SizedBox(height: 12),
            CampoTextoPersonalizado(
              controller: controller.contCorrElec,
              label: 'Correo Electrónico',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            CampoTextoPersonalizado(
              controller: controller.contTel,
              label: 'Teléfono',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            CampoTextoPersonalizado(
              controller: controller.contDir,
              label: 'Dirección de Facturación',
              icon: Icons.location_on,
              maxLines: 2,
            ),
            if (controller.metodoPagoSelec == PaymentMethod.card) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                'Datos de la Tarjeta',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              CampoTextoPersonalizado(
                controller: controller.contTarj,
                label: 'Número de Tarjeta',
                icon: Icons.credit_card,
                placeholder: '1234 5678 9012 3456',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CampoTextoPersonalizado(
                      controller: controller.contFecha,
                      label: 'MM/AA',
                      placeholder: '12/25',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CampoTextoPersonalizado(
                      controller: controller.contCodigoCVV,
                      label: 'CVV',
                      placeholder: '123',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
