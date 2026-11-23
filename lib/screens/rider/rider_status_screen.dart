import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/api_models.dart';
import '../../providers/rider_status_provider.dart';
import '../../widgets/common/brand_button.dart';
import '../../widgets/common/cards.dart';
import '../../widgets/common/reveal.dart';
import '../../widgets/common/section_widgets.dart';
import '../../widgets/form/form_widgets.dart';
import '../../widgets/layout/navigation.dart';
import '../../widgets/layout/site_page.dart';

/// Status badge colours from `riderStatusClass()` in src/utils/rider.js.
(Color, Color) riderStatusColors(String status) {
  switch (status) {
    case 'Submitted':
      return (AppColors.amber100, AppColors.amber900);
    case 'Under Review':
      return (AppColors.blue100, AppColors.blue900);
    case 'Additional Documents Required':
      return (AppColors.violet100, AppColors.violet900);
    case 'Approved':
      return (AppColors.emerald100, AppColors.emerald900);
    case 'Active':
      return (AppColors.emerald600, Colors.white);
    case 'Rejected':
      return (AppColors.red100, AppColors.red900);
    case 'Inactive':
      return (AppColors.slate200, AppColors.slate700);
    default:
      return (AppColors.light, AppColors.dark);
  }
}

class RiderStatusScreen extends StatelessWidget {
  const RiderStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<RiderStatusProvider>();
    final r = p.result;
    return SitePage(
      route: Routes.riderStatus,
      children: [
        const PageHero(
          eyebrow: 'Application status',
          title: 'Check your rider application',
          description: 'Enter the Application ID from your confirmation screen. No login is needed.',
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
                        label: 'Application ID',
                        required: true,
                        hint: 'Format: RIDER-YYYYMMDD-XXXXXX',
                        child: AppTextField(
                          controller: p.applicationId,
                          hint: 'RIDER-20261120-ABC123',
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
                        'This page shows application status only. It does not display documents, bank details or other private information. Do not share your Application ID publicly.',
                        style: AppText.body(
                          size: 14,
                          height: 1.6,
                          color: AppColors.muted,
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
                                onTap: () =>
                                    AppNav.push(context, Routes.contact),
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
                            const TextSpan(
                              text: ' and mention your Application ID.',
                            ),
                          ],
                        ),
                      ),
                      if (r != null &&
                          r.applicationStatus == 'Approved' &&
                          !r.active) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              LucideIcons.checkCircle2,
                              size: 17,
                              color: AppColors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Approval is not activation. You will receive a separate activation update.',
                                style: AppText.body(
                                  size: 14,
                                  weight: FontWeight.w700,
                                  color: AppColors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
  final RiderStatusResult r;

  @override
  Widget build(BuildContext context) {
    final label = r.active ? 'Active' : r.applicationStatus;
    final (bg, fg) = riderStatusColors(label);
    Widget box(String t, String v) => Container(
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
            t.toUpperCase(),
            style: AppText.body(
              size: 12,
              weight: FontWeight.w800,
              letterSpacing: 1.6,
              color: AppColors.muted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            v,
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
                r.applicationId,
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
                  label,
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
          Text('Application update', style: AppText.display(size: 24)),
          const SizedBox(height: 12),
          Text(
            r.nextSteps,
            style: AppText.body(size: 16, height: 1.6, color: AppColors.muted),
          ),
          if (r.active) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.emerald50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.checkCircle2,
                    size: 18,
                    color: AppColors.emerald900,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your rider account is active.',
                      style: AppText.body(
                        size: 14,
                        weight: FontWeight.w700,
                        color: AppColors.emerald900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (r.riderId != null) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.yellow.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RIDER ID',
                    style: AppText.body(
                      size: 12,
                      weight: FontWeight.w800,
                      letterSpacing: 1.6,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(r.riderId!, style: AppText.display(size: 20)),
                ],
              ),
            ),
          ],
          if (r.documentRequestMessage != null) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.violet50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text.rich(
                TextSpan(
                  style: AppText.body(
                    size: 14,
                    height: 1.6,
                    color: AppColors.violet900,
                  ),
                  children: [
                    TextSpan(
                      text: 'Message from our team: ',
                      style: AppText.body(
                        size: 14,
                        weight: FontWeight.w800,
                        color: AppColors.violet900,
                      ),
                    ),
                    TextSpan(text: r.documentRequestMessage!),
                  ],
                ),
              ),
            ),
          ],
          if (r.rejectionReason != null) ...[
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.red50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text.rich(
                TextSpan(
                  style: AppText.body(
                    size: 14,
                    height: 1.6,
                    color: AppColors.red900,
                  ),
                  children: [
                    TextSpan(
                      text: 'Reason: ',
                      style: AppText.body(
                        size: 14,
                        weight: FontWeight.w800,
                        color: AppColors.red900,
                      ),
                    ),
                    TextSpan(text: r.rejectionReason!),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 28),
          box('Submitted', formatDateTime(r.submittedAt)),
          const SizedBox(height: 12),
          box('Last updated', formatDateTime(r.updatedAt)),
        ],
      ),
    );
  }
}
