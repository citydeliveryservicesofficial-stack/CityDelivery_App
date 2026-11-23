import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Fade + slide-up the first time the child scrolls into view (framer-motion `whileInView`, once).
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.dy = 28,
    this.dx = 0,
    this.duration = const Duration(milliseconds: 650),
  });

  final Widget child;
  final Duration delay;
  final double dy;
  final double dx;
  final Duration duration;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _a = CurvedAnimation(
    parent: _c,
    curve: const Cubic(0.22, 1, 0.36, 1),
  );
  bool _started = false;
  final _key = UniqueKey();

  void _start() {
    if (_started || !mounted) return;
    _started = true;
    Future.delayed(widget.delay, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.of(context).disableAnimations;
    if (reduce) return widget.child;
    return VisibilityDetector(
      key: _key,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.08) _start();
      },
      child: AnimatedBuilder(
        animation: _a,
        child: widget.child,
        builder: (context, child) => Opacity(
          opacity: _a.value.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(
              widget.dx * (1 - _a.value),
              widget.dy * (1 - _a.value),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
