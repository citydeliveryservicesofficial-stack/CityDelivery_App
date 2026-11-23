import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/brand_button.dart';
import '../../widgets/common/reveal.dart';
import '../../widgets/common/section_widgets.dart';
import '../../widgets/layout/navigation.dart';

const _brand = 'City Delivery Services';

/// Home hero, adapted from the website's responsive (< lg) layout: full-bleed scooter artwork behind the copy.
class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounce = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final w = mq.size.width;
    final wide = w >= 640;
    final topPad = (wide ? 128.0 : 112.0) + mq.padding.top * 0.3;
    final bottomSpace = w * (wide ? 0.62 : 0.92);
    final h1 = wide ? 72.0 : 46.4;

    Widget h1Line(String t, {bool green = false}) => Text(
      t,
      style: AppText.display(
        size: h1,
        weight: FontWeight.w800,
        height: 1,
        letterSpacing: -0.03 * h1,
        color: green ? AppColors.homeGreen : AppColors.homeDark,
        fontStyle: green ? FontStyle.italic : FontStyle.normal,
      ),
    );

    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFEE88F), Color(0xFFFEDD74), Color(0xFFFED45D)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/hero_mobile_bg.webp',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              excludeFromSemantics: true,
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
                    Color(0xB8FEE88F),
                    Color(0x2EFEE88F),
                    Color(0x38FEF1C4),
                    Color(0xE0FEF1C4),
                  ],
                  stops: const [0, .34, .58, 1],
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: -60,
            child: Orb(
              size: wide ? 220 : 160,
              color: Colors.white.withValues(alpha: 0.55),
            ),
          ),
          Positioned(
            bottom: bottomSpace * 0.45,
            left: -60,
            child: Orb(
              size: wide ? 210 : 160,
              color: AppColors.homeGreen.withValues(alpha: 0.22),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              wide ? 40 : 20,
              topPad,
              wide ? 40 : 20,
              bottomSpace,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Reveal(
                  dy: -16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xE6FFEFA3),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _LiveDot(),
                        const SizedBox(width: 12),
                        const Icon(
                          LucideIcons.truck,
                          size: 20,
                          color: AppColors.homeDark,
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            'Product Request & Delivery Service',
                            style: AppText.body(
                              size: 14,
                              weight: FontWeight.w700,
                              color: AppColors.homeDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Reveal(
                  delay: const Duration(milliseconds: 150),
                  dy: 30,
                  child: h1Line('Your Product.'),
                ),
                Reveal(
                  delay: const Duration(milliseconds: 300),
                  dy: 30,
                  child: h1Line('Your Store.'),
                ),
                Reveal(
                  delay: const Duration(milliseconds: 450),
                  dy: 30,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: h1Line('Delivered with Ease.', green: true),
                      ),
                      const Positioned(
                        left: 0,
                        right: 0,
                        bottom: -8,
                        height: 12,
                        child: _Underline(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Reveal(
                  delay: const Duration(milliseconds: 600),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Text.rich(
                      TextSpan(
                        style: AppText.body(
                          size: wide ? 20 : 18,
                          height: 1.6,
                          color: const Color(0xFF5B5A55),
                        ),
                        children: [
                          const TextSpan(
                            text: 'Tell us what you need and where you want it from. ',
                          ),
                          TextSpan(
                            text: 'simple and convenient.',
                            style: AppText.body(
                              size: wide ? 20 : 18,
                              weight: FontWeight.w700,
                              color: AppColors.homeDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Reveal(
                  delay: const Duration(milliseconds: 750),
                  child: wide
                      ? Row(
                          children: [
                            Chunky3DButton(
                              label: 'Request a Service',
                              icon: LucideIcons.arrowRight,
                              expand: false,
                              onPressed: () =>
                                  AppNav.push(context, Routes.request),
                            ),
                            const SizedBox(width: 16),
                            Chunky3DButton(
                              label: 'How It Works',
                              icon: LucideIcons.play,
                              white: true,
                              expand: false,
                              onPressed: () =>
                                  AppNav.push(context, Routes.howItWorks),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Chunky3DButton(
                              label: 'Request a Service',
                              icon: LucideIcons.arrowRight,
                              onPressed: () =>
                                  AppNav.push(context, Routes.request),
                            ),
                            const SizedBox(height: 16),
                            Chunky3DButton(
                              label: 'How It Works',
                              icon: LucideIcons.play,
                              white: true,
                              onPressed: () =>
                                  AppNav.push(context, Routes.howItWorks),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 28),
                Reveal(
                  delay: const Duration(milliseconds: 900),
                  child: const Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      _Chip(LucideIcons.store, 'Groceries'),
                      _Chip(LucideIcons.heartHandshake, 'Medicines'),
                      _Chip(LucideIcons.send, 'Gifts'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ExcludeSemantics(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AnimatedBuilder(
                  animation: _bounce,
                  builder: (context, _) {
                    final letters = _brand.split('');
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < letters.length; i++)
                          Transform.translate(
                            offset: Offset(
                              0,
                              _bump(_bounce.value * 2.4 - i * 0.13),
                            ),
                            child: Text(
                              letters[i] == ' '
                                  ? '\u00A0'
                                  : letters[i].toUpperCase(),
                              style:
                                  AppText.display(
                                    size: math.max(25.6, w * 0.06),
                                    weight: FontWeight.w900,
                                    letterSpacing: 0.08 * 25.6,
                                    color: AppColors.homeDark,
                                  ).copyWith(
                                    shadows: const [
                                      Shadow(
                                        color: AppColors.yellow,
                                        offset: Offset(0, 3),
                                      ),
                                      Shadow(
                                        color: Color(0x33111713),
                                        offset: Offset(0, 7),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// framer-motion `y: [0, -18, 0, 0]` over 2.4 s, staggered per letter.
  double _bump(double seconds) {
    var phase = (seconds / 2.4) % 1.0;
    if (phase < 0) phase += 1;
    if (phase >= 2 / 3) return 0;
    return -18 * math.sin(math.pi * phase / (2 / 3));
  }
}

class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 1.0, end: 0.5).animate(_c),
      child: Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(
          color: AppColors.homeGreen,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.homeGreen),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppText.body(
              size: 14,
              weight: FontWeight.w700,
              color: AppColors.homeDark,
            ),
          ),
        ],
      ),
    );
  }
}

/// The hand-drawn green underline from the hero heading, drawn in over 0.9 s after 1 s.
class _Underline extends StatelessWidget {
  const _Underline();

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      builder: (context, v, _) => CustomPaint(painter: _UnderlinePainter(v)),
    );
  }
}

class _UnderlinePainter extends CustomPainter {
  _UnderlinePainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 400;
    final sy = size.height / 12;
    final path = Path()
      ..moveTo(4 * sx, 7 * sy)
      ..cubicTo(90 * sx, 3 * sy, 150 * sx, 9 * sy, 240 * sx, 6 * sy)
      ..cubicTo(330 * sx, 3 * sy, 340 * sx, 3 * sy, 396 * sx, 6 * sy);
    final paint = Paint()
      ..color = AppColors.homeGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (final m in path.computeMetrics()) {
      canvas.drawPath(m.extractPath(0, m.length * t), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _UnderlinePainter old) => old.t != t;
}
