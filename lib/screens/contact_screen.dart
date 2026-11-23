import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../core/utils/helpers.dart';
import '../providers/contact_provider.dart';
import '../widgets/common/brand_button.dart';
import '../widgets/common/cards.dart';
import '../widgets/common/reveal.dart';
import '../widgets/common/section_widgets.dart';
import '../widgets/form/form_widgets.dart';
import '../widgets/layout/navigation.dart';
import '../widgets/layout/site_page.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ContactProvider>();
    final socials = Site.social.entries
        .where((e) => e.value.isNotEmpty)
        .toList();
    const socialIcons = {
      'Instagram': LucideIcons.camera,
      'Facebook': LucideIcons.users,
      'X': LucideIcons.atSign,
      'WhatsApp': LucideIcons.messageCircle,
    };
    final details =
        <({IconData icon, String label, String value, VoidCallback? onTap})>[
          if (Site.email.isNotEmpty)
            (
              icon: LucideIcons.mail,
              label: 'Email',
              value: Site.email,
              onTap: () => Launcher.mail(Site.email),
            ),
          if (Site.phone.isNotEmpty)
            (
              icon: LucideIcons.phone,
              label: 'Phone',
              value: Site.phone,
              onTap: () => Launcher.tel(Site.phone),
            ),
          if (Site.address.isNotEmpty)
            (
              icon: LucideIcons.mapPin,
              label: 'Address',
              value: Site.address,
              onTap: null,
            ),
        ];

    return SitePage(
      route: Routes.contact,
      children: [
        const PageHero(
          eyebrow: 'Contact us',
          title: 'We would love to hear from you.',
          description: 'Questions about a request or how the service works? Send us a message and our team will get back to you.',
        ),
        ContainerX(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                Reveal(
                  child: WhiteCard(
                    padding: const EdgeInsets.all(24),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: p.done.isNotEmpty
                          ? _Done(message: p.done, onAgain: p.clearDone)
                          : _Form(provider: p),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Reveal(
                  delay: const Duration(milliseconds: 100),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: AppColors.dark,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact details',
                          style: AppText.display(size: 24, color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        if (details.isEmpty)
                          Text(
                            'Contact details have not been published yet. Please use the form and we will reply by email.',
                            style: AppText.body(color: Colors.white70),
                          ),
                        for (final d in details)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: d.onTap,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconBadge(d.icon, size: 48, shadow: false),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          d.label.toUpperCase(),
                                          style: AppText.body(
                                            size: 12,
                                            weight: FontWeight.w700,
                                            letterSpacing: 1.6,
                                            color: Colors.white54,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          d.value,
                                          style: AppText.body(
                                            size: 16,
                                            weight: FontWeight.w600,
                                            color: Colors.white,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (socials.isNotEmpty)
                          Wrap(
                            spacing: 12,
                            children: [
                              for (final s in socials)
                                GestureDetector(
                                  onTap: () => Launcher.url(s.value),
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      socialIcons[s.key],
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Reveal(
                  delay: const Duration(milliseconds: 150),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.yellow, AppColors.yellowDeep],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Looking for a product?',
                          style: AppText.display(size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Skip the message and send us a request directly.',
                          style: AppText.body(
                            size: 16,
                            color: AppColors.dark.withValues(alpha: 0.75),
                          ),
                        ),
                        const SizedBox(height: 24),
                        BrandButton(
                          label: 'Request a Service',
                          trailing: LucideIcons.arrowRight,
                          onPressed: () => AppNav.push(context, Routes.request),
                        ),
                      ],
                    ),
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

class _Form extends StatelessWidget {
  const _Form({required this.provider});
  final ContactProvider provider;

  @override
  Widget build(BuildContext context) {
    final p = provider;
    return Column(
      key: const ValueKey('form'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabeledField(
          label: 'Your name',
          required: true,
          error: p.errors['name'],
          child: AppTextField(
            controller: p.name,
            hasError: p.errors['name'] != null,
            maxLength: 80,
            autofillHints: const [AutofillHints.name],
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => p.clearError('name'),
          ),
        ),
        const SizedBox(height: 20),
        LabeledField(
          label: 'Email',
          required: true,
          error: p.errors['email'],
          child: AppTextField(
            controller: p.email,
            hasError: p.errors['email'] != null,
            maxLength: 120,
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            onChanged: (_) => p.clearError('email'),
          ),
        ),
        const SizedBox(height: 20),
        LabeledField(
          label: 'Subject',
          optional: true,
          error: p.errors['subject'],
          child: AppTextField(
            controller: p.subject,
            hasError: p.errors['subject'] != null,
            maxLength: 140,
            onChanged: (_) => p.clearError('subject'),
          ),
        ),
        const SizedBox(height: 20),
        LabeledField(
          label: 'Message',
          required: true,
          error: p.errors['message'],
          child: AppTextField(
            controller: p.message,
            hasError: p.errors['message'] != null,
            maxLength: 2000,
            minLines: 6,
            maxLines: 8,
            hint: 'How can we help?',
            onChanged: (_) => p.clearError('message'),
          ),
        ),
        if (p.formError.isNotEmpty) ...[
          const SizedBox(height: 20),
          ErrorBanner(p.formError),
        ],
        const SizedBox(height: 20),
        BrandButton(
          label: p.sending ? 'Sending…' : 'Send message',
          size: BrandButtonSize.lg,
          expand: true,
          loading: p.sending,
          trailing: LucideIcons.send,
          onPressed: p.sending
              ? null
              : () {
                  FocusScope.of(context).unfocus();
                  p.submit();
                },
        ),
      ],
    );
  }
}

class _Done extends StatelessWidget {
  const _Done({required this.message, required this.onAgain});
  final String message;
  final VoidCallback onAgain;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('done'),
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.checkCircle2,
              size: 42,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text('Message sent', style: AppText.display(size: 30)),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppText.body(size: 16, height: 1.6, color: AppColors.muted),
          ),
          const SizedBox(height: 32),
          BrandButton(label: 'Send another message', onPressed: onAgain),
        ],
      ),
    );
  }
}
