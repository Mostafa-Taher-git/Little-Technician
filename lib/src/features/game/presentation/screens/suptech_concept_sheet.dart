import 'dart:math';
import 'package:flutter/material.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';

class SupTechConceptSheet extends StatelessWidget {
  final SkinDefinition skin;
  const SupTechConceptSheet({super.key, required this.skin});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 720;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Concept Sheet: Default SupTech',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF1E293B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 48 : 24,
          vertical: 32,
        ),
        child: isWide ? _buildWideLayout(context) : _buildNarrowLayout(context),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 22,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle('SupTech'),
                  const SizedBox(height: 8),
                  Text('SupTech is', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  const SizedBox(height: 12),
                  _traitChip(Icons.psychology, 'Smart', const Color(0xFF6366F1)),
                  const SizedBox(height: 8),
                  _traitChip(Icons.emoji_emotions, 'Helpful', const Color(0xFF10B981)),
                  const SizedBox(height: 8),
                  _traitChip(Icons.lock, 'Secure', const Color(0xFF3B82F6)),
                  const SizedBox(height: 8),
                  _traitChip(Icons.sentiment_satisfied, 'Friendly', const Color(0xFFF59E0B)),
                ],
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              flex: 38,
              child: _buildMainCharacter(context),
            ),
            const SizedBox(width: 32),
            Expanded(
              flex: 33,
              child: _buildAboutCard(),
            ),
          ],
        ),
        const SizedBox(height: 32),
        _sectionTitle('Expressions'),
        const SizedBox(height: 16),
        _buildExpressionsRow(context),
        const SizedBox(height: 32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildColorPalette()),
            const SizedBox(width: 32),
            Expanded(child: _buildAccessoriesSection(context)),
            const SizedBox(width: 32),
            Expanded(child: _buildPosesSection(context)),
          ],
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('SupTech'),
        const SizedBox(height: 8),
        Text('SupTech is', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _traitChip(Icons.psychology, 'Smart', const Color(0xFF6366F1)),
            _traitChip(Icons.emoji_emotions, 'Helpful', const Color(0xFF10B981)),
            _traitChip(Icons.lock, 'Secure', const Color(0xFF3B82F6)),
            _traitChip(Icons.sentiment_satisfied, 'Friendly', const Color(0xFFF59E0B)),
          ],
        ),
        const SizedBox(height: 24),
        _buildMainCharacter(context),
        const SizedBox(height: 24),
        _buildAboutCard(),
        const SizedBox(height: 32),
        _sectionTitle('Expressions'),
        const SizedBox(height: 16),
        _buildExpressionsRow(context),
        const SizedBox(height: 32),
        _buildColorPalette(),
        const SizedBox(height: 32),
        _buildAccessoriesSection(context),
        const SizedBox(height: 32),
        _buildPosesSection(context),
      ],
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Color(0xFF1E293B), letterSpacing: -0.5),
  );

  Widget _traitChip(IconData icon, String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: color.withValues(alpha: 0.2)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 10),
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
      ],
    ),
  );

  Widget _buildMainCharacter(BuildContext context) => Column(
    children: [
      Container(
        width: 280,
        height: 340,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 24, offset: const Offset(0, 8))],
        ),
        child: CustomPaint(painter: _ConceptPainter(skin: skin), size: const Size(280, 340)),
      ),
      const SizedBox(height: 12),
      Text('FRONT VIEW', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 2, color: Colors.grey[400])),
    ],
  );

  Widget _buildAboutCard() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ABOUT SUPTECH', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: Color(0xFF6366F1))),
        const SizedBox(height: 16),
        _infoRow('Name', 'SupTech'),
        const SizedBox(height: 12),
        _infoRow('Version', '1.0'),
        const SizedBox(height: 12),
        _infoRow('Framework', 'Flutter'),
        const SizedBox(height: 12),
        _infoRow('Personality', 'Helpful'),
      ],
    ),
  );

  Widget _infoRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
    ],
  );

  Widget _buildExpressionsRow(BuildContext context) {
    final expressions = [
      SupTechExpression.neutral, SupTechExpression.happy, SupTechExpression.angry,
      SupTechExpression.surprised, SupTechExpression.determined, SupTechExpression.wink,
    ];
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: expressions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final expr = expressions[index];
          return Column(
            children: [
              Container(
                width: 100, height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3))],
                ),
                child: CustomPaint(painter: _ExpressionPainter(skin: skin, expression: expr), size: const Size(100, 100)),
              ),
              const SizedBox(height: 8),
              Text(_expressionName(expr), style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            ],
          );
        },
      ),
    );
  }

  Widget _buildColorPalette() {
    final colors = [
      const _ColorInfo('Robe', Color(0xFF667280)), const _ColorInfo('Glow', Color(0xFF9CA3AF)),
      const _ColorInfo('Accent', Color(0xFF6366F1)), const _ColorInfo('Face', Color(0xFF0F172A)),
      const _ColorInfo('Light', Color(0xFFE5E7EB)),
    ];
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('COLOR PALETTE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: Color(0xFF6366F1))),
          const SizedBox(height: 16),
          Wrap(spacing: 12, runSpacing: 12, children: colors.map((c) => _colorSwatch(c)).toList()),
        ],
      ),
    );
  }

  Widget _colorSwatch(_ColorInfo color) {
    final hex = '#${color.color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
    return Column(
      children: [
        Container(width: 44, height: 44, decoration: BoxDecoration(color: color.color, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withValues(alpha: 0.2)))),
        const SizedBox(height: 6),
        Text(color.label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        Text(hex, style: TextStyle(fontSize: 9, color: Colors.grey[400], fontFamily: 'monospace')),
      ],
    );
  }

  Widget _buildAccessoriesSection(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ACCESSORIES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: Color(0xFF6366F1))),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _accessoryItem('Antenna', 'antenna'),
            _accessoryItem('Badge', 'badge'),
            _accessoryItem('Headset', 'headset'),
          ],
        ),
      ],
    ),
  );

  Widget _accessoryItem(String label, String type) => Column(
    children: [
      Container(
        width: 72, height: 72,
        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
        child: CustomPaint(painter: _AccessoryPainter(skin: skin, type: type), size: const Size(72, 72)),
      ),
      const SizedBox(height: 6),
      Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
    ],
  );

  Widget _buildPosesSection(BuildContext context) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, 4))],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('POSES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.5, color: Color(0xFF6366F1))),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [_poseItem('Wave'), _poseItem('Thinking'), _poseItem('Working')],
        ),
      ],
    ),
  );

  Widget _poseItem(String label) => Column(
    children: [
      Container(
        width: 72, height: 72,
        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
        child: CustomPaint(painter: _PosePainter(label: label), size: const Size(72, 72)),
      ),
      const SizedBox(height: 6),
      Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
    ],
  );

  static String _expressionName(SupTechExpression e) => switch (e) {
    SupTechExpression.neutral => 'Neutral', SupTechExpression.happy => 'Happy',
    SupTechExpression.angry => 'Angry', SupTechExpression.surprised => 'Surprised',
    SupTechExpression.determined => 'Determined', SupTechExpression.wink => 'Wink',
    SupTechExpression.sleep => 'Sleep', SupTechExpression.error => 'Error',
  };
}

