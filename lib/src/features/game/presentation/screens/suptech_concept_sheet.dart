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
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _labeledPanel(
                'Accessories',
                _buildAccessoriesSection(context, cubit, c),
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _labeledPanel(
                'Poses',
                _buildPosesSection(context, cubit, c),
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton.icon(
            onPressed: () => cubit.reset(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Reset Customization'),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFEF4444)),
          ),
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
        const SizedBox(height: 20),
        _labeledPanel(
          'Accessories',
          _buildAccessoriesSection(context, cubit, c),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        ),
        const SizedBox(height: 20),
        _labeledPanel(
          'Poses',
          _buildPosesSection(context, cubit, c),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton.icon(
            onPressed: () => cubit.reset(),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Reset Customization'),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFEF4444)),
          ),
        ),
      ],
    );
  }

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
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: maxWidth, height: height,
        child: CustomPaint(
          painter: _InteractiveConceptPainter(
            skin: skin,
            expression: c.expression ?? SupTechExpression.neutral,
            headAccessory: c.headAccessory ?? skin.headAccessory,
            earAccessory: c.earAccessory ?? skin.earAccessory,
            chestAccessory: c.chestAccessory ?? skin.chestAccessory,
            pose: c.pose ?? SupTechPose.neutral,
          ),
          size: Size(maxWidth, height),
        ),
      ),
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

  Widget _buildAccessoriesSection(
      BuildContext context, SupTechCustomizationCubit cubit, SupTechCustomization c) {
    final headRows = _buildAccessoryRow<SupTechHeadAccessory>(
      cubit, c,
      SupTechHeadAccessory.values,
      (v, cc) => v == (cc.headAccessory ?? skin.headAccessory),
      (v) {
        final isSame = v == (c.headAccessory ?? skin.headAccessory);
        cubit.setHeadAccessory(isSame ? null : v);
      },
      _headAccessoryLabel,
      _renderHeadAccessoryMini,
    );
    final earRows = _buildAccessoryRow<SupTechEarAccessory>(
      cubit, c,
      SupTechEarAccessory.values,
      (v, cc) => v == (cc.earAccessory ?? skin.earAccessory),
      (v) {
        final isSame = v == (c.earAccessory ?? skin.earAccessory);
        cubit.setEarAccessory(isSame ? null : v);
      },
      _earAccessoryLabel,
      _renderEarAccessoryMini,
    );
    final chestRows = _buildAccessoryRow<SupTechChestAccessory>(
      cubit, c,
      SupTechChestAccessory.values,
      (v, cc) => v == (cc.chestAccessory ?? skin.chestAccessory),
      (v) {
        final isSame = v == (c.chestAccessory ?? skin.chestAccessory);
        cubit.setChestAccessory(isSame ? null : v);
      },
      _chestAccessoryLabel,
      _renderChestAccessoryMini,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _accessoryGroupLabel('Head'), headRows,
        const SizedBox(height: 12),
        _accessoryGroupLabel('Ears'), earRows,
        const SizedBox(height: 12),
        _accessoryGroupLabel('Chest'), chestRows,
      ],
    );
  }

  Widget _accessoryGroupLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF8C98AA), letterSpacing: 1.5),
      ),
    );
  }

  Widget _buildAccessoryRow<T>(
    SupTechCustomizationCubit cubit,
    SupTechCustomization c,
    List<T> values,
    bool Function(T v, SupTechCustomization c) isSelected,
    void Function(T v) onTap,
    String Function(T v) label,
    Widget Function(T v, SkinDefinition s) render,
  ) {
    final items = values.where((v) {
      if (v is SupTechHeadAccessory) return v != SupTechHeadAccessory.none;
      if (v is SupTechEarAccessory) return v != SupTechEarAccessory.none;
      if (v is SupTechChestAccessory) return v != SupTechChestAccessory.none;
      return true;
    }).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            _accessoryMiniItem(
              label(items[i]),
              isSelected(items[i], c),
              () => onTap(items[i]),
              render(items[i], skin),
            ),
          ],
        ],
      ),
    );
  }

  Widget _accessoryMiniItem(
      String label, bool isSelected, VoidCallback onTap, Widget preview) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F8FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF4777EA) : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            SizedBox(width: 56, height: 56, child: preview),
            const SizedBox(height: 4),
            Text(label,
              style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF4777EA) : const Color(0xFF45536A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderHeadAccessoryMini(SupTechHeadAccessory acc, SkinDefinition skinDef) {
    return CustomPaint(
      painter: _MiniAccessoryPainter(
        skin: skinDef,
        type: 'head',
        headAccessory: acc,
      ),
      size: const Size(56, 56),
    );
  }

  Widget _renderEarAccessoryMini(SupTechEarAccessory acc, SkinDefinition skinDef) {
    return CustomPaint(
      painter: _MiniAccessoryPainter(
        skin: skinDef,
        type: 'ear',
        earAccessory: acc,
      ),
      size: const Size(56, 56),
    );
  }

  Widget _renderChestAccessoryMini(SupTechChestAccessory acc, SkinDefinition skinDef) {
    return CustomPaint(
      painter: _MiniAccessoryPainter(
        skin: skinDef,
        type: 'chest',
        chestAccessory: acc,
      ),
      size: const Size(56, 56),
    );
  }

  Widget _buildPosesSection(
      BuildContext context, SupTechCustomizationCubit cubit, SupTechCustomization c) {
    final poses = [
      SupTechPose.neutral,
      SupTechPose.wave,
      SupTechPose.thinking,
      SupTechPose.working,
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final pose in poses)
          _poseItem(pose, cubit, c),
      ],
    );
  }

  Widget _poseItem(SupTechPose pose, SupTechCustomizationCubit cubit, SupTechCustomization c) {
    final effectivePose = c.pose ?? SupTechPose.neutral;
    final isSelected = effectivePose == pose;
    return GestureDetector(
      onTap: () => cubit.setPose(isSelected ? null : pose),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF5F8FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF4777EA) : Colors.transparent,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              width: 90, height: 88,
              child: CustomPaint(
                painter: _PosePainter(skin: skin, pose: pose),
                size: const Size(90, 88),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _poseLabel(pose),
              style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w500,
                color: isSelected ? const Color(0xFF4777EA) : const Color(0xFF45536A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _poseLabel(SupTechPose p) => switch (p) {
    SupTechPose.neutral => 'Neutral',
    SupTechPose.wave => 'Wave',
    SupTechPose.thinking => 'Thinking',
    SupTechPose.working => 'Working',
    SupTechPose.none => 'None',
  };

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

  static String _headAccessoryLabel(SupTechHeadAccessory a) => switch (a) {
    SupTechHeadAccessory.none => 'None',
    SupTechHeadAccessory.antenna => 'Antenna',
    SupTechHeadAccessory.crown => 'Crown',
    SupTechHeadAccessory.wizardHat => 'Wizard Hat',
    SupTechHeadAccessory.ninjaHeadband => 'Headband',
    SupTechHeadAccessory.visor => 'Visor',
    SupTechHeadAccessory.horns => 'Horns',
    SupTechHeadAccessory.crest => 'Crest',
  };

  static String _earAccessoryLabel(SupTechEarAccessory a) => switch (a) {
    SupTechEarAccessory.none => 'None',
    SupTechEarAccessory.headset => 'Headset',
    SupTechEarAccessory.scarf => 'Scarf',
    SupTechEarAccessory.earGlow => 'Ear Glow',
  };

  static String _chestAccessoryLabel(SupTechChestAccessory a) => switch (a) {
    SupTechChestAccessory.none => 'None',
    SupTechChestAccessory.badge => 'Badge',
    SupTechChestAccessory.cape => 'Cape',
    SupTechChestAccessory.codeScroll => 'Scroll',
    SupTechChestAccessory.gear => 'Gear',
    SupTechChestAccessory.flameEmblem => 'Flame',
    SupTechChestAccessory.staff => 'Staff',
  };
}

// ═══════════════════════════════════════════════════════
// Interactive Concept Painter - combines all selections
// ═══════════════════════════════════════════════════════

class _InteractiveConceptPainter extends CustomPainter {
  final SkinDefinition skin;
  final SupTechExpression expression;
  final SupTechHeadAccessory headAccessory;
  final SupTechEarAccessory earAccessory;
  final SupTechChestAccessory chestAccessory;
  final SupTechPose pose;

  _InteractiveConceptPainter({
    required this.skin,
    required this.expression,
    required this.headAccessory,
    required this.earAccessory,
    required this.chestAccessory,
    required this.pose,
  });

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
    final stripeColor = _stripeColorForAccessory(headAccessory);
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
    if (pose == SupTechPose.working) {
      drawSupTechFocusedEyes(canvas, s, eyeY, eyeSpacing);
    } else {
      drawSupTechEyes(canvas, skin, s, eyeY, eyeSpacing, eyeR, expression);
    }

    drawSupTechHeadAccessory(canvas, skin, s, headCY, headR, hoodPeakY, headAccessory);
    drawSupTechEarAccessory(canvas, skin, s, headCY, headR, earAccessory);
    drawSupTechChestAccessory(canvas, skin, s, bodyTopY, bodyBotY, chestAccessory);

    if (pose != SupTechPose.none && pose != SupTechPose.neutral) {
      drawSupTechPoseOverlay(canvas, skin, s, pose, eyeY, eyeSpacing);
    }

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
      old.skin.id != skin.id ||
      old.expression != expression ||
      old.headAccessory != headAccessory ||
      old.earAccessory != earAccessory ||
      old.chestAccessory != chestAccessory ||
      old.pose != pose;
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
      ..strokeWidth = 0.5 * s
      ..strokeCap = StrokeCap.round,
  );
}

void _drawMiniFace(Canvas canvas, double s, {required Color eyeColor}) {
  final faceRect = Rect.fromCenter(
    center: Offset(0, -1.4 * s),
    width: 13.8 * s, height: 8.8 * s,
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
    canvas.drawOval(
      Rect.fromCenter(center: center, width: 4 * s, height: 5 * s),
      Paint()
        ..shader = RadialGradient(colors: [
          eyeColor.withValues(alpha: 0.4),
          eyeColor.withValues(alpha: 0.0),
        ]).createShader(Rect.fromCenter(center: center, width: 5 * s, height: 6 * s)),
    );
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

// ═══════════════════════════════════════════════════════
// Mini Accessory Painter (single, parameterized by type)
// ═══════════════════════════════════════════════════════

class _MiniAccessoryPainter extends CustomPainter {
  final SkinDefinition skin;
  final String type;
  final SupTechHeadAccessory? headAccessory;
  final SupTechEarAccessory? earAccessory;
  final SupTechChestAccessory? chestAccessory;

  _MiniAccessoryPainter({
    required this.skin,
    required this.type,
    this.headAccessory,
    this.earAccessory,
    this.chestAccessory,
  });

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
      ..strokeWidth = 0.5 * s
      ..strokeCap = StrokeCap.round;
    final robePath = Path()
      ..moveTo(-4 * s, 2 * s)
      ..quadraticBezierTo(-5 * s, 5 * s, -5 * s, 8 * s)
      ..quadraticBezierTo(0, 9 * s, 5 * s, 8 * s)
      ..quadraticBezierTo(5 * s, 5 * s, 4 * s, 2 * s)
      ..close();
    canvas.drawPath(robePath, robePaint);
    canvas.drawPath(robePath, robeOutline);

    if (type == 'head' && headAccessory != null) {
      _drawMiniHeadAcc(canvas, s, headAccessory!, skin.accentColor);
    } else if (type == 'ear' && earAccessory != null) {
      _drawMiniEarAcc(canvas, s, earAccessory!, skin.accentColor);
    } else if (type == 'chest' && chestAccessory != null) {
      _drawMiniChestAcc(canvas, s, chestAccessory!, skin.accentColor);
    }

    canvas.restore();
  }

  void _drawMiniHeadAcc(Canvas canvas, double s, SupTechHeadAccessory acc, Color accent) {
    switch (acc) {
      case SupTechHeadAccessory.antenna:
        canvas.drawLine(Offset(0, -8.5 * s), Offset(0, -11.5 * s),
          Paint()..color = accent..strokeWidth = 0.6 * s..strokeCap = StrokeCap.round);
        canvas.drawCircle(Offset(0, -12 * s), 1.0 * s, Paint()..color = accent);
        canvas.drawCircle(Offset(0, -12 * s), 1.0 * s, Paint()..color = accent..style = PaintingStyle.stroke..strokeWidth = 0.4 * s);
      case SupTechHeadAccessory.crown:
        final crown = Path()
          ..moveTo(-3 * s, -9 * s)..lineTo(-2.5 * s, -12 * s)..lineTo(-1 * s, -10 * s)
          ..lineTo(0, -13 * s)..lineTo(1 * s, -10 * s)..lineTo(2.5 * s, -12 * s)..lineTo(3 * s, -9 * s);
        canvas.drawPath(crown, Paint()..color = accent..style = PaintingStyle.fill);
      case SupTechHeadAccessory.wizardHat:
        final cone = Path()..moveTo(-3 * s, -9 * s)..lineTo(3 * s, -9 * s)..lineTo(0, -14 * s);
        canvas.drawPath(cone, Paint()..color = const Color(0xFF1E293B));
        canvas.drawRect(Rect.fromLTWH(-3 * s, -10 * s, 6 * s, 1.5 * s), Paint()..color = accent);
      case SupTechHeadAccessory.ninjaHeadband:
        canvas.drawRect(Rect.fromLTWH(-7 * s, -3 * s, 14 * s, 2 * s), Paint()..color = accent);
      case SupTechHeadAccessory.visor:
        canvas.drawRRect(
          RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(0, -2 * s), width: 12 * s, height: 3.5 * s), Radius.circular(1.5 * s)),
          Paint()..color = accent.withValues(alpha: 0.75),
        );
      case SupTechHeadAccessory.horns:
        for (final dir in [-1, 1]) {
          canvas.drawPath(
            Path()..moveTo(dir * 3 * s, -9 * s)..quadraticBezierTo(dir * 5 * s, -12 * s, dir * 3.5 * s, -14 * s),
            Paint()..color = accent..style = PaintingStyle.stroke..strokeWidth = 0.75 * s..strokeCap = StrokeCap.round,
          );
        }
      case SupTechHeadAccessory.crest:
        final crest = Path()..moveTo(0, -14 * s)..lineTo(-1.5 * s, -9 * s)..lineTo(0, -10 * s)..lineTo(1.5 * s, -9 * s);
        canvas.drawPath(crest, Paint()..color = accent);
      case SupTechHeadAccessory.none:
        break;
    }
  }

  void _drawMiniEarAcc(Canvas canvas, double s, SupTechEarAccessory acc, Color accent) {
    switch (acc) {
      case SupTechEarAccessory.none: break;
      case SupTechEarAccessory.headset:
        for (final dx in [-6 * s, 6 * s]) {
          canvas.drawOval(Rect.fromCenter(center: Offset(dx, -1.5 * s), width: 2 * s, height: 3 * s),
            Paint()..color = accent.withValues(alpha: 0.85));
        }
        canvas.drawArc(
          Rect.fromCenter(center: Offset(0, -4 * s), width: 12 * s, height: 5 * s),
          pi, pi, false,
          Paint()..color = accent..style = PaintingStyle.stroke..strokeWidth = 0.5 * s..strokeCap = StrokeCap.round,
        );
      case SupTechEarAccessory.scarf:
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(-6 * s, 0, 12 * s, 3 * s), Radius.circular(1.5 * s)),
          Paint()..color = accent);
        canvas.drawPath(
          Path()..moveTo(-6 * s, 2 * s)..quadraticBezierTo(-8 * s, 6 * s, -6 * s, 9 * s),
          Paint()..color = accent..style = PaintingStyle.stroke..strokeWidth = 1 * s..strokeCap = StrokeCap.round,
        );
      case SupTechEarAccessory.earGlow:
        for (final dx in [-4 * s, 4 * s]) {
          canvas.drawCircle(Offset(dx, -1.4 * s), 1.5 * s,
            Paint()..shader = RadialGradient(colors: [accent, accent.withValues(alpha: 0.0)]).createShader(Rect.fromCircle(center: Offset(dx, -1.4 * s), radius: 1.5 * s)));
        }
    }
  }

  void _drawMiniChestAcc(Canvas canvas, double s, SupTechChestAccessory acc, Color accent) {
    switch (acc) {
      case SupTechChestAccessory.none: break;
      case SupTechChestAccessory.badge:
        final stSpan = TextSpan(
          text: 'ST',
          style: TextStyle(fontSize: 3.0 * s, fontWeight: FontWeight.w800, color: Colors.white,
            shadows: [Shadow(color: accent, blurRadius: 2.5 * s), Shadow(color: accent, blurRadius: 1.0 * s)],
          ),
        );
        final tp = TextPainter(text: stSpan, textDirection: TextDirection.ltr)..layout();
        tp.paint(canvas, Offset(-tp.width / 2, 5.5 * s - tp.height / 2));
      case SupTechChestAccessory.cape:
        final cape = Path()..moveTo(-3 * s, 2 * s)..lineTo(-4.5 * s, 8 * s)..lineTo(4.5 * s, 8 * s)..lineTo(3 * s, 2 * s);
        canvas.drawPath(cape, Paint()..color = accent);
      case SupTechChestAccessory.codeScroll:
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(0, 5.5 * s), width: 5 * s, height: 6 * s), Radius.circular(0.8 * s)),
          Paint()..color = const Color(0xFFF8FAFC));
        canvas.drawLine(Offset(-1.5 * s, 4 * s), Offset(1.5 * s, 4 * s), Paint()..color = accent..strokeWidth = 0.3 * s);
        canvas.drawLine(Offset(-1.5 * s, 6 * s), Offset(1.5 * s, 6 * s), Paint()..color = accent..strokeWidth = 0.3 * s);
      case SupTechChestAccessory.gear:
        canvas.drawCircle(Offset(0, 5.5 * s), 2.5 * s, Paint()..color = accent.withValues(alpha: 0.25));
        for (var i = 0; i < 6; i++) {
          final angle = i * pi / 3;
          canvas.drawLine(Offset(0, 5.5 * s), Offset(cos(angle) * 3 * s, 5.5 * s + sin(angle) * 3 * s),
            Paint()..color = accent..strokeWidth = 0.5 * s);
        }
      case SupTechChestAccessory.flameEmblem:
        final flame = Path()..moveTo(0, 3 * s)..quadraticBezierTo(-2 * s, 5.5 * s, 0, 7.5 * s)..quadraticBezierTo(2 * s, 5.5 * s, 0, 3 * s);
        canvas.drawPath(flame, Paint()..color = const Color(0xFFF97316));
      case SupTechChestAccessory.staff:
        canvas.drawLine(Offset(5 * s, 2 * s), Offset(5 * s, 8 * s),
          Paint()..color = const Color(0xFF92400E)..strokeWidth = 0.6 * s..strokeCap = StrokeCap.round);
        canvas.drawCircle(Offset(5 * s, 1.5 * s), 1.2 * s, Paint()..color = accent);
    }
  }

  @override
  bool shouldRepaint(covariant _MiniAccessoryPainter old) =>
      old.skin.id != skin.id || old.type != type ||
      old.headAccessory != headAccessory || old.earAccessory != earAccessory ||
      old.chestAccessory != chestAccessory;
}

