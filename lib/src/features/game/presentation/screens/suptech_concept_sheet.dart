import 'dart:math';
import 'package:flutter/material.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';

class SupTechConceptSheet extends StatefulWidget {
  final SkinDefinition skin;
  const SupTechConceptSheet({super.key, required this.skin});

  @override
  State<SupTechConceptSheet> createState() => _SupTechConceptSheetState();
}

class _SupTechConceptSheetState extends State<SupTechConceptSheet> {
  final _traitsKey = GlobalKey();
  final _characterKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _expressionsKey = GlobalKey();
  final _paletteKey = GlobalKey();
  final _accessoriesKey = GlobalKey();
  final _posesKey = GlobalKey();

  SkinDefinition get skin => widget.skin;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width > 720;
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFE),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isWide ? 30 : 18,
              isWide ? 30 : 22,
              isWide ? 30 : 18,
              36,
            ),
            child: isWide
                ? _buildWideLayout(context)
                : _buildNarrowLayout(context),
          ),
          Positioned(
            top: MediaQuery.paddingOf(context).top + 12,
            right: 16,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: const Color(0xFFE8ECF3)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF253247).withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF344256)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _referencePanel({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE9EDF4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF253247).withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w800,
        letterSpacing: 3,
        color: Color(0xFF4777EA),
      ),
    );
  }

  Widget _sectionPanel({
    required GlobalKey key,
    required String title,
    required Widget child,
    EdgeInsetsGeometry? padding,
  }) {
    return KeyedSubtree(
      key: key,
      child: _labeledPanel(title, child, padding: padding),
    );
  }

  Widget _labeledPanel(String title, Widget child, {EdgeInsetsGeometry? padding}) {
    return _referencePanel(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader(title),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Column(
      children: [
        _buildSectionNav(),
        const SizedBox(height: 22),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _sectionPanel(
                key: _traitsKey,
                title: 'Traits',
                child: _buildTraitsSection(),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _sectionPanel(
                key: _characterKey,
                title: 'Character',
                child: _buildMainCharacter(context),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _sectionPanel(
                key: _aboutKey,
                title: 'About',
                child: _buildAboutSection(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _sectionPanel(
          key: _expressionsKey,
          title: 'Expressions',
          child: _buildExpressionsRow(context),
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 18),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _sectionPanel(
                key: _paletteKey,
                title: 'Color Palette',
                child: _buildColorPalette(),
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _sectionPanel(
                key: _accessoriesKey,
                title: 'Accessories',
                child: _buildAccessoriesSection(context),
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _sectionPanel(
                key: _posesKey,
                title: 'Poses',
                child: _buildPosesSection(context),
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      children: [
        _buildSectionNav(),
        const SizedBox(height: 18),
        _sectionPanel(
          key: _traitsKey,
          title: 'Traits',
          child: _buildTraitsSection(),
        ),
        const SizedBox(height: 20),
        _sectionPanel(
          key: _characterKey,
          title: 'Character',
          child: _buildMainCharacter(context),
        ),
        const SizedBox(height: 20),
        _sectionPanel(
          key: _aboutKey,
          title: 'About',
          child: _buildAboutSection(),
        ),
        const SizedBox(height: 20),
        _sectionPanel(
          key: _expressionsKey,
          title: 'Expressions',
          child: _buildExpressionsRow(context),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        ),
        const SizedBox(height: 20),
        _sectionPanel(
          key: _paletteKey,
          title: 'Color Palette',
          child: _buildColorPalette(),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        ),
        const SizedBox(height: 20),
        _sectionPanel(
          key: _accessoriesKey,
          title: 'Accessories',
          child: _buildAccessoriesSection(context),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        ),
        const SizedBox(height: 20),
        _sectionPanel(
          key: _posesKey,
          title: 'Poses',
          child: _buildPosesSection(context),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        ),
      ],
    );
  }

  Widget _buildSectionNav() {
    final navItems = [
      ('Traits', _traitsKey),
      ('Character', _characterKey),
      ('About', _aboutKey),
      ('Expressions', _expressionsKey),
      ('Color Palette', _paletteKey),
      ('Accessories', _accessoriesKey),
      ('Poses', _posesKey),
    ];

    return _referencePanel(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final navItem in navItems) ...[
              _sectionNavButton(navItem.$1, navItem.$2),
              if (navItem != navItems.last) const SizedBox(width: 8),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionNavButton(String label, GlobalKey targetKey) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: () => _scrollToSection(targetKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F8FF),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFDDE7FF)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF426AE3),
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _scrollToSection(GlobalKey targetKey) {
    final targetContext = targetKey.currentContext;
    if (targetContext == null) return;
    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 360),
      curve: Curves.easeOutCubic,
      alignment: 0.06,
    );
  }

  Widget _buildTraitsSection() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _traitChip(Icons.psychology, 'Smart', const Color(0xFF4777EA)),
        _traitChip(Icons.emoji_emotions, 'Helpful', const Color(0xFF11A36A)),
        _traitChip(Icons.lock, 'Secure', const Color(0xFF2777C8)),
        _traitChip(Icons.sentiment_satisfied, 'Friendly', const Color(0xFFD58B17)),
      ],
    );
  }

  Widget _traitChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      children: [
        _aboutRow('Name', skin.name),
        _aboutRow('Version', '1.0'),
        _aboutRow('Framework', 'Flutter'),
        _aboutRow('Personality', 'Helpful'),
      ],
    );
  }

  Widget _aboutRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF738197), fontSize: 13),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Color(0xFF263348),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorPalette() {
    final colors = [
      ('Robe', skin.bodyColor),
      ('Glow', skin.accentColor),
      ('Face', const Color(0xFF05070B)),
      ('Light', const Color(0xFFFFFFFF)),
    ];

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        for (final paletteColor in colors)
          _colorSwatch(paletteColor.$1, paletteColor.$2),
      ],
    );
  }

  Widget _colorSwatch(String label, Color color) {
    final hex = '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFDDE3EE)),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF45536A), fontSize: 11),
          ),
          Text(
            hex,
            style: const TextStyle(
              color: Color(0xFF8C98AA),
              fontSize: 9,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCharacter(BuildContext context) => Column(
    children: [
      Container(
        width: 386,
        height: 516,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width - 36,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEFF2F7)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF253247).withValues(alpha: 0.07),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: CustomPaint(painter: _ConceptPainter(skin: skin), size: const Size(386, 516)),
      ),
    ],
  );

  Widget _buildExpressionsRow(BuildContext context) {
    final expressions = [
      SupTechExpression.neutral, SupTechExpression.happy, SupTechExpression.angry,
      SupTechExpression.surprised, SupTechExpression.determined, SupTechExpression.wink,
    ];
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: expressions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final expr = expressions[index];
          return Container(
            width: 188,
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE9EDF4)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF253247).withValues(alpha: 0.04),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: CustomPaint(
                    painter: _ExpressionPainter(skin: skin, expression: expr),
                    size: const Size(142, 92),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _expressionName(expr),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF45536A),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccessoriesSection(BuildContext context) => Wrap(
    alignment: WrapAlignment.spaceAround,
    runAlignment: WrapAlignment.center,
    spacing: 18,
    runSpacing: 14,
    children: [
      _accessoryItem('Antenna', 'antenna'),
      _accessoryItem('Badge', 'badge'),
      _accessoryItem('Headset', 'headset'),
    ],
  );

  Widget _accessoryItem(String label, String type) => Column(
    children: [
      SizedBox(
        width: 88,
        height: 76,
        child: CustomPaint(painter: _AccessoryPainter(skin: skin, type: type), size: const Size(88, 76)),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF45536A),
        ),
      ),
    ],
  );

  Widget _buildPosesSection(BuildContext context) => Wrap(
    alignment: WrapAlignment.spaceAround,
    runAlignment: WrapAlignment.center,
    spacing: 18,
    runSpacing: 14,
    children: [_poseItem('Wave'), _poseItem('Thinking'), _poseItem('Working')],
  );

  Widget _poseItem(String label) => Column(
    children: [
      SizedBox(
        width: 98,
        height: 76,
        child: CustomPaint(painter: _PosePainter(label: label), size: const Size(98, 76)),
      ),
      const SizedBox(height: 8),
      Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF45536A),
        ),
      ),
    ],
  );

  static String _expressionName(SupTechExpression e) => switch (e) {
    SupTechExpression.neutral => 'Neutral', SupTechExpression.happy => 'Happy',
    SupTechExpression.angry => 'Angry', SupTechExpression.surprised => 'Surprised',
    SupTechExpression.determined => 'Determined', SupTechExpression.wink => 'Wink',
    SupTechExpression.sleep => 'Sleep', SupTechExpression.error => 'Error',
  };
}

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
    final s = size.width / 50;
    canvas.translate(size.width / 2, size.height / 2 + 9 * s);

    final bodyPaint = Paint()..color = skin.bodyColor..style = PaintingStyle.fill;
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
    final faceRect = Rect.fromCenter(
      center: Offset(0, -8.8 * s),
      width: 23.5 * s,
      height: 14.5 * s,
    );
    canvas.drawOval(
      faceRect.inflate(1.4 * s),
      Paint()
        ..shader = RadialGradient(colors: [
          skin.accentColor.withValues(alpha: 0.12),
          skin.accentColor.withValues(alpha: 0.0),
        ]).createShader(faceRect.inflate(5 * s)),
    );
    canvas.drawOval(
      faceRect,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(0.05, -0.1),
          radius: 0.95,
          colors: [Color(0xFF1B2633), Color(0xFF05070B), Color(0xFF020306)],
          stops: [0.0, 0.52, 1.0],
        ).createShader(faceRect),
    );

    // ── EYES (white tall ovals with blue glow) ──
    final eyeY = -8.5 * s;
    final eyeSpacing = 5.2 * s;
    final eyeRx = 1.8 * s;
    final eyeRy = 3.1 * s;

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
    ..moveTo(-8.5 * s, 2 * s)
    ..cubicTo(-8.5 * s, -5.5 * s, -6 * s, -9.6 * s, 0, -10.2 * s)
    ..cubicTo(6 * s, -9.6 * s, 8.5 * s, -5.5 * s, 8.5 * s, 2 * s)
    ..quadraticBezierTo(4.6 * s, 4.2 * s, 0, 3.2 * s)
    ..quadraticBezierTo(-4.6 * s, 4.2 * s, -8.5 * s, 2 * s)
    ..close();
  canvas.drawPath(hoodPath, bodyPaint);
  canvas.drawPath(hoodPath, outlinePaint);

  // Dark tab at top
  final tabPaint = Paint()..color = const Color(0xFF2D3748)..style = PaintingStyle.fill;
  final tabPath = Path()
    ..moveTo(-1.0 * s, -10.2 * s)
    ..lineTo(1.0 * s, -10.2 * s)
    ..lineTo(1.0 * s, -7.1 * s)
    ..lineTo(-1.0 * s, -7.1 * s)
    ..close();
  canvas.drawPath(tabPath, tabPaint);
  canvas.drawPath(tabPath, outlinePaint);

  // Hood highlight
  canvas.drawPath(
    Path()
      ..moveTo(-4 * s, -7.5 * s)
      ..quadraticBezierTo(0, -10.6 * s, 4 * s, -7.5 * s),
    Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0 * s
      ..strokeCap = StrokeCap.round,
  );
}