class _ColorInfo { final String label; final Color color; const _ColorInfo(this.label, this.color); }

// ═══════════════════════════════════════════════════════
// Main Concept Painter — exact reference match
// ═══════════════════════════════════════════════════════

class _ConceptPainter extends CustomPainter {
  final SkinDefinition skin;
  _ConceptPainter({required this.skin});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    canvas.save();
    final s = size.width / 60;
    canvas.translate(size.width / 2, size.height / 2 + 2 * s);

    final bodyPaint = Paint()..color = skin.bodyColor..style = PaintingStyle.fill;
    final darkPaint = Paint()..color = const Color(0xFF050505)..style = PaintingStyle.fill;
    final outlinePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // ── DROP SHADOW ──
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, 16 * s), width: 22 * s, height: 2.5 * s),
      Paint()..color = Colors.black.withValues(alpha: 0.10),
    );

    // ── ROBE BODY ──
    final robePath = Path()
      ..moveTo(-8 * s, -1 * s)
      ..lineTo(8 * s, -1 * s)
      ..quadraticBezierTo(10 * s, 6 * s, 11 * s, 12 * s)
      ..quadraticBezierTo(5.5 * s, 14 * s, 0, 13 * s)
      ..quadraticBezierTo(-5.5 * s, 14 * s, -11 * s, 12 * s)
      ..quadraticBezierTo(-10 * s, 6 * s, -8 * s, -1 * s)
      ..close();
    canvas.drawPath(robePath, bodyPaint);
    canvas.drawPath(robePath, outlinePaint);

    // Robe fold lines
    final foldPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()..moveTo(-2.5 * s, 0)..quadraticBezierTo(-3.5 * s, 6 * s, -5.5 * s, 12 * s),
      foldPaint,
    );
    canvas.drawPath(
      Path()..moveTo(2.5 * s, 0)..quadraticBezierTo(3.5 * s, 6 * s, 5.5 * s, 12 * s),
      foldPaint,
    );

    // ── BLUE GLOW AT ROBE BOTTOM ──
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, 13.5 * s), width: 20 * s, height: 4 * s),
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0x006366F1), Color(0xFF6366F1)],
        ).createShader(Rect.fromCenter(center: Offset(0, 13.5 * s), width: 20 * s, height: 4 * s))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // ── HOOD (smooth dome with cubic bezier) ──
    final hoodPath = Path()
      ..moveTo(-13 * s, -3 * s)
      ..cubicTo(-13 * s, -18 * s, -10 * s, -27 * s, 0, -28 * s)
      ..cubicTo(10 * s, -27 * s, 13 * s, -18 * s, 13 * s, -3 * s)
      ..quadraticBezierTo(7 * s, 1 * s, 0, -0.5 * s)
      ..quadraticBezierTo(-7 * s, 1 * s, -13 * s, -3 * s)
      ..close();
    canvas.drawPath(hoodPath, bodyPaint);
    canvas.drawPath(hoodPath, outlinePaint);

    // ── HOOD TOP STRIPE (dark tab) ──
    final stripePaint = Paint()..color = const Color(0xFF2D3748)..style = PaintingStyle.fill;
    final stripePath = Path()
      ..moveTo(-1.5 * s, -28 * s)
      ..lineTo(1.5 * s, -28 * s)
      ..lineTo(1.5 * s, -23 * s)
      ..lineTo(-1.5 * s, -23 * s)
      ..close();
    canvas.drawPath(stripePath, stripePaint);
    canvas.drawPath(stripePath, outlinePaint);

    // ── HOOD HIGHLIGHT ──
    canvas.drawPath(
      Path()
        ..moveTo(-8 * s, -25 * s)
        ..quadraticBezierTo(0, -29 * s, 8 * s, -25 * s),
      Paint()
        ..color = skin.accentColor.withValues(alpha: 0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * s
        ..strokeCap = StrokeCap.round,
    );

    // ── FACE (dark oval) ──
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, -8 * s), width: 16 * s, height: 21 * s),
      darkPaint,
    );

    // ── EYES (white tall ovals with blue glow) ──
    final eyeY = -8.5 * s;
    final eyeSpacing = 3.0 * s;
    final eyeRx = 2.0 * s;
    final eyeRy = 3.0 * s;

    for (final dx in [-eyeSpacing, eyeSpacing]) {
      final eyeCenter = Offset(dx, eyeY);

      // Outer glow
      canvas.drawOval(
        Rect.fromCenter(center: eyeCenter, width: (eyeRx + 3.5 * s) * 2, height: (eyeRy + 3.5 * s) * 2),
        Paint()
          ..shader = RadialGradient(colors: [
            skin.accentColor.withValues(alpha: 0.5),
            skin.accentColor.withValues(alpha: 0.0),
          ]).createShader(Rect.fromCenter(center: eyeCenter, width: (eyeRx + 5 * s) * 2, height: (eyeRy + 5 * s) * 2)),
      );

      // Inner glow
      canvas.drawOval(
        Rect.fromCenter(center: eyeCenter, width: (eyeRx + 1.2 * s) * 2, height: (eyeRy + 1.2 * s) * 2),
        Paint()
          ..shader = RadialGradient(colors: [
            Colors.white.withValues(alpha: 0.3),
            skin.accentColor.withValues(alpha: 0.6),
            skin.accentColor.withValues(alpha: 0.0),
          ]).createShader(Rect.fromCenter(center: eyeCenter, width: (eyeRx + 2.5 * s) * 2, height: (eyeRy + 2.5 * s) * 2)),
      );

      // White iris
      canvas.drawOval(
        Rect.fromCenter(center: eyeCenter, width: eyeRx * 2, height: eyeRy * 2),
        Paint()..color = Colors.white,
      );

      // Highlight dot
      canvas.drawCircle(
        Offset(dx + eyeRx * 0.3, eyeY - eyeRy * 0.3),
        eyeRx * 0.2,
        Paint()..color = Colors.white.withValues(alpha: 0.4),
      );
    }

    // ── ST BADGE ON CHEST ──
    final badgeCY = 5.0 * s;

    // Badge glow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, badgeCY), width: 14 * s, height: 10 * s),
      Paint()
        ..shader = RadialGradient(colors: [
          const Color(0xFF6366F1).withValues(alpha: 0.35),
          const Color(0xFF6366F1).withValues(alpha: 0.0),
        ]).createShader(Rect.fromCenter(center: Offset(0, badgeCY), width: 16 * s, height: 12 * s)),
    );

    final stSpan = TextSpan(
      text: 'ST',
      style: TextStyle(
        fontSize: 10 * s,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        shadows: [
          Shadow(color: const Color(0xFF6366F1), blurRadius: 6 * s),
          Shadow(color: const Color(0xFF6366F1), blurRadius: 2 * s),
        ],
      ),
    );
    final stPainter = TextPainter(text: stSpan, textDirection: TextDirection.ltr)..layout();
    stPainter.paint(canvas, Offset(-stPainter.width / 2, badgeCY - stPainter.height / 2));

    // ── AMBIENT GLOW ──
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: 84 * s, height: 84 * s),
      Paint()
        ..shader = RadialGradient(colors: [
          skin.accentColor.withValues(alpha: 0.10),
          skin.accentColor.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCircle(center: Offset.zero, radius: 42 * s)),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ConceptPainter old) => old.skin.id != skin.id;
}

