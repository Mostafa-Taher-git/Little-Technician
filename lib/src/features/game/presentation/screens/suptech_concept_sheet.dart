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
  SkinDefinition get skin => widget.skin;

  late SupTechExpression _selectedExpression;
  late SupTechHeadAccessory _selectedHeadAccessory;
  late SupTechEarAccessory _selectedEarAccessory;
  late SupTechChestAccessory _selectedChestAccessory;
  String _selectedPose = 'Neutral';

  @override
  void initState() {
    super.initState();
    _selectedExpression = SupTechExpression.neutral;
    _selectedHeadAccessory = skin.headAccessory;
    _selectedEarAccessory = skin.earAccessory;
    _selectedChestAccessory = skin.chestAccessory != SupTechChestAccessory.none
        ? skin.chestAccessory
        : (skin.showLogo ? SupTechChestAccessory.badge : SupTechChestAccessory.none);
  }

  void _selectExpression(SupTechExpression expr) {
    setState(() => _selectedExpression = expr);
  }

  void _selectHeadAccessory(SupTechHeadAccessory acc) {
    setState(() {
      _selectedHeadAccessory =
          _selectedHeadAccessory == acc ? SupTechHeadAccessory.none : acc;
    });
  }

  void _selectEarAccessory(SupTechEarAccessory acc) {
    setState(() {
      _selectedEarAccessory =
          _selectedEarAccessory == acc ? SupTechEarAccessory.none : acc;
    });
  }

  void _selectChestAccessory(SupTechChestAccessory acc) {
    setState(() {
      _selectedChestAccessory =
          _selectedChestAccessory == acc ? SupTechChestAccessory.none : acc;
    });
  }

  void _selectPose(String pose) {
    setState(() => _selectedPose = _selectedPose == pose ? 'Neutral' : pose);
  }

  bool _isAccessorySelected(
    SupTechHeadAccessory head,
    SupTechEarAccessory ear,
    SupTechChestAccessory chest,
  ) {
    if (head != SupTechHeadAccessory.none) {
      return _selectedHeadAccessory == head;
    }
    if (ear != SupTechEarAccessory.none) {
      return _selectedEarAccessory == ear;
    }
    if (chest != SupTechChestAccessory.none) {
      return _selectedChestAccessory == chest;
    }
    return false;
  }

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
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _labeledPanel(
                'Traits',
                _buildTraitsSection(),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _labeledPanel(
                'Character',
                _buildMainCharacter(context),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _labeledPanel(
                'About',
                _buildAboutSection(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _labeledPanel(
          'Expressions',
          _buildExpressionsRow(context),
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 18),
        ),
        const SizedBox(height: 24),
        _labeledPanel(
          'Color Palette',
          _buildColorPalette(),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _labeledPanel(
                'Accessories',
                _buildAccessoriesSection(context),
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _labeledPanel(
                'Poses',
                _buildPosesSection(context),
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
        _labeledPanel('Traits', _buildTraitsSection()),
        const SizedBox(height: 20),
        _labeledPanel('Character', _buildMainCharacter(context)),
        const SizedBox(height: 20),
        _labeledPanel('About', _buildAboutSection()),
        const SizedBox(height: 20),
        _labeledPanel(
          'Expressions',
          _buildExpressionsRow(context),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        ),
        const SizedBox(height: 20),
        _labeledPanel(
          'Color Palette',
          _buildColorPalette(),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        ),
        const SizedBox(height: 20),
        _labeledPanel(
          'Accessories',
          _buildAccessoriesSection(context),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        ),
        const SizedBox(height: 20),
        _labeledPanel(
          'Poses',
          _buildPosesSection(context),
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
        ),
      ],
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

  Widget _buildMainCharacter(BuildContext context) {
    final maxWidth = min(280.0, MediaQuery.sizeOf(context).width - 36);
    final height = maxWidth * (516 / 386);
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: maxWidth,
        height: height,
        child: CustomPaint(
          painter: _InteractiveConceptPainter(
            skin: skin,
            expression: _selectedExpression,
            headAccessory: _selectedHeadAccessory,
            earAccessory: _selectedEarAccessory,
            chestAccessory: _selectedChestAccessory,
            pose: _selectedPose,
          ),
          size: Size(maxWidth, height),
        ),
      ),
    );
  }

  Widget _buildExpressionsRow(BuildContext context) {
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
                child: _expressionCard(expressions[i]),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _expressionCard(SupTechExpression expr) {
    final isSelected = expr == _selectedExpression;
    return GestureDetector(
      onTap: () => _selectExpression(expr),
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
              blurRadius: 10,
              offset: const Offset(0, 4),
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
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF4777EA)
                    : const Color(0xFF6B7A90),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessoriesSection(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _accessoryItem('Antenna', 'antenna', SupTechHeadAccessory.antenna, SupTechEarAccessory.none, SupTechChestAccessory.none),
      _accessoryItem('Badge', 'badge', SupTechHeadAccessory.none, SupTechEarAccessory.none, SupTechChestAccessory.badge),
      _accessoryItem('Headset', 'headset', SupTechHeadAccessory.none, SupTechEarAccessory.headset, SupTechChestAccessory.none),
    ],
  );

  Widget _accessoryItem(
    String label,
    String type,
    SupTechHeadAccessory head,
    SupTechEarAccessory ear,
    SupTechChestAccessory chest,
  ) {
    final isSelected = _isAccessorySelected(head, ear, chest);
    return GestureDetector(
      onTap: () {
        if (head != SupTechHeadAccessory.none) _selectHeadAccessory(head);
        if (ear != SupTechEarAccessory.none) _selectEarAccessory(ear);
        if (chest != SupTechChestAccessory.none) _selectChestAccessory(chest);
      },
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
              width: 90,
              height: 88,
              child: CustomPaint(
                painter: _AccessoryPainter(skin: skin, type: type),
                size: const Size(90, 88),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF4777EA)
                    : const Color(0xFF45536A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPosesSection(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _poseItem('Wave'),
      _poseItem('Thinking'),
      _poseItem('Working'),
    ],
  );

  Widget _poseItem(String label) {
    final isSelected = _selectedPose == label;
    return GestureDetector(
      onTap: () => _selectPose(label),
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
              width: 90,
              height: 88,
              child: CustomPaint(
                painter: _PosePainter(skin: skin, label: label),
                size: const Size(90, 88),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF4777EA)
                    : const Color(0xFF45536A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _expressionName(SupTechExpression e) => switch (e) {
    SupTechExpression.neutral => 'Neutral', SupTechExpression.happy => 'Happy',
    SupTechExpression.angry => 'Angry', SupTechExpression.surprised => 'Surprised',
    SupTechExpression.determined => 'Determined', SupTechExpression.wink => 'Wink',
    SupTechExpression.sleep => 'Sleep', SupTechExpression.error => 'Error',
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
  final String pose;

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

    // Ambient glow behind character
    canvas.drawCircle(
      Offset.zero,
      42 * s,
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
      ..strokeWidth = 2.5 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // DROP SHADOW
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, 16 * s), width: 22 * s, height: 2.5 * s),
      Paint()..color = Colors.black.withValues(alpha: 0.10),
    );

    // ROBE BODY
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

    // Glow at robe bottom and cuff accents
    canvas.drawOval(
      Rect.fromCenter(center: Offset(0, 13.5 * s), width: 20 * s, height: 4 * s),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            skin.accentColor.withValues(alpha: 0.0),
            skin.accentColor,
          ],
        ).createShader(Rect.fromCenter(center: Offset(0, 13.5 * s), width: 20 * s, height: 4 * s))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    final cuffPaint = Paint()
      ..color = skin.accentColor.withValues(alpha: 0.85)
      ..strokeWidth = 1.2 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(-8 * s, 0), Offset(-10.5 * s, 4 * s), cuffPaint);
    canvas.drawLine(Offset(8 * s, 0), Offset(10.5 * s, 4 * s), cuffPaint);

    // HOOD
    final hoodPath = Path()
      ..moveTo(-13 * s, -3 * s)
      ..cubicTo(-13 * s, -18 * s, -10 * s, -27 * s, 0, -28 * s)
      ..cubicTo(10 * s, -27 * s, 13 * s, -18 * s, 13 * s, -3 * s)
      ..quadraticBezierTo(7 * s, 1 * s, 0, -0.5 * s)
      ..quadraticBezierTo(-7 * s, 1 * s, -13 * s, -3 * s)
      ..close();
    canvas.drawPath(hoodPath, bodyPaint);
    canvas.drawPath(hoodPath, outlinePaint);

    // Hood tab color based on head accessory
    final stripeColor = headAccessory == SupTechHeadAccessory.antenna
        ? skin.accentColor
        : headAccessory == SupTechHeadAccessory.crown
            ? const Color(0xFFFCD34D)
            : headAccessory == SupTechHeadAccessory.wizardHat
                ? const Color(0xFFF59E0B)
                : headAccessory == SupTechHeadAccessory.ninjaHeadband
                    ? skin.bodyColor
                    : headAccessory == SupTechHeadAccessory.visor
                        ? const Color(0xFF334155)
                        : headAccessory == SupTechHeadAccessory.horns
                            ? const Color(0xFF7C3AED)
                            : headAccessory == SupTechHeadAccessory.crest
                                ? const Color(0xFF4338CA)
                                : const Color(0xFF2D3748);
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
        ..strokeWidth = 1.5 * s
        ..strokeCap = StrokeCap.round,
    );

    // FACE
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

    // EYES based on expression (Working pose uses focused eyes)
    final eyeY = -8.5 * s;
    final eyeSpacing = 5.2 * s;
    if (pose == 'Working') {
      _drawFocusedEyes(canvas, s, eyeY, eyeSpacing);
    } else {
      _drawReferenceEyes(
        canvas,
        s,
        expression,
        eyeY,
        eyeSpacing,
        skin.accentColor,
        large: true,
      );
    }

    _drawConceptHeadAccessory(canvas, s, skin, headAccessory, outlinePaint);
    _drawConceptEarAccessory(canvas, s, skin, earAccessory);
    _drawConceptChestAccessory(canvas, s, skin, chestAccessory);

    // POSE overlays
    if (pose == 'Wave') {
      canvas.drawPath(
        Path()
          ..moveTo(-8 * s, -15 * s)
          ..quadraticBezierTo(-12 * s, -20 * s, -14 * s, -25 * s),
        Paint()
          ..color = skin.bodyColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 * s
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(Offset(-14 * s, -27 * s), 1.2 * s, Paint()..color = skin.bodyColor);
      canvas.drawCircle(Offset(-14 * s, -27 * s), 1.2 * s, outlinePaint);
      final wavePaint = Paint()
        ..color = skin.accentColor.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8 * s
        ..strokeCap = StrokeCap.round;
      for (final i in [0, 1, 2]) {
        final radius = (3 + i * 1.5) * s;
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(-14 * s, -27 * s),
            width: radius * 2,
            height: radius * 2,
          ),
          -pi * 0.2,
          pi * 0.6,
          false,
          wavePaint,
        );
      }
    } else if (pose == 'Thinking') {
      _drawClaspedHands(canvas, s, skin.bodyColor, outlinePaint, y: -11 * s);
    } else if (pose == 'Working') {
      _drawHolographicScreen(canvas, s, skin.accentColor, outlinePaint, y: -14 * s);
    }

    canvas.restore();
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

void _drawGlowingOvalEye(
  Canvas canvas,
  Offset center,
  double s, {
  required double rx,
  required double ry,
  required Color glowColor,
}) {
  canvas.drawOval(
    Rect.fromCenter(
      center: center,
      width: (rx + 2.5 * s) * 2,
      height: (ry + 2.5 * s) * 2,
    ),
    Paint()
      ..shader = RadialGradient(colors: [
        glowColor.withValues(alpha: 0.35),
        glowColor.withValues(alpha: 0.0),
      ]).createShader(Rect.fromCircle(center: center, radius: (rx + 2.5 * s))),
  );
  canvas.drawOval(
    Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
    Paint()..color = Colors.white,
  );
}

void _drawReferenceEyes(
  Canvas canvas,
  double s,
  SupTechExpression expression,
  double eyeY,
  double eyeSpacing,
  Color glowColor, {
  bool large = false,
}) {
  final rx = large ? 1.8 * s : 1.0 * s;
  final ry = large ? 3.1 * s : 1.4 * s;
  final stroke = large ? 2.0 * s : 1.4 * s;

  switch (expression) {
    case SupTechExpression.neutral:
      for (final dx in [-eyeSpacing, eyeSpacing]) {
        _drawGlowingOvalEye(canvas, Offset(dx, eyeY), s, rx: rx, ry: ry, glowColor: glowColor);
      }
    case SupTechExpression.happy:
      final arcPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;
      for (final dx in [-eyeSpacing, eyeSpacing]) {
        canvas.drawPath(
          Path()
            ..moveTo(dx - 2.5 * s, eyeY + 0.5 * s)
            ..quadraticBezierTo(dx, eyeY - 2.0 * s, dx + 2.5 * s, eyeY + 0.5 * s),
          arcPaint,
        );
      }
    case SupTechExpression.angry:
      for (final dx in [-eyeSpacing, eyeSpacing]) {
        canvas.save();
        canvas.translate(dx, eyeY);
        canvas.rotate(dx < 0 ? 0.35 : -0.35);
        _drawGlowingOvalEye(canvas, Offset.zero, s, rx: rx * 0.9, ry: ry * 0.85, glowColor: glowColor);
        canvas.restore();
      }
    case SupTechExpression.surprised:
      for (final dx in [-eyeSpacing, eyeSpacing]) {
        canvas.drawCircle(Offset(dx, eyeY), large ? 1.6 * s : 0.9 * s, Paint()..color = Colors.white);
        canvas.drawLine(
          Offset(dx - 1.5 * s, eyeY - 2.8 * s),
          Offset(dx + 1.5 * s, eyeY - 2.8 * s),
          Paint()
            ..color = Colors.white
            ..strokeWidth = large ? 1.0 * s : 0.6 * s
            ..strokeCap = StrokeCap.round,
        );
      }
    case SupTechExpression.determined:
      for (final dx in [-eyeSpacing, eyeSpacing]) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(dx, eyeY),
              width: large ? 5 * s : 3 * s,
              height: large ? 1.4 * s : 0.8 * s,
            ),
            Radius.circular(0.6 * s),
          ),
          Paint()..color = Colors.white,
        );
      }
    case SupTechExpression.wink:
      canvas.drawPath(
        Path()
          ..moveTo(-eyeSpacing - 2.5 * s, eyeY)
          ..quadraticBezierTo(-eyeSpacing, eyeY - 1.2 * s, -eyeSpacing + 2.5 * s, eyeY),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(
        Offset(eyeSpacing, eyeY),
        large ? 1.6 * s : 0.9 * s,
        Paint()..color = Colors.white,
      );
    case SupTechExpression.sleep:
      final linePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;
      for (final dx in [-eyeSpacing, eyeSpacing]) {
        canvas.drawLine(Offset(dx - 2.5 * s, eyeY), Offset(dx + 2.5 * s, eyeY), linePaint);
      }
    case SupTechExpression.error:
      final xPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round;
      for (final dx in [-eyeSpacing, eyeSpacing]) {
        canvas.drawLine(Offset(dx - 1.5 * s, eyeY - 1.5 * s), Offset(dx + 1.5 * s, eyeY + 1.5 * s), xPaint);
        canvas.drawLine(Offset(dx + 1.5 * s, eyeY - 1.5 * s), Offset(dx - 1.5 * s, eyeY + 1.5 * s), xPaint);
      }
  }
}

void _drawFocusedEyes(Canvas canvas, double s, double eyeY, double eyeSpacing) {
  final eyePaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.8 * s
    ..strokeCap = StrokeCap.round;
  canvas.drawLine(
    Offset(-eyeSpacing - 2 * s, eyeY - 0.5 * s),
    Offset(-eyeSpacing + 2 * s, eyeY + 0.5 * s),
    eyePaint,
  );
  canvas.drawLine(
    Offset(eyeSpacing - 2 * s, eyeY - 0.5 * s),
    Offset(eyeSpacing + 2 * s, eyeY + 0.5 * s),
    eyePaint,
  );
}

void _drawClaspedHands(
  Canvas canvas,
  double s,
  Color bodyColor,
  Paint outlinePaint, {
  required double y,
}) {
  final handPaint = Paint()..color = bodyColor;
  canvas.drawOval(
    Rect.fromCenter(center: Offset(-2 * s, y), width: 3 * s, height: 2.5 * s),
    handPaint,
  );
  canvas.drawOval(
    Rect.fromCenter(center: Offset(2 * s, y), width: 3 * s, height: 2.5 * s),
    handPaint,
  );
  canvas.drawOval(
    Rect.fromCenter(center: Offset(0, y + 1.5 * s), width: 4 * s, height: 3 * s),
    handPaint,
  );
  canvas.drawOval(
    Rect.fromCenter(center: Offset(0, y + 1.5 * s), width: 4 * s, height: 3 * s),
    outlinePaint,
  );
}

void _drawHolographicScreen(
  Canvas canvas,
  double s,
  Color accentColor,
  Paint outlinePaint, {
  required double y,
}) {
  final screenRect = RRect.fromRectAndRadius(
    Rect.fromCenter(center: Offset(0, y), width: 16 * s, height: 11 * s),
    Radius.circular(1.2 * s),
  );
  canvas.drawRRect(
    screenRect,
    Paint()..color = accentColor.withValues(alpha: 0.18),
  );
  canvas.drawRRect(
    screenRect,
    Paint()
      ..color = outlinePaint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 * s,
  );
  for (final lineY in [y - 3 * s, y, y + 3 * s]) {
    canvas.drawLine(
      Offset(-5 * s, lineY),
      Offset(5 * s, lineY),
      Paint()
        ..color = accentColor.withValues(alpha: 0.45)
        ..strokeWidth = 0.7 * s,
    );
  }
}

void _drawConceptHeadAccessory(
  Canvas canvas,
  double s,
  SkinDefinition skin,
  SupTechHeadAccessory accessory,
  Paint outlinePaint,
) {
  switch (accessory) {
    case SupTechHeadAccessory.none:
      break;
    case SupTechHeadAccessory.antenna:
      canvas.drawLine(
        Offset(0, -27 * s),
        Offset(0, -31 * s),
        Paint()
          ..color = skin.accentColor
          ..strokeWidth = 1.2 * s
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(
        Offset(0, -32 * s),
        1.0 * s,
        Paint()..color = skin.accentColor,
      );
    case SupTechHeadAccessory.crown:
      final crown = Path()
        ..moveTo(-5 * s, -26 * s)
        ..lineTo(-4 * s, -31 * s)
        ..lineTo(-2 * s, -28 * s)
        ..lineTo(0, -33 * s)
        ..lineTo(2 * s, -28 * s)
        ..lineTo(4 * s, -31 * s)
        ..lineTo(5 * s, -26 * s);
      canvas.drawPath(crown, Paint()..color = skin.accentColor);
      canvas.drawPath(crown, outlinePaint);
    case SupTechHeadAccessory.wizardHat:
      final cone = Path()
        ..moveTo(-5 * s, -26 * s)
        ..lineTo(5 * s, -26 * s)
        ..lineTo(0, -36 * s);
      canvas.drawPath(cone, Paint()..color = const Color(0xFF1E293B));
      canvas.drawPath(cone, outlinePaint);
      canvas.drawRect(
        Rect.fromLTWH(-5 * s, -27 * s, 10 * s, 2 * s),
        Paint()..color = skin.accentColor,
      );
    case SupTechHeadAccessory.ninjaHeadband:
      canvas.drawRect(
        Rect.fromLTWH(-12 * s, -12 * s, 24 * s, 2.5 * s),
        Paint()..color = skin.accentColor,
      );
    case SupTechHeadAccessory.visor:
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(0, -7 * s), width: 18 * s, height: 5 * s),
          Radius.circular(2 * s),
        ),
        Paint()..color = skin.accentColor.withValues(alpha: 0.75),
      );
    case SupTechHeadAccessory.horns:
      for (final dir in [-1, 1]) {
        final horn = Path()
          ..moveTo(dir * 4 * s, -24 * s)
          ..quadraticBezierTo(dir * 7 * s, -30 * s, dir * 5 * s, -34 * s);
        canvas.drawPath(horn, Paint()..color = skin.accentColor..style = PaintingStyle.stroke..strokeWidth = 2 * s..strokeCap = StrokeCap.round);
      }
    case SupTechHeadAccessory.crest:
      final crest = Path()
        ..moveTo(0, -34 * s)
        ..lineTo(-2.5 * s, -26 * s)
        ..lineTo(0, -28 * s)
        ..lineTo(2.5 * s, -26 * s);
      canvas.drawPath(crest, Paint()..color = skin.accentColor);
      canvas.drawPath(crest, outlinePaint);
  }
}

