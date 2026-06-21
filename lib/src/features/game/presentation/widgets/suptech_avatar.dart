import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _wandSwingAnimation;
  late Animation<double> _antennaBobAnimation;
  late Animation<double> _castAnimation;
  late Animation<double> _robeFlutter;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: 3000.ms,
    );

    _floatAnimation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _wandSwingAnimation = Tween<double>(begin: -0.08, end: 0.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _antennaBobAnimation = Tween<double>(begin: -0.05, end: 0.12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _castAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    _robeFlutter = Tween<double>(begin: 0.0, end: 4.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_controller.isAnimating && mounted) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant SupTechAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_controller.isAnimating && mounted) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    final isGlowing = widget.isGlowing;
    final scheme = Theme.of(context).colorScheme;
    final skinId = widget.skinId ?? context.read<GameCubit>().state.progress.activeSkinId;
    final skin = SkinTierManager.getActiveSkin(skinId);

    final avatar = AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: CustomPaint(
            size: Size(size, size),
            painter: _SupTechBodyPainter(
              scheme: scheme,
              isGlowing: isGlowing,
              isCasting: widget.isCasting,
              skin: skin,
              anim: _AnimationState(
                wandSwing: _wandSwingAnimation.value,
                antennaBob: _antennaBobAnimation.value,
                blinkPhase: _controller.value,
                castPhase: _castAnimation.value,
                robeFlutter: _robeFlutter.value,
              ),
            ),
          ),
        );
      },
    );

    final particles = isGlowing || widget.isCasting
        ? Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                size: Size(size, size),
                painter: _SparklePainter(
                  phase: _controller.value,
                  color: scheme.secondary,
                  intensity: widget.isCasting ? 1.0 : 0.5,
                ),
              ),
            ),
          )
        : null;

    final glowOverlay = isGlowing
        ? IgnorePointer(
            child: Container(
              width: size * 1.5,
              height: size * 1.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: scheme.secondary.withValues(alpha: 0.3),
                    blurRadius: size * 0.5,
                    spreadRadius: size * 0.15,
                  ),
                  BoxShadow(
                    color: scheme.tertiary.withValues(alpha: 0.15),
                    blurRadius: size * 0.8,
                    spreadRadius: size * 0.1,
                  ),
                ],
              ),
            ),
          )
        : null;

    final layered = Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        if (glowOverlay != null) glowOverlay,
        if (particles != null) particles,
        avatar,
      ],
    );

    final result = isGlowing
        ? layered
            .animate(onPlay: (c) => c.repeat())
            .shimmer(duration: 1500.ms, color: Colors.white.withValues(alpha: 0.15))
        : layered;

    if (widget.onTap != null) {
      return GestureDetector(onTap: widget.onTap, child: result);
    }
    return result;
  }
}

class _AnimationState {
  final double wandSwing;
  final double antennaBob;
  final double blinkPhase;
  final double castPhase;
  final double robeFlutter;

  const _AnimationState({
    this.wandSwing = 0.0,
    this.antennaBob = 0.0,
    this.blinkPhase = 0.0,
    this.castPhase = 0.0,
    this.robeFlutter = 0.0,
  });
}

class _SupTechBodyPainter extends CustomPainter {
  final ColorScheme scheme;
  final bool isGlowing;
  final bool isCasting;
  final SkinDefinition skin;
  final _AnimationState anim;

  _SupTechBodyPainter({
    required this.scheme,
    required this.isGlowing,
    this.isCasting = false,
    SkinDefinition? skin,
    _AnimationState? anim,
  }) : skin = skin ?? SkinTierManager.skins.first,
       anim = anim ?? const _AnimationState();

  Color get _robeColor => isGlowing ? skin.robeColor.withValues(alpha: 0.9) : skin.robeColor;
  Color get _trimColor => isGlowing ? skin.trimColor : skin.trimColor.withValues(alpha: 0.7);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final s = size.width / 60;

    canvas.save();
    canvas.translate(cx, cy);

    if (skin.hasCape) _drawCape(canvas, s);
    _drawRobe(canvas, s);
    if (skin.hasGearEmblem) _drawGearEmblem(canvas, s);
    _drawWandArm(canvas, s);
    _drawHead(canvas, s);
    if (skin.hasScarf) _drawScarf(canvas, s);
    if (skin.hasVisor) _drawVisor(canvas, s);
    _drawEyes(canvas, s);
    if (skin.hasWizardHat) _drawHat(canvas, s);
    if (skin.hasCrown) _drawCrown(canvas, s);
    if (skin.hasAntenna) _drawAntenna(canvas, s);
    if (isCasting) _drawSpellCharge(canvas, s);