// ═══════════════════════════════════════════════════════
// Shared mini-chibi body for expressions/accessories/poses
// ═══════════════════════════════════════════════════════

void _drawMiniHood(Canvas canvas, double s, Color bodyColor) {
  final bodyPaint = Paint()..color = bodyColor..style = PaintingStyle.fill;
  final outlinePaint = Paint()
    ..color = Colors.black87
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.2 * s
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  final hoodPath = Path()
    ..moveTo(-7 * s, 2 * s)
    ..cubicTo(-7 * s, -4 * s, -5 * s, -7.5 * s, 0, -8.5 * s)
    ..cubicTo(5 * s, -7.5 * s, 7 * s, -4 * s, 7 * s, 2 * s)
    ..quadraticBezierTo(4 * s, 3.2 * s, 0, 2.8 * s)
    ..quadraticBezierTo(-4 * s, 3.2 * s, -7 * s, 2 * s)
    ..close();
  canvas.drawPath(hoodPath, bodyPaint);
  canvas.drawPath(hoodPath, outlinePaint);

  // Dark tab at top
  final tabPaint = Paint()..color = const Color(0xFF2D3748)..style = PaintingStyle.fill;
  final tabPath = Path()
    ..moveTo(-1.0 * s, -8.5 * s)
    ..lineTo(1.0 * s, -8.5 * s)
    ..lineTo(1.0 * s, -6.0 * s)
    ..lineTo(-1.0 * s, -6.0 * s)
    ..close();
  canvas.drawPath(tabPath, tabPaint);
  canvas.drawPath(tabPath, outlinePaint);

  // Hood highlight
  canvas.drawPath(
    Path()
      ..moveTo(-4 * s, -7.5 * s)
      ..quadraticBezierTo(0, -9 * s, 4 * s, -7.5 * s),
    Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 * s
      ..strokeCap = StrokeCap.round,
  );
}