// ═══════════════════════════════════════════════════════
// Pose Painter
// ═══════════════════════════════════════════════════════

class _PosePainter extends CustomPainter {
  final SkinDefinition skin;
  final SupTechPose pose;
  _PosePainter({required this.skin, required this.pose});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    canvas.save();
    final s = size.width / 20;
    canvas.translate(size.width / 2, size.height / 2 + 2 * s);

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

    // Small robe
    final robePaint = Paint()..color = skin.bodyColor..style = PaintingStyle.fill;
    final robeOutline = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5 * s
      ..strokeCap = StrokeCap.round;
    final robePath = Path()
      ..moveTo(-4 * s, 2 * s)
      ..quadraticBezierTo(-5 * s, 5 * s, -5 * s, 8 * s)
      ..quadraticBezierTo(0, 9 * s, 5 * s, 8 * s)
      ..quadraticBezierTo(5 * s, 5 * s, 4 * s, 2 * s)
      ..close();
    canvas.drawPath(robePath, robePaint);
    canvas.drawPath(robePath, robeOutline);

    final eyeSpacing = 3.3 * s;
    final eyeY = -1.4 * s;

    if (pose == SupTechPose.working) {
      drawSupTechFocusedEyes(canvas, s, eyeY, eyeSpacing);
    } else {
      drawSupTechEyes(canvas, skin, s, eyeY, eyeSpacing, 1.4 * s, SupTechExpression.neutral);
    }

