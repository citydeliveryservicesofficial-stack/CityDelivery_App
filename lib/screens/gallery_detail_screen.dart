import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../data/gallery_data.dart';
import '../widgets/common/brand_button.dart';
import '../widgets/common/cards.dart';
import '../widgets/common/reveal.dart';
import '../widgets/common/section_widgets.dart';
import '../widgets/layout/navigation.dart';
import '../widgets/layout/site_page.dart';

class GalleryDetailScreen extends StatelessWidget {
  const GalleryDetailScreen({super.key, required this.slug});
  final String slug;

  @override
  Widget build(BuildContext context) {
    final item = galleryItemBySlug(slug);
    final route = Routes.gallery(slug);
    if (item == null) {
      return SitePage(
        route: route,
        children: [
          const PageHero(
            eyebrow: 'Gallery',
            title: 'Image not found.',
            description: 'That gallery image is not available. You can return to the homepage and browse the gallery from there.',
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Center(
              child: BrandButton(
                label: 'Back to home',
                onPressed: () => AppNav.goTop(context, Routes.home),
              ),
            ),
          ),
        ],
      );
    }

    final related = [
      for (var o = 1; o <= 3; o++)
        kGalleryItems[(item.index - 1 + o) % kGalleryItems.length],
    ];

    return SitePage(
      route: route,
      children: [
        PageHero(
          eyebrow: item.category,
          title: item.title,
          description: item.text,
        ),
        ContainerX(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Reveal(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: AppShadows.lift,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.yellow, AppColors.yellowSoft],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Image.asset(
                        item.asset,
                        fit: BoxFit.cover,
                        semanticLabel: '${item.title} — City Delivery Services',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Reveal(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Eyebrow(item.category),
                    const SizedBox(height: 20),
                    Text(
                      'About this service',
                      style: AppText.display(size: 30, height: 1.15),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      item.description,
                      style: AppText.body(
                        size: 17,
                        height: 1.65,
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              for (var i = 0; i < item.highlights.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Reveal(
                    delay: Duration(milliseconds: 60 * i),
                    dy: 16,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.green.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(top: 1),
                            decoration: const BoxDecoration(
                              color: AppColors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              LucideIcons.check,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.highlights[i],
                              style: AppText.body(
                                size: 14,
                                height: 1.6,
                                color: AppColors.dark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  BrandButton(
                    label: 'Request a Service',
                    trailing: LucideIcons.arrowRight,
                    onPressed: () => AppNav.push(context, Routes.request),
                  ),
                  BrandButton(
                    label: 'How it works',
                    outline: true,
                    onPressed: () => AppNav.push(context, Routes.howItWorks),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              const SectionHeading(
                eyebrow: 'Keep exploring',
                title: 'More from the gallery',
                description: 'See more of the products and moments we help bring to your door.',
              ),
              const SizedBox(height: 40),
              for (final r in related)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Reveal(
                    child: GestureDetector(
                      onTap: () =>
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.gallery(r.slug)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.yellow.withValues(alpha: 0.4),
                          ),
                          boxShadow: AppShadows.lift,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              r.asset,
                              height: 192,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              cacheWidth: 900,
                              semanticLabel:
                                  '${r.title} — City Delivery Services',
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Eyebrow(r.category),
                                  const SizedBox(height: 10),
                                  Text(
                                    r.title,
                                    style: AppText.display(
                                      size: 18,
                                      height: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    r.text,
                                    style: AppText.body(
                                      size: 14,
                                      color: AppColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 4),
              Center(
                child: BrandButton(
                  label: 'Back to gallery',
                  outline: true,
                  leading: LucideIcons.arrowLeft,
                  onPressed: () => AppNav.goTop(context, Routes.home),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ],
    );
  }
}
