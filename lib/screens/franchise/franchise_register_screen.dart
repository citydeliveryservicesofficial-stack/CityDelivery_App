import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/franchise_provider.dart';
import '../../widgets/common/brand_button.dart';
import '../../widgets/common/cards.dart';
import '../../widgets/common/reveal.dart';
import '../../widgets/common/section_widgets.dart';
import '../../widgets/form/form_widgets.dart';
import '../../widgets/form/upload_fields.dart';
import '../../widgets/layout/navigation.dart';
import '../../widgets/layout/site_page.dart';

const _steps = [
  'Your details',
  'Area & experience',
  'Vehicles & office',
  'Review & submit',
];

class FranchiseRegisterScreen extends StatefulWidget {
  const FranchiseRegisterScreen({super.key});

  @override
  State<FranchiseRegisterScreen> createState() =>
      _FranchiseRegisterScreenState();
}

class _FranchiseRegisterScreenState extends State<FranchiseRegisterScreen> {
  final _keys = FieldKeys();
  final _scroll = ScrollController();
  final _stepperKey = GlobalKey();
  int _step = 0;

  @override
  void dispose() {
    _keys.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _toStepper() async {
    final ctx = _stepperKey.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      alignment: 0.02,
    );
  }

  Future<void> _afterFailure(FranchiseProvider p) async {
    if (p.errors.isEmpty) return;
    const ordered = [
      'fullName',
      'mobile',
      'email',
      'state',
      'district',
      'city',
      'preferredOperatingArea',
      'pincode',
      'fullAddress',
      'investmentCapacity',
      'hasOfficeOrShop',
      'vehicles',
      'otherVehicleType',
      'consents.accurate',
      'consents.contact',
      'businessProof',
      'addressProof',
      'otherProof',
    ];
    for (final key in ordered) {
      if (p.errors.containsKey(key)) {
        await _keys.scrollTo(key);
        return;
      }
    }
    await _keys.scrollTo(p.errors.keys.first);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<FranchiseProvider>();

    if (p.result != null) {
      return SitePage(
        route: Routes.franchiseRegister,
        controller: _scroll,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 130, 20, 80),
            child: _Success(provider: p),
          ),
        ],
      );
    }

    return SitePage(
      route: Routes.franchiseRegister,
      controller: _scroll,
      children: [
        const PageHero(
          eyebrow: 'Franchise application',
          title: 'Apply to become a franchise partner',
          description:
              'Tell us about yourself, your proposed operating area and the local capacity you can arrange. You can review everything before you submit.',
        ),
        ContainerX(
          maxWidth: 860,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: WhiteCard(
              key: _stepperKey,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Stepper(step: _step),
                  const SizedBox(height: 32),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween(
                          begin: const Offset(0.06, 0),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: KeyedSubtree(
                      key: ValueKey(_step),
                      child: _StepBody(step: _step, provider: p, keys: _keys),
                    ),
                  ),
                  if (p.formError.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    ErrorBanner(p.formError),
                  ],
                  const SizedBox(height: 28),
                  Container(height: 1, color: Colors.black.withValues(alpha: 0.05)),
                  const SizedBox(height: 20),
                  if (_step < _steps.length - 1)
                    BrandButton(
                      label: 'Continue',
                      expand: true,
                      trailing: LucideIcons.arrowRight,
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        setState(() => _step += 1);
                        await _toStepper();
                      },
                    )
                  else
                    BrandButton(
                      label: p.submitting
                          ? 'Submitting…'
                          : 'Submit application',
                      expand: true,
                      loading: p.submitting,
                      leading: LucideIcons.fileCheck2,
                      onPressed: p.submitting
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              await p.submit();
                              if (!mounted) return;
                              if (p.result != null) {
                                if (_scroll.hasClients) _scroll.jumpTo(0);
                              } else {
                                await _afterFailure(p);
                              }
                            },
                    ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton.icon(
                      onPressed: _step == 0 || p.submitting
                          ? null
                          : () async {
                              setState(() => _step -= 1);
                              await _toStepper();
                            },
                      icon: const Icon(LucideIcons.arrowLeft, size: 17),
                      label: Text(
                        'Back',
                        style: AppText.body(
                          size: 14,
                          weight: FontWeight.w700,
                          color: _step == 0 ? AppColors.muted : AppColors.dark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 1),
                        child: Icon(
                          LucideIcons.shieldCheck,
                          size: 15,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Submitting does not guarantee approval, an agreement, territory or income. Application details are reviewed by our team.',
                          textAlign: TextAlign.center,
                          style: AppText.body(size: 12, color: AppColors.muted),
                        ),
                      ),
                    ],
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

class _Stepper extends StatelessWidget {
  const _Stepper({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _steps.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final current = i == step;
              final done = i < step;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: current
                      ? AppColors.dark
                      : done
                      ? AppColors.yellow.withValues(alpha: 0.4)
                      : AppColors.light,
                ),
                child: Text(
                  '${i + 1}. ${_steps[i]}',
                  style: AppText.body(
                    size: 12,
                    weight: FontWeight.w700,
                    color: current
                        ? AppColors.yellow
                        : done
                        ? AppColors.dark
                        : AppColors.muted.withValues(alpha: 0.7),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 8,
            color: AppColors.light,
            alignment: Alignment.centerLeft,
            child: AnimatedFractionallySizedBox(
              duration: const Duration(milliseconds: 300),
              widthFactor: (step + 1) / _steps.length,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StepBody extends StatelessWidget {
  const _StepBody({
    required this.step,
    required this.provider,
    required this.keys,
  });

  final int step;
  final FranchiseProvider provider;
  final FieldKeys keys;

  static const _gap = SizedBox(height: 20);

  FranchiseProvider get p => provider;

  Widget tf(
    String path,
    String label, {
    bool required = false,
    bool optional = false,
    String? hint,
    String? placeholder,
    TextInputType? type,
    TextCapitalization cap = TextCapitalization.none,
    int? maxLength,
    int maxLines = 1,
    Iterable<String>? autofill,
    List<TextInputFormatter>? formatters,
  }) {
    final e = p.error(path);
    return LabeledField(
      key: keys.key(path),
      label: label,
      required: required,
      optional: optional,
      hint: hint,
      error: e,
      child: AppTextField(
        controller: p.controllers[path]!,
        focusNode: keys.node(path),
        hasError: e != null,
        hint: placeholder,
        keyboardType: type,
        textCapitalization: cap,
        maxLength: maxLength,
        maxLines: maxLines,
        minLines: maxLines > 1 ? 3 : 1,
        autofillHints: autofill,
        inputFormatters: formatters,
        onChanged: (_) => p.clearError(path),
      ),
    );
  }

  Widget select(
    String path,
    String label,
    List<String> options,
    String placeholder, {
    bool required = false,
  }) {
    final e = p.error(path);
    return LabeledField(
      key: keys.key(path),
      label: label,
      required: required,
      error: e,
      child: SelectField(
        value: path == 'investmentCapacity'
            ? p.investmentCapacity
            : p.raw(path),
        options: options,
        placeholder: placeholder,
        hasError: e != null,
        onChanged: (v) =>
            path == 'investmentCapacity' ? p.setInvestment(v) : p.set(path, v),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case 0:
        return Column(
          children: [
            tf(
              'fullName',
              'Full name',
              required: true,
              placeholder: 'As on your ID',
              cap: TextCapitalization.words,
              autofill: const [AutofillHints.name],
            ),
            _gap,
            tf(
              'mobile',
              'Mobile number',
              required: true,
              placeholder: '10-digit mobile number',
              type: TextInputType.phone,
              autofill: const [AutofillHints.telephoneNumber],
            ),
            _gap,
            tf(
              'email',
              'Email address',
              required: true,
              hint: 'Application updates are sent to this address.',
              type: TextInputType.emailAddress,
              autofill: const [AutofillHints.email],
            ),
            _gap,
            tf(
              'state',
              'State',
              required: true,
              cap: TextCapitalization.words,
              autofill: const [AutofillHints.addressState],
            ),
            _gap,
            tf(
              'district',
              'District',
              required: true,
              cap: TextCapitalization.words,
            ),
            _gap,
            tf(
              'city',
              'City / town',
              required: true,
              cap: TextCapitalization.words,
              autofill: const [AutofillHints.addressCity],
            ),
            _gap,
            tf(
              'preferredOperatingArea',
              'Preferred operating area',
              required: true,
              placeholder: 'Area / locality you want to support',
              cap: TextCapitalization.words,
            ),
            _gap,
            tf(
              'pincode',
              'PIN code',
              required: true,
              placeholder: '632009',
              type: TextInputType.number,
              maxLength: 6,
              autofill: const [AutofillHints.postalCode],
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            tf(
              'fullAddress',
              'Full address',
              required: true,
              placeholder: 'House no., street, landmark',
              type: TextInputType.streetAddress,
              maxLines: 3,
              autofill: const [AutofillHints.fullStreetAddress],
            ),
            _gap,
            select(
              'investmentCapacity',
              'Investment capacity',
              p.config.investmentCapacities.isEmpty
                  ? kFranchiseInvestmentCapacities
                  : p.config.investmentCapacities,
              'Select investment capacity',
              required: true,
            ),
            _gap,
            tf(
              'businessExperience',
              'Business or delivery experience',
              optional: true,
              placeholder: 'Tell us about any relevant experience',
              maxLines: 4,
            ),
            _gap,
            tf(
              'motivation',
              'Why do you want to become a partner?',
              optional: true,
              placeholder: 'A few lines about your plan for the area',
              maxLines: 4,
            ),
          ],
        );
      case 2:
        final vehicleError = p.error('vehicles');
        return Column(
          children: [
            LabeledField(
              key: keys.key('hasOfficeOrShop'),
              label: 'Do you have an office or shop?',
              required: true,
              error: p.error('hasOfficeOrShop'),
              child: Wrap(
                spacing: 12,
                children: [
                  ChoicePill(
                    label: 'Yes',
                    selected: p.hasOfficeOrShop == 'Yes',
                    onTap: () => p.setOffice('Yes'),
                  ),
                  ChoicePill(
                    label: 'No',
                    selected: p.hasOfficeOrShop == 'No',
                    onTap: () => p.setOffice('No'),
                  ),
                ],
              ),
            ),
            _gap,
            LabeledField(
              key: keys.key('vehicles'),
              label: 'How many vehicles can you arrange?',
              hint: 'Enter 0 if you cannot arrange that type right now.',
              error: vehicleError,
              child: Column(
                children: [
                  for (final type in kFranchiseVehicleTypes) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            kFranchiseVehicleLabels[type] ?? type,
                            style: AppText.body(size: 14, weight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 88,
                          child: AppTextField(
                            controller: p.vehicleCounts[type]!,
                            hasError: vehicleError != null,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            onChanged: (_) => p.clearError('vehicles'),
                          ),
                        ),
                      ],
                    ),
                    if (type != kFranchiseVehicleTypes.last)
                      const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
            _gap,
            LabeledField(
              key: keys.key('otherVehicleType'),
              label: 'Describe other vehicle type',
              optional: true,
              error: p.error('vehicles'),
              child: AppTextField(
                controller: p.otherVehicleType,
                focusNode: keys.node('otherVehicleType'),
                hasError: p.error('vehicles') != null,
                hint: 'Required only if you enter a count for Other',
                onChanged: (_) => p.clearError('vehicles'),
              ),
            ),
            _gap,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.yellow.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.truck, color: AppColors.green),
                  const SizedBox(width: 12),
                  Text(
                    '${p.vehicleTotal} vehicle${p.vehicleTotal == 1 ? '' : 's'} added',
                    style: AppText.body(size: 15, weight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        );
      case 3:
        return Column(
          children: [
            _Review(p: provider),
            _gap,
            LabeledField(
              label: 'Supporting documents',
              optional: true,
              hint: 'Optional JPG, PNG, WebP or PDF files up to 5 MB each.',
              child: Column(
                children: [
                  for (final doc in kFranchiseDocuments) ...[
                    LabeledField(
                      key: keys.key(doc.key),
                      label: doc.label,
                      optional: true,
                      error: p.error(doc.key),
                      child: DocumentUploadField(
                        label: doc.label,
                        hint: doc.hint,
                        file: p.files[doc.key],
                        onChanged: (file) => p.setFile(doc.key, file),
                      ),
                    ),
                    if (doc.key != kFranchiseDocuments.last.key)
                      const SizedBox(height: 18),
                  ],
                ],
              ),
            ),
            _gap,
            CheckTile(
              key: keys.key('consents.accurate'),
              value: p.accurate,
              error: p.error('consents.accurate'),
              onChanged: (v) => p.setConsent('accurate', v),
              label:
                  'I confirm that the information provided is accurate and I understand that submission does not guarantee approval, an agreement, territory or income.',
            ),
            const SizedBox(height: 12),
            CheckTile(
              key: keys.key('consents.contact'),
              value: p.contactConsent,
              error: p.error('consents.contact'),
              onChanged: (v) => p.setConsent('contact', v),
              label:
                  'I agree to be contacted by City Delivery Services about this application.',
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _Review extends StatelessWidget {
  const _Review({required this.p});

  final FranchiseProvider p;

  @override
  Widget build(BuildContext context) {
    String value(String key) {
      final text = p.raw(key);
      return text.isEmpty ? '—' : text;
    }

    Widget row(String label, String text) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 128,
            child: Text(
              label,
              style: AppText.body(size: 12, color: AppColors.muted),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppText.body(size: 14, weight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.light.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Review your application', style: AppText.display(size: 20)),
          const SizedBox(height: 16),
          row('Name', value('fullName')),
          row('Mobile', value('mobile')),
          row('Email', value('email')),
          row('Area', '${value('preferredOperatingArea')}, ${value('city')}'),
          row('State / district', '${value('state')}, ${value('district')}'),
          row('Investment', p.investmentCapacity.isEmpty ? '—' : p.investmentCapacity),
          row('Office / shop', p.hasOfficeOrShop.isEmpty ? '—' : p.hasOfficeOrShop),
          row('Vehicles', '${p.vehicleTotal}'),
        ],
      ),
    );
  }
}

class _Success extends StatelessWidget {
  const _Success({required this.provider});

  final FranchiseProvider provider;

  @override
  Widget build(BuildContext context) {
    final result = provider.result!;
    final id = result.applicationId;
    return Reveal(
      child: WhiteCard(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IconBadge(
              LucideIcons.checkCircle2,
              color: AppColors.green,
              iconColor: Colors.white,
              size: 64,
              radius: 20,
            ),
            const SizedBox(height: 24),
            Text(
              result.duplicate
                  ? 'Application already on file'
                  : 'Application submitted',
              style: AppText.display(size: 32, height: 1.1),
            ),
            const SizedBox(height: 12),
            Text(
              result.message.isEmpty
                  ? 'Save the Application ID below. Our team will review your details.'
                  : result.message,
              style: AppText.body(size: 16, height: 1.6, color: AppColors.muted),
            ),
            const SizedBox(height: 24),
            if (id.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.yellow.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'APPLICATION ID',
                      style: AppText.body(
                        size: 12,
                        weight: FontWeight.w800,
                        letterSpacing: 1.6,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      id,
                      style: AppText.display(
                        size: 20,
                        color: AppColors.dark,
                      ).copyWith(fontFamily: 'monospace'),
                    ),
                    const SizedBox(height: 12),
                    BrandButton(
                      label: 'Copy ID',
                      outline: true,
                      size: BrandButtonSize.sm,
                      leading: LucideIcons.copy,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: id));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Application ID copied')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            Text(
              'What happens next',
              style: AppText.display(size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              'Your application starts under review. The initial payment is optional and can be completed later from the status page. Submission does not guarantee approval, an agreement, territory or income.',
              style: AppText.body(
                size: 15,
                height: 1.6,
                color: AppColors.muted,
              ),
            ),
            const SizedBox(height: 28),
            BrandButton(
              label: 'Pay or check status',
              expand: true,
              trailing: LucideIcons.arrowRight,
              onPressed: () {
                if (id.isNotEmpty) provider.statusController.text = id;
                AppNav.goTop(
                  context,
                  Routes.franchiseStatus,
                  current: Routes.franchiseRegister,
                );
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: BrandButton(
                label: 'Submit another application',
                outline: true,
                expand: true,
                onPressed: provider.resetForm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
