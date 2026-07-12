import 'package:dsage/shared/model/pizza.dart';
import 'package:dsage/realizar_pago_del_pedido.dart';
import 'package:flutter/material.dart';

class EjemploUsoPago extends StatelessWidget {
  const EjemploUsoPago({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejemplo de Uso - Pago')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            final itemsPedido = [
              Pizza.catalog[0].copyWith(quantity: 2),
              Pizza.catalog[1].copyWith(quantity: 1),
            ];

            final double subtotal = itemsPedido.fold(
              0.0,
              (sum, item) => sum + item.totalPrice,
            );

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PantallaPago(
                  orderId: 'ORD-2024-${DateTime.now().millisecondsSinceEpoch}',
                  items: itemsPedido,
                  subtotal: subtotal,
                  tax: subtotal * 0.08,
                  shippingCost: 50.00,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: const Text(
            'Ir a Pagar Pedido',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class GestorCarrito {
  final List<Pizza> _items = [];

  void agregarPizza(Pizza pizza) => _items.add(pizza);

  void removerPizza(int index) {
    if (index >= 0 && index < _items.length) _items.removeAt(index);
  }

  double obtenerSubtotal() =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  List<Pizza> obtenerItems() => List.unmodifiable(_items);

  void limpiar() => _items.clear();
}

void ejemploNavegacionDesdePantallaPrincipal(BuildContext context) {
  final carrito = GestorCarrito();

  carrito.agregarPizza(Pizza.catalog[2].copyWith(quantity: 1));
  carrito.agregarPizza(Pizza.catalog[3].copyWith(quantity: 2));

  final subtotal = carrito.obtenerSubtotal();
  final impuestos = subtotal * 0.08;
  const envio = 50.00;

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => PantallaPago(
        orderId: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        items: carrito.obtenerItems(),
        subtotal: subtotal,
        tax: impuestos,
        shippingCost: envio,
      ),
    ),
  );
}
