import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/layout/auto_marquee.dart';

const _items = [
  (LucideIcons.truck, 'Doorstep Delivery'),
  (LucideIcons.store, 'Groceries & Daily Needs'),
  (LucideIcons.heartHandshake, 'Medicines & Health'),
  (LucideIcons.send, 'Gifts & Surprises'),
  (LucideIcons.bike, 'Shoes & Fashion'),
  (LucideIcons.zap, 'Electronics & Gadgets'),
  (LucideIcons.shieldCheck, 'Any Store, Any Product'),
  (LucideIcons.bellRing, 'On Time, Every Time'),
];

/// Green ticker band listing what the service can deliver.
class MarqueeSection extends StatelessWidget {
  const MarqueeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'What we can deliver',
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0A6E25), AppColors.homeGreen, Color(0xFF0A6E25)],
          ),
          border: Border.symmetric(
            horizontal: BorderSide(
              color: AppColors.yellow.withValues(alpha: 0.4),
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ShaderMask(
          shaderCallback: (r) => const LinearGradient(
            colors: [
              Colors.transparent,
              Colors.white,
              Colors.white,
              Colors.transparent,
            ],
            stops: [0, 0.06, 0.94, 1],
          ).createShader(r),
          blendMode: BlendMode.dstIn,
          child: SizedBox(
            height: 28,
            child: AutoMarquee(
              pixelsPerSecond: 42,
              copyBuilder: (copy) => Row(
                children: [
                  for (final it in _items) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 27),
                      child: Row(
                        children: [
                          Icon(it.$1, size: 18, color: const Color(0xFFFFE08A)),
                          const SizedBox(width: 11),
                          Text(
                            it.$2.toUpperCase(),
                            style:
                                AppText.display(
                                  size: 14,
                                  weight: FontWeight.w600,
                                  letterSpacing: 2.4,
                                  color: Colors.white,
                                ).copyWith(
                                  shadows: const [
                                    Shadow(
                                      color: Color(0x4D000000),
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ),
                    Transform.rotate(
                      angle: 0.785,
                      child: Container(
                        width: 6,
                        height: 6,
                        color: AppColors.yellow,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
