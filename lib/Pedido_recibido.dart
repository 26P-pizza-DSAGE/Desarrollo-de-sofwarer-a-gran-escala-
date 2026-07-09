import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Pedido {
  final int id;
  final String cliente;
  final List<String> pizzas;
  String estado;

  Pedido({
    required this.id,
    required this.cliente,
    required this.pizzas,
    this.estado = 'Pendiente',
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pedidos',
      home: PedidoRecibidoScreen(),
    );
  }
}

class PedidoRecibidoScreen extends StatefulWidget {
  @override
  State<PedidoRecibidoScreen> createState() =>
      _PedidoRecibidoScreenState();
}

class _PedidoRecibidoScreenState
    extends State<PedidoRecibidoScreen> {

  final List<Pedido> pedidos = [
    Pedido(
      id: 1,
      cliente: 'Juan Pérez',
      pizzas: ['Pepperoni', 'Hawaiana'],
    ),
    Pedido(
      id: 2,
      cliente: 'María López',
      pizzas: ['Mexicana'],
    ),
  ];

  void confirmarPedido(Pedido pedido) {
    setState(() {
      pedido.estado = 'Confirmado';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pedido #${pedido.id} enviado a preparación',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos Recibidos'),
      ),
      body: ListView.builder(
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          final pedido = pedidos[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedido #${pedido.id}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Cliente: ${pedido.cliente}'),
                  const SizedBox(height: 8),

                  const Text(
                    'Pizzas:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  ...pedido.pizzas.map(
                    (pizza) => Text('• $pizza'),
                  ),

                  const SizedBox(height: 10),

                  Chip(
                    label: Text(pedido.estado),
                  ),

                  const SizedBox(height: 10),

                  if (pedido.estado == 'Pendiente')
                    ElevatedButton(
                      onPressed: () =>
                          confirmarPedido(pedido),
                      child: const Text(
                        'Confirmar Pedido',
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}