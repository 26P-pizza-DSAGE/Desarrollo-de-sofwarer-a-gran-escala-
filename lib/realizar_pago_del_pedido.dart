import 'package:dsage/shared/model/pizza.dart';
import 'package:dsage/core/config/app_constants.dart';
import 'package:dsage/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

enum PaymentStatus { pending, processing, confirmed, rejected }

enum PaymentMethod { card, cash }

class Transaction {
  final String id;
  final DateTime date;
  final double amount;
  final PaymentStatus status;
  final PaymentMethod method;

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.status,
    required this.method,
  });
}

class PagoScreen extends StatefulWidget {
  final String orderId;
  final List<Pizza> items;
  final double subtotal;
  final double tax;
  final double shippingCost;

  const PagoScreen({
    super.key,
    required this.orderId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
  });

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  PaymentMethod? selectedPaymentMethod;
  PaymentStatus paymentStatus = PaymentStatus.pending;
  bool showBillingForm = false;
  bool showTransactionHistory = false;
  final TextEditingController discountCodeController = TextEditingController();
  String? appliedDiscountCode;
  double appliedDiscountAmount = 0.0;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  late List<Transaction> transactionHistory;

  @override
  void initState() {
    super.initState();
    discountCodeController.addListener(_handleDiscountCodeChanged);
    transactionHistory = [
      Transaction(
        id: 'TRX-001-${widget.orderId}',
        date: DateTime.now().subtract(const Duration(days: 1)),
        amount: total,
        status: PaymentStatus.confirmed,
        method: PaymentMethod.card,
      ),
    ];
  }

  @override
  void dispose() {
    discountCodeController.removeListener(_handleDiscountCodeChanged);
    discountCodeController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  double get subtotalWithTaxesAndShipping =>
      widget.subtotal + widget.tax + widget.shippingCost;

  double get total => (subtotalWithTaxesAndShipping - appliedDiscountAmount)
      .clamp(0.0, subtotalWithTaxesAndShipping);

  void _handleDiscountCodeChanged() {
    if (discountCodeController.text.trim().isNotEmpty) {
      return;
    }

    if (appliedDiscountAmount == 0.0 && appliedDiscountCode == null) {
      return;
    }

    setState(() {
      appliedDiscountCode = null;
      appliedDiscountAmount = 0.0;
    });
  }

  void _applyDiscountCode() {
    final String code = discountCodeController.text.trim().toUpperCase();

    if (appliedDiscountAmount > 0) {
      setState(() {
        appliedDiscountCode = null;
        appliedDiscountAmount = 0.0;
      });
      discountCodeController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Código de descuento eliminado.'),
          backgroundColor: AppTheme.primaryOrange,
        ),
      );
      return;
    }

    if (code.isEmpty) {
      discountCodeController.clear();
      setState(() {
        appliedDiscountCode = null;
        appliedDiscountAmount = 0.0;
      });

      return;
    }

    final double? discount = AppConstants.discountCodes[code];

    if (discount == null) {
      setState(() {
        appliedDiscountCode = null;
        appliedDiscountAmount = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Código "$code" inválido.',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() {
      appliedDiscountCode = code;
      appliedDiscountAmount = discount;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Código "$code" aplicado con éxito.'),
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

  void _processPayment() {
    if (selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un método de pago')),
      );
      return;
    }

    if (!showBillingForm) {
      setState(() => showBillingForm = true);
      return;
    }

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos requeridos')),
      );
      return;
    }

    if (selectedPaymentMethod == PaymentMethod.card &&
        (cardNumberController.text.isEmpty ||
            expiryController.text.isEmpty ||
            cvvController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa los datos de la tarjeta')),
      );
      return;
    }

    setState(() => paymentStatus = PaymentStatus.processing);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => paymentStatus = PaymentStatus.confirmed);

