import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Endlessly scrolling strip (CSS `marquee`): two identical copies, wraps seamlessly.
/// Used by the green service ticker and the customer-reviews carousel.
class AutoMarquee extends StatefulWidget {
  const AutoMarquee({
    super.key,
    required this.copyBuilder,
    this.pixelsPerSecond = 40,
    this.interactive = false,
  });

  final Widget Function(int copy) copyBuilder;
  final double pixelsPerSecond;

  /// When true the user can drag; auto-scroll resumes shortly after they let go.
  final bool interactive;

  @override
  State<AutoMarquee> createState() => _AutoMarqueeState();
}

class _AutoMarqueeState extends State<AutoMarquee>
    with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  late final Ticker _ticker;
  Duration _last = Duration.zero;
  bool _touching = false;
  DateTime _resumeAt = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_tick)..start();
  }

  void _tick(Duration elapsed) {
    final dt = (elapsed - _last).inMicroseconds / 1e6;
    _last = elapsed;
    if (!_controller.hasClients || dt <= 0 || dt > 0.5) return;
    if (_touching || DateTime.now().isBefore(_resumeAt)) return;
    final pos = _controller.position;
    if (!pos.hasContentDimensions) return;
    final copyWidth = (pos.maxScrollExtent + pos.viewportDimension) / 2;
    if (copyWidth <= 0) return;
    var next = pos.pixels + widget.pixelsPerSecond * dt;
    if (next >= copyWidth) next -= copyWidth;
    _controller.jumpTo(next);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations && _ticker.isActive)
      _ticker.stop();
    return Listener(
      onPointerDown: (_) => _touching = true,
      onPointerUp: (_) {
        _touching = false;
        _resumeAt = DateTime.now().add(const Duration(milliseconds: 1800));
      },
      onPointerCancel: (_) => _touching = false,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: widget.interactive
            ? const ClampingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        child: Row(children: [widget.copyBuilder(0), widget.copyBuilder(1)]),
      ),
    );
  }
}
