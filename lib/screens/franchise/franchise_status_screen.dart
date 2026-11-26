import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/franchise_models.dart';
import '../../providers/franchise_provider.dart';
import '../../widgets/common/brand_button.dart';
import '../../widgets/common/cards.dart';
import '../../widgets/common/reveal.dart';
import '../../widgets/common/section_widgets.dart';
import '../../widgets/form/form_widgets.dart';
import '../../widgets/layout/navigation.dart';
import '../../widgets/layout/site_page.dart';

const _statusGuide = [
  (
    'Payment Pending',
    'Application received. The optional initial payment has not been recorded.',
  ),
  (
    'Under Review',
    'Our team is reviewing your application and may contact you for details.',
  ),
  (
    'Payment Successful',
    'The optional initial payment has been recorded. Review continues.',
  ),
  (
    'Approved',
    'Your application was approved. Agreement and activation come next.',
  ),
  (
    'Agreement Pending',
    'Terms are being prepared or reviewed in writing.',
  ),
  (
    'Active Franchise',
    'Agreement and activation are complete for the approved area.',
  ),
  (
    'Rejected',
    'This application was not approved. Contact us if you think a detail was missed.',
  ),
];

(Color, Color) franchiseStatusColors(String status) {
  switch (status) {
    case 'Payment Pending':
      return (AppColors.amber100, AppColors.amber900);
    case 'Payment Successful':
      return (const Color(0xFFE0F2FE), const Color(0xFF0C4A6E));
    case 'Approved':
      return (AppColors.emerald100, AppColors.emerald900);
    case 'Active Franchise':
      return (AppColors.emerald600, Colors.white);
    case 'Under Review':
      return (AppColors.blue100, AppColors.blue900);
    case 'Agreement Pending':
      return (AppColors.violet100, AppColors.violet900);
    case 'Rejected':
      return (AppColors.red100, AppColors.red900);
    default:
      return (AppColors.light, AppColors.dark);
  }
}

class FranchiseStatusScreen extends StatefulWidget {
  const FranchiseStatusScreen({super.key});

  @override
  State<FranchiseStatusScreen> createState() => _FranchiseStatusScreenState();
}