void _drawConceptEarAccessory(
  Canvas canvas,
  double s,
  SkinDefinition skin,
  SupTechEarAccessory accessory,
) {
  switch (accessory) {
    case SupTechEarAccessory.none:
      break;
    case SupTechEarAccessory.headset:
      for (final dx in [-7 * s, 7 * s]) {
        canvas.drawOval(
          Rect.fromCenter(center: Offset(dx, -3 * s), width: 2.5 * s, height: 3.5 * s),
          Paint()..color = skin.accentColor.withValues(alpha: 0.85),
        );
        canvas.drawOval(
          Rect.fromCenter(center: Offset(dx, -3 * s), width: 2.5 * s, height: 3.5 * s),
          Paint()
            ..color = Colors.black87
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.8 * s,
        );
      }
      canvas.drawArc(
        Rect.fromCenter(center: Offset(0, -8 * s), width: 14 * s, height: 6 * s),
        pi,
        pi,
        false,
        Paint()
          ..color = skin.accentColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2 * s
          ..strokeCap = StrokeCap.round,
      );
    case SupTechEarAccessory.scarf:
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(-8 * s, -1 * s, 16 * s, 4 * s),
          Radius.circular(2 * s),
        ),
        Paint()..color = skin.accentColor,
      );
      canvas.drawPath(
        Path()
          ..moveTo(-8 * s, 2 * s)
          ..quadraticBezierTo(-11 * s, 8 * s, -9 * s, 12 * s),
        Paint()
          ..color = skin.accentColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 * s
          ..strokeCap = StrokeCap.round,
      );
    case SupTechEarAccessory.earGlow:
      for (final dx in [-5.5 * s, 5.5 * s]) {
        canvas.drawCircle(
          Offset(dx, -8.5 * s),
          2 * s,
          Paint()
            ..shader = RadialGradient(colors: [
              skin.accentColor,
              skin.accentColor.withValues(alpha: 0.0),
            ]).createShader(Rect.fromCircle(center: Offset(dx, -8.5 * s), radius: 2 * s)),
        );
      }
  }
}

