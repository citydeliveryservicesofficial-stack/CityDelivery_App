import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../widgets/common/brand_button.dart';
import '../widgets/common/cards.dart';
import '../widgets/common/reveal.dart';
import '../widgets/common/section_widgets.dart';
import '../widgets/layout/navigation.dart';
import '../widgets/layout/site_page.dart';

class HowItWorksScreen extends StatelessWidget {
  const HowItWorksScreen({super.key});

  static const _steps = [
    (
      LucideIcons.clipboardList,
      'Tell us what product you need',
      'Give the product a name, choose a category and describe it — brand, size, colour. Add a photo if it helps.',
    ),
    (
      LucideIcons.store,
      'Share the store information',
      'Tell us the store name and where it is located so we know exactly where to look.',
    ),
    (
      LucideIcons.send,
      'Submit your request',
      'Add your delivery address and contact details, then press submit. You instantly receive a unique Request ID.',
    ),
    (
      LucideIcons.bellRing,
      'Our team receives your request',
      'Your request is saved and our team is notified with every detail you provided. If you add an email address, you get a confirmation email too.',
    ),
    (
      LucideIcons.phoneCall,
      'Our team contacts you with the next steps',
      'A team member reviews the request and reaches out to confirm details, availability and what happens next.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SitePage(
      route: Routes.howItWorks,
      children: [
        const PageHero(
          eyebrow: 'How it works',
          title: 'From idea to inbox in five steps.',
          description: 'A clear, honest process. Submitting a request starts the conversation — our team confirms everything with you directly.',
        ),
        ContainerX(
          maxWidth: 720,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                Stack(
                  children: [
                    Positioned(
                      left: 26,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: AppColors.yellow.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(milliseconds: 1600),
                            curve: Curves.easeOutCubic,
                            builder: (_, v, __) => FractionallySizedBox(
                              heightFactor: v,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.green,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        for (var i = 0; i < _steps.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 48),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 80),
                                  child: Reveal(
                                    child: WhiteCard(
                                      padding: const EdgeInsets.all(28),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          IconBadge(_steps[i].$1),
                                          const SizedBox(height: 20),
                                          Text(
                                            _steps[i].$2,
                                            style: AppText.display(
                                              size: 22,
                                              height: 1.2,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            _steps[i].$3,
                                            style: AppText.body(
                                              size: 16,
                                              height: 1.6,
                                              color: AppColors.muted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 56,
                                  height: 56,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.dark,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: AppShadows.lift,
                                  ),
                                  child: Text(
                                    '${i + 1}',
                                    style: AppText.display(
                                      size: 20,
                                      color: AppColors.yellow,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Reveal(
                  child: Column(
                    children: [
                      Text(
                        'Please note: a submitted request is not an automatic order. Availability, pricing and timing are confirmed by our team.',
                        textAlign: TextAlign.center,
                        style: AppText.body(
                          size: 16,
                          height: 1.6,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: 32),
                      BrandButton(
                        label: 'Start your request',
                        size: BrandButtonSize.lg,
                        trailing: LucideIcons.arrowRight,
                        onPressed: () => AppNav.push(context, Routes.request),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