      transactionHistory.insert(
        0,
        Transaction(
          id: 'TRX-${DateTime.now().millisecondsSinceEpoch}',
          date: DateTime.now(),
          amount: total,
          status: PaymentStatus.confirmed,
          method: selectedPaymentMethod!,
        ),
      );

      _showSuccessDialog();
    });
  }

  void _showSuccessDialog() {
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
              'Pedido #${widget.orderId}',
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
              _downloadInvoice();
              context.go('/home');
            },
            child: const Text('Descargar Factura'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext, rootNavigator: true).pop();
              context.go('/tracking', extra: widget.orderId);
            },
            child: const Text('Seguimiento de Entrega'),
          ),
        ],
      ),
    );
  }

  void _downloadInvoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Descargando factura...'),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
        backgroundColor: AppTheme.primaryOrange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme cs = theme.colorScheme;

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
              _buildOrderIdCard(),
              const SizedBox(height: 24),
              _buildOrderSummary(cs),
              const SizedBox(height: 24),
              _buildPaymentStatusIndicator(),
              const SizedBox(height: 24),
              _buildPaymentMethodsSection(),
              const SizedBox(height: 24),
              if (showBillingForm) ...[
                _buildBillingFormSection(),
                const SizedBox(height: 24),
              ],
              _buildSecurityMessage(),
              const SizedBox(height: 24),
              _buildConfirmButton(),
              const SizedBox(height: 24),
              _buildTransactionHistoryButton(),
              const SizedBox(height: 24),
              if (showTransactionHistory) _buildTransactionHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderIdCard() {
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
            '#${widget.orderId}',
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

  Widget _buildOrderSummary(ColorScheme cs) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen del Pedido',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ...widget.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${item.name} x${item.quantity}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            TextField(
              controller: discountCodeController,
              decoration: InputDecoration(
                labelText: 'Código de Descuento',
                hintText: 'Ingresa un código válido',
                suffixIcon: IconButton(
                  icon: appliedDiscountAmount > 0
                      ? const Icon(Icons.close)
                      : const Icon(Icons.check),
                  onPressed: _applyDiscountCode,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            if (appliedDiscountAmount > 0) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.accentGreen),
                ),
                child: Text(
                  'Descuento aplicado (${appliedDiscountCode ?? ''}): -\$${appliedDiscountAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accentGreen,
                  ),
                ),
              ),
            ],

            const Divider(height: 20),
            _buildSummaryRow('Subtotal', widget.subtotal),
            const SizedBox(height: 8),
            _buildSummaryRow('Impuestos', widget.tax, AppTheme.primaryOrange),
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Costo de Envío',
              widget.shippingCost,
              AppTheme.accentGreen,
            ),
            if (appliedDiscountAmount > 0) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Descuento',
                    style: TextStyle(fontSize: 14, color: AppTheme.accentGreen),
                  ),
                  Text(
                    '-\$${appliedDiscountAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.accentGreen,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryOrange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryOrange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, [Color? color]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: color ?? AppTheme.onSurfaceVariant,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentStatusIndicator() {
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
                    color: getStatusColor(paymentStatus).withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    switch (paymentStatus) {
                      PaymentStatus.pending => Icons.schedule,
                      PaymentStatus.processing => Icons.hourglass_empty,
                      PaymentStatus.confirmed => Icons.check_circle,
                      PaymentStatus.rejected => Icons.cancel,
                    },
                    color: getStatusColor(paymentStatus),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getStatusText(paymentStatus),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: getStatusColor(paymentStatus),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        switch (paymentStatus) {
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
            if (paymentStatus == PaymentStatus.processing)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: LinearProgressIndicator(
                  minHeight: 4,
                  backgroundColor: AppTheme.outlineVariant,
                  valueColor: AlwaysStoppedAnimation(
                    getStatusColor(paymentStatus),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Método de Pago',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            PaymentMethodCard(
              icon: Icons.credit_card,
              title: 'Tarjeta de Crédito/Débito',
              subtitle: 'Visa, Mastercard, American Express',
              isSelected: selectedPaymentMethod == PaymentMethod.card,
              onTap: () => setState(() {
                selectedPaymentMethod = PaymentMethod.card;
              }),
            ),
            const SizedBox(height: 12),
            PaymentMethodCard(
              icon: Icons.payments,
              title: 'Pago en Efectivo',
              subtitle: 'Al momento de la entrega',
              isSelected: selectedPaymentMethod == PaymentMethod.cash,
              onTap: () => setState(() {
                selectedPaymentMethod = PaymentMethod.cash;
                showBillingForm = false;
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingFormSection() {
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
            CustomCheckoutTextField(
              controller: nameController,
              label: 'Nombre Completo',
              icon: Icons.person,
            ),
            const SizedBox(height: 12),
            CustomCheckoutTextField(
              controller: emailController,
              label: 'Correo Electrónico',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            CustomCheckoutTextField(
              controller: phoneController,
              label: 'Teléfono',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            CustomCheckoutTextField(
              controller: addressController,
              label: 'Dirección de Facturación',
              icon: Icons.location_on,
              maxLines: 2,
            ),
            if (selectedPaymentMethod == PaymentMethod.card) ...[
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                'Datos de la Tarjeta',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              CustomCheckoutTextField(
                controller: cardNumberController,
                label: 'Número de Tarjeta',
                icon: Icons.credit_card,
                placeholder: '1234 5678 9012 3456',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomCheckoutTextField(
                      controller: expiryController,
                      label: 'MM/AA',
                      placeholder: '12/25',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomCheckoutTextField(
                      controller: cvvController,
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

  Widget _buildSecurityMessage() {
    return Container(
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
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: paymentStatus == PaymentStatus.processing
            ? null
            : _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryOrange,
          disabledBackgroundColor: AppTheme.outlineVariant,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: paymentStatus == PaymentStatus.processing
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
                paymentStatus == PaymentStatus.confirmed
                    ? 'Pago Confirmado ✓'
                    : 'Confirmar Pago - \$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildTransactionHistoryButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () =>
            setState(() => showTransactionHistory = !showTransactionHistory),
        icon: const Icon(Icons.history),
        label: Text(
          showTransactionHistory
              ? 'Ocultar Historial'
              : 'Ver Historial de Transacciones (${transactionHistory.length})',
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: const BorderSide(color: AppTheme.primaryOrange, width: 2),
        ),
      ),
    );
  }

  Widget _buildTransactionHistory() {
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
            ...transactionHistory.asMap().entries.map((entry) {
              return Column(
                children: [
                  _buildTransactionItem(entry.value),
                  if (entry.key < transactionHistory.length - 1)
                    const Divider(height: 16),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: getStatusColor(transaction.status).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              transaction.method == PaymentMethod.card
                  ? Icons.credit_card
                  : Icons.payments,
              color: getStatusColor(transaction.status),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.method == PaymentMethod.card
                      ? 'Tarjeta'
                      : 'Efectivo',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  DateFormat('dd/MM/yyyy HH:mm').format(transaction.date),
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
                '\$${transaction.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: getStatusColor(
                    transaction.status,
                  ).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  getStatusText(transaction.status),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: getStatusColor(transaction.status),
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

class CustomCheckoutTextField extends StatelessWidget {
  const CustomCheckoutTextField({
    super.key,
    required this.controller,
    required this.label,
    this.icon,
    this.placeholder,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final IconData? icon;
  final String? placeholder;
  final TextInputType keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        prefixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.primaryOrange, width: 2),
        ),
      ),
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppTheme.primaryOrange : AppTheme.outline,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppTheme.primaryOrange.withValues(alpha: 0.08)
              : AppTheme.surfaceDark,
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryOrange
                    : AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryOrange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
          ],
        ),
      ),
    );
  }
}