void _drawConceptChestAccessory(
  Canvas canvas,
  double s,
  SkinDefinition skin,
  SupTechChestAccessory accessory,
) {
  final badgeCY = 5.0 * s;
  switch (accessory) {
    case SupTechChestAccessory.none:
      break;
    case SupTechChestAccessory.badge:
      canvas.drawOval(
        Rect.fromCenter(center: Offset(0, badgeCY), width: 14 * s, height: 10 * s),
        Paint()
          ..shader = RadialGradient(colors: [
            skin.accentColor.withValues(alpha: 0.35),
            skin.accentColor.withValues(alpha: 0.0),
          ]).createShader(Rect.fromCenter(center: Offset(0, badgeCY), width: 16 * s, height: 12 * s)),
      );
      final stSpan = TextSpan(
        text: 'ST',
        style: TextStyle(
          fontSize: 10 * s,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          shadows: [
            Shadow(color: skin.accentColor, blurRadius: 6 * s),
            Shadow(color: skin.accentColor, blurRadius: 2 * s),
          ],
        ),
      );
      final stPainter = TextPainter(text: stSpan, textDirection: TextDirection.ltr)..layout();
      stPainter.paint(canvas, Offset(-stPainter.width / 2, badgeCY - stPainter.height / 2));
    case SupTechChestAccessory.cape:
      final cape = Path()
        ..moveTo(-6 * s, 0)
        ..lineTo(-9 * s, 12 * s)
        ..lineTo(9 * s, 12 * s)
        ..lineTo(6 * s, 0);
      canvas.drawPath(cape, Paint()..color = skin.bodyColor.withValues(alpha: 0.75));
    case SupTechChestAccessory.codeScroll:
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(0, badgeCY), width: 8 * s, height: 10 * s),
          Radius.circular(1 * s),
        ),
        Paint()..color = const Color(0xFFF8FAFC),
      );
      canvas.drawLine(
        Offset(-2 * s, badgeCY - 3 * s),
        Offset(2 * s, badgeCY - 3 * s),
        Paint()..color = skin.accentColor..strokeWidth = 0.8 * s,
      );
      canvas.drawLine(
        Offset(-2 * s, badgeCY),
        Offset(2 * s, badgeCY),
        Paint()..color = skin.accentColor..strokeWidth = 0.8 * s,
      );
    case SupTechChestAccessory.gear:
      canvas.drawCircle(
        Offset(0, badgeCY),
        3 * s,
        Paint()..color = skin.accentColor.withValues(alpha: 0.25),
      );
      for (var i = 0; i < 6; i++) {
        final angle = i * pi / 3;
        canvas.drawLine(
          Offset(0, badgeCY),
          Offset(cos(angle) * 4 * s, badgeCY + sin(angle) * 4 * s),
          Paint()..color = skin.accentColor..strokeWidth = 1.2 * s,
        );
      }
    case SupTechChestAccessory.flameEmblem:
      final flame = Path()
        ..moveTo(0, badgeCY - 4 * s)
        ..quadraticBezierTo(-3 * s, badgeCY, 0, badgeCY + 4 * s)
        ..quadraticBezierTo(3 * s, badgeCY, 0, badgeCY - 4 * s);
      canvas.drawPath(flame, Paint()..color = const Color(0xFFF97316));
    case SupTechChestAccessory.staff:
      canvas.drawLine(
        Offset(10 * s, -10 * s),
        Offset(10 * s, 8 * s),
        Paint()
          ..color = const Color(0xFF92400E)
          ..strokeWidth = 1.5 * s
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(
        Offset(10 * s, -11 * s),
        2 * s,
        Paint()..color = skin.accentColor,
      );
  }
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

    _drawReferenceEyes(
      canvas,
      s,
      expression,
      eyeY,
      eyeSpacing,
      skin.accentColor,
    );

    canvas.restore();
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
  final SkinDefinition skin;
  final String label;
  _PosePainter({required this.skin, required this.label});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    canvas.save();
    final s = size.width / 20;
    canvas.translate(size.width / 2, size.height / 2 + 2 * s);

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

    final eyeSpacing = 3.3 * s;
    final eyeY = -1.4 * s;

    if (label == 'Working') {
      _drawFocusedEyes(canvas, s, eyeY, eyeSpacing);
    } else {
      _drawReferenceEyes(
        canvas,
        s,
        SupTechExpression.neutral,
        eyeY,
        eyeSpacing,
        skin.accentColor,
      );
    }

    if (label == 'Wave') {
      canvas.drawPath(
        Path()
          ..moveTo(-4 * s, 2 * s)
          ..quadraticBezierTo(-7 * s, 0, -8 * s, -3 * s),
        Paint()
          ..color = skin.bodyColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5 * s
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(Offset(-8 * s, -3.5 * s), 1.2 * s, Paint()..color = skin.bodyColor);
      canvas.drawCircle(Offset(-8 * s, -3.5 * s), 1.2 * s, robeOutline);
      final wavePaint = Paint()
        ..color = skin.accentColor.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8 * s
        ..strokeCap = StrokeCap.round;
      for (final i in [0, 1, 2]) {
        final radius = (3 + i * 1.5) * s;
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(-8 * s, -3.5 * s),
            width: radius * 2,
            height: radius * 2,
          ),
          -pi * 0.2,
          pi * 0.6,
          false,
          wavePaint,
        );
      }
    } else if (label == 'Thinking') {
      _drawClaspedHands(canvas, s, skin.bodyColor, robeOutline, y: 1.5 * s);
    } else if (label == 'Working') {
      _drawHolographicScreen(canvas, s, skin.accentColor, robeOutline, y: -1 * s);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PosePainter old) =>
      old.skin.id != skin.id || old.label != label;
}
