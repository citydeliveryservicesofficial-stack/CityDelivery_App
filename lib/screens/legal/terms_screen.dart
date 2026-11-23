import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/cards.dart';
import '../../widgets/common/section_widgets.dart';
import '../../widgets/layout/navigation.dart';
import '../../widgets/layout/site_page.dart';

const _sections = [
  (
    '1. Request-based service',
    'City Delivery Services helps you submit a product and delivery request. A request starts a conversation with our team; it is not an automatic order or a guarantee that an item is available.',
  ),
  (
    '2. Accurate information',
    'Please provide accurate contact, product, store and delivery details. We may contact you to clarify the request before confirming what can be arranged.',
  ),
  (
    '3. Confirmation before arrangement',
    'Availability, price, timing and any delivery arrangement are confirmed with you directly. Do not assume that a submitted request has been accepted until our team confirms the next steps.',
  ),
  (
    '4. Images and content',
    'Only upload product images and information that you are permitted to share. Uploaded images are used to help our team identify the requested product.',
  ),
  (
    '5. Contact',
    'For questions about these terms, use the Contact page or reach us through the contact details published on this website.',
  ),
];

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SitePage(
      route: Routes.terms,
      children: [
        const PageHero(
          eyebrow: 'Legal',
          title: 'Terms and Conditions',
          description:
              'The basic terms for using our request-based delivery service.',
        ),
        ContainerX(
          maxWidth: 760,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                for (final s in _sections)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: WhiteCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.$1, style: AppText.display(size: 20)),
                          const SizedBox(height: 10),
                          Text(
                            s.$2,
                            style: AppText.body(
                              size: 16,
                              height: 1.7,
                              color: AppColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  'Canonical page: ${Site.websiteUrl}/terms',
                  style: AppText.body(size: 13, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
