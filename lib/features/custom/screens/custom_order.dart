import 'package:dsage/core/config/app_constants.dart';
import 'package:dsage/shared/model/payment_arguments.dart';
import 'package:dsage/shared/model/pizza.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomOrderScreen extends StatelessWidget {
  const CustomOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TamanoScreen();
  }
}

class TamanoScreen extends StatefulWidget {
  const TamanoScreen({super.key});

  @override
  State<TamanoScreen> createState() => _TamanoScreenState();
}

class _TamanoScreenState extends State<TamanoScreen> {
  String tamanoSeleccionado = 'Mediana';
  double precioSeleccionado = 12.90;

  final List<Map<String, dynamic>> tamanos = [
    {'nombre': 'Personal', 'descripcion': '20 cm · 1-2 pax', 'precio': 8.90},
    {'nombre': 'Mediana', 'descripcion': '28 cm · 2-3 pax', 'precio': 12.90},
    {'nombre': 'Grande', 'descripcion': '33 cm · 3-4 pax', 'precio': 16.90},
    {'nombre': 'Familiar', 'descripcion': '40 cm · 4-6 pax', 'precio': 21.90},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF241006),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Encabezado(titulo: 'Arma tu Pizza', paso: 'Tamaño'),

              const SizedBox(height: 18),

              const BarraProgreso(pasoActual: 1),

              const SizedBox(height: 35),

              const Center(child: PizzaPreview()),

              const SizedBox(height: 30),

              Expanded(
                child: ListView.builder(
                  itemCount: tamanos.length,
                  itemBuilder: (context, index) {
                    final item = tamanos[index];
                    final seleccionado = item['nombre'] == tamanoSeleccionado;

                    return TarjetaTamano(
                      nombre: item['nombre'],
                      descripcion: item['descripcion'],
                      precio: item['precio'],
                      seleccionado: seleccionado,
                      onTap: () {
                        setState(() {
                          tamanoSeleccionado = item['nombre'];
                          precioSeleccionado = item['precio'];
                        });
                      },
                    );
                  },
                ),
              ),

              BotonContinuar(
                texto: 'Continuar',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MasaScreen(
                        tamano: tamanoSeleccionado,
                        precioTamano: precioSeleccionado,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Encabezado extends StatelessWidget {
  final String titulo;
  final String paso;

  const Encabezado({super.key, required this.titulo, required this.paso});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 27,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              paso,
              style: const TextStyle(color: Color(0xFFC48A5A), fontSize: 14),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF6B3A0A)),
          ),
          child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
        ),
      ],
    );
  }
}

class BarraProgreso extends StatelessWidget {
  final int pasoActual;

  const BarraProgreso({super.key, required this.pasoActual});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(6, (index) {
        final activo = index < pasoActual;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 6),
            height: 7,
            decoration: BoxDecoration(
              color: activo ? const Color(0xFFFFA51E) : const Color(0xFF4A250C),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      }),
    );
  }
}

class PizzaPreview extends StatelessWidget {
  const PizzaPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      height: 235,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFD39A4E),
      ),
      child: Center(
        child: Container(
          width: 195,
          height: 195,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF2C2A5),
            border: Border.all(color: const Color(0xFFD64332), width: 10),
          ),
        ),
      ),
    );
  }
}

class TarjetaTamano extends StatelessWidget {
  final String nombre;
  final String descripcion;
  final double precio;
  final bool seleccionado;
  final VoidCallback onTap;

  const TarjetaTamano({
    super.key,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF351A0B),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: seleccionado
                ? const Color(0xFFFFA51E)
                : const Color(0xFF6B3A0A),
            width: seleccionado ? 2 : 1.3,
          ),
        ),
        child: Row(
          children: [
            const Text('🍕', style: TextStyle(fontSize: 34)),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    descripcion,
                    style: const TextStyle(
                      color: Color(0xFFC48A5A),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              '\$${precio.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFFFFA51E),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),

            if (seleccionado) ...[
              const SizedBox(width: 12),
              const Icon(Icons.check, color: Color(0xFFFFA51E)),
            ],
          ],
        ),
      ),
    );
  }
}

class BotonContinuar extends StatelessWidget {
  final String texto;
  final VoidCallback onTap;

