import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Route names (mirror the website's React-Router paths).
class Routes {
  Routes._();
  static const home = '/';
  static const request = '/request';
  static const howItWorks = '/how-it-works';
  static const about = '/about';
  static const contact = '/contact';
  static const privacy = '/privacy';
  static const terms = '/terms';
  static const prohibited = '/prohibited-items-policy';
  static const becomeRider = '/become-a-rider';
  static const riderRegister = '/rider/register';
  static const riderStatus = '/rider/status';
  static String gallery(String slug) => '/gallery/$slug';
}

class AppNav {
  AppNav._();

  /// Navbar / footer links: behave like top-level navigation (no stack build-up).
  static void goTop(BuildContext context, String route, {String? current}) {
    if (route == current) return;
    final nav = Navigator.of(context);
    if (route == Routes.home) {
      nav.popUntil((r) => r.isFirst);
    } else {
      nav.pushNamedAndRemoveUntil(route, (r) => r.isFirst);
    }
  }

  /// In-page links / CTAs: normal push so the back button returns to where you were.
  static void push(BuildContext context, String route) =>
      Navigator.of(context).pushNamed(route);
}

/// Floating, yellow-themed bottom navigation with a delivery rider who
/// keeps riding left and right along the top edge of the bar.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.route});

  final String route;

  static const _cream = Color(0xFFFFF8DC);
  static const _creamDeep = Color(0xFFFFEDA8);
  static const _inactive = Color(0xFF8B7A33);

  // Layout: [ rider lane 46 ][ 16 headroom for raised button ][ pill 72 ]
  static const double _riderLane = 46;
  static const double _headroom = 16;
  static const double _pillHeight = 72;

  static const _destinations =
      <({String route, String label, IconData icon, bool primary})>[
        (
          route: Routes.home,
          label: 'Home',
          icon: LucideIcons.home,
          primary: false,
        ),
        (
          route: Routes.request,
          label: 'Request',
          icon: LucideIcons.clipboardList,
          primary: true,
        ),
        (
          route: Routes.becomeRider,
          label: 'Partner',
          icon: LucideIcons.handshake,
          primary: false,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    const pillTop = _riderLane + _headroom;
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 10 + bottom),
      child: SizedBox(
        height: pillTop + _pillHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ---- the floating pill
            Positioned(
              left: 0,
              right: 0,
              top: pillTop,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_cream, _creamDeep],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.85),
                    width: 1.4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.yellowDeep.withValues(alpha: 0.45),
                      blurRadius: 30,
                      offset: const Offset(0, 14),
                    ),
                    BoxShadow(
                      color: AppColors.dark.withValues(alpha: 0.14),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.white.withValues(alpha: 0.65),
                        Colors.white.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // ---- delivery rider, wheels touch the top edge of the pill
            const Positioned(
              left: 14,
              right: 14,
              top: 0,
              height: pillTop,
              child: IgnorePointer(child: _DeliveryRiderLane()),
            ),
            // ---- items
            Positioned(
              left: 0,
              right: 0,
              top: _riderLane,
              bottom: 0,
              child: Row(
                children: [
                  for (final d in _destinations)
                    _AppBottomNavItem(
                      icon: d.icon,
                      label: d.label,
                      active: _isActive(route, d.route),
                      primary: d.primary,
                      onTap: () =>
                          AppNav.goTop(context, d.route, current: route),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static bool _isActive(String current, String destination) {
    if (destination == Routes.becomeRider) {
      return current == Routes.becomeRider ||
          current == Routes.riderRegister ||
          current == Routes.riderStatus;
    }
    return current == destination;
  }
}

// ============================================================================
//  Delivery rider animation
// ============================================================================

/// A scooter courier with a delivery box who rides to the right, turns around
/// at the edge, rides back to the left, and repeats forever. Wheels rotate in
/// proportion to the distance travelled, speed eases in/out at each turn.
class _DeliveryRiderLane extends StatefulWidget {
  const _DeliveryRiderLane();

  @override
  State<_DeliveryRiderLane> createState() => _DeliveryRiderLaneState();
}

class _DeliveryRiderLaneState extends State<_DeliveryRiderLane>
    with SingleTickerProviderStateMixin {
  static const double _riderW = 92;
  static const double _riderH = 54;
  static const double _wheelRadius = 9;

  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  )..repeat();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respect the "reduce motion" accessibility setting.
    if (MediaQuery.of(context).disableAnimations) {
      _c.stop();
      _c.value = 0.18;
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final travel = math.max(0.0, constraints.maxWidth - _riderW);
          return AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              final u = _c.value; // 0..1 for a full round trip
              final goingRight = u < 0.5;
              final phase = goingRight ? u * 2 : (1 - u) * 2; // 0..1..0
              final eased = Curves.easeInOutSine.transform(phase);
              // total distance driven (always increases) -> wheel rotation
              final distance = (goingRight ? eased : 2 - eased) * travel;
              final wheelAngle = distance / _wheelRadius;
              final bob = math.sin(wheelAngle * 1.6) * 0.7;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: eased * travel,
                    bottom: 0,
                    width: _riderW,
                    height: _riderH,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.diagonal3Values(
                        goingRight ? 1 : -1,
                        1,
                        1,
                      ),
                      child: CustomPaint(
                        painter: _RiderPainter(
                          wheelAngle: wheelAngle,
                          bob: bob,
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

/// Vector illustration of a helmeted courier on a yellow scooter with a green
/// delivery box. Drawn facing right in a 92 x 54 box; the parent mirrors it
/// when travelling left.
class _RiderPainter extends CustomPainter {
  _RiderPainter({required this.wheelAngle, required this.bob});

  final double wheelAngle;
  final double bob;

  // palette
  static const _yellow = Color(0xFFFFC928);
  static const _yellowLight = Color(0xFFFFE58A);
  static const _yellowDark = Color(0xFFE0A800);
  static const _green = Color(0xFF168447);
  static const _greenDark = Color(0xFF0F6B38);
  static const _ink = Color(0xFF17221A);
  static const _skin = Color(0xFFE2A97B);
  static const _pants = Color(0xFF263042);

  @override
  void paint(Canvas canvas, Size size) {
    const rearWheel = Offset(18, 44);
    const frontWheel = Offset(74, 44);
    const r = 9.0;

    // ---------- ground shadow
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(46, 53), width: 78, height: 5),
      Paint()..color = Colors.black.withValues(alpha: 0.18),
    );

    // ---------- delivery box (behind the rider, on the rear rack)
    _drawBox(canvas);

    // ---------- scooter body (under the rider)
    _drawScooter(canvas);

    // ---------- wheels
    _drawWheel(canvas, rearWheel, r);
    _drawWheel(canvas, frontWheel, r);

    // ---------- rider (bobs slightly)
    canvas.save();
    canvas.translate(0, bob);
    _drawRider(canvas);
    canvas.restore();

    // ---------- headlight glow
    canvas.drawCircle(
      const Offset(71, 27),
      7,
      Paint()
        ..shader = RadialGradient(
          colors: [
            const Color(0xFFFFF3B0).withValues(alpha: 0.85),
            const Color(0xFFFFF3B0).withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: const Offset(71, 27), radius: 7)),
    );
    canvas.drawCircle(const Offset(70, 27), 2.1, Paint()..color = Colors.white);
  }

  // -------------------------------------------------------------- box
  void _drawBox(Canvas canvas) {
    final box = RRect.fromLTRBR(3, 11, 31, 33, const Radius.circular(3.5));
    // rack
    canvas.drawRRect(
      RRect.fromLTRBR(4, 32, 38, 34.5, const Radius.circular(1.2)),
      Paint()..color = const Color(0xFF2B2F2C),
    );
    // body
    canvas.drawRRect(
      box,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF22A25B), _greenDark],
        ).createShader(box.outerRect),
    );
    // lid
    canvas.drawRRect(
      RRect.fromLTRBR(3, 11, 31, 16.5, const Radius.circular(3.5)),
      Paint()..color = _green,
    );
    canvas.drawLine(
      const Offset(3.5, 16.5),
      const Offset(30.5, 16.5),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.25)
        ..strokeWidth = 0.9,
    );
    // lid highlight
    canvas.drawLine(
      const Offset(6, 12.6),
      const Offset(25, 12.6),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.35)
        ..strokeWidth = 1.1
        ..strokeCap = StrokeCap.round,
    );
    // brand badge
    canvas.drawCircle(const Offset(17, 25), 4.6, Paint()..color = _yellow);
    canvas.drawCircle(
      const Offset(17, 25),
      4.6,
      Paint()
        ..color = _yellowDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    final tp = TextPainter(
      text: const TextSpan(
        text: 'C',
        style: TextStyle(
          color: _ink,
          fontSize: 6.8,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(17 - tp.width / 2, 25 - tp.height / 2));
    // reflective strip
    canvas.drawRect(
      const Rect.fromLTWH(3, 30, 28, 1.6),
      Paint()..color = Colors.white.withValues(alpha: 0.55),
    );
    // tail light
    canvas.drawRRect(
      RRect.fromLTRBR(1.6, 19, 3.6, 24, const Radius.circular(1)),
      Paint()..color = const Color(0xFFE5392F),
    );
  }

  // ----------------------------------------------------------- scooter
  void _drawScooter(Canvas canvas) {
    final bodyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_yellowLight, _yellow, _yellowDark],
      ).createShader(const Rect.fromLTWH(14, 24, 56, 24));

    // rear body / seat base
    final rear = Path()
      ..moveTo(15, 41)
      ..cubicTo(15, 33, 22, 32, 30, 33)
      ..lineTo(48, 33)
      ..cubicTo(52, 33, 53, 36, 51, 38)
      ..lineTo(50, 41)
      ..close();
    canvas.drawPath(rear, bodyPaint);

    // floorboard
    final floor = RRect.fromLTRBR(46, 38, 64, 42, const Radius.circular(2));
    canvas.drawRRect(floor, Paint()..color = _yellowDark);
    canvas.drawRRect(
      RRect.fromLTRBR(48, 38.4, 63, 39.6, const Radius.circular(1)),
      Paint()..color = const Color(0xFF3A3A3A),
    );

    // front leg shield + steering column
    final front = Path()
      ..moveTo(61, 41)
      ..cubicTo(60, 34, 61, 27, 63, 22)
      ..lineTo(68, 23)
      ..cubicTo(68, 29, 69, 35, 71, 41)
      ..close();
    canvas.drawPath(front, bodyPaint);

    // front fork down to the wheel
    canvas.drawLine(
      const Offset(67, 30),
      const Offset(74, 44),
      Paint()
        ..color = const Color(0xFF3A403C)
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );

    // front mudguard
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(74, 44), radius: 11),
      math.pi * 1.05,
      math.pi * 0.62,
      false,
      Paint()
        ..color = _yellowDark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );

    // seat
    final seat = RRect.fromLTRBR(30, 29.5, 50, 33.6, const Radius.circular(2.2));
    canvas.drawRRect(seat, Paint()..color = const Color(0xFF232826));
    canvas.drawLine(
      const Offset(32, 30.5),
      const Offset(47, 30.5),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.22)
        ..strokeWidth = 0.9
        ..strokeCap = StrokeCap.round,
    );

    // handlebar + mirror
    canvas.drawLine(
      const Offset(62, 21.5),
      const Offset(67, 20.5),
      Paint()
        ..color = _ink
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      const Offset(62, 21),
      const Offset(60, 16.5),
      Paint()
        ..color = _ink
        ..strokeWidth = 0.9
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(59.6, 15.6), width: 3.4, height: 2.2),
      Paint()..color = const Color(0xFFB8C4CC),
    );

    // body highlight
    canvas.drawPath(
      Path()
        ..moveTo(19, 36)
        ..cubicTo(22, 34.4, 28, 34.4, 34, 35),
      Paint()
        ..color = Colors.white.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.1
        ..strokeCap = StrokeCap.round,
    );
  }

  // ------------------------------------------------------------- wheel
  void _drawWheel(Canvas canvas, Offset c, double r) {
    canvas.drawCircle(c, r, Paint()..color = const Color(0xFF1B1D1C));
    canvas.drawCircle(
      c,
      r - 1.3,
      Paint()
        ..color = const Color(0xFF2E3230)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    // rim
    canvas.drawCircle(
      c,
      r - 3.2,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEEF1F3), Color(0xFF9AA4AB)],
        ).createShader(Rect.fromCircle(center: c, radius: r - 3.2)),
    );
    // spokes (rotating)
    final spoke = Paint()
      ..color = const Color(0xFF59636A)
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 5; i++) {
      final a = wheelAngle + i * (2 * math.pi / 5);
      canvas.drawLine(
        c,
        c + Offset(math.cos(a), math.sin(a)) * (r - 3.6),
        spoke,
      );
    }
    // a visible tread notch so the rotation reads clearly
    final notch = wheelAngle * 1.0;
    canvas.drawCircle(
      c + Offset(math.cos(notch), math.sin(notch)) * (r - 0.9),
      0.8,
      Paint()..color = const Color(0xFF5B615E),
    );
    // hub
    canvas.drawCircle(c, 1.7, Paint()..color = _ink);
    canvas.drawCircle(c, 0.7, Paint()..color = const Color(0xFFCBD2D6));
  }

  // ------------------------------------------------------------- rider
  void _drawRider(Canvas canvas) {
    const hip = Offset(40, 31);
    const knee = Offset(55, 33);
    const foot = Offset(57, 40);
    const shoulder = Offset(47, 16);
    const elbow = Offset(55, 21.5);
    const hand = Offset(63, 21);

    Paint stroke(Color c, double w) => Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = w
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // far arm (slightly darker) + far leg for depth
    canvas.drawPath(
      Path()
        ..moveTo(shoulder.dx - 1, shoulder.dy + 1)
        ..lineTo(elbow.dx - 1, elbow.dy + 1.5)
        ..lineTo(hand.dx - 1, hand.dy + 0.5),
      stroke(_greenDark, 4.3),
    );
    canvas.drawPath(
      Path()
        ..moveTo(hip.dx - 1, hip.dy)
        ..lineTo(knee.dx - 1.5, knee.dy)
        ..lineTo(foot.dx - 1.5, foot.dy),
      stroke(const Color(0xFF1B2230), 5.6),
    );

    // near leg: thigh + shin
    canvas.drawPath(
      Path()
        ..moveTo(hip.dx, hip.dy)
        ..lineTo(knee.dx, knee.dy)
        ..lineTo(foot.dx, foot.dy),
      stroke(_pants, 6),
    );
    // shoe
    canvas.drawRRect(
      RRect.fromLTRBR(54.5, 39, 62.5, 42.2, const Radius.circular(1.6)),
      Paint()..color = const Color(0xFFF4F4F2),
    );
    canvas.drawRRect(
      RRect.fromLTRBR(54.5, 41, 62.5, 42.4, const Radius.circular(0.8)),
      Paint()..color = _ink,
    );

    // torso (leaning slightly forward)
    final torso = Path()
      ..moveTo(36, 31.5)
      ..cubicTo(35, 24, 39, 17, 43, 14.8)
      ..lineTo(51, 17)
      ..cubicTo(51.5, 23, 48, 29, 45.5, 33)
      ..close();
    canvas.drawPath(
      torso,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF22A25B), _greenDark],
        ).createShader(const Rect.fromLTWH(35, 14, 17, 20)),
    );
    // reflective stripes
    canvas.drawLine(
      const Offset(37.2, 25),
      const Offset(48.6, 25.6),
      stroke(Colors.white.withValues(alpha: 0.85), 1.5),
    );
    canvas.drawLine(
      const Offset(37.8, 28.2),
      const Offset(47.4, 28.8),
      stroke(_yellow, 1.3),
    );
    // backpack strap
    canvas.drawLine(
      const Offset(42, 15.6),
      const Offset(38, 30),
      stroke(const Color(0xFF0B3F22), 1.4),
    );

    // near arm
    canvas.drawPath(
      Path()
        ..moveTo(shoulder.dx, shoulder.dy)
        ..lineTo(elbow.dx, elbow.dy)
        ..lineTo(hand.dx, hand.dy),
      stroke(_green, 4.6),
    );
    // glove
    canvas.drawCircle(hand, 2.3, Paint()..color = _ink);

    // neck + head
    canvas.drawLine(
      const Offset(47, 14.5),
      const Offset(48.5, 11.5),
      stroke(_skin, 3.4),
    );
    const head = Offset(49.5, 9.2);
    canvas.drawCircle(head, 5.1, Paint()..color = _skin);
    // chin strap
    canvas.drawLine(
      const Offset(46, 12.5),
      const Offset(51.5, 13.6),
      stroke(_ink, 0.8),
    );

    // helmet shell
    final helmetRect = Rect.fromCircle(center: const Offset(48.6, 8.2), radius: 7);
    final helmet = Path()
      ..addArc(helmetRect, math.pi * 0.92, math.pi * 1.2)
      ..lineTo(48.6, 8.2)
      ..close();
    canvas.drawPath(
      helmet,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_yellowLight, _yellow, _yellowDark],
        ).createShader(helmetRect),
    );
    // helmet rear skirt
    canvas.drawRRect(
      RRect.fromLTRBR(41.6, 8, 47, 13, const Radius.circular(2.2)),
      Paint()..color = _yellow,
    );
    // visor
    final visor = RRect.fromLTRBR(51, 6.2, 57.4, 10.8, const Radius.circular(1.8));
    canvas.drawRRect(
      visor,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xE62E4150), Color(0xE60E1820)],
        ).createShader(visor.outerRect),
    );
    canvas.drawLine(
      const Offset(52.2, 7.2),
      const Offset(55.6, 7.2),
      stroke(Colors.white.withValues(alpha: 0.6), 0.8),
    );
    // helmet highlight + stripe
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(48.6, 8.2), radius: 5.2),
      math.pi * 1.1,
      math.pi * 0.5,
      false,
      stroke(Colors.white.withValues(alpha: 0.55), 1),
    );
    canvas.drawLine(
      const Offset(44.4, 4.4),
      const Offset(50.8, 2.6),
      stroke(_green, 1.2),
    );
  }

  @override
  bool shouldRepaint(covariant _RiderPainter old) =>
      old.wheelAngle != wheelAngle || old.bob != bob;
}

