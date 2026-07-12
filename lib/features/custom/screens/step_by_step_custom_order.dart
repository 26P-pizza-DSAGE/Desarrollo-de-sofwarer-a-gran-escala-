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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF241006),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Encabezado(
                titulo: 'Arma tu Pizza',
                paso: 'Tamaño',
              ),
              SizedBox(height: 18),
              BarraProgreso(pasoActual: 1),
              SizedBox(height: 40),
              Center(
                child: PizzaPreview(),
              ),
              SizedBox(height: 30),
              Center(
                child: Text(
                  'Aquí irá la selección de tamaño',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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