class _FranchiseStatusScreenState extends State<FranchiseStatusScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final p = context.read<FranchiseProvider>();
      if (p.statusController.text.trim().isNotEmpty && p.statusResult == null) {
        p.checkStatus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<FranchiseProvider>();
    final result = p.statusResult;

    return SitePage(
      route: Routes.franchiseStatus,
      children: [
        const PageHero(
          eyebrow: 'Application status',
          title: 'Check your franchise application',
          description:
              'Enter the Application ID from your confirmation screen. No login is needed.',
        ),
        ContainerX(
          maxWidth: 860,
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
                        hint: 'Format: FRANCH-YYYYMMDD-XXXXXX',
                        child: AppTextField(
                          controller: p.statusController,
                          hint: 'FRANCH-20261125-ABC123',
                          monospace: true,
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.search,
                          inputFormatters: [_UpperCaseFormatter()],
                          onSubmitted: (_) => p.checkStatus(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      BrandButton(
                        label: p.checkingStatus ? 'Checking…' : 'Check status',
                        expand: true,
                        loading: p.checkingStatus,
                        leading: LucideIcons.search,
                        onPressed: p.checkingStatus
                            ? null
                            : () {
                                FocusScope.of(context).unfocus();
                                p.checkStatus();
                              },
                      ),
                      if (p.statusError.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        ErrorBanner(p.statusError),
                      ],
                    ],
                  ),
                ),
                if (result != null) ...[
                  const SizedBox(height: 24),
                  Reveal(dy: 20, child: _ResultCard(provider: p, result: result)),
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
                            const TextSpan(
                              text: ' and mention your Application ID.',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.yellow.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What each status means',
                        style: AppText.display(size: 24),
                      ),
                      const SizedBox(height: 18),
                      for (final item in _statusGuide) ...[
                        Text(
                          item.$1,
                          style: AppText.body(
                            size: 14,
                            weight: FontWeight.w800,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.$2,
                          style: AppText.body(
                            size: 13,
                            height: 1.5,
                            color: AppColors.muted,
                          ),
                        ),
                        if (item.$1 != _statusGuide.last.$1)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(height: 1),
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
  const _ResultCard({required this.provider, required this.result});

  final FranchiseProvider provider;
  final FranchiseStatusResult result;

  @override
  Widget build(BuildContext context) {
    final app = result.application;
    final (bg, fg) = franchiseStatusColors(app.applicationStatus);

    Widget box(String title, String value) => Container(
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
            title.toUpperCase(),
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
                app.applicationId,
                style: AppText.body(
                  size: 18,
                  weight: FontWeight.w800,
                  color: AppColors.dark,
                ).copyWith(fontFamily: 'monospace'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  app.applicationStatus,
                  style: AppText.body(
                    size: 14,
                    weight: FontWeight.w800,
                    color: fg,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Application update', style: AppText.display(size: 24)),
          const SizedBox(height: 10),
          Text(
            app.nextSteps.isEmpty
                ? 'Your application has been received. Our team will update this page as it moves forward.'
                : app.nextSteps,
            style: AppText.body(size: 16, height: 1.6, color: AppColors.muted),
          ),
          if (app.infoRequestMessage.isNotEmpty) ...[
            const SizedBox(height: 18),
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
                    const TextSpan(
                      text: 'Message from our team: ',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    TextSpan(text: app.infoRequestMessage),
                  ],
                ),
              ),
            ),
          ],
          if (app.rejectionReason.isNotEmpty) ...[
            const SizedBox(height: 18),
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
                    const TextSpan(
                      text: 'Reason: ',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    TextSpan(text: app.rejectionReason),
                  ],
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          _PaymentCard(provider: provider, app: app),
          const SizedBox(height: 24),
          box('Submitted', formatFranchiseDate(app.submittedAt)),
          const SizedBox(height: 12),
          box('Last updated', formatFranchiseDate(app.updatedAt)),
          if (app.franchiseId != null) ...[
            const SizedBox(height: 12),
            box('Franchise ID', app.franchiseId!),
          ],
        ],
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.provider, required this.app});

  final FranchiseProvider provider;
  final FranchiseApplication app;

  @override
  Widget build(BuildContext context) {
    final payment = app.payment;
    final instructions = provider.config.paymentInstructions;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.light.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x14000000)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                LucideIcons.wallet,
                size: 20,
                color: AppColors.green,
              ),
              const SizedBox(width: 10),
              Text(
                'Optional initial payment',
                style: AppText.display(size: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _PaymentBox(label: 'Amount', value: app.fee.label),
              _PaymentBox(label: 'Payment status', value: payment.status),
              _PaymentBox(
                label: 'Paid at',
                value: formatFranchiseDate(payment.paidAt),
              ),
              if (payment.transactionId != null)
                _PaymentBox(
                  label: 'Reference',
                  value: payment.transactionId!,
                ),
            ],
          ),
          if (payment.lastError.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              payment.lastError,
              style: AppText.body(
                size: 13,
                height: 1.5,
                color: AppColors.red700,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            app.fee.refundPolicyDetails.isEmpty
                ? 'Refund policy: ${app.fee.refundPolicy}.'
                : 'Refund policy: ${app.fee.refundPolicy}. ${app.fee.refundPolicyDetails}',
            style: AppText.body(size: 13, height: 1.5, color: AppColors.muted),
          ),
          const SizedBox(height: 6),
          Text(
            'Payment does not guarantee approval, an agreement, exclusive territory or income. Your application remains under review.',
            style: AppText.body(size: 13, height: 1.5, color: AppColors.muted),
          ),
          const SizedBox(height: 14),
          Text(
            instructions.isEmpty
                ? 'Our team will share the simple payment steps after you apply. Save your Application ID and use this page to check payment status.'
                : 'Payment steps:\n$instructions',
            style: AppText.body(
              size: 13,
              height: 1.5,
              weight: FontWeight.w700,
              color:
                  instructions.isEmpty ? AppColors.amber900 : AppColors.muted,
            ),
          ),
          if (payment.isPaid) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  LucideIcons.checkCircle2,
                  size: 17,
                  color: AppColors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  'Payment recorded.',
                  style: AppText.body(
                    size: 14,
                    weight: FontWeight.w800,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: BrandButton(
              label: 'Copy Application ID',
              outline: true,
              size: BrandButtonSize.sm,
              expand: true,
              leading: LucideIcons.copy,
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: app.applicationId),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Application ID copied')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentBox extends StatelessWidget {
  const _PaymentBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0x0D000000)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: AppText.body(
                size: 11,
                weight: FontWeight.w800,
                letterSpacing: 1.4,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppText.body(size: 14, weight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
