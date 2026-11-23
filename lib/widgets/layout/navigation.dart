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

  static const _destinations = <({String route, String label, IconData icon})>[
    (route: Routes.home, label: 'Home', icon: LucideIcons.home),
    (route: Routes.request, label: 'Request', icon: LucideIcons.clipboardList),
    (
      route: Routes.becomeRider,
      label: 'Become a partner',
      icon: LucideIcons.handshake,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFECECEC))),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: [
              for (final destination in _destinations)
                Expanded(
                  child: _AppBottomNavItem(
                    icon: destination.icon,
                    label: destination.label,
                    active: _isActive(route, destination.route),
                    onTap: () => AppNav.goTop(
                      context,
                      destination.route,
                      current: route,
                    ),
                  ),
                ),
            ],
          ),
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

class _AppBottomNavItem extends StatelessWidget {
  const _AppBottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.green : AppColors.muted;
    return Semantics(
      button: true,
      selected: active,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 30,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.yellow.withValues(alpha: 0.28)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: AppText.body(
                size: 10,
                height: 1.1,
                weight: active ? FontWeight.w800 : FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
