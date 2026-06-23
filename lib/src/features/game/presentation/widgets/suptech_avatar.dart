import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:littletech/src/features/game/constants/skin_tiers.dart';
import 'package:littletech/src/features/game/domain/cubit/game_cubit.dart';

class SupTechAvatar extends StatefulWidget {
  final bool isGlowing;
  final double size;
  final bool isCasting;
  final VoidCallback? onTap;
  final String? skinId;

  const SupTechAvatar({
    super.key,
    this.isGlowing = true,
    this.size = 40,
    this.isCasting = false,
    this.onTap,
    this.skinId,
  });

  @override
  State<SupTechAvatar> createState() => _SupTechAvatarState();
}

class _SupTechAvatarState extends State<SupTechAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  bool _isBlinking = false;
  Timer? _blinkTimer;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _floatAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOutSine),
    );
    _startBlinkTimer();
  }

  void _startBlinkTimer() {
    _blinkTimer = Timer.periodic(const Duration(milliseconds: 3500), (_) {
      if (!mounted) return;
      setState(() => _isBlinking = true);
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) setState(() => _isBlinking = false);
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_floatController.isAnimating && mounted) {
      _floatController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant SupTechAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_floatController.isAnimating && mounted) {
      _floatController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final skinId = widget.skinId ?? context.read<GameCubit>().state.progress.activeSkinId;
    final skin = SkinTierManager.getActiveSkin(skinId);

    final avatar = AnimatedBuilder(
      animation: _floatController,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: CustomPaint(
            size: Size(size, size),
            painter: _ChibiPainter(
              skin: skin,
              isBlinking: _isBlinking,
            ),
          ),
        );
      },
    );

    if (widget.onTap != null) {
      return GestureDetector(onTap: widget.onTap, child: avatar);
    }
    return avatar;
  }
}

class _ChibiPainter extends CustomPainter {
  final SkinDefinition skin;
  final bool isBlinking;

  _ChibiPainter({required this.skin, this.isBlinking = false});

  static const _outline = Color(0xFF1A1A1A);
  static const _outlineWidth = 2.5;
  static const _stickerWidth = 5.0;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 60;
    canvas.translate(size.width / 2, size.height / 2);

