import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/api_models.dart';
import '../../providers/request_status_provider.dart';
import '../../widgets/common/brand_button.dart';
import '../../widgets/common/cards.dart';
import '../../widgets/common/reveal.dart';
import '../../widgets/common/section_widgets.dart';
import '../../widgets/form/form_widgets.dart';
import '../../widgets/layout/navigation.dart';
import '../../widgets/layout/site_page.dart';

(Color, Color) requestStatusColors(String status) {
  switch (status) {
    case 'Pending':
      return (AppColors.amber100, AppColors.amber900);
    case 'Reviewing':
      return (AppColors.blue100, AppColors.blue900);
    case 'Contacted':
      return (AppColors.violet100, AppColors.violet900);
    case 'Completed':
      return (AppColors.emerald100, AppColors.emerald900);
    case 'Cancelled':
      return (AppColors.red100, AppColors.red900);
    default:
      return (AppColors.light, AppColors.dark);
  }
}

class RequestStatusScreen extends StatelessWidget {
  const RequestStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<RequestStatusProvider>();
    final r = p.result;
    return SitePage(
      route: Routes.requestStatus,
      children: [
        const PageHero(
          eyebrow: 'Request status',
          title: 'Check your request',
          description: 'Enter the Request ID from your confirmation screen or email. No login is needed.',
        ),
        ContainerX(
          maxWidth: 680,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                WhiteCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabeledField(
                        label: 'Request ID',
                        required: true,
                        hint: 'Format: CDS-YYYYMMDD-XXXXXX',
                        child: AppTextField(
                          controller: p.requestId,
                          hint: 'CDS-20261126-ABC123',
                          monospace: true,
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.search,
                          inputFormatters: [_UpperCaseFormatter()],
                          onSubmitted: (_) => p.check(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      BrandButton(
                        label: p.busy ? 'Checking…' : 'Check status',
                        expand: true,
                        loading: p.busy,
                        leading: LucideIcons.search,
                        onPressed: p.busy
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                p.check();
                              },
                      ),
                      if (p.error.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.red50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            p.error,
                            style: AppText.body(
                              size: 14,
                              weight: FontWeight.w600,
                              color: AppColors.red700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (r != null) ...[
                  const SizedBox(height: 24),
                  Reveal(dy: 20, child: _ResultCard(r: r)),
                ],
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0x0D000000)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.shieldCheck,
                            size: 18,
                            color: AppColors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Privacy',
                            style: AppText.body(
                              size: 15,
                              weight: FontWeight.w800,
                              color: AppColors.dark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'This page shows request status only. It does not display your contact details, address, product image or other private information. Do not share your Request ID publicly.',
                        style: AppText.body(
                          size: 14,
                          height: 1.6,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          style: AppText.body(
                            size: 14,
                            height: 1.6,
                            color: AppColors.muted,
                          ),
                          children: [
                            const TextSpan(text: 'Requests saved on this phone are listed on the '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: GestureDetector(
                                onTap: () =>
                                    AppNav.push(context, Routes.requestHistory),
                                child: Text(
                                  'My Requests page',
                                  style: AppText.body(
                                    size: 14,
                                    weight: FontWeight.w700,
                                    color: AppColors.green,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.clipboardList,
                            size: 18,
                            color: AppColors.green,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Need help?',
                            style: AppText.body(
                              size: 15,
                              weight: FontWeight.w800,
                              color: AppColors.dark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text.rich(
                        TextSpan(
                          style: AppText.body(
                            size: 14,
                            height: 1.6,
                            color: AppColors.muted,
                          ),
                          children: [
                            const TextSpan(text: 'Contact us from the '),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: GestureDetector(
                                onTap: () => AppNav.push(context, Routes.contact),
                                child: Text(
                                  'Contact page',
                                  style: AppText.body(
                                    size: 14,
                                    weight: FontWeight.w700,
                                    color: AppColors.green,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(text: ' and mention your Request ID.'),
                          ],
                        ),
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

class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toUpperCase());
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.r});
  final RequestStatusResult r;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = requestStatusColors(r.status);
    Widget box(String label, String value) => Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.light.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: AppText.body(
                  size: 12,
                  weight: FontWeight.w800,
                  letterSpacing: 1.6,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppText.body(
                  size: 15,
                  weight: FontWeight.w700,
                  color: AppColors.dark,
                ),
              ),
            ],
          ),
        );

    return WhiteCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              Text(
                r.requestId,
                style: AppText.body(
                  size: 18,
                  weight: FontWeight.w800,
                  color: AppColors.dark,
                ).copyWith(fontFamily: 'monospace'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  r.status,
                  style: AppText.body(
                    size: 14,
                    weight: FontWeight.w800,
                    color: fg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Text('Request update', style: AppText.display(size: 24)),
          const SizedBox(height: 12),
          Text(
            r.nextSteps.isEmpty
                ? 'Our team is handling your request. We will contact you with the next steps.'
                : r.nextSteps,
            style: AppText.body(size: 16, height: 1.6, color: AppColors.muted),
          ),
          const SizedBox(height: 28),
          box('Submitted', formatDateTime(r.createdAt)),
          const SizedBox(height: 12),
          box('Last updated', formatDateTime(r.updatedAt)),
        ],
      ),
    );
  }
}
