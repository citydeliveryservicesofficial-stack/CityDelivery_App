import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../widgets/common/cards.dart';
import '../../widgets/common/section_widgets.dart';
import '../../widgets/layout/navigation.dart';
import '../../widgets/layout/site_page.dart';

const _sections = <({String title, List<String> body})>[
  (
    title: '1. Information we collect',
    body: [
      'When you submit a product request we collect the details you enter: your name, optional email address and mobile number; the product name, category, optional store name, store location and description, quantity and optional estimated budget for each item you add; and one delivery address, city, postal code and any additional instructions. We also record whether you accepted the Prohibited Items Policy, the version accepted and the time of acceptance.',
      'If you choose to attach a product image, we collect that image. When you use the contact form we collect your name, email address, optional subject and your message.',
    ],
  ),
  (
    title: '2. How we use product request information',
    body: [
      'We use this information only to review and respond to your request — for example to contact you, confirm details and arrange next steps. Every request is given a unique Request ID so we and you can refer to it.',
    ],
  ),
  (
    title: '3. Email communication',
    body: [
      'After you submit a request we send a confirmation email to the address you provide, and we send a notification email containing your request details to our team. We may also reply to you by email or phone about your request or contact message.',
      'We do not use the details you provide for a product request to send unrelated marketing emails.',
    ],
  ),
  (
    title: '4. Data storage',
    body: [
      'Request and contact details are stored in a database operated for this service. Uploaded product images are stored with a third-party image hosting provider (Cloudinary) so our team can view them. Email is sent through an SMTP email service configured by the business.',
      'We keep this information for as long as it is needed to handle your request and for the business’s record-keeping, after which it may be deleted.',
    ],
  ),
  (
    title: '5. Data protection',
    body: [
      'We take reasonable technical steps to protect your information, including validating and sanitising submitted data, limiting the types and size of uploaded files, rate-limiting submissions, restricting access to administrative functions and keeping service credentials out of the website code.',
      'No method of transmission or storage is completely secure, so we cannot guarantee absolute security. We do not claim any formal security certification or regulatory compliance.',
    ],
  ),
  (
    title: '6. Sharing',
    body: [
      'We do not sell your personal information. It is accessible to our team and to the service providers mentioned above (database, image hosting and email delivery) only to the extent needed to operate the service, or where we are required to disclose it by law.',
    ],
  ),
  (
    title: '7. Your choices',
    body: [
      'You can ask us to correct or delete the information associated with your request by contacting us and quoting your Request ID.',
    ],
  ),
];

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final body = AppText.body(size: 16, height: 1.7, color: AppColors.muted);
    final link = AppText.body(
      size: 16,
      height: 1.7,
      weight: FontWeight.w700,
      color: AppColors.green,
    );
    return SitePage(
      route: Routes.privacy,
      children: [
        const PageHero(
          eyebrow: 'Legal',
          title: 'Privacy Policy',
          description: 'Last updated: November 2026',
        ),
        ContainerX(
          maxWidth: 760,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: WhiteCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This policy explains what information City Delivery Services collects through this website, why we collect it and how it is handled.',
                    style: body,
                  ),
                  for (final s in _sections) ...[
                    const SizedBox(height: 28),
                    Text(s.title, style: AppText.display(size: 20)),
                    for (final p in s.body) ...[
                      const SizedBox(height: 10),
                      Text(p, style: body),
                    ],
                  ],
                  const SizedBox(height: 28),
                  Text(
                    '8. Privacy questions',
                    style: AppText.display(size: 20),
                  ),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      style: body,
                      children: [
                        const TextSpan(text: 'For any privacy concern, '),
                        if (Site.email.isNotEmpty) ...[
                          const TextSpan(text: 'email us at '),
                          TextSpan(
                            text: Site.email,
                            style: link,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Launcher.mail(Site.email),
                          ),
                          const TextSpan(text: ' or '),
                        ],
                        const TextSpan(text: 'use the '),
                        TextSpan(
                          text: 'contact form',
                          style: link,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                AppNav.push(context, Routes.contact),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