void _drawMiniFace(Canvas canvas, double s, {required Color eyeColor}) {
  final facePaint = Paint()..color = const Color(0xFF050505);

  // Face oval
  canvas.drawOval(
    Rect.fromCenter(center: Offset(0, -1 * s), width: 10 * s, height: 8 * s),
    facePaint,
  );

  // Eyes
  for (final dx in [-2.4 * s, 2.4 * s]) {
    final center = Offset(dx, -1 * s);

    // Outer glow
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 4 * s, height: 5 * s),
      Paint()
        ..shader = RadialGradient(colors: [
          eyeColor.withValues(alpha: 0.4),
          eyeColor.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCenter(center: center, width: 5 * s, height: 6 * s)),
    );

    // White oval eye
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 2 * s, height: 2.8 * s),
      Paint()..color = Colors.white,
    );
  }
}

// ═══════════════════════════════════════════════════════
// Expression Painter
// ═══════════════════════════════════════════════════════

class _ExpressionPainter extends CustomPainter {
  final SkinDefinition skin;
  final SupTechExpression expression;
  _ExpressionPainter({required this.skin, required this.expression});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    canvas.save();
    final s = size.width / 20;
    canvas.translate(size.width / 2, size.height / 2 + 1.5 * s);

    _drawMiniHood(canvas, s, skin.bodyColor);

