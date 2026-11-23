import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../widgets/common/brand_button.dart';
import '../widgets/layout/navigation.dart';
import '../widgets/layout/site_page.dart';

class NotFoundScreen extends StatefulWidget {
  const NotFoundScreen({super.key});

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 5),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return SitePage(
      route: '/404',
      children: [
        Container(
          constraints: BoxConstraints(minHeight: h * 0.85),
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 40),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _c,
                builder: (_, child) => Transform.translate(
                  offset: Offset(0, -12 * (1 - (2 * _c.value - 1).abs())),
                  child: Transform.rotate(
                    angle:
                        0.07 *
                        (_c.value < .5 ? -1 : 1) *
                        (1 - (2 * _c.value - 1).abs()),
                    child: child,
                  ),
                ),
                child: Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: AppColors.dark,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: const Icon(
                    LucideIcons.package,
                    size: 60,
                    color: AppColors.yellow,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text('404', style: AppText.display(size: 76)),
              const SizedBox(height: 16),
              Text(
                'This page seems to have gone missing in transit.',
                textAlign: TextAlign.center,
                style: AppText.body(size: 18, color: AppColors.muted),
              ),
              const SizedBox(height: 32),
              BrandButton(
                label: 'Back to home',
                onPressed: () => AppNav.goTop(context, Routes.home),
              ),
              const SizedBox(height: 12),
              BrandButton(
                label: 'Request a Service',
                outline: true,
                onPressed: () => AppNav.push(context, Routes.request),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
