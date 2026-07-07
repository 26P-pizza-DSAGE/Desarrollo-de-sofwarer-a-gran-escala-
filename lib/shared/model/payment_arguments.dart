import 'package:dsage/shared/model/pizza.dart';

class PaymentArguments {
  final String orderId;
  final List<Pizza> items;
  final double subtotal;
  final double tax;
  final double shippingCost;

  const PaymentArguments({
    required this.orderId,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
  });
}