    // Face
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, -1 * s), width: 10 * s, height: 8 * s),
      Paint()..color = const Color(0xFF050505),
    );

    final eyeSpacing = 2.4 * s;
    final eyeY = -1.0 * s;

    switch (expression) {
      case SupTechExpression.neutral:
        for (final dx in [-eyeSpacing, eyeSpacing]) {
          _drawExprEye(canvas, dx, eyeY, s, skin.accentColor);
        }
        break;

      case SupTechExpression.happy:
        final arcPaint = Paint()
          ..color = skin.accentColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0 * s
          ..strokeCap = StrokeCap.round;
        for (final dx in [-eyeSpacing, eyeSpacing]) {
          canvas.drawPath(
            Path()
              ..moveTo(dx - 2.5 * s, eyeY + 0.5 * s)
              ..quadraticBezierTo(dx, eyeY - 2.0 * s, dx + 2.5 * s, eyeY + 0.5 * s),
            arcPaint,
          );
        }
        break;

      case SupTechExpression.angry:
        for (final dx in [-eyeSpacing, eyeSpacing]) {
          _drawExprEye(canvas, dx, eyeY, s, skin.accentColor);
          final browPaint = Paint()
            ..color = Colors.black87
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.8 * s
            ..strokeCap = StrokeCap.round;
          if (dx < 0) {
            canvas.drawLine(Offset(dx - 2.5 * s, eyeY - 2.8 * s), Offset(dx + 2.5 * s, eyeY - 1.8 * s), browPaint);
          } else {
            canvas.drawLine(Offset(dx - 2.5 * s, eyeY - 1.8 * s), Offset(dx + 2.5 * s, eyeY - 2.8 * s), browPaint);
          }
        }
        break;

      case SupTechExpression.surprised:
        for (final dx in [-eyeSpacing, eyeSpacing]) {
          final center = Offset(dx, eyeY);
          canvas.drawOval(
            Rect.fromCenter(center: center, width: 5 * s, height: 6.5 * s),
            Paint()..shader = RadialGradient(colors: [skin.accentColor.withValues(alpha: 0.4), skin.accentColor.withValues(alpha: 0.0)]).createShader(Rect.fromCenter(center: center, width: 6 * s, height: 7 * s)),
          );
          canvas.drawOval(Rect.fromCenter(center: center, width: 2.4 * s, height: 3.4 * s), Paint()..color = Colors.white);
        }
        break;

      case SupTechExpression.determined:
        for (final dx in [-eyeSpacing, eyeSpacing]) {
          _drawExprEye(canvas, dx, eyeY, s, skin.accentColor);
          canvas.drawLine(
            Offset(dx - 2.5 * s, eyeY - 1.8 * s),
            Offset(dx + 2.5 * s, eyeY - 1.8 * s),
            Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 2.0 * s..strokeCap = StrokeCap.round,
          );
        }
        break;

      case SupTechExpression.wink:
        // Left eye: wink
        canvas.drawPath(
          Path()
            ..moveTo(-eyeSpacing - 2.5 * s, eyeY)
            ..quadraticBezierTo(-eyeSpacing, eyeY - 1.2 * s, -eyeSpacing + 2.5 * s, eyeY),
          Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 2.0 * s..strokeCap = StrokeCap.round,
        );
        // Right eye: normal
        _drawExprEye(canvas, eyeSpacing, eyeY, s, skin.accentColor);
        break;

      case SupTechExpression.sleep:
        final linePaint = Paint()
          ..color = skin.accentColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0 * s
          ..strokeCap = StrokeCap.round;
        for (final dx in [-eyeSpacing, eyeSpacing]) {
          canvas.drawLine(Offset(dx - 2.5 * s, eyeY), Offset(dx + 2.5 * s, eyeY), linePaint);
        }
        break;

      case SupTechExpression.error:
        final xPaint = Paint()
          ..color = skin.accentColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0 * s
          ..strokeCap = StrokeCap.round;
        for (final dx in [-eyeSpacing, eyeSpacing]) {
          canvas.drawLine(Offset(dx - 1.5 * s, eyeY - 1.5 * s), Offset(dx + 1.5 * s, eyeY + 1.5 * s), xPaint);
          canvas.drawLine(Offset(dx + 1.5 * s, eyeY - 1.5 * s), Offset(dx - 1.5 * s, eyeY + 1.5 * s), xPaint);
        }
        break;
    }

    canvas.restore();
  }

  void _drawExprEye(Canvas canvas, double cx, double cy, double s, Color glowColor) {
    final center = Offset(cx, cy);
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 4 * s, height: 5 * s),
      Paint()..shader = RadialGradient(colors: [glowColor.withValues(alpha: 0.4), glowColor.withValues(alpha: 0.0)]).createShader(Rect.fromCenter(center: center, width: 5 * s, height: 6 * s)),
    );
    canvas.drawOval(Rect.fromCenter(center: center, width: 2 * s, height: 2.8 * s), Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _ExpressionPainter old) => old.skin.id != skin.id || old.expression != expression;
}