void _drawMiniFace(Canvas canvas, double s, {required Color eyeColor}) {
  final faceRect = Rect.fromCenter(
    center: Offset(0, -1.4 * s),
    width: 13.8 * s,
    height: 8.8 * s,
  );

  canvas.drawOval(
    faceRect.inflate(1.0 * s),
    Paint()
      ..shader = RadialGradient(colors: [
        eyeColor.withValues(alpha: 0.12),
        eyeColor.withValues(alpha: 0.0),
      ]).createShader(faceRect.inflate(3 * s)),
  );
  canvas.drawOval(
    faceRect,
    Paint()
      ..shader = const RadialGradient(
        center: Alignment(0, -0.15),
        radius: 0.95,
        colors: [Color(0xFF1B2633), Color(0xFF05070B), Color(0xFF020306)],
        stops: [0.0, 0.5, 1.0],
      ).createShader(faceRect),
  );

  for (final dx in [-3.3 * s, 3.3 * s]) {
    final center = Offset(dx, -1.4 * s);

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

    final faceRect = Rect.fromCenter(
      center: Offset(0, -1.4 * s),
      width: 13.8 * s,
      height: 8.8 * s,
    );
    canvas.drawOval(
      faceRect,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(0, -0.15),
          radius: 0.95,
          colors: [Color(0xFF1B2633), Color(0xFF05070B), Color(0xFF020306)],
          stops: [0.0, 0.5, 1.0],
        ).createShader(faceRect),
    );

    final eyeSpacing = 3.3 * s;
    final eyeY = -1.4 * s;

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
    } else if (type == 'badge') {
      final textSpan = TextSpan(
        text: 'ST',
        style: TextStyle(
          fontSize: 3.0 * s,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          shadows: [
            Shadow(color: skin.accentColor, blurRadius: 2.5 * s),
            Shadow(color: skin.accentColor, blurRadius: 1.0 * s),
          ],
        ),
      );
      final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, 5.5 * s - textPainter.height / 2));
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
    _drawMiniFace(canvas, s, eyeColor: const Color(0xFF7DB8FF));

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
