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
      theme: ThemeData(useMaterial3: true),
      home: const PedidoRecibidoScreen(),
    );
  }
}

class PedidoRecibidoScreen extends StatefulWidget {
  const PedidoRecibidoScreen({super.key});

  @override
  State<PedidoRecibidoScreen> createState() => _PedidoRecibidoScreenState();
}

class _PedidoRecibidoScreenState extends State<PedidoRecibidoScreen> {
  final Color fondo = const Color(0xFF241006);
  final Color tarjeta = const Color(0xFF351A0B);
  final Color borde = const Color(0xFF6B3A0A);
  final Color naranja = const Color(0xFFFFA51E);
  final Color naranjaFuerte = const Color(0xFFFF941C);
  final Color textoSecundario = const Color(0xFFC48A5A);

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
        backgroundColor: naranjaFuerte,
        content: Text(
          'Pedido #${pedido.id} enviado a preparación',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pedidos Recibidos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Órdenes pendientes',
                        style: TextStyle(
                          color: Color(0xFFC48A5A),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: tarjeta,
                      shape: BoxShape.circle,
                      border: Border.all(color: borde),
                    ),
                    child: const Icon(
                      Icons.receipt_long_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Lista de pedidos
              Expanded(
                child: ListView.builder(
                  itemCount: pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = pedidos[index];
                    final pendiente = pedido.estado == 'Pendiente';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: tarjeta,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: pendiente ? naranja : Colors.green,
                          width: 1.6,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título del pedido
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4A250C),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: borde),
                                ),
                                child: const Center(
                                  child: Text(
                                    '🍕',
                                    style: TextStyle(fontSize: 28),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 14),

                              Expanded(
                                child: Text(
                                  'Pedido #${pedido.id}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),

                              Chip(
                                backgroundColor: pendiente
                                    ? const Color(0xFF4A250C)
                                    : Colors.green.withOpacity(0.18),
                                side: BorderSide(
                                  color: pendiente ? naranja : Colors.green,
                                ),
                                avatar: Icon(
                                  pendiente
                                      ? Icons.hourglass_bottom
                                      : Icons.check_circle,
                                  color: pendiente ? naranja : Colors.green,
                                  size: 16,
                                ),
                                label: Text(
                                  pedido.estado,
                                  style: TextStyle(
                                    color: pendiente ? naranja : Colors.green,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Cliente
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                color: textoSecundario,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Cliente: ${pedido.cliente}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Text(
                            'Pizzas:',
                            style: TextStyle(
                              color: textoSecundario,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          ...pedido.pizzas.map(
                            (pizza) => Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.local_pizza_outlined,
                                    color: naranja,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    pizza,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          if (pendiente)
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton.icon(
                                onPressed: () => confirmarPedido(pedido),
                                icon: const Icon(Icons.check_circle_outline),
                                label: const Text(
                                  'Confirmar Pedido',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: naranjaFuerte,
                                  foregroundColor: Colors.black,
                                  elevation: 8,
                                  shadowColor: naranjaFuerte,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}