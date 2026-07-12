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
class MasaScreen extends StatelessWidget {
  final String tamano;
  final double precioTamano;

  const MasaScreen({
    super.key,
    required this.tamano,
    required this.precioTamano,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF241006),
      body: SafeArea(
        child: Center(
          child: Text(
            'Masa para $tamano - \$${precioTamano.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
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
class QuesoScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF241006),
      body: SafeArea(
        child: Center(
          child: Text(
            'Queso para $tamano con salsa $salsa',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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