import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Route names (mirror the website's React-Router paths).
class Routes {
  Routes._();
  static const home = '/';
  static const request = '/request';
  static const requestStatus = '/request/status';
  static const requestHistory = '/request/history';
  static const howItWorks = '/how-it-works';
  static const about = '/about';
  static const contact = '/contact';
  static const privacy = '/privacy';
  static const terms = '/terms';
  static const prohibited = '/prohibited-items-policy';
  static const becomeRider = '/become-a-rider';
  static const riderRegister = '/rider/register';
  static const riderStatus = '/rider/status';
  static const becomeFranchise = '/become-a-franchise';
  static const franchiseRegister = '/franchise/register';
  static const franchiseStatus = '/franchise/status';
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

// ============================================================================
//  Premium 3D bottom navigation
// ============================================================================
//
//  SYSTEM BUTTON FIX
//  Phones with the 3-button Android bar (Back / Home / Recents) or a gesture
//  pill were drawing on top of the nav bar, because the bottom inset was lost
//  (MediaQuery padding is often consumed by a parent Scaffold / SafeArea).
//  We now read the *raw* window inset straight from the platform view and use
//  the largest of every available source, so the bar always sits above the
//  system buttons.
//
//  Also add this once in main() for consistent behaviour on all phones:
//
//    WidgetsFlutterBinding.ensureInitialized();
//    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//
//  and place the bar as `bottomNavigationBar:` of your Scaffold (or at the
//  bottom of a Column) – do NOT wrap it in another SafeArea (it would add the
//  gap twice).
// ============================================================================

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.route});

  final String route;

  // ---- palette
  static const _cream = Color(0xFFFFF8DC);
  static const _creamDeep = Color(0xFFFFEDA8);
  static const _inactive = Color(0xFF8B7A33);
  static const _edge = Color(0xFFD9A400); // extruded "side wall" of the bar
  static const _edgeDeep = Color(0xFFB07F00);

  // ---- geometry
  static const double _pillHeight = 74;
  static const double _depth = 8; // 3D thickness under the bar
  static const double _riderFloatHeight = 54;
  static const double _sideMargin = 16;
  static const double _minBottomGap = 10;

  static const _destinations =
      <({String route, String label, IconData icon, bool primary})>[
        (
          route: Routes.home,
          label: 'Home',
          icon: LucideIcons.home,
          primary: false,
        ),
        (
          route: Routes.becomeRider,
          label: 'Rider',
          icon: LucideIcons.bike,
          primary: false,
        ),
        (
          route: Routes.request,
          label: 'Request',
          icon: LucideIcons.clipboardList,
          primary: true,
        ),
        (
          route: Routes.becomeFranchise,
          label: 'Franchise',
          icon: LucideIcons.handshake,
          primary: false,
        ),
        (
          route: Routes.requestStatus,
          label: 'Status',
          icon: LucideIcons.clipboardCheck,
          primary: false,
        ),
      ];

  /// Largest bottom inset from every source, so 3-button / gesture navigation
  /// bars can never cover the bar.
  static double _systemBottomInset(BuildContext context) {
    final mq = MediaQuery.of(context);
    final view = View.of(context);
    final rawViewPadding = view.viewPadding.bottom / view.devicePixelRatio;
    final rawSystemGesture =
        view.systemGestureInsets.bottom / view.devicePixelRatio;
    var inset = math.max(
      math.max(mq.padding.bottom, mq.viewPadding.bottom),
      rawViewPadding,
    );
    // Gesture insets can be large on some OEMs; only trust them on Android.
    if (defaultTargetPlatform == TargetPlatform.android) {
      inset = math.max(inset, math.min(rawSystemGesture, 48));
    }
    return inset;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = _systemBottomInset(context);

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(
        _sideMargin,
        0,
        _sideMargin,
        _minBottomGap + bottomInset,
      ),
      child: SizedBox(
        height: _pillHeight + _depth,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ---- soft ground shadow under the whole slab
            Positioned(
              left: 14,
              right: 14,
              bottom: -6,
              height: 26,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.dark.withValues(alpha: 0.28),
                      blurRadius: 26,
                      offset: const Offset(0, 14),
                    ),
                    BoxShadow(
                      color: AppColors.yellowDeep.withValues(alpha: 0.35),
                      blurRadius: 30,
                      spreadRadius: -4,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
              ),
            ),
            // ---- extruded side wall (gives the bar real thickness)
            Positioned(
              left: 0,
              right: 0,
              top: _depth,
              height: _pillHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_edge, _edgeDeep],
                  ),
                ),
              ),
            ),
            // ---- bar face
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: _pillHeight,
              child: _BarFace(),
            ),
            // ---- delivery rider: wheels touch the top edge of the bar
            const Positioned(
              left: 18,
              right: 18,
              top: -_riderFloatHeight + 2,
              height: _riderFloatHeight,
              child: IgnorePointer(child: _DeliveryRiderLane()),
            ),
            // ---- items
            Positioned(
              left: 4,
              right: 4,
              top: 0,
              height: _pillHeight,
              child: Row(
                children: [
                  for (final d in _destinations)
                    _AppBottomNavItem(
                      icon: d.icon,
                      label: d.label,
                      active: _isActive(route, d.route),
                      primary: d.primary,
                      onTap: () => AppNav.goTop(
                        context,
                        _targetRoute(d.route, route),
                        current: route,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _targetRoute(String destination, String current) {
    if (destination != Routes.requestStatus) return destination;
    if (current == Routes.becomeRider ||
        current == Routes.riderRegister ||
        current == Routes.riderStatus) {
      return Routes.riderStatus;
    }
    if (current == Routes.becomeFranchise ||
        current == Routes.franchiseRegister ||
        current == Routes.franchiseStatus) {
      return Routes.franchiseStatus;
    }
    return Routes.requestStatus;
  }

  static bool _isActive(String current, String destination) {
    if (destination == Routes.becomeRider) {
      return current == Routes.becomeRider || current == Routes.riderRegister;
    }
    if (destination == Routes.becomeFranchise) {
      return current == Routes.becomeFranchise ||
          current == Routes.franchiseRegister;
    }
    if (destination == Routes.requestStatus) {
      return current == Routes.requestStatus ||
          current == Routes.franchiseStatus ||
          current == Routes.riderStatus;
    }
    return current == destination;
  }
}

/// The glossy top face of the 3D bar: gradient body, bevelled rim,
/// specular highlight and an inner bottom shade.
class _BarFace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFBEA),
            AppBottomNav._cream,
            AppBottomNav._creamDeep,
          ],
          stops: [0, 0.45, 1],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.95),
          width: 1.6,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.7),
            blurRadius: 2,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(31),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // top specular gloss
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: AppBottomNav._pillHeight * 0.5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: 0.75),
                      Colors.white.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            // inner bottom shade for depth
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 22,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.yellowDeep.withValues(alpha: 0),
                      AppColors.yellowDeep.withValues(alpha: 0.28),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