  const BotonContinuar({super.key, required this.texto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF941C),
          foregroundColor: Colors.black,
          elevation: 8,
          shadowColor: const Color(0xFFFF941C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              texto,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

class MasaScreen extends StatefulWidget {
  final String tamano;
  final double precioTamano;

  const MasaScreen({
    super.key,
    required this.tamano,
    required this.precioTamano,
  });

  @override
  State<MasaScreen> createState() => _MasaScreenState();
}

class _MasaScreenState extends State<MasaScreen> {
  String masaSeleccionada = 'Clásica';
  double precioMasa = 0;

  final List<Map<String, dynamic>> masas = [
    {'nombre': 'Delgada', 'descripcion': 'Crujiente y ligera', 'precio': 0.0},
    {
      'nombre': 'Clásica',
      'descripcion': 'El equilibrio perfecto',
      'precio': 0.0,
    },
    {
      'nombre': 'Rellena',
      'descripcion': 'Con queso en el borde',
      'precio': 1.50,
    },
    {
      'nombre': 'Focaccia',
      'descripcion': 'Esponjosa y aromática',
      'precio': 1.50,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF241006),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Encabezado(titulo: 'Arma tu Pizza', paso: 'Masa'),

              const SizedBox(height: 18),

              const BarraProgreso(pasoActual: 2),

              const SizedBox(height: 35),

              const Center(child: PizzaPreview()),

              const SizedBox(height: 30),

              Expanded(
                child: GridView.builder(
                  itemCount: masas.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    final item = masas[index];
                    final seleccionado = item['nombre'] == masaSeleccionada;

                    return TarjetaOpcionCuadro(
                      icono: '◌',
                      nombre: item['nombre'],
                      descripcion: item['descripcion'],
                      precio: item['precio'],
                      seleccionado: seleccionado,
                      onTap: () {
                        setState(() {
                          masaSeleccionada = item['nombre'];
                          precioMasa = item['precio'];
                        });
                      },
                    );
                  },
                ),
              ),

              Row(
                children: [
                  BotonAtras(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: BotonContinuar(
                      texto: 'Continuar',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SalsaScreen(
                              tamano: widget.tamano,
                              precioTamano: widget.precioTamano,
                              masa: masaSeleccionada,
                              precioMasa: precioMasa,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TarjetaOpcionCuadro extends StatelessWidget {
  final String icono;
  final String nombre;
  final String descripcion;
  final double precio;
  final bool seleccionado;
  final VoidCallback onTap;

  const TarjetaOpcionCuadro({
    super.key,
    required this.icono,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF351A0B),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: seleccionado
                ? const Color(0xFFFFA51E)
                : const Color(0xFF6B3A0A),
            width: seleccionado ? 2 : 1.3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              icono,
              style: TextStyle(
                color: seleccionado
                    ? const Color(0xFFFFA51E)
                    : const Color(0xFFD9A85E),
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              nombre,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              descripcion,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFC48A5A),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),

            if (precio > 0) ...[
              const SizedBox(height: 8),
              Text(
                '+\$${precio.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFFFFA51E),
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class BotonAtras extends StatelessWidget {
  final VoidCallback onTap;

  const BotonAtras({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF6B3A0A), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Color(0xFFC48A5A),
          size: 18,
        ),
      ),
    );
  }
}

class SalsaScreen extends StatefulWidget {
  final String tamano;
  final double precioTamano;
  final String masa;
  final double precioMasa;

  const SalsaScreen({
    super.key,
    required this.tamano,
    required this.precioTamano,
    required this.masa,
    required this.precioMasa,
  });

  @override
  State<SalsaScreen> createState() => _SalsaScreenState();
}

class _SalsaScreenState extends State<SalsaScreen> {
  String salsaSeleccionada = 'Tomate';

  final List<Map<String, dynamic>> salsas = [
    {
      'nombre': 'Tomate',
      'descripcion': 'Clásica y fresca',
      'icono': '🍅',
      'precio': 0.0,
    },
    {
      'nombre': 'BBQ',
      'descripcion': 'Dulce y ahumada',
      'icono': '🔥',
      'precio': 0.0,
    },
    {
      'nombre': 'Blanca',
      'descripcion': 'Cremosa y suave',
      'icono': '🧄',
      'precio': 0.0,
    },
    {
      'nombre': 'Pesto',
      'descripcion': 'Hierbas y aroma',
      'icono': '🌿',
      'precio': 0.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF241006),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Encabezado(titulo: 'Arma tu Pizza', paso: 'Salsa'),

              const SizedBox(height: 18),

              const BarraProgreso(pasoActual: 3),

              const SizedBox(height: 35),

              const Center(child: PizzaPreview()),

              const SizedBox(height: 30),

              Expanded(
                child: GridView.builder(
                  itemCount: salsas.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.08,
                  ),
                  itemBuilder: (context, index) {
                    final item = salsas[index];
                    final seleccionado = item['nombre'] == salsaSeleccionada;

                    return TarjetaOpcionCuadro(
                      icono: item['icono'],
                      nombre: item['nombre'],
                      descripcion: item['descripcion'],
                      precio: item['precio'],
                      seleccionado: seleccionado,
                      onTap: () {
                        setState(() {
                          salsaSeleccionada = item['nombre'];
                        });
                      },
                    );
                  },
                ),
              ),

              Row(
                children: [
                  BotonAtras(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: BotonContinuar(
                      texto: 'Continuar',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QuesoScreen(
                              tamano: widget.tamano,
                              precioTamano: widget.precioTamano,
                              masa: widget.masa,
                              precioMasa: widget.precioMasa,
                              salsa: salsaSeleccionada,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuesoScreen extends StatefulWidget {
  final String tamano;
  final double precioTamano;
  final String masa;
  final double precioMasa;
  final String salsa;

  const QuesoScreen({
    super.key,
    required this.tamano,
    required this.precioTamano,
    required this.masa,
    required this.precioMasa,
    required this.salsa,
  });

  @override
  State<QuesoScreen> createState() => _QuesoScreenState();
}

class _QuesoScreenState extends State<QuesoScreen> {
  String quesoSeleccionado = 'Mozzarella';

  final List<Map<String, dynamic>> quesos = [
    {
      'nombre': 'Mozzarella',
      'descripcion': 'Clásico y suave',
      'icono': '🧀',
      'precio': 0.0,
    },
    {
      'nombre': 'Cheddar',
      'descripcion': 'Intenso y cremoso',
      'icono': '🧀',
      'precio': 0.0,
    },
    {
      'nombre': 'Parmesano',
      'descripcion': 'Fuerte y aromático',
      'icono': '🧀',
      'precio': 0.0,
    },
    {
      'nombre': 'Sin queso',
      'descripcion': 'Sin lácteos',
      'icono': '🚫',
      'precio': 0.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF241006),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Encabezado(titulo: 'Arma tu Pizza', paso: 'Queso'),

              const SizedBox(height: 18),

              const BarraProgreso(pasoActual: 4),

              const SizedBox(height: 35),

              const Center(child: PizzaPreview()),

              const SizedBox(height: 30),

              Expanded(
                child: GridView.builder(
                  itemCount: quesos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.08,
                  ),
                  itemBuilder: (context, index) {
                    final item = quesos[index];
                    final seleccionado = item['nombre'] == quesoSeleccionado;

                    return TarjetaOpcionCuadro(
                      icono: item['icono'],
                      nombre: item['nombre'],
                      descripcion: item['descripcion'],
                      precio: item['precio'],
                      seleccionado: seleccionado,
                      onTap: () {
                        setState(() {
                          quesoSeleccionado = item['nombre'];
                        });
                      },
                    );
                  },
                ),
              ),

              Row(
                children: [
                  BotonAtras(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: BotonContinuar(
                      texto: 'Continuar',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ToppingsScreen(
                              tamano: widget.tamano,
                              precioTamano: widget.precioTamano,
                              masa: widget.masa,
                              precioMasa: widget.precioMasa,
                              salsa: widget.salsa,
                              queso: quesoSeleccionado,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToppingsScreen extends StatefulWidget {
  final String tamano;
  final double precioTamano;
  final String masa;
  final double precioMasa;
  final String salsa;
  final String queso;

  const ToppingsScreen({
    super.key,
    required this.tamano,
    required this.precioTamano,
    required this.masa,
    required this.precioMasa,
    required this.salsa,
    required this.queso,
  });

  @override
  State<ToppingsScreen> createState() => _ToppingsScreenState();
}

class _ToppingsScreenState extends State<ToppingsScreen> {
  final List<Map<String, dynamic>> toppingsSeleccionados = [];

  final List<Map<String, dynamic>> toppings = [
    {'nombre': 'Pepperoni', 'icono': '🍖', 'precio': 1.50},
    {'nombre': 'Champiñones', 'icono': '🍄', 'precio': 1.00},
    {'nombre': 'Aceitunas', 'icono': '🫒', 'precio': 1.00},
    {'nombre': 'Pimientos', 'icono': '🫑', 'precio': 1.00},
    {'nombre': 'Cebolla', 'icono': '🧅', 'precio': 0.80},
    {'nombre': 'Bacon', 'icono': '🥓', 'precio': 1.50},
    {'nombre': 'Espinaca', 'icono': '🥬', 'precio': 0.80},
    {'nombre': 'Piña', 'icono': '🍍', 'precio': 1.00},
    {'nombre': 'Anchoas', 'icono': '🐟', 'precio': 1.50},
    {'nombre': 'Jalapeño', 'icono': '🌶️', 'precio': 1.00},
    {'nombre': 'Maíz', 'icono': '🌽', 'precio': 0.80},
    {'nombre': 'Prosciutto', 'icono': '🥩', 'precio': 2.00},
  ];

  bool estaSeleccionado(String nombre) {
    return toppingsSeleccionados.any((item) => item['nombre'] == nombre);
  }

  void alternarTopping(Map<String, dynamic> topping) {
    setState(() {
      if (estaSeleccionado(topping['nombre'])) {
        toppingsSeleccionados.removeWhere(
          (item) => item['nombre'] == topping['nombre'],
        );
      } else {
        toppingsSeleccionados.add(topping);
      }
    });
  }

  double calcularTotal() {
    double total = widget.precioTamano + widget.precioMasa;

    for (final topping in toppingsSeleccionados) {
      total += topping['precio'];
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF241006),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Encabezado(titulo: 'Arma tu Pizza', paso: 'Toppings'),

              const SizedBox(height: 18),

              const BarraProgreso(pasoActual: 5),

              const SizedBox(height: 25),

              const Center(child: PizzaPreview()),

              const SizedBox(height: 18),

              Center(
                child: Text(
                  'Seleccionados: ${toppingsSeleccionados.length} ingredientes',
                  style: const TextStyle(
                    color: Color(0xFFC48A5A),
                    fontSize: 13,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Expanded(
                child: GridView.builder(
                  itemCount: toppings.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.88,
                  ),
                  itemBuilder: (context, index) {
                    final item = toppings[index];
                    final seleccionado = estaSeleccionado(item['nombre']);

                    return TarjetaTopping(
                      icono: item['icono'],
                      nombre: item['nombre'],
                      precio: item['precio'],
                      seleccionado: seleccionado,
                      onTap: () {
                        alternarTopping(item);
                      },
                    );
                  },
                ),
              ),

              Row(
                children: [
                  BotonAtras(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: BotonContinuar(
                      texto: 'Revisar pedido',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PedidoScreen(
                              tamano: widget.tamano,
                              precioTamano: widget.precioTamano,
                              masa: widget.masa,
                              precioMasa: widget.precioMasa,
                              salsa: widget.salsa,
                              queso: widget.queso,
                              toppings: toppingsSeleccionados,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TarjetaTopping extends StatelessWidget {
  final String icono;
  final String nombre;
  final double precio;
  final bool seleccionado;
  final VoidCallback onTap;

  const TarjetaTopping({
    super.key,
    required this.icono,
    required this.nombre,
    required this.precio,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF351A0B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: seleccionado
                ? const Color(0xFFFFA51E)
                : const Color(0xFF6B3A0A),
            width: seleccionado ? 2 : 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icono, style: const TextStyle(fontSize: 27)),

            const SizedBox(height: 8),

            Text(
              nombre,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              '+\$${precio.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFFFFA51E),
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),

            if (seleccionado) ...[
              const SizedBox(height: 4),
              const Icon(
                Icons.check_circle,
                color: Color(0xFFFFA51E),
                size: 16,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PedidoScreen extends StatefulWidget {
  final String tamano;
  final double precioTamano;
  final String masa;
  final double precioMasa;
  final String salsa;
  final String queso;
  final List<Map<String, dynamic>> toppings;

  const PedidoScreen({
    super.key,
    required this.tamano,
    required this.precioTamano,
    required this.masa,
    required this.precioMasa,
    required this.salsa,
    required this.queso,
    required this.toppings,
  });

  @override
  State<PedidoScreen> createState() => _PedidoScreenState();
}

class _PedidoScreenState extends State<PedidoScreen> {
  String tipoEntrega = 'Delivery';

  double calcularTotal() {
    double total = widget.precioTamano + widget.precioMasa;

    for (final topping in widget.toppings) {
      total += topping['precio'];
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final total = calcularTotal();

    return Scaffold(
      backgroundColor: const Color(0xFF241006),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Encabezado(titulo: 'Arma tu Pizza', paso: 'Pedido'),

              const SizedBox(height: 18),

              const BarraProgreso(pasoActual: 6),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF351A0B),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF6B3A0A)),
                      ),
                      child: Column(
                        children: [
                          FilaResumen(
                            titulo: 'Tamaño',
                            valor:
                                '${widget.tamano} (${widget.precioTamano.toStringAsFixed(2)})',
                            precio: widget.precioTamano,
                          ),

                          FilaResumen(
                            titulo: 'Masa',
                            valor: widget.masa,
                            precio: widget.precioMasa,
                          ),

                          FilaResumen(
                            titulo: 'Salsa',
                            valor: widget.salsa,
                            emoji: '🍅',
                          ),

                          FilaResumen(
                            titulo: 'Queso',
                            valor: widget.queso,
                            emoji: '🧀',
                          ),

                          const Divider(color: Color(0xFF6B3A0A), height: 28),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Ingredientes',
                              style: const TextStyle(
                                color: Color(0xFFC48A5A),
                                fontSize: 14,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          if (widget.toppings.isEmpty)
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Sin ingredientes extra',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else
                            ...widget.toppings.map((topping) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Text(
                                      topping['icono'],
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        topping['nombre'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '+\$${topping['precio'].toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Color(0xFFFFA51E),
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),

                          const Divider(color: Color(0xFF6B3A0A), height: 28),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                '\$${total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color(0xFFFFA51E),
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFF351A0B),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF6B3A0A)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '¿Cómo quieres recibirla?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: BotonEntrega(
                                  texto: 'Delivery',
                                  icono: Icons.delivery_dining_outlined,
                                  seleccionado: tipoEntrega == 'Delivery',
                                  onTap: () {
                                    setState(() {
                                      tipoEntrega = 'Delivery';
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: BotonEntrega(
                                  texto: 'Recoger',
                                  icono: Icons.storefront_outlined,
                                  seleccionado: tipoEntrega == 'Recoger',
                                  onTap: () {
                                    setState(() {
                                      tipoEntrega = 'Recoger';
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  BotonAtras(
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: SizedBox(
                      height: 58,
                      child: ElevatedButton(
                        onPressed: () {
                          final items = [
                            Pizza(
                              id: 'custom-${DateTime.now().millisecondsSinceEpoch}',
                              name: 'Pizza personalizada',
                              description:
                                  '${widget.tamano} · ${widget.masa} · ${widget.salsa} · ${widget.queso}',
                              basePrice: total,
                              size: widget.tamano,
                              crust: widget.masa,
                              toppings: widget.toppings
                                  .map(
                                    (topping) => Topping(
                                      name: topping['nombre'] as String,
                                      price: (topping['precio'] as num)
                                          .toDouble(),
                                      description: topping['icono'] as String?,
                                    ),
                                  )
                                  .toList(),
                              isCustom: true,
                            ),
                          ];
                          final subtotal = items.first.totalPrice;
                          final tax = subtotal * AppConstants.taxRate;
                          final shipping = AppConstants.baseShippingCost;

                          context.push(
                            '/payment',
                            extra: PaymentArguments(
                              orderId:
                                  'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                              items: items,
                              subtotal: subtotal,
                              tax: tax,
                              shippingCost: shipping,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF63220),
                          foregroundColor: Colors.white,
                          elevation: 8,
                          shadowColor: const Color(0xFFF63220),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          '🔥 Pedir Ahora · \$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilaResumen extends StatelessWidget {
  final String titulo;
  final String valor;
  final double? precio;
  final String? emoji;

  const FilaResumen({
    super.key,
    required this.titulo,
    required this.valor,
    this.precio,
    this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              titulo,
              style: const TextStyle(color: Color(0xFFC48A5A), fontSize: 14),
            ),
          ),

          Expanded(
            child: Text(
              emoji == null ? valor : '$emoji  $valor',
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          if (precio != null && precio! > 0) ...[
            const SizedBox(width: 8),
            Text(
              '+\$${precio!.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFFFFA51E),
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class BotonEntrega extends StatelessWidget {
  final String texto;
  final IconData icono;
  final bool seleccionado;
  final VoidCallback onTap;

  const BotonEntrega({
    super.key,
    required this.texto,
    required this.icono,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: seleccionado
              ? const Color(0xFF4A250C)
              : const Color(0xFF351A0B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: seleccionado
                ? const Color(0xFFFFA51E)
                : const Color(0xFF6B3A0A),
            width: seleccionado ? 2 : 1.2,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icono,
                color: seleccionado
                    ? const Color(0xFFFFA51E)
                    : const Color(0xFFC48A5A),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                texto,
                style: TextStyle(
                  color: seleccionado
                      ? const Color(0xFFFFA51E)
                      : const Color(0xFFC48A5A),
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
