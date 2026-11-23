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

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.route});

  final String route;

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
          label: 'Become a partner',
          icon: LucideIcons.handshake,
          primary: false,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      color: const Color(0xFF0B1711),
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8 + bottom),
      child: SizedBox(
        height: 78,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1D3B2A), Color(0xFF0C1A12)],
                ),
                border: Border.all(color: const Color(0x2EFFFFFF)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xA6000000),
                    blurRadius: 28,
                    offset: Offset(0, 12),
                  ),
                  BoxShadow(
                    color: Color(0x33168447),
                    blurRadius: 20,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.center,
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                for (final destination in _destinations)
                  _AppBottomNavItem(
                    icon: destination.icon,
                    label: destination.label,
                    active: _isActive(route, destination.route),
                    primary: destination.primary,
                    onTap: () => AppNav.goTop(
                      context,
                      destination.route,
                      current: route,
                    ),
                  ),
              ],
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
    lowerBound: 0.94,
    upperBound: 1,
  )..value = 1;

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    final primary = widget.primary;
    final foreground = primary
        ? AppColors.dark
        : active
            ? Colors.white
            : const Color(0xFFA9B5AC);
    final iconSize = primary ? 24.0 : 21.0;
    final icon = Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: const Offset(0, 1.2),
          child: Icon(widget.icon, size: iconSize, color: Colors.black26),
        ),
        Icon(widget.icon, size: iconSize, color: foreground),
      ],
    );

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
            selected: active,
            label: widget.label,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: EdgeInsets.symmetric(vertical: primary ? 0 : 6),
              decoration: !primary && active
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0x33FFC928), Color(0x14168447)],
                      ),
                      border: Border.all(color: const Color(0x3DFFFFFF)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x4DFFC928),
                          blurRadius: 18,
                          offset: Offset(0, 6),
                        ),
                      ],
                    )
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(0, primary ? -8 : 0),
                    child: SizedBox(
                      width: primary ? 54 : 44,
                      height: primary ? 54 : 38,
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: primary
                                  ? const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFFFFE58A),
                                        Color(0xFFF5B800),
                                      ],
                                    )
                                  : LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: active
                                          ? [
                                              const Color(0xFF2EA15E),
                                              const Color(0xFF126739),
                                            ]
                                          : [
                                              const Color(0xFF2B3A31),
                                              const Color(0xFF1A261E),
                                            ],
                                    ),
                              border: Border.all(
                                color: primary
                                    ? const Color(0xFFFFF0B0)
                                    : const Color(0x33FFFFFF),
                                width: 1.4,
                              ),
                              boxShadow: primary
                                  ? const [
                                      BoxShadow(
                                        color: Color(0x99F5B800),
                                        blurRadius: 22,
                                        offset: Offset(0, 8),
                                      ),
                                      BoxShadow(
                                        color: Color(0x66000000),
                                        blurRadius: 12,
                                        offset: Offset(0, 8),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Color(
                                          active ? 0x66168447 : 0x33000000,
                                        ),
                                        blurRadius: active ? 14 : 8,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                            ),
                            child: icon,
                          ),
                          if (primary)
                            Positioned(
                              top: 7,
                              left: 10,
                              right: 10,
                              height: 16,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(999),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.55),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: primary ? 2 : 4),
                  Transform.translate(
                    offset: Offset(0, primary ? -8 : 0),
                    child: Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: AppText.body(
                        size: 10,
                        height: 1.1,
                        weight: active || primary
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: foreground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
