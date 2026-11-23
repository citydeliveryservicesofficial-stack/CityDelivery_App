import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import 'reveal.dart';

/// `.eyebrow` — small uppercase green pill on a soft-yellow background.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.dark = false});
  final String text;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.yellow.withValues(alpha: dark ? 0.15 : 0.25),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text.toUpperCase(),
        style: AppText.body(
          size: 12,
          weight: FontWeight.w800,
          letterSpacing: 1.7,
          color: dark ? AppColors.yellow : AppColors.green,
        ),
      ),
    );
  }
}

/// `SectionHeading` component.
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    this.eyebrow,
    required this.title,
    this.description,
    this.dark = false,
    this.center = true,
  });

  final String? eyebrow;
  final String title;
  final String? description;
  final bool dark;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final align = center ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: align,
      children: [
        if (eyebrow != null) Reveal(child: Eyebrow(eyebrow!, dark: dark)),
        Reveal(
          delay: const Duration(milliseconds: 50),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              title,
              textAlign: center ? TextAlign.center : TextAlign.start,
              style: AppText.display(
                size: 34,
                height: 1.1,
                color: dark ? Colors.white : AppColors.dark,
              ),
            ),
          ),
        ),
        if (description != null)
          Reveal(
            delay: const Duration(milliseconds: 100),
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Text(
                description!,
                textAlign: center ? TextAlign.center : TextAlign.start,
                style: AppText.body(
                  size: 17,
                  height: 1.6,
                  color: dark ? Colors.white70 : AppColors.muted,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Small pill label used by Home sections: "• How it works".
class DotPill extends StatelessWidget {
  const DotPill(this.text, {super.key, this.dark = false});
  final String text;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final c = dark ? AppColors.yellow : AppColors.homeDark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.yellow.withValues(alpha: dark ? 0.15 : 0.30),
        borderRadius: BorderRadius.circular(999),
        border: dark
            ? Border.all(color: AppColors.yellow.withValues(alpha: 0.3))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: dark ? AppColors.yellow : AppColors.homeGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppText.body(size: 14, weight: FontWeight.w700, color: c),
          ),
        ],
      ),
    );
  }
}

/// Decorative drifting geometry behind page heroes (FloatingShapes.jsx).
class FloatingShapes extends StatefulWidget {
  const FloatingShapes({super.key});

  @override
  State<FloatingShapes> createState() => _FloatingShapesState();
}

class _FloatingShapesState extends State<FloatingShapes>
    with TickerProviderStateMixin {
  late final AnimationController _float = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat(reverse: true);
  late final AnimationController _spin = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 40),
  )..repeat();

  @override
  void dispose() {
    _float.dispose();
    _spin.dispose();
    super.dispose();
  }

  Widget _blob(double size, {BorderRadius? radius}) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: radius == null ? BoxShape.circle : BoxShape.rectangle,
      borderRadius: radius,
      gradient: RadialGradient(
        colors: [
          AppColors.yellow.withValues(alpha: 0.35),
          AppColors.yellow.withValues(alpha: 0),
        ],
        stops: const [0.35, 1],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          return AnimatedBuilder(
            animation: Listenable.merge([_float, _spin]),
            builder: (context, _) {
              final f = Curves.easeInOut.transform(_float.value);
              return Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Positioned(
                    left: -96,
                    top: 96,
                    child: _blob(288, radius: BorderRadius.circular(120)),
                  ),
                  Positioned(right: -110, top: 220, child: _blob(384)),
                  Positioned(
                    right: w * 0.12,
                    top: 96 - 14 * f,
                    child: Transform.rotate(
                      angle: 0.21,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.yellow.withValues(alpha: 0.7),
                            width: 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: w * 0.08,
                    bottom: 96 + 14 * f,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    left: w * 0.45,
                    top: 48,
                    child: Transform.rotate(
                      angle: _spin.value * 6.2832,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppColors.green.withValues(alpha: 0.4),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/// Header band for inner pages (PageHero.jsx).
class PageHero extends StatelessWidget {
  const PageHero({
    super.key,
    this.eyebrow,
    required this.title,
    this.description,
    this.child,
  });

  final String? eyebrow;
  final String title;
  final String? description;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final wide = MediaQuery.of(context).size.width >= 640;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.yellowSoft.withValues(alpha: 0.6),
            AppColors.light,
          ],
        ),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: FloatingShapes()),
          Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              (wide ? 176.0 : 144.0) + top * 0.4,
              20,
              wide ? 80 : 56,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  children: [
                    if (eyebrow != null)
                      Reveal(dy: 20, child: Eyebrow(eyebrow!)),
                    Reveal(
                      dy: 20,
                      delay: const Duration(milliseconds: 80),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          title,
                          textAlign: TextAlign.center,
                          style: AppText.display(
                            size: wide ? 56 : 40,
                            height: 1.05,
                            color: AppColors.dark,
                          ),
                        ),
                      ),
                    ),
                    if (description != null)
                      Reveal(
                        dy: 20,
                        delay: const Duration(milliseconds: 160),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 22),
                          child: Text(
                            description!,
                            textAlign: TextAlign.center,
                            style: AppText.body(
                              size: 17,
                              height: 1.6,
                              color: AppColors.muted,
                            ),
                          ),
                        ),
                      ),
                    if (child != null)
                      Reveal(
                        dy: 20,
                        delay: const Duration(milliseconds: 240),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: child,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dotted "grain" overlay from `.grain`.
class GrainPainter extends CustomPainter {
  const GrainPainter({this.color = const Color(0x0F111713), this.gap = 22});
  final Color color;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = color;
    for (double y = gap / 2; y < size.height; y += gap) {
      for (double x = gap / 2; x < size.width; x += gap) {
        canvas.drawCircle(Offset(x, y), 1, p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant GrainPainter old) => false;
}

/// Square-grid overlay used by the footer, "Why choose us" and CTA panels.
class GridPainter extends CustomPainter {
  const GridPainter({required this.color, this.step = 44});
  final Color color;
  final double step;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter old) =>
      old.color != color || old.step != step;
}

/// Soft blurred-looking orb (radial gradient — cheaper than a real blur).
class Orb extends StatelessWidget {
  const Orb({super.key, required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, color.withValues(alpha: 0)],
            stops: const [0.2, 1],
          ),
        ),
      ),
    );
  }
}