    canvas.restore();
  }

  void _drawRobe(Canvas canvas, double s) {
    final robePaint = Paint()
      ..color = _robeColor
      ..style = PaintingStyle.fill;

    final robePath = Path()
      ..moveTo(-14 * s, -10 * s)
      ..lineTo(14 * s, -10 * s)
      ..lineTo(16 * s, 6 * s)
      ..quadraticBezierTo(18 * s, 12 * s, 14 * s, 18 * s + anim.robeFlutter * 0.5 * s)
      ..lineTo(10 * s, 18 * s + anim.robeFlutter * s)
      ..lineTo(6 * s, 16 * s)
      ..lineTo(0, 20 * s + anim.robeFlutter * 0.5 * s)
      ..lineTo(-6 * s, 16 * s)
      ..lineTo(-10 * s, 18 * s - anim.robeFlutter * s)
      ..quadraticBezierTo(-18 * s, 12 * s, -16 * s, 6 * s)
      ..close();

    canvas.drawPath(robePath, robePaint);

    final trimPaint = Paint()
      ..color = _trimColor.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    canvas.drawPath(robePath, trimPaint);

    final beltPaint = Paint()
      ..color = _trimColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(-6 * s, -2 * s, 12 * s, 2 * s), beltPaint);
  }

  void _drawWandArm(Canvas canvas, double s) {
    canvas.save();
    canvas.translate(14 * s, -6 * s);
    canvas.rotate(0.4 - anim.wandSwing);

    final armPaint = Paint()
      ..color = _robeColor
      ..strokeWidth = 5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, Offset(0, 10 * s), armPaint);

    canvas.translate(0, 11 * s);
    final wandPaint = Paint()
      ..color = _trimColor
      ..strokeWidth = 2.5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset.zero, Offset(0, 10 * s), wandPaint);

    if (isGlowing || isCasting) {
      final tipPaint = Paint()
        ..color = scheme.secondary.withValues(alpha: 0.6 + 0.3 * anim.castPhase)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(0, 11 * s), 2.5 * s, tipPaint);
    }

    canvas.restore();
  }

  void _drawHead(Canvas canvas, double s) {
    final headPaint = Paint()
      ..color = const Color(0xFFFFE0BD)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(0, -16 * s), 8 * s, headPaint);
  }

  void _drawEyes(Canvas canvas, double s) {
    final isBlinking = (anim.blinkPhase * 10).floor() % 10 == 0;
    final eyeSize = isBlinking ? 1.0 * s : 3.0 * s;

    for (final dx in [-3.5 * s, 3.5 * s]) {
      final color = isGlowing
          ? (isCasting ? skin.eyeColor : skin.trimColor)
          : skin.eyeColor;
      final eyePaint = Paint()..color = color;
      canvas.drawCircle(Offset(dx, -17 * s), eyeSize, eyePaint);

      if (!isBlinking && !isGlowing) {
        final pupilPaint = Paint()
          ..color = const Color(0xFF0A0A0A);
        canvas.drawCircle(Offset(dx + 0.5 * s, -17 * s), 1.5 * s, pupilPaint);
      }
    }
  }

  void _drawHat(Canvas canvas, double s) {
    final hatPaint = Paint()
      ..color = scheme.primary.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;

    final hatPath = Path()
      ..moveTo(-16 * s, -18 * s)
      ..lineTo(16 * s, -18 * s)
      ..lineTo(5 * s, -38 * s)
      ..quadraticBezierTo(2 * s, -42 * s, -3 * s, -38 * s)
      ..close();
    canvas.drawPath(hatPath, hatPaint);

    final bandPaint = Paint()
      ..color = scheme.secondary
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(-15 * s, -19 * s, 30 * s, 2.5 * s), bandPaint);
  }

  void _drawSpellCharge(Canvas canvas, double s) {
    final chargePaint = Paint()
      ..color = scheme.secondary.withValues(alpha: 0.2 * anim.castPhase)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset.zero, 14 * s * anim.castPhase, chargePaint);

    final runePaint = Paint()
      ..color = scheme.secondary.withValues(alpha: 0.4 * anim.castPhase)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    for (var i = 0; i < 4; i++) {
      final angle = i * pi / 2 + anim.castPhase * 2;
      final rx = cos(angle) * 10 * s * anim.castPhase;
      final ry = sin(angle) * 10 * s * anim.castPhase;
      canvas.drawCircle(Offset(rx, ry), 2 * s, runePaint);
    }
  }

  void _drawCape(Canvas canvas, double s) {
    final capePaint = Paint()
      ..color = skin.trimColor.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final capePath = Path()
      ..moveTo(-14 * s, -12 * s)
      ..quadraticBezierTo(-20 * s, 0, -18 * s + anim.robeFlutter * s, 18 * s)
      ..quadraticBezierTo(-14 * s, 22 * s, -10 * s, 18 * s - anim.robeFlutter * 0.5 * s)
      ..lineTo(-10 * s, -8 * s)
      ..close();

    canvas.drawPath(capePath, capePaint);
  }

  void _drawAntenna(Canvas canvas, double s) {
    final antennaPaint = Paint()
      ..color = skin.trimColor
      ..strokeWidth = 1.5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(0, -24 * s), Offset(0, -32 * s), antennaPaint);

    final ledPaint = Paint()
      ..color = skin.eyeColor.withValues(alpha: 0.6 + 0.4 * anim.blinkPhase)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(Offset(0, -33 * s), 2 * s, ledPaint);
  }

  void _drawScarf(Canvas canvas, double s) {
    final scarfPaint = Paint()
      ..color = skin.trimColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    final scarfPath = Path()
      ..moveTo(-8 * s, -12 * s)
      ..quadraticBezierTo(-10 * s, -10 * s, -12 * s, -8 * s + anim.robeFlutter * 0.3 * s)
      ..lineTo(-14 * s, -4 * s + anim.robeFlutter * 0.5 * s)
      ..lineTo(-10 * s, -6 * s)
      ..lineTo(10 * s, -6 * s)
      ..lineTo(14 * s, -4 * s + anim.robeFlutter * 0.5 * s)
      ..lineTo(12 * s, -8 * s + anim.robeFlutter * 0.3 * s)
      ..quadraticBezierTo(10 * s, -10 * s, 8 * s, -12 * s)
      ..close();

    canvas.drawPath(scarfPath, scarfPaint);
  }

  void _drawCrown(Canvas canvas, double s) {
    final crownPaint = Paint()
      ..color = skin.trimColor
      ..style = PaintingStyle.fill;

    final crownPath = Path()
      ..moveTo(-8 * s, -23 * s)
      ..lineTo(-6 * s, -30 * s)
      ..lineTo(-2 * s, -26 * s)
      ..lineTo(0, -32 * s)
      ..lineTo(2 * s, -26 * s)
      ..lineTo(6 * s, -30 * s)
      ..lineTo(8 * s, -23 * s)
      ..close();

    canvas.drawPath(crownPath, crownPaint);

    final jewelPaint = Paint()
      ..color = skin.eyeColor;
    canvas.drawCircle(Offset(0, -28 * s), 1.5 * s, jewelPaint);
  }

  void _drawVisor(Canvas canvas, double s) {
    final visorPaint = Paint()
      ..color = skin.trimColor.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(-8 * s, -19 * s, 16 * s, 3.5 * s), visorPaint);

    final glowPaint = Paint()
      ..color = skin.eyeColor.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawRect(Rect.fromLTWH(-8 * s, -19 * s, 16 * s, 3.5 * s), glowPaint);
  }

  void _drawGearEmblem(Canvas canvas, double s) {
    final gearPaint = Paint()
      ..color = skin.trimColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;

    const teeth = 6;
    final outerR = 4 * s;
    final innerR = 2.5 * s;
    final gearPath = Path();
    for (var i = 0; i < teeth; i++) {
      final a1 = i * 2 * pi / teeth;
      final a2 = a1 + pi / teeth * 0.6;
      final a3 = a1 + pi / teeth;
      final a4 = a3 + pi / teeth * 0.6;
      if (i == 0) {
        gearPath.moveTo(cos(a1) * outerR, sin(a1) * outerR - 2 * s);
      }
      gearPath.lineTo(cos(a2) * outerR, sin(a2) * outerR - 2 * s);
      gearPath.lineTo(cos(a3) * innerR, sin(a3) * innerR - 2 * s);
      gearPath.lineTo(cos(a4) * innerR, sin(a4) * innerR - 2 * s);
    }
    gearPath.close();
    canvas.drawPath(gearPath, gearPaint);

    final centerPaint = Paint()
      ..color = skin.trimColor.withValues(alpha: 0.5);
    canvas.drawCircle(Offset(0, -2 * s), 1.5 * s, centerPaint);
  }

  @override
  bool shouldRepaint(covariant _SupTechBodyPainter oldDelegate) {
    return oldDelegate.isGlowing != isGlowing ||
        oldDelegate.isCasting != isCasting ||
        oldDelegate.skin.id != skin.id ||
        oldDelegate.anim.castPhase != anim.castPhase ||
        oldDelegate.anim.blinkPhase != anim.blinkPhase;
  }
}

class _SparklePainter extends CustomPainter {
  final double phase;
  final Color color;
  final double intensity;

  _SparklePainter({
    required this.phase,
    required this.color,
    this.intensity = 0.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    for (var i = 0; i < (12 * intensity).round(); i++) {
      final angle = phase * 2 + i * pi / 6;
      final dist = 14 + 6 * sin(phase * 3 + i.toDouble());
      final x = size.width / 2 + cos(angle) * dist;
      final y = size.height / 2 + sin(angle) * dist;
      final alpha = (0.2 * intensity + 0.3 * sin(phase * 4 + i.toDouble())).clamp(0.0, 1.0);
      final r = 1.0 + rng.nextDouble() * 1.5 * intensity;
      canvas.drawCircle(
        Offset(x, y),
        r,
        Paint()..color = color.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter old) =>
      old.phase != phase || old.intensity != intensity;
}
