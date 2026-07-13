import 'package:flutter/material.dart';

class StepByStepCustomOrderScreen extends StatelessWidget {
  const StepByStepCustomOrderScreen({super.key});

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
    {
      'nombre': 'Personal',
      'descripcion': '20 cm · 1-2 pax',
      'precio': 8.90,
    },
    {
      'nombre': 'Mediana',
      'descripcion': '28 cm · 2-3 pax',
      'precio': 12.90,
    },
    {
      'nombre': 'Grande',
      'descripcion': '33 cm · 3-4 pax',
      'precio': 16.90,
    },
    {
      'nombre': 'Familiar',
      'descripcion': '40 cm · 4-6 pax',
      'precio': 21.90,
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
              const Encabezado(
                titulo: 'Arma tu Pizza',
                paso: 'Tamaño',
              ),

              const SizedBox(height: 18),

              const BarraProgreso(pasoActual: 1),

              const SizedBox(height: 35),

              const Center(
                child: PizzaPreview(),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: ListView.builder(
                  itemCount: tamanos.length,
                  itemBuilder: (context, index) {
                    final item = tamanos[index];
                    final seleccionado =
                        item['nombre'] == tamanoSeleccionado;

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

  const Encabezado({
    super.key,
    required this.titulo,
    required this.paso,
  });

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
              style: const TextStyle(
                color: Color(0xFFC48A5A),
                fontSize: 14,
              ),
            ),
          ],
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF6B3A0A),
            ),
          ),
          child: const Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class BarraProgreso extends StatelessWidget {
  final int pasoActual;

  const BarraProgreso({
    super.key,
    required this.pasoActual,
  });

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
              color: activo
                  ? const Color(0xFFFFA51E)
                  : const Color(0xFF4A250C),
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
            border: Border.all(
              color: const Color(0xFFD64332),
              width: 10,
            ),
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
            const Text(
              '🍕',
              style: TextStyle(fontSize: 34),
            ),

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
              const Icon(
                Icons.check,
                color: Color(0xFFFFA51E),
              ),
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

  const BotonContinuar({
    super.key,
    required this.texto,
    required this.onTap,
  });

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
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
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
    {
      'nombre': 'Delgada',
      'descripcion': 'Crujiente y ligera',
      'precio': 0.0,
    },
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
              const Encabezado(
                titulo: 'Arma tu Pizza',
                paso: 'Masa',
              ),

              const SizedBox(height: 18),

              const BarraProgreso(pasoActual: 2),

              const SizedBox(height: 35),

              const Center(
                child: PizzaPreview(),
              ),

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

  const BotonAtras({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Color(0xFF6B3A0A),
            width: 1.5,
          ),
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
  String salsaSeleccionada = 'Tomate clásico';
  double precioSalsa = 0;

  final List<Map<String, dynamic>> salsas = [
    {
      'nombre': 'Tomate clásico',
      'descripcion': 'Salsa tradicional',
      'precio': 0.0,
      'icono': '🍅',
    },
    {
      'nombre': 'BBQ',
      'descripcion': 'Dulce y ahumada',
      'precio': 0.50,
      'icono': '🔥',
    },
    {
      'nombre': 'Alfredo',
      'descripcion': 'Cremosa y suave',
      'precio': 0.75,
      'icono': '🥛',
    },
    {
      'nombre': 'Picante',
      'descripcion': 'Con toque de chile',
      'precio': 0.50,
      'icono': '🌶️',
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
              const Encabezado(
                titulo: 'Arma tu Pizza',
                paso: 'Salsa',
              ),

              const SizedBox(height: 18),

              const BarraProgreso(pasoActual: 3),

              const SizedBox(height: 35),

              const Center(
                child: PizzaPreview(),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: GridView.builder(
                  itemCount: salsas.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    final item = salsas[index];
                    final seleccionado =
                        item['nombre'] == salsaSeleccionada;

                    return TarjetaOpcionCuadro(
                      icono: item['icono'],
                      nombre: item['nombre'],
                      descripcion: item['descripcion'],
                      precio: item['precio'],
                      seleccionado: seleccionado,
                      onTap: () {
                        setState(() {
                          salsaSeleccionada = item['nombre'];
                          precioSalsa = item['precio'];
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
                              precioSalsa: precioSalsa,
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
  final double precioSalsa;

  const QuesoScreen({
    super.key,
    required this.tamano,
    required this.precioTamano,
    required this.masa,
    required this.precioMasa,
    required this.salsa,
    required this.precioSalsa,
  });

  @override
  State<QuesoScreen> createState() => _QuesoScreenState();
}

class _QuesoScreenState extends State<QuesoScreen> {
  String quesoSeleccionado = 'Mozzarella';
  double precioQueso = 0;

  final List<Map<String, dynamic>> quesos = [
    {
      'nombre': 'Mozzarella',
      'descripcion': 'Clásico y fundido',
      'precio': 0.0,
      'icono': '🧀',
    },
    {
      'nombre': 'Cheddar',
      'descripcion': 'Sabor fuerte',
      'precio': 0.75,
      'icono': '🧀',
    },
    {
      'nombre': 'Parmesano',
      'descripcion': 'Toque italiano',
      'precio': 1.00,
      'icono': '🧀',
    },
    {
      'nombre': 'Extra queso',
      'descripcion': 'Más cremoso',
      'precio': 1.50,
      'icono': '🧀',
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
              const Encabezado(
                titulo: 'Arma tu Pizza',
                paso: 'Queso',
              ),

              const SizedBox(height: 18),

              const BarraProgreso(pasoActual: 4),

              const SizedBox(height: 35),

              const Center(
                child: PizzaPreview(),
              ),

              const SizedBox(height: 30),

              Expanded(
                child: GridView.builder(
                  itemCount: quesos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    final item = quesos[index];
                    final seleccionado =
                        item['nombre'] == quesoSeleccionado;

                    return TarjetaOpcionCuadro(
                      icono: item['icono'],
                      nombre: item['nombre'],
                      descripcion: item['descripcion'],
                      precio: item['precio'],
                      seleccionado: seleccionado,
                      onTap: () {
                        setState(() {
                          quesoSeleccionado = item['nombre'];
                          precioQueso = item['precio'];
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
                              precioSalsa: widget.precioSalsa,
                              queso: quesoSeleccionado,
                              precioQueso: precioQueso,
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
  final double precioSalsa;
  final String queso;
  final double precioQueso;

  const ToppingsScreen({
    super.key,
    required this.tamano,
    required this.precioTamano,
    required this.masa,
    required this.precioMasa,
    required this.salsa,
    required this.precioSalsa,
    required this.queso,
    required this.precioQueso,
  });

  @override
  State<ToppingsScreen> createState() => _ToppingsScreenState();
}

class _ToppingsScreenState extends State<ToppingsScreen> {
  final List<String> toppingsSeleccionados = [];

  final List<Map<String, dynamic>> toppings = [
    {
      'nombre': 'Pepperoni',
      'descripcion': 'Clásico y crujiente',
      'precio': 1.50,
      'icono': '🍕',
    },
    {
      'nombre': 'Champiñones',
      'descripcion': 'Frescos y suaves',
      'precio': 1.00,
      'icono': '🍄',
    },
    {
      'nombre': 'Jamón',
      'descripcion': 'Sabor tradicional',
      'precio': 1.25,
      'icono': '🥓',
    },
    {
      'nombre': 'Piña',
      'descripcion': 'Dulce y tropical',
      'precio': 1.00,
      'icono': '🍍',
    },
    {
      'nombre': 'Aceitunas',
      'descripcion': 'Toque mediterráneo',
      'precio': 0.75,
      'icono': '🫒',
    },
    {
      'nombre': 'Cebolla',
      'descripcion': 'Crujiente y aromática',
      'precio': 0.75,
      'icono': '🧅',
    },
  ];

  double get precioToppings {
    double total = 0;

    for (final topping in toppings) {
      if (toppingsSeleccionados.contains(topping['nombre'])) {
        total += topping['precio'];
      }
    }

    return total;
  }

  void cambiarSeleccion(String nombre) {
    setState(() {
      if (toppingsSeleccionados.contains(nombre)) {
        toppingsSeleccionados.remove(nombre);
      } else {
        toppingsSeleccionados.add(nombre);
      }
    });
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
              const Encabezado(
                titulo: 'Arma tu Pizza',
                paso: 'Ingredientes',
              ),

              const SizedBox(height: 18),

              const BarraProgreso(pasoActual: 5),

              const SizedBox(height: 25),

              const Center(
                child: PizzaPreview(),
              ),

              const SizedBox(height: 20),

              const Text(
                'Selecciona tus toppings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                '${toppingsSeleccionados.length} seleccionados · +\$${precioToppings.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Color(0xFFC48A5A),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: toppings.length,
                  itemBuilder: (context, index) {
                    final item = toppings[index];
                    final seleccionado =
                        toppingsSeleccionados.contains(item['nombre']);

                    return TarjetaTopping(
                      icono: item['icono'],
                      nombre: item['nombre'],
                      descripcion: item['descripcion'],
                      precio: item['precio'],
                      seleccionado: seleccionado,
                      onTap: () {
                        cambiarSeleccion(item['nombre']);
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
                            builder: (context) => PedidoScreen(
                              tamano: widget.tamano,
                              precioTamano: widget.precioTamano,
                              masa: widget.masa,
                              precioMasa: widget.precioMasa,
                              salsa: widget.salsa,
                              precioSalsa: widget.precioSalsa,
                              queso: widget.queso,
                              precioQueso: widget.precioQueso,
                              toppings: toppingsSeleccionados,
                              precioToppings: precioToppings,
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
  final String descripcion;
  final double precio;
  final bool seleccionado;
  final VoidCallback onTap;

  const TarjetaTopping({
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
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
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
            Text(
              icono,
              style: const TextStyle(fontSize: 32),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombre,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    descripcion,
                    style: const TextStyle(
                      color: Color(0xFFC48A5A),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              '+\$${precio.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFFFFA51E),
                fontSize: 15,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(width: 12),

            Icon(
              seleccionado
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: seleccionado
                  ? const Color(0xFFFFA51E)
                  : const Color(0xFFC48A5A),
            ),
          ],
        ),
      ),
    );
  }
}
class PedidoScreen extends StatelessWidget {
  final String tamano;
  final double precioTamano;
  final String masa;
  final double precioMasa;
  final String salsa;
  final double precioSalsa;
  final String queso;
  final double precioQueso;
  final List<String> toppings;
  final double precioToppings;

  const PedidoScreen({
    super.key,
    required this.tamano,
    required this.precioTamano,
    required this.masa,
    required this.precioMasa,
    required this.salsa,
    required this.precioSalsa,
    required this.queso,
    required this.precioQueso,
    required this.toppings,
    required this.precioToppings,
  });

  @override
  Widget build(BuildContext context) {
    final total = precioTamano +
        precioMasa +
        precioSalsa +
        precioQueso +
        precioToppings;

    return Scaffold(
      backgroundColor: const Color(0xFF241006),
      body: SafeArea(
        child: Center(
          child: Text(
            'Resumen · Total: \$${total.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}