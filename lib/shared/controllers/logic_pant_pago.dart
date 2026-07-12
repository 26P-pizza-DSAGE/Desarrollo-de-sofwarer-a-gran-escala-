import 'package:dsage/core/config/app_constants.dart';
import 'package:dsage/shared/model/pizza.dart';
import 'package:dsage/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum PaymentStatus { pending, processing, confirmed, rejected }

enum PaymentMethod { card, cash }

class Transaccion {
  final String id;
  final DateTime fecha;
  final double monto;
  final PaymentStatus estado;
  final PaymentMethod metodo;

  Transaccion({
    required this.id,
    required this.fecha,
    required this.monto,
    required this.estado,
    required this.metodo,
  });
}

class LogicPantPago {
  LogicPantPago({
    required this.orderId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    required this.onStateChanged,
  });

  final String orderId;
  final List<Pizza> items;
  final double subtotal;
  final double tax;
  final double shippingCost;
  final VoidCallback onStateChanged;

  PaymentMethod? metodoPagoSelec;
  PaymentStatus estPago = PaymentStatus.pending;
  bool mostFormFact = false;
  bool mostHistTran = false;
  final TextEditingController contCodDes = TextEditingController();
  String? codDesApli;
  double montDesApli = 0.0;

  final TextEditingController contNombre = TextEditingController();
  final TextEditingController contCorrElec = TextEditingController();
  final TextEditingController contTel = TextEditingController();
  final TextEditingController contDir = TextEditingController();
  final TextEditingController contTarj = TextEditingController();
  final TextEditingController contFecha = TextEditingController();
  final TextEditingController contCodigoCVV = TextEditingController();

  late List<Transaccion> histTrans;

  void iniciarEstado() {
    contCodDes.addListener(manejarCambioCodigoDescuento);
    histTrans = [
      Transaccion(
        id: 'TRX-001-$orderId',
        fecha: DateTime.now().subtract(const Duration(days: 1)),
        monto: total,
        estado: PaymentStatus.confirmed,
        metodo: PaymentMethod.card,
      ),
    ];
  }

  void eliminarEstado() {
    contCodDes.removeListener(manejarCambioCodigoDescuento);
    contCodDes.dispose();
    contNombre.dispose();
    contCorrElec.dispose();
    contTel.dispose();
    contDir.dispose();
    contTarj.dispose();
    contFecha.dispose();
    contCodigoCVV.dispose();
  }

  double get subtImpueYEnvio => subtotal + tax + shippingCost;

  double get total => (subtImpueYEnvio - montDesApli).clamp(0.0, subtImpueYEnvio);

  void manejarCambioCodigoDescuento() {
    if (contCodDes.text.trim().isNotEmpty) {
      return;
    }

    if (montDesApli == 0.0 && codDesApli == null) {
      return;
    }

    codDesApli = null;
    montDesApli = 0.0;
    onStateChanged();
  }

  void aplicarCodigoDescuento(BuildContext context) {
    final String codigo = contCodDes.text.trim().toUpperCase();

    if (montDesApli > 0) {
      codDesApli = null;
      montDesApli = 0.0;
      contCodDes.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código de descuento eliminado.'),
          backgroundColor: AppTheme.primaryOrange,
        ),
      );
      onStateChanged();
      return;
    }

    if (codigo.isEmpty) {
      contCodDes.clear();
      codDesApli = null;
      montDesApli = 0.0;
      onStateChanged();
      return;
    }

    final double? descuento = AppConstants.discountCodes[codigo];

    if (descuento == null) {
      codDesApli = null;
      montDesApli = 0.0;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Código "$codigo" inválido.',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      onStateChanged();
      return;
    }

    codDesApli = codigo;
    montDesApli = descuento;
    onStateChanged();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Código "$codigo" aplicado con éxito.'),
        backgroundColor: AppTheme.accentGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Color getStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return AppTheme.primaryOrange;
      case PaymentStatus.processing:
        return AppTheme.primaryOrange;
      case PaymentStatus.confirmed:
        return AppTheme.accentGreen;
      case PaymentStatus.rejected:
        return Colors.redAccent;
    }
  }

  String getStatusText(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'Pendiente';
      case PaymentStatus.processing:
        return 'Procesando...';
      case PaymentStatus.confirmed:
        return '✓ Confirmado';
      case PaymentStatus.rejected:
        return '✗ Rechazado';
    }
  }

  Future<void> procesarPago({
    required BuildContext context,
    required VoidCallback onNavigateHome,
    required VoidCallback onNavigateTracking,
  }) async {
    if (metodoPagoSelec == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un método de pago')),
      );
      return;
    }

    if (!mostFormFact) {
      mostFormFact = true;
      onStateChanged();
      return;
    }

    if (contNombre.text.isEmpty ||
        contCorrElec.text.isEmpty ||
        contDir.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos requeridos')),
      );
      return;
    }

    if (metodoPagoSelec == PaymentMethod.card &&
        (contTarj.text.isEmpty ||
            contFecha.text.isEmpty ||
            contCodigoCVV.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa los datos de la tarjeta')),
      );
      return;
    }

    estPago = PaymentStatus.processing;
    onStateChanged();

    await Future.delayed(const Duration(seconds: 2));

    if (!context.mounted) {
      return;
    }

    estPago = PaymentStatus.confirmed;
    onStateChanged();

    histTrans.insert(
      0,
      Transaccion(
        id: 'TRX-${DateTime.now().millisecondsSinceEpoch}',
        fecha: DateTime.now(),
        monto: total,
        estado: PaymentStatus.confirmed,
        metodo: metodoPagoSelec!,
      ),
    );

    mostrarDialExito(
      context: context,
      onNavigateHome: onNavigateHome,
      onNavigateTracking: onNavigateTracking,
    );
  }

  void mostrarDialExito({
    required BuildContext context,
    required VoidCallback onNavigateHome,
    required VoidCallback onNavigateTracking,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¡Pago Confirmado!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: AppTheme.accentGreen,
              size: 64,
            ),
            const SizedBox(height: 20),
            Text(
              'Pedido #$orderId',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${total.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext, rootNavigator: true).pop();
              descargarFactura(context);
              onNavigateHome();
            },
            child: const Text('Descargar Factura'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext, rootNavigator: true).pop();
              onNavigateTracking();
            },
            child: const Text('Seguimiento de Entrega'),
          ),
        ],
      ),
    );
  }

  void descargarFactura(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Descargando factura...'),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );
  }

  void seleccionarMetodo(PaymentMethod method) {
    metodoPagoSelec = method;
    if (method == PaymentMethod.cash) {
      mostFormFact = false;
    }
    onStateChanged();
  }

  void alternarHistorial() {
    mostHistTran = !mostHistTran;
    onStateChanged();
  }
}