    // 1. White sticker border
    _drawStickerBorder(canvas, s);
    // 2. Black outlines + flat fills
    _drawBody(canvas, s);
    _drawLegs(canvas, s);
    _drawArms(canvas, s);
    _drawHead(canvas, s);
    _drawEyes(canvas, s);
    _drawMouth(canvas, s);
    _drawAccessory(canvas, s);
  }

  void _drawStickerBorder(Canvas canvas, double s) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stickerWidth * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Head
    canvas.drawCircle(Offset(0, -10 * s), 12 * s, paint);
    // Body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(-8 * s, -2 * s, 16 * s, 22 * s),
      Radius.circular(4 * s),
    );
    canvas.drawRRect(bodyRect, paint);
    // Arms
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-13 * s, 1 * s, 5 * s, 13 * s),
        Radius.circular(2.5 * s),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(8 * s, 1 * s, 5 * s, 13 * s),
        Radius.circular(2.5 * s),
      ),
      paint,
    );
    // Legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-6 * s, 20 * s, 4 * s, 7 * s),
        Radius.circular(2 * s),
      ),
      paint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2 * s, 20 * s, 4 * s, 7 * s),
        Radius.circular(2 * s),
      ),
      paint,
    );
    // Accessory sticker extensions
    _drawAccessoryStickerBorder(canvas, s, paint);
  }

  void _drawBody(Canvas canvas, double s) {
    // Flat fill
    final fillPaint = Paint()..color = skin.bodyColor;
    final outlinePaint = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = _outlineWidth * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(-8 * s, -2 * s, 16 * s, 22 * s),
      Radius.circular(4 * s),
    );
    canvas.drawRRect(bodyRect, fillPaint);
    canvas.drawRRect(bodyRect, outlinePaint);
  }

  void _drawLegs(Canvas canvas, double s) {
    final fillPaint = Paint()..color = skin.accentColor;
    final outlinePaint = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = _outlineWidth * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final dx in [-6.0, 2.0]) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(dx * s, 20 * s, 4 * s, 7 * s),
        Radius.circular(2 * s),
      );
      canvas.drawRRect(rect, fillPaint);
      canvas.drawRRect(rect, outlinePaint);
    }
  }

  void _drawArms(Canvas canvas, double s) {
    final fillPaint = Paint()..color = skin.bodyColor;
    final outlinePaint = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = _outlineWidth * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (final dx in [-13.0, 8.0]) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(dx * s, 1 * s, 5 * s, 13 * s),
        Radius.circular(2.5 * s),
      );
      canvas.drawRRect(rect, fillPaint);
      canvas.drawRRect(rect, outlinePaint);
    }
  }

  void _drawHead(Canvas canvas, double s) {
    final fillPaint = Paint()..color = skin.bodyColor;
    final outlinePaint = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = _outlineWidth * s
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(Offset(0, -10 * s), 12 * s, fillPaint);
    canvas.drawCircle(Offset(0, -10 * s), 12 * s, outlinePaint);
  }

  void _drawEyes(Canvas canvas, double s) {
    if (isBlinking) {
      // Blink: horizontal lines
      final linePaint = Paint()
        ..color = _outline
        ..strokeWidth = 2 * s
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(
        Offset(-6 * s, -11 * s),
        Offset(-2 * s, -11 * s),
        linePaint,
      );
      canvas.drawLine(
        Offset(2 * s, -11 * s),
        Offset(6 * s, -11 * s),
        linePaint,
      );
      return;
    }

    // Open eyes: black dots with white highlights
    final eyePaint = Paint()..color = _outline;
    final highlightPaint = Paint()..color = Colors.white;

    for (final dx in [-4.0, 4.0]) {
      canvas.drawCircle(Offset(dx * s, -11 * s), 2.5 * s, eyePaint);
      canvas.drawCircle(Offset((dx + 1) * s, -12 * s), 1 * s, highlightPaint);
    }
  }

  void _drawMouth(Canvas canvas, double s) {
    final mouthPaint = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(-3 * s, -5 * s)
      ..quadraticBezierTo(0, -3 * s, 3 * s, -5 * s);
    canvas.drawPath(path, mouthPaint);
  }

  void _drawAccessory(Canvas canvas, double s) {
    switch (skin.accessory) {
      case SupTechAccessory.none:
        break;
      case SupTechAccessory.antenna:
        _drawAntenna(canvas, s);
      case SupTechAccessory.headband:
        _drawHeadband(canvas, s);
      case SupTechAccessory.pointedHat:
        _drawPointedHat(canvas, s);
      case SupTechAccessory.crown:
        _drawCrown(canvas, s);
      case SupTechAccessory.visor:
        _drawVisor(canvas, s);
      case SupTechAccessory.gear:
        _drawGear(canvas, s);
      case SupTechAccessory.cape:
        _drawCape(canvas, s);
    }
  }

  void _drawAccessoryStickerBorder(Canvas canvas, double s, Paint paint) {
    switch (skin.accessory) {
      case SupTechAccessory.none:
        break;
      case SupTechAccessory.antenna:
        // Line + circle
        canvas.drawLine(Offset(0, -22 * s), Offset(0, -30 * s), paint);
        canvas.drawCircle(Offset(0, -31 * s), 2.5 * s, paint);
      case SupTechAccessory.headband:
        canvas.drawRect(Rect.fromLTWH(-11 * s, -19 * s, 22 * s, 3.5 * s), paint);
      case SupTechAccessory.pointedHat:
        final hatPath = Path()
          ..moveTo(-11 * s, -20 * s)
          ..lineTo(11 * s, -20 * s)
          ..lineTo(1 * s, -36 * s)
          ..close();
        canvas.drawPath(hatPath, paint);
      case SupTechAccessory.crown:
        final crownPath = Path()
          ..moveTo(-7 * s, -21 * s)
          ..lineTo(-5 * s, -28 * s)
          ..lineTo(-1 * s, -24 * s)
          ..lineTo(1 * s, -30 * s)
          ..lineTo(3 * s, -24 * s)
          ..lineTo(5 * s, -28 * s)
          ..lineTo(7 * s, -21 * s)
          ..close();
        canvas.drawPath(crownPath, paint);
      case SupTechAccessory.visor:
        canvas.drawRect(Rect.fromLTWH(-9 * s, -14 * s, 18 * s, 4 * s), paint);
      case SupTechAccessory.gear:
        canvas.drawCircle(Offset(0, 8 * s), 5 * s, paint);
      case SupTechAccessory.cape:
        final capePath = Path()
          ..moveTo(-8 * s, -2 * s)
          ..lineTo(-14 * s, 22 * s)
          ..lineTo(-6 * s, 22 * s)
          ..lineTo(-6 * s, -2 * s)
          ..close();
        canvas.drawPath(capePath, paint);
        final capePath2 = Path()
          ..moveTo(8 * s, -2 * s)
          ..lineTo(14 * s, 22 * s)
          ..lineTo(6 * s, 22 * s)
          ..lineTo(6 * s, -2 * s)
          ..close();
        canvas.drawPath(capePath2, paint);
    }
  }

  void _drawAntenna(Canvas canvas, double s) {
    final linePaint = Paint()
      ..color = _outline
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, -22 * s), Offset(0, -30 * s), linePaint);

    final fillPaint = Paint()..color = skin.accentColor;
    final outlinePaint = Paint()
      ..color = _outline
      ..strokeWidth = _outlineWidth * s;
    canvas.drawCircle(Offset(0, -31 * s), 2.5 * s, fillPaint);
    canvas.drawCircle(Offset(0, -31 * s), 2.5 * s, outlinePaint);
  }

  void _drawHeadband(Canvas canvas, double s) {
    final fillPaint = Paint()..color = skin.accentColor;
    final outlinePaint = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = _outlineWidth * s;

    final rect = Rect.fromLTWH(-11 * s, -19 * s, 22 * s, 3.5 * s);
    canvas.drawRect(rect, fillPaint);
    canvas.drawRect(rect, outlinePaint);

    // Knot tails on right side
    final tailPaint = Paint()
      ..color = skin.accentColor
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(10 * s, -17 * s), Offset(14 * s, -14 * s), tailPaint);
    canvas.drawLine(Offset(10 * s, -17 * s), Offset(13 * s, -20 * s), tailPaint);
  }

  void _drawPointedHat(Canvas canvas, double s) {
    final fillPaint = Paint()..color = skin.bodyColor;
    final outlinePaint = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = _outlineWidth * s
      ..strokeJoin = StrokeJoin.round;

    final hatPath = Path()
      ..moveTo(-11 * s, -20 * s)
      ..lineTo(11 * s, -20 * s)
      ..lineTo(1 * s, -36 * s)
      ..close();
    canvas.drawPath(hatPath, fillPaint);
    canvas.drawPath(hatPath, outlinePaint);

    // Accent band
    final bandPaint = Paint()..color = skin.accentColor;
    canvas.drawRect(Rect.fromLTWH(-10 * s, -21 * s, 20 * s, 3 * s), bandPaint);
    final bandOutline = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    canvas.drawRect(Rect.fromLTWH(-10 * s, -21 * s, 20 * s, 3 * s), bandOutline);
  }

  void _drawCrown(Canvas canvas, double s) {
    final fillPaint = Paint()..color = skin.accentColor;
    final outlinePaint = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = _outlineWidth * s
      ..strokeJoin = StrokeJoin.round;

    final crownPath = Path()
      ..moveTo(-7 * s, -21 * s)
      ..lineTo(-5 * s, -28 * s)
      ..lineTo(-1 * s, -24 * s)
      ..lineTo(1 * s, -30 * s)
      ..lineTo(3 * s, -24 * s)
      ..lineTo(5 * s, -28 * s)
      ..lineTo(7 * s, -21 * s)
      ..close();
    canvas.drawPath(crownPath, fillPaint);
    canvas.drawPath(crownPath, outlinePaint);

    // Jewel
    final jewelPaint = Paint()..color = skin.bodyColor;
    canvas.drawCircle(Offset(1 * s, -27 * s), 1.5 * s, jewelPaint);
  }

  void _drawVisor(Canvas canvas, double s) {
    final fillPaint = Paint()..color = skin.accentColor;
    final outlinePaint = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = _outlineWidth * s;

    final rect = Rect.fromLTWH(-9 * s, -14 * s, 18 * s, 4 * s);
    canvas.drawRect(rect, fillPaint);
    canvas.drawRect(rect, outlinePaint);

    // Center line
    final linePaint = Paint()
      ..color = _outline
      ..strokeWidth = 1 * s;
    canvas.drawLine(Offset(-8 * s, -12 * s), Offset(8 * s, -12 * s), linePaint);
  }

  void _drawGear(Canvas canvas, double s) {
    final fillPaint = Paint()..color = skin.accentColor;
    final outlinePaint = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = _outlineWidth * s;

    const teeth = 6;
    final outerR = 5 * s;
    final innerR = 3 * s;
    final gearPath = Path();
    for (var i = 0; i < teeth; i++) {
      final a1 = i * 2 * pi / teeth;
      final a2 = a1 + pi / teeth * 0.6;
      final a3 = a1 + pi / teeth;
      final a4 = a3 + pi / teeth * 0.6;
      if (i == 0) {
        gearPath.moveTo(cos(a1) * outerR, sin(a1) * outerR + 8 * s);
      }
      gearPath.lineTo(cos(a2) * outerR, sin(a2) * outerR + 8 * s);
      gearPath.lineTo(cos(a3) * innerR, sin(a3) * innerR + 8 * s);
      gearPath.lineTo(cos(a4) * innerR, sin(a4) * innerR + 8 * s);
    }
    gearPath.close();
    canvas.drawPath(gearPath, fillPaint);
    canvas.drawPath(gearPath, outlinePaint);

    // Center dot
    final centerPaint = Paint()..color = skin.bodyColor;
    canvas.drawCircle(Offset(0, 8 * s), 1.5 * s, centerPaint);
  }

  void _drawCape(Canvas canvas, double s) {
    final fillPaint = Paint()..color = skin.accentColor;
    final outlinePaint = Paint()
      ..color = _outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = _outlineWidth * s
      ..strokeJoin = StrokeJoin.round;

    // Left cape
    final leftPath = Path()
      ..moveTo(-8 * s, -2 * s)
      ..lineTo(-14 * s, 22 * s)
      ..lineTo(-6 * s, 22 * s)
      ..lineTo(-6 * s, -2 * s)
      ..close();
    canvas.drawPath(leftPath, fillPaint);
    canvas.drawPath(leftPath, outlinePaint);

    // Right cape
    final rightPath = Path()
      ..moveTo(8 * s, -2 * s)
      ..lineTo(14 * s, 22 * s)
      ..lineTo(6 * s, 22 * s)
      ..lineTo(6 * s, -2 * s)
      ..close();
    canvas.drawPath(rightPath, fillPaint);
    canvas.drawPath(rightPath, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant _ChibiPainter oldDelegate) {
    return oldDelegate.skin.id != skin.id ||
        oldDelegate.isBlinking != isBlinking;
  }
}
