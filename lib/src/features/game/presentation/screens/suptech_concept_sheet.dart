import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';
import 'package:littletech/src/features/game/domain/cubit/suptech_customization_cubit.dart';
import 'package:littletech/src/features/game/domain/models/suptech_customization.dart';
import 'package:littletech/src/features/game/presentation/widgets/sup_tech_renderer.dart';

class SupTechConceptSheet extends StatelessWidget {
  final SkinDefinition skin;
  const SupTechConceptSheet({super.key, required this.skin});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<SupTechCustomizationCubit>();
    final c = cubit.state;
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
                ? _buildWideLayout(context, cubit, c)
                : _buildNarrowLayout(context, cubit, c),
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

  Widget _buildWideLayout(
      BuildContext context, SupTechCustomizationCubit cubit, SupTechCustomization c) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _labeledPanel('Traits', _buildTraitsSection())),
            const SizedBox(width: 24),
            Expanded(
              child: _labeledPanel('Character', _buildMainCharacter(context, cubit, c)),
            ),
            const SizedBox(width: 24),
            Expanded(child: _labeledPanel('About', _buildAboutSection())),
          ],
        ),
        const SizedBox(height: 24),
        _labeledPanel(
          'Expressions',
          _buildExpressionsRow(context, cubit, c),
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 18),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(
      BuildContext context, SupTechCustomizationCubit cubit, SupTechCustomization c) {
    return Column(
      children: [
        _labeledPanel('Traits', _buildTraitsSection()),
        const SizedBox(height: 20),
        _labeledPanel('Character', _buildMainCharacter(context, cubit, c)),
        const SizedBox(height: 20),
        _labeledPanel('About', _buildAboutSection()),
        const SizedBox(height: 20),
        _labeledPanel(
          'Expressions',
          _buildExpressionsRow(context, cubit, c),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        ),
      ],
    );
  }

  Widget _buildExpressionsRow(
      BuildContext context, SupTechCustomizationCubit cubit, SupTechCustomization c) {
    final expressions = [
      SupTechExpression.neutral,
      SupTechExpression.happy,
      SupTechExpression.angry,
      SupTechExpression.surprised,
      SupTechExpression.determined,
      SupTechExpression.wink,
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            for (var i = 0; i < expressions.length; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(
                child: _expressionCard(expressions[i], cubit, c),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _expressionCard(
      SupTechExpression expr, SupTechCustomizationCubit cubit, SupTechCustomization c) {
    final isSelected = (c.expression ?? SupTechExpression.neutral) == expr;
    return GestureDetector(
      onTap: () => cubit.setExpression(isSelected ? null : expr),
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 14, 8, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF4777EA) : const Color(0xFFE9EDF4),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF253247).withValues(alpha: 0.04),
              blurRadius: 10, offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1.15,
              child: CustomPaint(
                painter: _ExpressionPainter(skin: skin, expression: expr),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _expressionName(expr),
              style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF4777EA) : const Color(0xFF6B7A90),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _expressionName(SupTechExpression e) => switch (e) {
    SupTechExpression.neutral => 'Neutral',
    SupTechExpression.happy => 'Happy',
    SupTechExpression.angry => 'Angry',
    SupTechExpression.surprised => 'Surprised',
    SupTechExpression.determined => 'Determined',
    SupTechExpression.wink => 'Wink',
    SupTechExpression.sleep => 'Sleep',
    SupTechExpression.error => 'Error',
  };

  Widget _buildTraitsSection() {
    return Wrap(
      spacing: 10, runSpacing: 10,
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
          Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w700)),
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
          Text(label, style: const TextStyle(color: Color(0xFF738197), fontSize: 13)),
          Flexible(
            child: Text(value,
              textAlign: TextAlign.end,
              style: const TextStyle(color: Color(0xFF263348), fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCharacter(
      BuildContext context, SupTechCustomizationCubit cubit, SupTechCustomization c) {
    final maxWidth = min(280.0, MediaQuery.sizeOf(context).width - 36);
    final height = maxWidth * (516 / 386);
    final expression = c.expression ?? SupTechExpression.neutral;
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: maxWidth, height: height,
        child: CustomPaint(
          painter: _InteractiveConceptPainter(skin: skin, expression: expression),
          size: Size(maxWidth, height),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// Interactive Concept Painter - combines all selections
// ═══════════════════════════════════════════════════════

class _InteractiveConceptPainter extends CustomPainter {
  final SkinDefinition skin;
  final SupTechExpression expression;

  _InteractiveConceptPainter({required this.skin, required this.expression});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    canvas.save();
    final s = size.width / 50;
    canvas.translate(size.width / 2, size.height / 2 + 9 * s);

    // Ambient glow
    canvas.drawCircle(
      Offset.zero, 42 * s,
      Paint()
        ..shader = RadialGradient(colors: [
          skin.accentColor.withValues(alpha: 0.14),
          skin.accentColor.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCircle(center: Offset.zero, radius: 42 * s)),
    );

    final bodyPaint = Paint()..color = skin.bodyColor..style = PaintingStyle.fill;
    final outlinePaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.25 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Drop shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, 16 * s), width: 22 * s, height: 2.5 * s),
      Paint()..color = Colors.black.withValues(alpha: 0.10),
    );

    // Robe body
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
      ..strokeWidth = 0.5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(
      Path()..moveTo(-2.5 * s, 0)..quadraticBezierTo(-3.5 * s, 6 * s, -5.5 * s, 12 * s),
      foldPaint,
    );
    canvas.drawPath(
      Path()..moveTo(2.5 * s, 0)..quadraticBezierTo(3.5 * s, 6 * s, 5.5 * s, 12 * s),
      foldPaint,
    );

    // Glow at robe bottom
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, 13.5 * s), width: 20 * s, height: 4 * s),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [skin.accentColor.withValues(alpha: 0.0), skin.accentColor],
        ).createShader(Rect.fromCenter(center: Offset(0, 13.5 * s), width: 20 * s, height: 4 * s))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Cuff accents
    final cuffPaint = Paint()
      ..color = skin.accentColor.withValues(alpha: 0.85)
      ..strokeWidth = 0.6 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(-8 * s, 0), Offset(-10.5 * s, 4 * s), cuffPaint);
    canvas.drawLine(Offset(8 * s, 0), Offset(10.5 * s, 4 * s), cuffPaint);

    // Hood
    final hoodPath = Path()
      ..moveTo(-13 * s, -3 * s)
      ..cubicTo(-13 * s, -18 * s, -10 * s, -27 * s, 0, -28 * s)
      ..cubicTo(10 * s, -27 * s, 13 * s, -18 * s, 13 * s, -3 * s)
      ..quadraticBezierTo(7 * s, 1 * s, 0, -0.5 * s)
      ..quadraticBezierTo(-7 * s, 1 * s, -13 * s, -3 * s)
      ..close();
    canvas.drawPath(hoodPath, bodyPaint);
    canvas.drawPath(hoodPath, outlinePaint);

    // Hood stripe
    final stripeColor = _stripeColorForAccessory(skin.headAccessory);
    final stripePath = Path()
      ..moveTo(-1.5 * s, -28 * s)
      ..lineTo(1.5 * s, -28 * s)
      ..lineTo(1.5 * s, -23 * s)
      ..lineTo(-1.5 * s, -23 * s)
      ..close();
    canvas.drawPath(stripePath, Paint()..color = stripeColor..style = PaintingStyle.fill);
    canvas.drawPath(stripePath, outlinePaint);

    // Hood highlight
    canvas.drawPath(
      Path()
        ..moveTo(-8 * s, -25 * s)
        ..quadraticBezierTo(0, -29 * s, 8 * s, -25 * s),
      Paint()
        ..color = skin.accentColor.withValues(alpha: 0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.75 * s
        ..strokeCap = StrokeCap.round,
    );

    // Face
    final faceRect = Rect.fromCenter(
      center: Offset(0, -8.8 * s),
      width: 23.5 * s, height: 14.5 * s,
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

    // Eyes
    final eyeY = -8.5 * s;
    final eyeSpacing = 5.2 * s;
    final eyeR = 3.1 * s;
    final headCY = -8.8 * s;
    final headR = 11.75 * s;
    final hoodPeakY = -28 * s;
    final bodyTopY = -1 * s;
    final bodyBotY = 13 * s;
    drawSupTechEyes(canvas, skin, s, eyeY, eyeSpacing, eyeR, expression);
    drawSupTechHeadAccessory(canvas, skin, s, headCY, headR, hoodPeakY, skin.headAccessory);
    drawSupTechEarAccessory(canvas, skin, s, headCY, headR, skin.earAccessory);
    drawSupTechChestAccessory(canvas, skin, s, bodyTopY, bodyBotY, skin.chestAccessory);

    canvas.restore();
  }

  Color _stripeColorForAccessory(SupTechHeadAccessory acc) {
    return switch (acc) {
      SupTechHeadAccessory.antenna => skin.accentColor,
      SupTechHeadAccessory.crown => const Color(0xFFFCD34D),
      SupTechHeadAccessory.wizardHat => const Color(0xFFF59E0B),
      SupTechHeadAccessory.ninjaHeadband => skin.bodyColor,
      SupTechHeadAccessory.visor => const Color(0xFF334155),
      SupTechHeadAccessory.horns => const Color(0xFF7C3AED),
      SupTechHeadAccessory.crest => const Color(0xFF4338CA),
      _ => const Color(0xFF2D3748),
    };
  }

  @override
  bool shouldRepaint(covariant _InteractiveConceptPainter old) =>
      old.skin.id != skin.id || old.expression != expression;
}

// ═══════════════════════════════════════════════════════
// Mini hood + face base for small previews
// ═══════════════════════════════════════════════════════

void _drawMiniHood(Canvas canvas, double s, Color bodyColor) {
  final bodyPaint = Paint()..color = bodyColor..style = PaintingStyle.fill;
  final outlinePaint = Paint()
    ..color = Colors.black87
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.6 * s
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

  final tabPaint = Paint()..color = const Color(0xFF2D3748)..style = PaintingStyle.fill;
  final tabPath = Path()
    ..moveTo(-1.0 * s, -10.2 * s)
    ..lineTo(1.0 * s, -10.2 * s)
    ..lineTo(1.0 * s, -7.1 * s)
    ..lineTo(-1.0 * s, -7.1 * s)
    ..close();
  canvas.drawPath(tabPath, tabPaint);
  canvas.drawPath(tabPath, outlinePaint);

  canvas.drawPath(
    Path()
      ..moveTo(-4 * s, -7.5 * s)
      ..quadraticBezierTo(0, -10.6 * s, 4 * s, -7.5 * s),
    Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5 * s
      ..strokeCap = StrokeCap.round,
  );
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
      center: Offset(0, -1.4 * s), width: 13.8 * s, height: 8.8 * s,
    );
    canvas.drawOval(
      faceRect,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(0, -0.15), radius: 0.95,
          colors: [Color(0xFF1B2633), Color(0xFF05070B), Color(0xFF020306)],
          stops: [0.0, 0.5, 1.0],
        ).createShader(faceRect),
    );

    drawSupTechEyes(canvas, skin, s, -1.4 * s, 3.3 * s, 1.4 * s, expression);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ExpressionPainter old) =>
      old.skin.id != skin.id || old.expression != expression;
}