//  Nav items (3D keys that physically press down)
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

class _AppBottomNavItemState extends State<_AppBottomNavItem> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) {
          _setPressed(false);
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _pressed ? 0.92 : 1,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: Offset(0, _pressed ? 0.05 : 0),
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOut,
            child: Semantics(
              button: true,
              selected: widget.active,
              label: widget.label,
              child: widget.primary ? _primary() : _regular(),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------ raised golden centre orb
  Widget _primary() {
    final active = widget.active;
    return Transform.translate(
      offset: const Offset(0, -9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 66,
            height: 62,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // socket ring (the bezel the orb sits in)
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, AppBottomNav._creamDeep],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.yellowDeep.withValues(alpha: 0.6),
                        blurRadius: 22,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),
                // orb: solid extrude edge + glossy gradient face
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      center: Alignment(-0.35, -0.5),
                      radius: 1.05,
                      colors: [
                        Color(0xFFFFF0A0),
                        AppColors.yellow,
                        Color(0xFFF2A100),
                      ],
                      stops: [0, 0.55, 1],
                    ),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      const BoxShadow(
                        color: Color(0xFFB98600),
                        offset: Offset(0, 5),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 9),
                      ),
                      if (active)
                        BoxShadow(
                          color: AppColors.green.withValues(alpha: 0.6),
                          blurRadius: 18,
                          spreadRadius: 1,
                        ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // gloss
                      Positioned(
                        top: 4,
                        left: 10,
                        right: 10,
                        height: 16,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(alpha: 0.7),
                                Colors.white.withValues(alpha: 0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // embossed icon: light edge underneath, dark on top
                      Transform.translate(
                        offset: const Offset(0, 1),
                        child: Icon(
                          widget.icon,
                          size: 24,
                          color: Colors.white.withValues(alpha: 0.65),
                        ),
                      ),
                      Icon(widget.icon, size: 24, color: AppColors.dark),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text(
            widget.label,
            maxLines: 1,
            style: AppText.body(
              size: 11,
              height: 1,
              weight: FontWeight.w800,
              color: AppColors.dark,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------ Home / Partner items
  Widget _regular() {
    final active = widget.active;
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
        width: active ? 66 : 56,
        height: 56,
        margin: EdgeInsets.only(bottom: active ? 6 : 0),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: active
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF4A4120), Color(0xFF2A2410), AppColors.dark],
                )
              : null,
          border: active
              ? Border.all(color: Colors.white.withValues(alpha: 0.18))
              : null,
          boxShadow: active
              ? [
                  // solid extruded edge (3D key)
                  const BoxShadow(
                    color: Color(0xFF0A0803),
                    offset: Offset(0, 4),
                  ),
                  BoxShadow(
                    color: AppColors.dark.withValues(alpha: 0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 10),
                  ),
                ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (active)
              Positioned(
                top: 0,
                left: 6,
                right: 6,
                height: 16,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.22),
                        Colors.white.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: active ? 1.12 : 1,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutBack,
                  child: Icon(
                    widget.icon,
                    size: 22,
                    color: active ? AppColors.yellow : AppBottomNav._inactive,
                    shadows: active
                        ? [
                            Shadow(
                              color: AppColors.yellow.withValues(alpha: 0.6),
                              blurRadius: 10,
                            ),
                          ]
                        : [
                            Shadow(
                              color: Colors.white.withValues(alpha: 0.8),
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body(
                    size: 9.5,
                    weight: active ? FontWeight.w800 : FontWeight.w700,
                    color: active ? AppColors.yellow : AppBottomNav._inactive,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}