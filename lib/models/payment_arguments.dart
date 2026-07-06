import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Enums y modelos
enum PaymentStatus { pending, processing, confirmed, rejected }

enum PaymentMethod { card, cash }

class OrderItem {
  final String name;
  final double price;
  final int quantity;

  OrderItem({required this.name, required this.price, required this.quantity});
}

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

class PaymentArguments {
  final String orderId;
  final List<OrderItem> items;
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
