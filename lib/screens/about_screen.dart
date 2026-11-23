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

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _blocks = [
    (
      LucideIcons.target,
      'Our mission',
      'To make asking for the products you love as simple as filling in a short form — with clear communication at every step.',
    ),
    (
      LucideIcons.eye,
      'Our vision',
      'A city where getting what you need from the stores you trust never feels like a chore.',
    ),
    (
      LucideIcons.smile,
      'Customer convenience',
      'No accounts, no apps, no long queues. Tell us the product, the store and your address, and we take it from there.',
    ),
    (
      LucideIcons.compass,
      'Our service approach',
      'Every request is reviewed by a person who contacts you directly to confirm the details. We tell you what is possible — and what is not.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SitePage(
      route: Routes.about,
      children: [
        const PageHero(
          eyebrow: 'About us',
          title: 'Convenience, made personal.',
          description: 'City Delivery Services is a request-based service: you tell us what you need and where it is from, and our team works with you on the next steps.',
        ),
        ContainerX(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Reveal(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Eyebrow('Who we are'),
                      const SizedBox(height: 20),
                      Text(
                        'A simple idea, carefully run.',
                        style: AppText.display(size: 34, height: 1.15),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Finding a specific product from a specific store takes time. City Delivery Services exists to take that effort off your plate. You submit a request with the product, the store and your delivery details; our team receives it instantly and gets in touch.',
                        style: AppText.body(
                          size: 17,
                          height: 1.65,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'We keep the process honest and human: every request gets a unique ID, a confirmation email and a real conversation before anything is arranged.',
                        style: AppText.body(
                          size: 17,
                          height: 1.65,
                          color: AppColors.muted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Reveal(
                  delay: const Duration(milliseconds: 100),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Stack(
                          children: [
                            Transform.rotate(
                              angle: 0.105,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.yellow,
                                  borderRadius: BorderRadius.circular(48),
                                ),
                              ),
                            ),
                            Transform.rotate(
                              angle: -0.052,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.green.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(48),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.yellow,
                                borderRadius: BorderRadius.circular(48),
                                boxShadow: AppShadows.lift,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                'assets/images/hero_visual.webp',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                semanticLabel: 'City Delivery Services courier delivering products around the city',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: AppColors.dark,
          padding: const EdgeInsets.symmetric(vertical: 80),
          child: ContainerX(
            child: Column(
              children: [
                const SectionHeading(
                  dark: true,
                  eyebrow: 'What guides us',
                  title: 'Built around four ideas',
                ),
                const SizedBox(height: 48),
                for (var i = 0; i < _blocks.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Reveal(
                      delay: Duration(milliseconds: 80 * i),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconBadge(_blocks[i].$1, shadow: false),
                            const SizedBox(height: 24),
                            Text(
                              _blocks[i].$2,
                              style: AppText.display(
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _blocks[i].$3,
                              style: AppText.body(
                                size: 16,
                                height: 1.6,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
          child: Reveal(
            child: Column(
              children: [
                Text(
                  'Let us know what you need.',
                  textAlign: TextAlign.center,
                  style: AppText.display(size: 34, height: 1.15),
                ),
                const SizedBox(height: 32),
                BrandButton(
                  label: 'Request a Service',
                  size: BrandButtonSize.lg,
                  trailing: LucideIcons.arrowRight,
                  onPressed: () => AppNav.push(context, Routes.request),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
