
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
        scaffoldBackgroundColor: const Color(0xFF241006),
        useMaterial3: true,
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

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen>
    with SingleTickerProviderStateMixin {
  static const Color colorFondo = Color(0xFF241006);
  static const Color colorTarjeta = Color(0xFF351A0B);
  static const Color colorBorde = Color(0xFF6B3A0A);
  static const Color colorNaranja = Color(0xFFFFA51E);
  static const Color colorNaranjaFuerte = Color(0xFFFF941C);
  static const Color colorTextoSecundario = Color(0xFFC48A5A);
  static const Color colorRojo = Color(0xFFF63220);
  static const Color colorVerde = Color(0xFF4B7A51);

  int _remainingSeconds = 26;
  Timer? _timer;
  bool _isDelivered = false;
  int _rating = 0;

  late AnimationController _mapAnimationController;

  @override
  void initState() {
    super.initState();

    _mapAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 26),
    )..forward();

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _markAsDelivered();
        }
      });
    });
  }

  void _markAsDelivered() {
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
      backgroundColor: colorFondo,
      body: SafeArea(
        child: Center(
          child: Container(
            maxWidth: 420,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: colorTarjeta,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: colorBorde,
                width: 1.3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTopBar(),
                  _buildHeroStatus(),
                  _buildStepper(),

                  if (!_isDelivered) ...[
                    _buildCourierCard(),
                    _buildMapCard(),
                  ] else ...[
                    _buildDeliveredPanel(),
                  ],

                  _buildDemoButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorBorde,
                width: 1.3,
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 17,
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
          ),
          const Spacer(),
          const Text(
            '🍕 Pizza Builder',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 17,
              color: colorNaranja,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: colorFondo,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorBorde,
              ),
            ),
            child: const Text(
              '#PB-4821',
              style: TextStyle(
                fontSize: 11,
                color: colorTextoSecundario,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _isDelivered ? colorVerde : colorRojo,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                _isDelivered ? 'COMPLETADO' : 'EN VIVO',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 1.5,
                  color: _isDelivered ? colorVerde : colorNaranja,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _isDelivered ? '¡Pizza entregada!' : 'Tu pizza va en camino',
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 26,
              color: Colors.white,
            ),
          ),
          if (!_isDelivered) ...[
            const SizedBox(height: 8),
            Row(
              baseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                const Text(
                  'Llega en ',
                  style: TextStyle(
                    color: colorTextoSecundario,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _formatTime(_remainingSeconds),
                  style: const TextStyle(
                    fontSize: 22,
                    color: colorNaranja,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  ' min',
                  style: TextStyle(
                    color: colorTextoSecundario,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Row(
        children: [
          _buildStep('✓', 'Confirmado', isDone: true),
          _buildStep('✓', 'Preparando', isDone: true),
          _buildStep(
            _isDelivered ? '✓' : '🛵',
            'En camino',
            isActive: !_isDelivered,
            isDone: _isDelivered,
          ),
          _buildStep(
            _isDelivered ? '✓' : '🏠',
            'Entregado',
            isDone: _isDelivered,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    String bubbleText,
    String label, {
    bool isActive = false,
    bool isDone = false,
  }) {
    Color bubbleColor = colorFondo;
    Color borderColor = colorBorde;
    Color textColor = colorTextoSecundario;

    if (isDone) {
      bubbleColor = colorVerde;
      borderColor = colorVerde;
      textColor = Colors.white;
    } else if (isActive) {
      bubbleColor = colorNaranjaFuerte;
      borderColor = colorNaranja;
      textColor = Colors.white;
    }

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: bubbleColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: borderColor,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                bubbleText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCourierCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorBorde,
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  colorNaranja,
                  colorRojo,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.delivery_dining,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rodrigo Márquez',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '★★★★★ ',
                      style: TextStyle(
                        color: colorNaranja,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '4.9 · Moto',
                      style: TextStyle(
                        color: colorTextoSecundario,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildIconButton(Icons.call),
          const SizedBox(width: 8),
          _buildIconButton(Icons.chat_bubble_outline),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: colorTarjeta,
        shape: BoxShape.circle,
        border: Border.all(
          color: colorBorde,
          width: 1.2,
        ),
      ),
      child: Icon(
        icon,
        color: colorNaranja,
        size: 18,
      ),
    );
  }

  Widget _buildMapCard() {
    return Container(
      height: 230,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2E1A0B),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorBorde,
          width: 1.3,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _mapAnimationController,
              builder: (context, child) {
                return CustomPaint(
                  painter: SimulatedMapPainter(
                    progress: _mapAnimationController.value,
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                color: colorTarjeta.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorBorde,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: colorRojo,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Rodrigo se está moviendo',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveredPanel() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorFondo,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorBorde,
          width: 1.3,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: const BoxDecoration(
              color: colorVerde,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            '¡Tu pizza fue entregada!',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Rodrigo la dejó justo a tiempo. Buen provecho 🍕',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: colorTextoSecundario,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '★',
                    style: TextStyle(
                      fontSize: 28,
                      color: index < _rating
                          ? colorNaranja
                          : colorTextoSecundario.withOpacity(0.35),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorNaranjaFuerte,
              foregroundColor: Colors.black,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              shadowColor: colorNaranjaFuerte,
            ),
            onPressed: () {},
            child: const Text(
              'Volver a pedir',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22, top: 4),
      child: Center(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(
              color: colorBorde,
              width: 1.3,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          onPressed: _simulateDeliveryNow,
          child: const Text(
            'Simular entrega ahora (demo)',
            style: TextStyle(
              color: colorTextoSecundario,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class SimulatedMapPainter extends CustomPainter {
  final double progress;

  SimulatedMapPainter({
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 400;
    final scaleY = size.height / 240;

    final blockPaint = Paint()..color = const Color(0xFF4A250C);

    final blocks = [
      RRect.fromRectAndRadius(
        Rect.fromLTWH(15 * scaleX, 15 * scaleY, 60 * scaleX, 45 * scaleY),
        const Radius.circular(6),
      ),
      RRect.fromRectAndRadius(
        Rect.fromLTWH(120 * scaleX, 20 * scaleY, 45 * scaleX, 35 * scaleY),
        const Radius.circular(6),
      ),
      RRect.fromRectAndRadius(
        Rect.fromLTWH(250 * scaleX, 10 * scaleY, 55 * scaleX, 50 * scaleY),
        const Radius.circular(6),
      ),
      RRect.fromRectAndRadius(
        Rect.fromLTWH(20 * scaleX, 170 * scaleY, 55 * scaleX, 45 * scaleY),
        const Radius.circular(6),
      ),
      RRect.fromRectAndRadius(
        Rect.fromLTWH(150 * scaleX, 185 * scaleY, 45 * scaleX, 40 * scaleY),
        const Radius.circular(6),
      ),
      RRect.fromRectAndRadius(
        Rect.fromLTWH(300 * scaleX, 150 * scaleY, 60 * scaleX, 55 * scaleY),
        const Radius.circular(6),
      ),
      RRect.fromRectAndRadius(
        Rect.fromLTWH(330 * scaleX, 30 * scaleY, 45 * scaleX, 40 * scaleY),
        const Radius.circular(6),
      ),
    ];

    for (final block in blocks) {
      canvas.drawRRect(block, blockPaint);
    }

    final streetPaint = Paint()
      ..color = const Color(0xFF6B3A0A)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(40 * scaleX, 90 * scaleY),
      Offset(40 * scaleX, 220 * scaleY),
      streetPaint,
    );

    canvas.drawLine(
      Offset(0, 90 * scaleY),
      Offset(400 * scaleX, 90 * scaleY),
      streetPaint,
    );

    canvas.drawLine(
      Offset(200 * scaleX, 0),
      Offset(200 * scaleX, 240 * scaleY),
      streetPaint,
    );

    canvas.drawLine(
      Offset(0, 150 * scaleY),
      Offset(400 * scaleX, 150 * scaleY),
      streetPaint,
    );

    final routePath = Path()
      ..moveTo(55 * scaleX, 45 * scaleY)
      ..lineTo(55 * scaleX, 90 * scaleY)
      ..lineTo(200 * scaleX, 90 * scaleY)
      ..lineTo(200 * scaleX, 150 * scaleY)
      ..lineTo(345 * scaleX, 150 * scaleY)
      ..lineTo(345 * scaleX, 190 * scaleY);

    final routePaint = Paint()
      ..color = const Color(0xFFFFA51E)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(routePath, routePaint);

    final pizzaPaint = Paint()..color = const Color(0xFFF63220);
    canvas.drawCircle(
      Offset(45 * scaleX, 35 * scaleY),
      13,
      pizzaPaint,
    );
    _drawEmojiText(
      canvas,
      '🍕',
      Offset(45 * scaleX, 35 * scaleY),
      14,
    );

    final housePaint = Paint()..color = const Color(0xFF4B7A51);
    canvas.drawCircle(
      Offset(345 * scaleX, 190 * scaleY),
      13,
      housePaint,
    );
    _drawEmojiText(
      canvas,
      '🏠',
      Offset(345 * scaleX, 190 * scaleY),
      13,
    );

    final points = [
      Offset(55 * scaleX, 45 * scaleY),
      Offset(55 * scaleX, 90 * scaleY),
      Offset(200 * scaleX, 90 * scaleY),
      Offset(200 * scaleX, 150 * scaleY),
      Offset(345 * scaleX, 150 * scaleY),
      Offset(345 * scaleX, 190 * scaleY),
    ];

    final courierPos = _getPointOnPath(points, progress);

    final courierBgPaint = Paint()..color = const Color(0xFF241006);
    canvas.drawCircle(courierPos, 13, courierBgPaint);

    _drawEmojiText(
      canvas,
      '🛵',
      courierPos,
      14,
    );
  }

  void _drawEmojiText(
    Canvas canvas,
    String text,
    Offset position,
    double fontSize,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      position - Offset(textPainter.width / 2, textPainter.height / 2),
    );
  }

  Offset _getPointOnPath(List<Offset> points, double t) {
    if (points.isEmpty) return Offset.zero;
    if (t <= 0) return points.first;
    if (t >= 1) return points.last;

    final segmentLengths = <double>[];
    double totalLength = 0;

    for (int i = 0; i < points.length - 1; i++) {
      final len = (points[i + 1] - points[i]).distance;
      segmentLengths.add(len);
      totalLength += len;
    }

    final targetDistance = t * totalLength;
    double currentDistance = 0;

    for (int i = 0; i < segmentLengths.length; i++) {
      if (currentDistance + segmentLengths[i] >= targetDistance) {
        final segmentT =
            (targetDistance - currentDistance) / segmentLengths[i];

        return Offset.lerp(
          points[i],
          points[i + 1],
          segmentT,
        )!;
      }

      currentDistance += segmentLengths[i];
    }

    return points.last;
  }

  @override
  bool shouldRepaint(covariant SimulatedMapPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