    if (pose == SupTechPose.wave) {
      canvas.drawPath(
        Path()
          ..moveTo(-4 * s, 2 * s)
          ..quadraticBezierTo(-7 * s, 0, -8 * s, -3 * s),
        Paint()
          ..color = skin.bodyColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.25 * s
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(Offset(-8 * s, -3.5 * s), 1.2 * s, Paint()..color = skin.bodyColor);
      canvas.drawCircle(Offset(-8 * s, -3.5 * s), 1.2 * s, robeOutline);
      final wavePaint = Paint()
        ..color = skin.accentColor.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.4 * s
        ..strokeCap = StrokeCap.round;
      for (final i in [0, 1, 2]) {
        final radius = (3 + i * 1.5) * s;
        canvas.drawArc(
          Rect.fromCenter(center: Offset(-8 * s, -3.5 * s), width: radius * 2, height: radius * 2),
          -pi * 0.2, pi * 0.6, false, wavePaint,
        );
      }
    } else if (pose == SupTechPose.thinking) {
      final handPaint = Paint()..color = skin.bodyColor;
      final handY = 1.5 * s;
      canvas.drawOval(Rect.fromCenter(center: Offset(-2 * s, handY), width: 3 * s, height: 2.5 * s), handPaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(2 * s, handY), width: 3 * s, height: 2.5 * s), handPaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(0, handY + 1.5 * s), width: 4 * s, height: 3 * s), handPaint);
      canvas.drawOval(Rect.fromCenter(center: Offset(0, handY + 1.5 * s), width: 4 * s, height: 3 * s), robeOutline);
    } else if (pose == SupTechPose.working) {
      final screenY = -1 * s;
      final screenRect = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(0, screenY), width: 16 * s, height: 11 * s),
        Radius.circular(1.2 * s),
      );
      final glowPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [skin.accentColor.withValues(alpha: 0.15), skin.accentColor.withValues(alpha: 0.05)],
        ).createShader(Rect.fromCenter(center: Offset(0, screenY), width: 16 * s, height: 11 * s));
      canvas.drawRRect(screenRect, glowPaint);
      canvas.drawRRect(
        screenRect,
        Paint()..color = skin.accentColor.withValues(alpha: 0.3)..style = PaintingStyle.stroke..strokeWidth = 0.4 * s,
      );
      final dataPaint = Paint()..color = skin.accentColor.withValues(alpha: 0.4)..strokeWidth = 0.3 * s;
      for (var row = 0; row < 3; row++) {
        for (var col = 0; col < 4; col++) {
          final x = (-6 + col * 4) * s;
          final y = (screenY - 3 + row * 3) * s;
          canvas.drawLine(Offset(x - 0.5 * s, y), Offset(x + 1.5 * s, y), dataPaint);
          canvas.drawLine(Offset(x, y - 0.3 * s), Offset(x, y + 0.3 * s), dataPaint);
        }
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PosePainter old) =>
      old.skin.id != skin.id || old.pose != pose;
}
