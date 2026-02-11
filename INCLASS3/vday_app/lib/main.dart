import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(const ValentineApp());

class ValentineApp extends StatelessWidget {
  const ValentineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Selecting a nicer font since i feel like the one Professor Henry gave was chopped
        fontFamily: 'SF Pro Display',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF2D55)),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      home: const ValentineHome(),
    );
  }
}

class ValentineHome extends StatefulWidget {
  const ValentineHome({super.key});

  @override
  State<ValentineHome> createState() => _ValentineHomeState();
}

class _ValentineHomeState extends State<ValentineHome>
    with SingleTickerProviderStateMixin {
  final List<String> emojiOptions = const ['Sweet Heart', 'Party Heart'];
  String selectedEmoji = 'Sweet Heart';

  // Stamps
  final List<Offset> stamps = [];

  // Pulsing
  double pulseAmount = 0.06;

  late final AnimationController _controller;

  // Balloons for the party hat
  final List<_Balloon> balloons = [];
  final Random rng = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addStamp(Offset localPosition) {
    setState(() => stamps.add(localPosition));
  }

  void _clearCanvas() => setState(() => stamps.clear());

  void _dropBalloons() {
    final now = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      for (int i = 0; i < 14; i++) {
        balloons.add(
          _Balloon(
            id: '${now}_$i',
            x: rng.nextDouble(),
            size: 34 + rng.nextDouble() * 30,
            speed: 0.6 + rng.nextDouble() * 0.9,
            wobble: rng.nextDouble() * 2 - 1,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cupid's Canvas"),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Balloon Celebration',
            onPressed: _dropBalloons,
            icon: const Icon(Icons.celebration),
          ),
          IconButton(
            tooltip: 'Clear Canvas',
            onPressed: _clearCanvas,
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value; // 0..1
          final pulse = 1.0 + (sin(t * pi) * pulseAmount);

          return Stack(
            children: [
              // Drawing area (fills screen)
              GestureDetector(
                onPanStart: (d) => _addStamp(d.localPosition),
                onPanUpdate: (d) => _addStamp(d.localPosition),
                onTapDown: (d) => _addStamp(d.localPosition),
                child: CustomPaint(
                  size: Size.infinite,
                  painter: CupidCanvasPainter(
                    type: selectedEmoji,
                    stamps: stamps,
                    pulse: pulse,
                    sparkleT: t,
                  ),
                ),
              ),

              // Balloons overlay
              ...balloons.map((b) {
                final fall =
                    (t + (b.speed * (DateTime.now().millisecond / 1000)))
                        .remainder(1.0);
                final y = media.size.height * (1.15 - fall * 1.35);
                final x =
                    media.size.width * b.x +
                    sin((t * 2 * pi) + b.wobble * 3) * 10;

                return Positioned(
                  left: x - b.size / 2,
                  top: y,
                  child: Opacity(
                    opacity: 0.92,
                    child: _BalloonWidget(size: b.size),
                  ),
                );
              }),

              // TOP controls (makes room for drawing below)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: _TopControls(
                    selectedEmoji: selectedEmoji,
                    onSelectEmoji: (v) => setState(() => selectedEmoji = v),
                    pulseAmount: pulseAmount,
                    onPulseChanged: (v) => setState(() => pulseAmount = v),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TopControls extends StatelessWidget {
  const _TopControls({
    required this.selectedEmoji,
    required this.onSelectEmoji,
    required this.pulseAmount,
    required this.onPulseChanged,
  });

  final String selectedEmoji;
  final ValueChanged<String> onSelectEmoji;
  final double pulseAmount;
  final ValueChanged<double> onPulseChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.86),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            blurRadius: 16,
            offset: Offset(0, 8),
            color: Color(0x22000000),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Emoji choice buttons at the TOP (segmented vibe)
          Row(
            children: [
              Expanded(
                child: _ChoiceChipButton(
                  label: 'Sweet Heart',
                  selected: selectedEmoji == 'Sweet Heart',
                  selectedColor: cs.primary.withOpacity(0.14),
                  onTap: () => onSelectEmoji('Sweet Heart'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ChoiceChipButton(
                  label: 'Party Heart',
                  selected: selectedEmoji == 'Party Heart',
                  selectedColor: cs.primary.withOpacity(0.14),
                  onTap: () => onSelectEmoji('Party Heart'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Pulse slider (still top, compact)
          Row(
            children: [
              const Icon(Icons.favorite, size: 18),
              const SizedBox(width: 8),
              Text('Pulse', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(width: 10),
              Expanded(
                child: Slider(
                  value: pulseAmount,
                  min: 0,
                  max: 0.15,
                  onChanged: onPulseChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChoiceChipButton extends StatelessWidget {
  const _ChoiceChipButton({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected ? selectedColor : Colors.white.withOpacity(0.55),
          border: Border.all(
            color: selected
                ? cs.primary.withOpacity(0.35)
                : const Color(0x22000000),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              letterSpacing: -0.2,
              color: const Color(0xFF111111),
            ),
          ),
        ),
      ),
    );
  }
}

class CupidCanvasPainter extends CustomPainter {
  CupidCanvasPainter({
    required this.type,
    required this.stamps,
    required this.pulse,
    required this.sparkleT,
  });

  final String type;
  final List<Offset> stamps;
  final double pulse;
  final double sparkleT;

  final Random _rng = Random(7);

  @override
  void paint(Canvas canvas, Size size) {
    // Background radial gradient
    final bgPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.95,
        colors: const [Color(0xFFFFF3F7), Color(0xFFFFC3D7), Color(0xFFFF6FA7)],
        stops: [0.0, 0.55, 1.0],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, bgPaint);

    // Stamped hearts
    for (final p in stamps) {
      _drawHeartEmoji(
        canvas,
        center: p,
        scale: 0.22,
        type: type,
        sparkleT: sparkleT,
        withSparkles: false,
        withTrail: false,
      );
    }

    // The heart
    final center = Offset(size.width / 2, size.height / 2 - 40);
    _drawHeartEmoji(
      canvas,
      center: center,
      scale: 1.0 * pulse,
      type: type,
      sparkleT: sparkleT,
      withSparkles: true,
      withTrail: true,
    );

    // Hints!
    final hint = TextPainter(
      text: const TextSpan(
        text: 'Tap/drag to draw hearts ✨',
        style: TextStyle(
          color: Color(0xAA000000),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    hint.paint(canvas, Offset(16, size.height - 60));
  }

  void _drawHeartEmoji(
    Canvas canvas, {
    required Offset center,
    required double scale,
    required String type,
    required double sparkleT,
    required bool withSparkles,
    required bool withTrail,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(scale, scale * 1.10);

    final heartPath = Path()
      ..moveTo(0, 60)
      ..cubicTo(110, -10, 60, -120, 0, -40)
      ..cubicTo(-60, -120, -110, -10, 0, 60)
      ..close();

    // Trail
    if (withTrail) {
      final aura = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..color = const Color(0x55FFFFFF);
      canvas.drawPath(heartPath, aura);

      final aura2 = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..color = const Color(0x55FF2D7A);
      canvas.drawPath(heartPath, aura2);
    }

    // Shadow for a little bit of deppth since it looks flat
    canvas.drawShadow(heartPath, const Color(0x33000000), 14, false);

    // Fill the heart with a gradient
    final Rect heartBounds = const Rect.fromLTWH(-120, -140, 240, 240);
    final heartFill = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: type == 'Party Heart'
            ? const [Color(0xFFFFB7CD), Color(0xFFFF2D7A)]
            : const [Color(0xFFFF2D55), Color(0xFFB0003A)],
      ).createShader(heartBounds);

    canvas.drawPath(heartPath, heartFill);

    // Eyes
    final eyeWhite = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(-30, -10), 10, eyeWhite);
    canvas.drawCircle(const Offset(30, -10), 10, eyeWhite);

    // Pupils
    final pupil = Paint()..color = const Color(0xFF111111);
    canvas.drawCircle(const Offset(-27, -8), 4, pupil);
    canvas.drawCircle(const Offset(33, -8), 4, pupil);

    // Highlight in eye to make it cuter
    final highlight = Paint()..color = const Color(0xEEFFFFFF);
    canvas.drawCircle(const Offset(-24, -14), 3, highlight);
    canvas.drawCircle(const Offset(36, -14), 3, highlight);

    // Mouth
    final mouthPaint = Paint()
      ..color = const Color(0xFF111111)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: const Offset(0, 20), radius: 30),
      0,
      pi,
      false,
      mouthPaint,
    );

    if (type == 'Party Heart') {
      _drawPartyHat(canvas);
      _drawConfetti(canvas);
    }

    if (withSparkles) {
      _drawSparkles(canvas, sparkleT);
    }

    canvas.restore();
  }

  void _drawPartyHat(Canvas canvas) {
    final hatPaint = Paint()..color = const Color(0xFFFFD54F);
    final hatPath = Path()
      ..moveTo(0, -120)
      ..lineTo(-48, -40)
      ..lineTo(48, -40)
      ..close();
    canvas.drawPath(hatPath, hatPaint);

    final stripe = Paint()..color = const Color(0xFF7C4DFF);
    canvas.drawRect(const Rect.fromLTWH(-48, -55, 96, 10), stripe);

    final pom = Paint()..color = const Color(0xFF00C853);
    canvas.drawCircle(const Offset(0, -120), 10, pom);
  }

  void _drawConfetti(Canvas canvas) {
    const colors = [
      Color(0xFF00C853),
      Color(0xFF2979FF),
      Color(0xFFFF1744),
      Color(0xFFFFD54F),
      Color(0xFF7C4DFF),
    ];

    for (int i = 0; i < 22; i++) {
      final dx = _rng.nextDouble() * 240 - 120;
      final dy = _rng.nextDouble() * 220 - 160;
      if (dy > 40) continue;

      final p = Paint()..color = colors[i % colors.length];

      if (i.isEven) {
        canvas.drawCircle(Offset(dx, dy), 3.5 + _rng.nextDouble() * 2, p);
      } else {
        final t = Path()
          ..moveTo(dx, dy)
          ..lineTo(dx + 8, dy + 14)
          ..lineTo(dx - 10, dy + 12)
          ..close();
        canvas.drawPath(t, p);
      }
    }
  }

  void _drawSparkles(Canvas canvas, double t) {
    final sparkle = Paint()
      ..color = const Color(0xAAFFFFFF)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 10; i++) {
      final ang = (i / 10) * 2 * pi + (t * 2 * pi);
      final r = 118.0 + 8 * sin((t * 2 * pi) + i);
      final x = cos(ang) * r;
      final y = sin(ang) * r - 10;

      final len = 8 + 5 * sin((t * 2 * pi) + i * 1.7);
      canvas.drawLine(Offset(x - len, y), Offset(x + len, y), sparkle);
      canvas.drawLine(Offset(x, y - len), Offset(x, y + len), sparkle);

      final dot = Paint()..color = const Color(0xCCFFEB3B);
      canvas.drawCircle(Offset(x + 6, y - 6), 2.2, dot);
    }
  }

  @override
  bool shouldRepaint(covariant CupidCanvasPainter old) {
    return old.type != type ||
        old.pulse != pulse ||
        old.sparkleT != sparkleT ||
        old.stamps.length != stamps.length;
  }
}

class _Balloon {
  _Balloon({
    required this.id,
    required this.x,
    required this.size,
    required this.speed,
    required this.wobble,
  });

  final String id;
  final double x;
  final double size;
  final double speed;
  final double wobble;
}

class _BalloonWidget extends StatelessWidget {
  const _BalloonWidget({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    // Slightly more romantic palette (less random-looking)
    const romantic = [
      Color(0xFFFF2D55),
      Color(0xFFFF6FA7),
      Color(0xFFFFC2D1),
      Color(0xFFFFD54F),
      Color(0xFF7C4DFF),
    ];
    final c = romantic[size.toInt() % romantic.length].withOpacity(0.88);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size * 1.15,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(size),
            boxShadow: const [
              BoxShadow(
                blurRadius: 12,
                offset: Offset(0, 8),
                color: Color(0x22000000),
              ),
            ],
          ),
        ),
        Container(width: 2, height: size * 0.8, color: const Color(0x66000000)),
      ],
    );
  }
}
