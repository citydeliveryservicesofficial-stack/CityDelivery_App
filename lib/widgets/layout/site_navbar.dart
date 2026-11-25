import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../common/brand_button.dart';
import 'navigation.dart';

/// Floating pill navbar (Navbar.jsx): logo, nav links / hamburger, rider + request CTAs.
class SiteNavbar extends StatefulWidget {
  const SiteNavbar({super.key, required this.route, required this.scrolled});

  final String route;
  final bool scrolled;

  @override
  State<SiteNavbar> createState() => _SiteNavbarState();
}

class _SiteNavbarState extends State<SiteNavbar> {
  bool _open = false;

  void _go(String route) {
    setState(() => _open = false);
    AppNav.goTop(context, route, current: widget.route);
  }

  bool get _partnerActive =>
      widget.route == Routes.becomeFranchise ||
      widget.route.startsWith('/franchise/');

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final showCtas = width >= 640;
    final showLinks = width >= 1024;
    final showFranchiseCta = width >= 1280;
    final top = MediaQuery.of(context).padding.top;

    final bar = Container(
      padding: EdgeInsets.symmetric(
        horizontal: showCtas ? 24 : 12,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: widget.scrolled
            ? Colors.white.withValues(alpha: 0.72)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: widget.scrolled
            ? Border.all(color: Colors.white.withValues(alpha: 0.6))
            : null,
        boxShadow: widget.scrolled ? AppShadows.soft : null,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _go(Routes.home),
            child: Semantics(
              label: 'City Delivery Services — home',
              button: true,
              child: Image.asset(
                'assets/images/logo.webp',
                width: 120,
                height: 72,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const Spacer(),
          if (showLinks) ...[
            for (final l in kNavLinks)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: GestureDetector(
                  onTap: () => _go(l.route),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: widget.route == l.route
                          ? AppColors.yellow
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      l.label,
                      style: AppText.body(
                        size: 15,
                        weight: widget.route == l.route
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: widget.route == l.route
                            ? AppColors.dark
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(width: 12),
          ],
          if (showCtas) ...[
            GestureDetector(
              onTap: () => _go(Routes.becomeRider),
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: AppShadows.soft,
                  border: Border.all(
                    color: widget.route == Routes.becomeRider
                        ? AppColors.dark
                        : AppColors.yellowDeep.withValues(alpha: 0.4),
                    width: widget.route == Routes.becomeRider ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.bike,
                      size: 16,
                      color: AppColors.dark,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Become a Rider',
                      style: AppText.body(
                        size: 14,
                        weight: FontWeight.w800,
                        color: AppColors.dark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (showFranchiseCta) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => _go(Routes.becomeFranchise),
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: AppShadows.soft,
                    border: Border.all(
                      color: _partnerActive
                          ? AppColors.dark
                          : AppColors.greenHover,
                      width: _partnerActive ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.handshake,
                        size: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Become a Franchise',
                        style: AppText.body(
                          size: 14,
                          weight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(width: 8),
            BrandButton(
              label: 'Request a Service',
              size: BrandButtonSize.sm,
              trailing: LucideIcons.arrowRight,
              onPressed: () => _go(Routes.request),
            ),
            const SizedBox(width: 8),
          ],
          if (!showLinks)
            Semantics(
              button: true,
              label: _open ? 'Close menu' : 'Open menu',
              child: GestureDetector(
                onTap: () => setState(() => _open = !_open),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.dark,
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      _open ? LucideIcons.x : LucideIcons.menu,
                      key: ValueKey(_open),
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    return Stack(
      children: [
        if (_open)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => setState(() => _open = false),
            ),
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(12, top + 12, 12, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.scrolled
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: bar,
                      ),
                    )
                  : bar,
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: _open && !showLinks
                    ? _menu()
                    : const SizedBox(width: double.infinity),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _menu() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.lift,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final l in kNavLinks)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _go(l.route),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(minHeight: 52),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: widget.route == l.route
                      ? AppColors.yellow
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  l.label,
                  style: AppText.display(
                    size: 20,
                    weight: FontWeight.w700,
                    color: widget.route == l.route
                        ? AppColors.dark
                        : Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _go(Routes.becomeRider),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 56),
              decoration: BoxDecoration(
                color: widget.route == Routes.becomeRider
                    ? AppColors.yellowDeep
                    : AppColors.yellow,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(LucideIcons.bike, size: 18, color: AppColors.dark),
                  const SizedBox(width: 8),
                  Text(
                    'Become a Rider',
                    style: AppText.body(
                      size: 16,
                      weight: FontWeight.w800,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    LucideIcons.arrowRight,
                    size: 17,
                    color: AppColors.dark,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _go(Routes.becomeFranchise),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 56),
              decoration: BoxDecoration(
                color: _partnerActive ? AppColors.greenHover : AppColors.green,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.handshake,
                    size: 18,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Become a Franchise',
                    style: AppText.body(
                      size: 16,
                      weight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    LucideIcons.arrowRight,
                    size: 17,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          BrandButton(
            label: 'Request a Service',
            size: BrandButtonSize.lg,
            expand: true,
            trailing: LucideIcons.arrowRight,
            onPressed: () => _go(Routes.request),
          ),
        ],
      ),
    );
  }
}
