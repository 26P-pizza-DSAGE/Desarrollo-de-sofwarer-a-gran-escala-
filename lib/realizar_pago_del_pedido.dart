import 'package:dsage/shared/model/pizza.dart';
import 'package:dsage/theme/app_theme.dart';
import 'package:dsage/shared/controllers/logic_pant_pago.dart';
import 'package:dsage/shared/widgets/payment/boton_confirmar_pago.dart';
import 'package:dsage/shared/widgets/payment/estado_pago_card.dart';
import 'package:dsage/shared/widgets/payment/formulario_facturacion_card.dart';
import 'package:dsage/shared/widgets/payment/historial_transacciones_card.dart';
import 'package:dsage/shared/widgets/payment/metodos_pago_card.dart';
import 'package:dsage/shared/widgets/payment/order_id_card.dart';
import 'package:dsage/shared/widgets/payment/resumen_pedido_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PantallaPago extends StatefulWidget {
  final String orderId;
  final List<Pizza> items;
  final double subtotal;
  final double tax;
  final double shippingCost;

  String get idPedido => orderId;
  List<Pizza> get productos => items;
  double get impuesto => tax;
  double get costEnvio => shippingCost;

  const PantallaPago({
    super.key,
    required this.orderId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
  });

  @override
  State<PantallaPago> createState() => _EstPantPago();

  State<PantallaPago> crearEstado() => _EstPantPago();
}

class _EstPantPago extends State<PantallaPago> {
  late final LogicPantPago pagoController;

  @override
  void initState() {
    super.initState();
    pagoController = LogicPantPago(
      orderId: widget.orderId,
      items: widget.items,
      subtotal: widget.subtotal,
      tax: widget.tax,
      shippingCost: widget.shippingCost,
      onStateChanged: () => setState(() {}),
    );
    pagoController.iniciarEstado();
  }

  @override
  void dispose() {
    pagoController.eliminarEstado();
    super.dispose();
  }

  PaymentMethod? get metoPagoSelec => pagoController.metodoPagoSelec;
  set metoPagoSelec(PaymentMethod? value) => pagoController.metodoPagoSelec = value;

  PaymentStatus get estPago => pagoController.estPago;
  set estPago(PaymentStatus value) => pagoController.estPago = value;

  bool get mostFormFact => pagoController.mostFormFact;
  set mostFormFact(bool value) => pagoController.mostFormFact = value;

  bool get mostHistTran => pagoController.mostHistTran;
  set mostHistTran(bool value) => pagoController.mostHistTran = value;

  TextEditingController get contCodDes => pagoController.contCodDes;
  TextEditingController get contNombre => pagoController.contNombre;
  TextEditingController get contCorrElec => pagoController.contCorrElec;
  TextEditingController get contTel => pagoController.contTel;
  TextEditingController get contDir => pagoController.contDir;
  TextEditingController get contTarj => pagoController.contTarj;
  TextEditingController get contFecha => pagoController.contFecha;
  TextEditingController get contCodigoCVV => pagoController.contCodigoCVV;

  String? get codDesApli => pagoController.codDesApli;
  set codDesApli(String? value) => pagoController.codDesApli = value;

  double get montDesApli => pagoController.montDesApli;
  set montDesApli(double value) => pagoController.montDesApli = value;

  List<Transaccion> get histTrans => pagoController.histTrans;
  set histTrans(List<Transaccion> value) => pagoController.histTrans = value;

  double get subtImpueYEnvio => pagoController.subtImpueYEnvio;
  double get total => pagoController.total;

  Color getStatusColor(PaymentStatus status) => pagoController.getStatusColor(status);

  String getStatusText(PaymentStatus status) => pagoController.getStatusText(status);

  void _procesarPago() {
    pagoController.procesarPago(
      context: context,
      onNavigateHome: () => context.go('/home'),
      onNavigateTracking: () => context.go('/tracking', extra: widget.idPedido),
    );
  }

  void descargarFactura() => pagoController.descargarFactura(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        title: const Text('Pago del Pedido'),
        elevation: 0,
        backgroundColor: AppTheme.primaryOrange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OrderIdCard(orderId: widget.orderId),
              const SizedBox(height: 24),
              ResumenPedidoCard(controller: pagoController),
              const SizedBox(height: 24),
              EstadoPagoCard(controller: pagoController),
              const SizedBox(height: 24),
              MetodosPagoCard(controller: pagoController),
              const SizedBox(height: 24),
              if (mostFormFact) ...[
                FormularioFacturacionCard(controller: pagoController),
                const SizedBox(height: 24),
              ],
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.accentGreen, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock, color: AppTheme.accentGreen, size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🔒 Conexión Segura',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.accentGreen,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tus datos están protegidos con encriptación SSL de 256 bits. '
                            'Tu información financiera nunca será compartida.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              BotonConfirmarPago(
                controller: pagoController,
                onPressed: _procesarPago,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => setState(() => mostHistTran = !mostHistTran),
                  icon: const Icon(Icons.history),
                  label: Text(
                    mostHistTran
                        ? 'Ocultar Historial'
                        : 'Ver Historial de Transacciones (${histTrans.length})',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: AppTheme.primaryOrange, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (mostHistTran) HistorialTransaccionesCard(controller: pagoController),
            ],
          ),
        ),
      ),
    );
  }
}

