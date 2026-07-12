import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const PizzaBuilderApp());
}

class PizzaBuilderApp extends StatelessWidget {
  const PizzaBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pizza Builder',
      theme: ThemeData(
        fontFamily: 'DM Sans',
        scaffoldBackgroundColor: const Color(0xFFFBF3E4), // var(--masa)
      ),
      home: const DeliveryTrackingScreen(),
    );
  }
}

class DeliveryTrackingScreen extends StatefulWidget {
  const DeliveryTrackingScreen({super.key});

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> with SingleTickerProviderStateMixin {
  // Paleta de colores basada en el CSS original
  static const Color colorMasa = Color(0xFFFBF3E4);
  static const Color colorMasaDark = Color(0xFFEBDCC0);
  static const Color colorTomate = Color(0xFFD6472A);
  static const Color colorTomateDark = Color(0xFFB5381F);
  static const Color colorAlbahaca = Color(0xFF4B7A51);
  static const Color colorQueso = Color(0xFFF2A93B);
  static const Color colorCarbon = Color(0xFF2B2118);
  static const Color colorCarbonSoft = Color(0xFF5B4D40);

  // Duración total de la simulación de entrega, en segundos.
  static const int _totalSeconds = 26;

  int _remainingSeconds = _totalSeconds;
  Timer? _timer;
  bool _isDelivered = false;
  int _rating = 0;

  // Control de la animación del repartidor en el mapa simulado
  late AnimationController _mapAnimationController;

  @override
  void initState() {
    super.initState();
    _mapAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _totalSeconds),
    )..forward();

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_remainingSeconds <= 1) {
        timer.cancel();
        _markAsDelivered();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  void _markAsDelivered() {
    if (!mounted) return;
    setState(() {
      _isDelivered = true;
      _remainingSeconds = 0;
      _mapAnimationController.stop();
    });
  }

  void _simulateDeliveryNow() {
    _timer?.cancel();
    _markAsDelivered();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mapAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: colorCarbon.withOpacity(0.06)),
              boxShadow: [
                BoxShadow(
                  color: colorCarbon.withOpacity(0.12),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ---------- Top bar ----------
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: colorMasa,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            splashRadius: 18,
                            icon: const Icon(Icons.arrow_back, color: colorCarbon, size: 18),
                            tooltip: 'Volver',
                            onPressed: () => Navigator.maybePop(context),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          '🍕 Pizza Builder',
                          style: TextStyle(
                            fontFamily: 'Baloo 2',
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: colorTomate,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorMasa,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '#PB-4821',
                            style: TextStyle(
                              fontFamily: 'DM Mono',
                              fontSize: 11,
                              color: colorCarbonSoft,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ---------- Hero status ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: _isDelivered ? colorAlbahaca : colorTomate,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _isDelivered ? 'COMPLETADO' : 'EN VIVO',
                              style: const TextStyle(
                                fontFamily: 'DM Mono',
                                fontSize: 11,
                                letterSpacing: 1.5,
                                color: colorAlbahaca,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isDelivered ? '¡Pizza entregada!' : 'Tu pizza va en camino',
                          style: const TextStyle(
                            fontFamily: 'Baloo 2',
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: colorCarbon,
                          ),
                        ),
                        if (!_isDelivered) ...[
                          const SizedBox(height: 6),
                          Row(
                            textBaseline: TextBaseline.alphabetic,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            children: [
                              const Text('Llega en ', style: TextStyle(color: colorCarbonSoft, fontSize: 14)),
                              Text(
                                _formatTime(_remainingSeconds),
                                style: const TextStyle(
                                  fontFamily: 'DM Mono',
                                  fontSize: 20,
                                  color: colorCarbon,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text(' min', style: TextStyle(color: colorCarbonSoft, fontSize: 14)),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  // ---------- Stepper ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        _buildStep('✓', 'Confirmado', isDone: true),
                        _buildStep('✓', 'Preparando', isDone: true),
                        _buildStep(_isDelivered ? '✓' : '🛵', 'En camino', isActive: !_isDelivered, isDone: _isDelivered),
                        _buildStep(_isDelivered ? '✓' : '🏠', 'Entregado', isDone: _isDelivered),
                      ],
                    ),
                  ),

                  // ---------- Condicional: En Camino o Entregado ----------
                  if (!_isDelivered) ...[
                    // Courier card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: colorMasa,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [colorQueso, colorTomate],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Icon(Icons.person, color: Colors.white, size: 28),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rodrigo Márquez',
                                  style: TextStyle(
                                    fontFamily: 'Baloo 2',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: colorCarbon,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text('★★★★★ ', style: TextStyle(color: colorQueso, fontSize: 12)),
                                    Text('4.9 · Moto', style: TextStyle(color: colorCarbonSoft, fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          _buildIconButton('📞'),
                          const SizedBox(width: 8),
                          _buildIconButton('💬'),
                        ],
                      ),
                    ),

                    // Map simulation widget
                    Container(
                      height: 230,
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCE9DC),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: AnimatedBuilder(
                              animation: _mapAnimationController,
                              builder: (context, child) {
                                return CustomPaint(
                                  painter: SimulatedMapPainter(progress: _mapAnimationController.value),
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.92),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(color: colorTomate, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'Rodrigo se está moviendo',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorCarbon),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Delivered panel
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: colorMasa,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: colorAlbahaca,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text('✓', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            '¡Tu pizza fue entregada!',
                            style: TextStyle(fontFamily: 'Baloo 2', fontSize: 19, fontWeight: FontWeight.bold, color: colorCarbon),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Rodrigo la dejó justo a tiempo. Buen provecho 🍕',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: colorCarbonSoft),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              return GestureDetector(
                                onTap: () => setState(() => _rating = index + 1),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Text(
                                    '★',
                                    style: TextStyle(
                                      fontSize: 26,
                                      color: index < _rating ? colorQueso : colorCarbonSoft.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 18),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorTomate,
                              minimumSize: const Size.fromHeight(48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              elevation: 0,
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Volver a pedir',
                              style: TextStyle(fontFamily: 'Baloo 2', fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // Demo control button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: Center(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: colorCarbonSoft, style: BorderStyle.solid),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                        ),
                        onPressed: _simulateDeliveryNow,
                        child: const Text(
                          'Simular entrega ahora (demo)',
                          style: TextStyle(color: colorCarbonSoft, fontSize: 11.5),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper para construir los pasos del Stepper
  Widget _buildStep(String bubbleText, String label, {bool isActive = false, bool isDone = false}) {
    Color bubbleColor = colorMasa;
    Color borderColor = colorMasaDark;
    Color textColor = colorCarbonSoft;
    FontWeight weight = FontWeight.w500;

    if (isDone) {
      bubbleColor = colorAlbahaca;
      borderColor = colorAlbahaca;
      textColor = colorCarbon;
      weight = FontWeight.bold;
    } else if (isActive) {
      bubbleColor = colorTomate;
      borderColor = colorTomate;
      textColor = colorCarbon;
      weight = FontWeight.bold;
    }

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: bubbleColor,
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 2),
            ),
            child: Center(
              child: Text(
                bubbleText,
                style: TextStyle(color: isDone || isActive ? Colors.white : colorCarbon, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(fontSize: 10.5, color: textColor, fontWeight: weight),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Helper para botones redondos pequeños
  Widget _buildIconButton(String emoji) {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Color(0x142B2118), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Center(
        child: Text(emoji, style: const TextStyle(fontSize: 15)),
      ),
    );
  }
}

// Dibujo personalizado del mapa idéntico al SVG del HTML original
class SimulatedMapPainter extends CustomPainter {
  final double progress;
  SimulatedMapPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Normalizar escala según el viewBox original 400x240
    double scaleX = size.width / 400;
    double scaleY = size.height / 240;

    // 1. Manzanas / bloques
    final blockPaint = Paint()..color = const Color(0xFFC9DEC8);
    final blocks = [
      RRect.fromRectAndRadius(Rect.fromLTWH(15 * scaleX, 15 * scaleY, 60 * scaleX, 45 * scaleY), const Radius.circular(6)),
      RRect.fromRectAndRadius(Rect.fromLTWH(120 * scaleX, 20 * scaleY, 45 * scaleX, 35 * scaleY), const Radius.circular(6)),
      RRect.fromRectAndRadius(Rect.fromLTWH(250 * scaleX, 10 * scaleY, 55 * scaleX, 50 * scaleY), const Radius.circular(6)),
      RRect.fromRectAndRadius(Rect.fromLTWH(20 * scaleX, 170 * scaleY, 55 * scaleX, 45 * scaleY), const Radius.circular(6)),
      RRect.fromRectAndRadius(Rect.fromLTWH(150 * scaleX, 185 * scaleY, 45 * scaleX, 40 * scaleY), const Radius.circular(6)),
      RRect.fromRectAndRadius(Rect.fromLTWH(300 * scaleX, 150 * scaleY, 60 * scaleX, 55 * scaleY), const Radius.circular(6)),
      RRect.fromRectAndRadius(Rect.fromLTWH(330 * scaleX, 30 * scaleY, 45 * scaleX, 40 * scaleY), const Radius.circular(6)),
    ];
    for (var block in blocks) {
      canvas.drawRRect(block, blockPaint);
    }

    // 2. Calles
    final streetPaint = Paint()
      ..color = const Color(0xFFF3F0E4)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(40 * scaleX, 90 * scaleY), Offset(40 * scaleX, 220 * scaleY), streetPaint);
    canvas.drawLine(Offset(0, 90 * scaleY), Offset(400 * scaleX, 90 * scaleY), streetPaint);
    canvas.drawLine(Offset(200 * scaleX, 0), Offset(200 * scaleX, 240 * scaleY), streetPaint);
    canvas.drawLine(Offset(0, 150 * scaleY), Offset(400 * scaleX, 150 * scaleY), streetPaint);

    // 3. Ruta punteada original
    final Path routePath = Path()
      ..moveTo(55 * scaleX, 45 * scaleY)
      ..lineTo(55 * scaleX, 90 * scaleY)
      ..lineTo(200 * scaleX, 90 * scaleY)
      ..lineTo(200 * scaleX, 150 * scaleY)
      ..lineTo(345 * scaleX, 150 * scaleY)
      ..lineTo(345 * scaleX, 190 * scaleY);

    final routePaint = Paint()
      ..color = const Color(0xFFD6472A)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Simular el trazado de línea discontinua (dasharray)
    canvas.drawPath(routePath, routePaint);

    // 4. Pines fijos (Pizzería y Casa)
    final pizzaPaint = Paint()..color = const Color(0xFFD6472A);
    canvas.drawCircle(Offset(45 * scaleX, 35 * scaleY), 13, pizzaPaint);
    _drawEmojiText(canvas, '🍕', Offset(45 * scaleX, 35 * scaleY), 14);

    final housePaint = Paint()..color = const Color(0xFF4B7A51);
    canvas.drawCircle(Offset(345 * scaleX, 190 * scaleY), 13, housePaint);
    _drawEmojiText(canvas, '🏠', Offset(345 * scaleX, 190 * scaleY), 13);

    // 5. Calcular posición del repartidor en la ruta basándose en el "progress" de la animación
    List<Offset> points = [
      Offset(55 * scaleX, 45 * scaleY),
      Offset(55 * scaleX, 90 * scaleY),
      Offset(200 * scaleX, 90 * scaleY),
      Offset(200 * scaleX, 150 * scaleY),
      Offset(345 * scaleX, 150 * scaleY),
      Offset(345 * scaleX, 190 * scaleY),
    ];
    Offset courierPos = _getPointOnPath(points, progress);

    final courierBgPaint = Paint()..color = const Color(0xFF2B2118);
    canvas.drawCircle(courierPos, 12, courierBgPaint);
    _drawEmojiText(canvas, '🛵', courierPos, 13);
  }

  void _drawEmojiText(Canvas canvas, String text, Offset position, double fontSize) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(fontSize: fontSize)),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, position - Offset(textPainter.width / 2, textPainter.height / 2));
  }

  // Interpola los puntos de la calle para que el repartidor se mueva fluidamente
  Offset _getPointOnPath(List<Offset> points, double t) {
    if (points.isEmpty) return Offset.zero;
    if (t <= 0) return points.first;
    if (t >= 1) return points.last;

    List<double> segmentLengths = [];
    double totalLength = 0;
    for (int i = 0; i < points.length - 1; i++) {
      double len = (points[i + 1] - points[i]).distance;
      segmentLengths.add(len);
      totalLength += len;
    }

    double targetDistance = t * totalLength;
    double currentDistance = 0;

    for (int i = 0; i < segmentLengths.length; i++) {
      if (currentDistance + segmentLengths[i] >= targetDistance) {
        double segmentT = (targetDistance - currentDistance) / segmentLengths[i];
        return Offset.lerp(points[i], points[i + 1], segmentT)!;
      }
      currentDistance += segmentLengths[i];
    }
    return points.last;
  }

  @override
  bool shouldRepaint(covariant SimulatedMapPainter oldDelegate) => oldDelegate.progress != progress;
}