// ═══════════════════════════════════════════════════════
// Accessory Painter
// ═══════════════════════════════════════════════════════

class _AccessoryPainter extends CustomPainter {
  final SkinDefinition skin;
  final String type;
  _AccessoryPainter({required this.skin, required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    canvas.save();
    final s = size.width / 20;
    canvas.translate(size.width / 2, size.height / 2 + 2 * s);

    _drawMiniHood(canvas, s, skin.bodyColor);
    _drawMiniFace(canvas, s, eyeColor: skin.accentColor);

    // Small robe
    final robePaint = Paint()..color = skin.bodyColor..style = PaintingStyle.fill;
    final robeOutline = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 * s
      ..strokeCap = StrokeCap.round;
    final robePath = Path()
      ..moveTo(-4 * s, 2 * s)
      ..quadraticBezierTo(-5 * s, 5 * s, -5 * s, 8 * s)
      ..quadraticBezierTo(0, 9 * s, 5 * s, 8 * s)
      ..quadraticBezierTo(5 * s, 5 * s, 4 * s, 2 * s)
      ..close();
    canvas.drawPath(robePath, robePaint);
    canvas.drawPath(robePath, robeOutline);

    if (type == 'antenna') {
      canvas.drawLine(
        Offset(0, -8.5 * s), Offset(0, -11.5 * s),
        Paint()..color = skin.accentColor..strokeWidth = 1.2 * s..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(Offset(0, -12 * s), 1.0 * s, Paint()..color = skin.accentColor);
      canvas.drawCircle(Offset(0, -12 * s), 1.0 * s, Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 0.8 * s);
    } else if (type == 'headset') {
      for (final dx in [-7 * s, 7 * s]) {
        canvas.drawOval(
          Rect.fromCenter(center: Offset(dx, -1 * s), width: 2.5 * s, height: 3.5 * s),
          Paint()..color = const Color(0xFF334155),
        );
        canvas.drawOval(
          Rect.fromCenter(center: Offset(dx, -1 * s), width: 2.5 * s, height: 3.5 * s),
          Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 0.8 * s,
        );
      }
      canvas.drawArc(
        Rect.fromCenter(center: Offset(0, -4 * s), width: 14 * s, height: 6 * s),
        pi, pi, false,
        Paint()..color = const Color(0xFF334155)..style = PaintingStyle.stroke..strokeWidth = 1.2 * s..strokeCap = StrokeCap.round,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AccessoryPainter old) => old.skin.id != skin.id || old.type != type;
}

// ═══════════════════════════════════════════════════════
// Pose Painter
// ═══════════════════════════════════════════════════════

class _PosePainter extends CustomPainter {
  final String label;
  _PosePainter({required this.label});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    canvas.save();
    final s = size.width / 20;
    canvas.translate(size.width / 2, size.height / 2 + 2 * s);

    _drawMiniHood(canvas, s, const Color(0xFF667280));
    _drawMiniFace(canvas, s, eyeColor: const Color(0xFF9CA3AF));

    // Small robe
    final robePaint = Paint()..color = const Color(0xFF667280)..style = PaintingStyle.fill;
    final robeOutline = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 * s
      ..strokeCap = StrokeCap.round;
    final robePath = Path()
      ..moveTo(-4 * s, 2 * s)
      ..quadraticBezierTo(-5 * s, 5 * s, -5 * s, 8 * s)
      ..quadraticBezierTo(0, 9 * s, 5 * s, 8 * s)
      ..quadraticBezierTo(5 * s, 5 * s, 4 * s, 2 * s)
      ..close();
    canvas.drawPath(robePath, robePaint);
    canvas.drawPath(robePath, robeOutline);

    if (label == 'Wave') {
      // Arm raised
      canvas.drawPath(
        Path()..moveTo(4 * s, 2 * s)..quadraticBezierTo(7 * s, 0, 8 * s, -3 * s),
        Paint()..color = const Color(0xFF667280)..style = PaintingStyle.stroke..strokeWidth = 2.5 * s..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(Offset(8 * s, -3.5 * s), 1.2 * s, Paint()..color = const Color(0xFF667280));
      canvas.drawCircle(Offset(8 * s, -3.5 * s), 1.2 * s, robeOutline);
      // Wave lines
      final wavePaint = Paint()..color = const Color(0xFF6366F1).withValues(alpha: 0.6)..style = PaintingStyle.stroke..strokeWidth = 0.8 * s..strokeCap = StrokeCap.round;
      for (final i in [0, 1, 2]) {
        final radius = (3 + i * 1.5) * s;
        canvas.drawArc(
          Rect.fromCenter(center: Offset(8 * s, -3.5 * s), width: radius * 2, height: radius * 2),
          -pi * 0.8, pi * 0.6, false, wavePaint,
        );
      }
    } else if (label == 'Thinking') {
      final bubblePaint = Paint()..color = const Color(0xFF9CA3AF);
      canvas.drawCircle(Offset(5 * s, -5 * s), 0.6 * s, bubblePaint);
      canvas.drawCircle(Offset(6.5 * s, -6.5 * s), 0.9 * s, bubblePaint);
      canvas.drawCircle(Offset(8 * s, -8 * s), 1.2 * s, bubblePaint);
    } else if (label == 'Working') {
      final laptopPaint = Paint()..color = const Color(0xFF6366F1);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(0, -1 * s), width: 7 * s, height: 5 * s), Radius.circular(0.5 * s)),
        laptopPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(0, -1 * s), width: 7 * s, height: 5 * s), Radius.circular(0.5 * s)),
        robeOutline,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(0, -1 * s), width: 5.5 * s, height: 3.5 * s), Radius.circular(0.3 * s)),
        Paint()..color = const Color(0xFF818CF8),
      );
      canvas.drawRect(
        Rect.fromCenter(center: Offset(0, 2 * s), width: 8 * s, height: 1.5 * s),
        laptopPaint,
      );
      canvas.drawRect(
        Rect.fromCenter(center: Offset(0, 2 * s), width: 8 * s, height: 1.5 * s),
        robeOutline,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PosePainter old) => old.label != label;
}