// ============================================================================
//  Nav items
// ============================================================================

class _AppBottomNavItem extends StatefulWidget {
  const _AppBottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.primary,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final bool primary;
  final VoidCallback onTap;

  @override
  State<_AppBottomNavItem> createState() => _AppBottomNavItemState();
}

class _AppBottomNavItemState extends State<_AppBottomNavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
    lowerBound: 0.92,
    upperBound: 1,
  )..value = 1;

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _press.reverse(),
        onTapUp: (_) {
          _press.forward();
          widget.onTap();
        },
        onTapCancel: () => _press.forward(),
        child: ScaleTransition(
          scale: _press,
          child: Semantics(
            button: true,
            selected: widget.active,
            label: widget.label,
            child: widget.primary ? _primary() : _regular(),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------ raised golden centre button
  Widget _primary() {
    final active = widget.active;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 62,
          height: 62,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppBottomNav._cream,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.yellowDeep.withValues(alpha: 0.55),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
              ),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFE066),
                      AppColors.yellow,
                      Color(0xFFF5A800),
                    ],
                  ),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    const BoxShadow(
                      color: Color(0xFFB98600),
                      offset: Offset(0, 4),
                    ),
                    if (active)
                      BoxShadow(
                        color: AppColors.green.withValues(alpha: 0.55),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 5,
                      left: 10,
                      right: 10,
                      height: 14,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withValues(alpha: 0.6),
                              Colors.white.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Icon(widget.icon, size: 24, color: AppColors.dark),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 1),
        Text(
          widget.label,
          maxLines: 1,
          style: AppText.body(
            size: 11,
            weight: FontWeight.w800,
            color: AppColors.dark,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------ Home / Partner items
  Widget _regular() {
    final active = widget.active;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          width: active ? 68 : 58,
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: active
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2A2410), AppColors.dark],
                  )
                : null,
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.dark.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                size: 21,
                color: active ? AppColors.yellow : AppBottomNav._inactive,
              ),
              const SizedBox(height: 2),
              Text(
                widget.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.body(
                  size: 9,
                  weight: active ? FontWeight.w800 : FontWeight.w700,
                  color: active ? AppColors.yellow : AppBottomNav._inactive,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}