import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/rider_application_provider.dart';
import '../../widgets/common/brand_button.dart';
import '../../widgets/common/cards.dart';
import '../../widgets/common/section_widgets.dart';
import '../../widgets/form/form_widgets.dart';
import '../../widgets/form/upload_fields.dart';
import '../../widgets/layout/navigation.dart';
import '../../widgets/layout/site_page.dart';

class RiderRegisterScreen extends StatefulWidget {
  const RiderRegisterScreen({super.key});

  @override
  State<RiderRegisterScreen> createState() => _RiderRegisterScreenState();
}

class _RiderRegisterScreenState extends State<RiderRegisterScreen> {
  final _keys = FieldKeys();
  final _scroll = ScrollController();
  final _stepperKey = GlobalKey();

  @override
  void dispose() {
    _keys.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _toStepper() async {
    final ctx = _stepperKey.currentContext;
    if (ctx != null) {
      await Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        alignment: 0.02,
      );
    }
  }

  Future<void> _afterFailure(RiderApplicationProvider p) async {
    if (p.errors.isEmpty) return;
    await _keys.scrollTo(p.errors.keys.first);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<RiderApplicationProvider>();

    if (p.result != null) {
      return SitePage(
        route: Routes.riderRegister,
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
      route: Routes.riderRegister,
      controller: _scroll,
      children: [
        const PageHero(
          eyebrow: 'Rider application',
          title: 'Apply to ride with us',
          description: 'Tell us about yourself. You can review every section before you submit.',
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
                  _Stepper(provider: p),
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
                      key: ValueKey(p.step),
                      child: _StepBody(provider: p, keys: _keys),
                    ),
                  ),
                  if (p.configError.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.amber50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        p.configError,
                        style: AppText.body(
                          size: 14,
                          weight: FontWeight.w600,
                          color: AppColors.amber900,
                        ),
                      ),
                    ),
                  ],
                  if (p.formError.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.red50,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        p.formError,
                        style: AppText.body(
                          size: 14,
                          weight: FontWeight.w600,
                          color: AppColors.red700,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 28),
                  Container(
                    height: 1,
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                  const SizedBox(height: 20),
                  if (p.step < kRiderSteps.length - 1)
                    BrandButton(
                      label: 'Continue',
                      expand: true,
                      trailing: LucideIcons.arrowRight,
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        final ok = p.next();
                        if (ok) {
                          await _toStepper();
                        } else {
                          await _afterFailure(p);
                        }
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
                      onPressed: p.step == 0 || p.submitting
                          ? null
                          : () {
                              p.back();
                              _toStepper();
                            },
                      icon: const Icon(LucideIcons.arrowLeft, size: 17),
                      label: Text(
                        'Back',
                        style: AppText.body(
                          size: 14,
                          weight: FontWeight.w700,
                          color: p.step == 0 ? AppColors.muted : AppColors.dark,
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
                          'Your documents are stored privately and used only for rider onboarding.',
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
  const _Stepper({required this.provider});
  final RiderApplicationProvider provider;

  @override
  Widget build(BuildContext context) {
    final p = provider;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: kRiderSteps.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final current = i == p.step;
              final done = i < p.step;
              return GestureDetector(
                onTap: done ? () => p.goTo(i) : null,
                child: Container(
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
                    '${i + 1}. ${kRiderSteps[i]}',
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
              widthFactor: (p.step + 1) / kRiderSteps.length,
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
  const _StepBody({required this.provider, required this.keys});
  final RiderApplicationProvider provider;
  final FieldKeys keys;

  static const _gap = SizedBox(height: 20);

  RiderApplicationProvider get p => provider;

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
    Iterable<String>? autofill,
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
        autofillHints: autofill,
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
    bool optional = false,
  }) {
    final e = p.error(path);
    return LabeledField(
      key: keys.key(path),
      label: label,
      required: required,
      optional: optional,
      error: e,
      child: SelectField(
        value: p.str(path),
        options: options,
        placeholder: placeholder,
        hasError: e != null,
        onChanged: (v) => p.set(path, v),
      ),
    );
  }

  Widget segmented(
    String path,
    String label,
    List<(String, String)> options, {
    bool required = false,
    String? hint,
  }) {
    return LabeledField(
      key: keys.key(path),
      label: label,
      required: required,
      hint: hint,
      error: p.error(path),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (final o in options)
            ChoicePill(
              label: o.$2,
              selected: p.str(path) == o.$1,
              onTap: () => p.set(path, o.$1),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (p.step) {
      case 0:
        return Column(
          children: [
            tf(
              'personalInformation.fullName',
              'Full name',
              required: true,
              placeholder: 'As on your ID',
              cap: TextCapitalization.words,
              autofill: const [AutofillHints.name],
            ),
            _gap,
            _DateField(provider: p, keys: keys),
            _gap,
            select(
              'personalInformation.gender',
              'Gender',
              kRiderGenders,
              'Prefer not to say',
              optional: true,
            ),
            _gap,
            tf(
              'contactInformation.mobile',
              'Mobile number',
              required: true,
              placeholder: '10-digit mobile number',
              type: TextInputType.phone,
              autofill: const [AutofillHints.telephoneNumber],
            ),
            _gap,
            tf(
              'contactInformation.whatsapp',
              'WhatsApp number',
              optional: true,
              type: TextInputType.phone,
            ),
            _gap,
            tf(
              'contactInformation.email',
              'Email address',
              optional: true,
              hint: 'Recommended — status updates are emailed to this address.',
              type: TextInputType.emailAddress,
              autofill: const [AutofillHints.email],
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            tf(
              'address.residentialAddress',
              'Residential address',
              required: true,
              placeholder: 'House no., street, landmark',
              type: TextInputType.streetAddress,
              autofill: const [AutofillHints.fullStreetAddress],
            ),
            _gap,
            tf(
              'address.city',
              'City',
              required: true,
              cap: TextCapitalization.words,
              autofill: const [AutofillHints.addressCity],
            ),
            _gap,
            tf(
              'address.area',
              'Area / locality',
              required: true,
              cap: TextCapitalization.words,
            ),
            _gap,
            tf(
              'address.pincode',
              'Pincode',
              required: true,
              placeholder: '632009',
              type: TextInputType.number,
              maxLength: 6,
              autofill: const [AutofillHints.postalCode],
            ),
            _gap,
            tf(
              'contactInformation.emergencyContactName',
              'Emergency contact name',
              optional: true,
              cap: TextCapitalization.words,
            ),
            _gap,
            tf(
              'contactInformation.emergencyContactNumber',
              'Emergency contact number',
              optional: true,
              type: TextInputType.phone,
            ),
          ],
        );
      case 2:
        final owns = p.str('vehicleInformation.ownsVehicle') == 'true';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tf(
              'drivingInformation.licenceNumber',
              'Driving licence number',
              required: true,
              cap: TextCapitalization.characters,
            ),
            _gap,
            tf(
              'drivingInformation.experience',
              'Driving experience',
              required: true,
              placeholder: 'e.g. 3 years',
            ),
            _gap,
            segmented(
              'vehicleInformation.ownsVehicle',
              'Do you own a vehicle?',
              const [('true', 'Yes'), ('false', 'No — I need assistance')],
              required: true,
            ),
            _gap,
            if (!owns)
              KeyedSubtree(
                key: keys.key('vehicleInformation.assistanceRequired'),
                child: CheckTile(
                  value: p.flag('vehicleInformation.assistanceRequired'),
                  onChanged: (v) =>
                      p.set('vehicleInformation.assistanceRequired', v),
                  label: 'I confirm I would like information about vehicle assistance options.',
                  error: p.error('vehicleInformation.assistanceRequired'),
                ),
              )
            else ...[
              select(
                'vehicleInformation.vehicleType',
                'Vehicle type',
                p.config.allowedVehicleTypes,
                'Choose vehicle type',
                required: true,
              ),
              _gap,
              tf(
                'vehicleInformation.registrationNumber',
                'Registration number',
                required: true,
                cap: TextCapitalization.characters,
              ),
              _gap,
              tf(
                'vehicleInformation.brand',
                'Brand',
                required: true,
                cap: TextCapitalization.words,
              ),
              _gap,
              tf(
                'vehicleInformation.model',
                'Model',
                required: true,
                cap: TextCapitalization.words,
              ),
              _gap,
              CheckTile(
                value: p.flag('vehicleInformation.insuranceAvailable'),
                onChanged: (v) =>
                    p.set('vehicleInformation.insuranceAvailable', v),
                label: 'Vehicle insurance is available',
              ),
            ],
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tf(
              'workPreferences.preferredWorkingArea',
              'Preferred working area',
              required: true,
              placeholder: 'e.g. Sathuvachari, Vellore',
            ),
            _gap,
            select(
              'workPreferences.workType',
              'Preferred work type',
              p.config.workTypes,
              'Choose work type',
              required: true,
            ),
            _gap,
            tf(
              'workPreferences.preferredWorkingHours',
              'Preferred working hours',
              optional: true,
              placeholder: 'e.g. 9 am – 6 pm',
            ),
            _gap,
            LabeledField(
              key: keys.key('workPreferences.availabilityDays'),
              label: 'Available days',
              required: true,
              error: p.error('workPreferences.availabilityDays'),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final d in p.config.availabilityDays)
                    ChoicePill(
                      label: d,
                      round: true,
                      selected: p.availabilityDays.contains(d),
                      onTap: () => p.toggleDay(d),
                    ),
                ],
              ),
            ),
          ],
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tf(
              'identityVerification.aadhaarNumber',
              'Aadhaar number',
              optional: true,
              placeholder: 'Only if you want to provide it',
              type: TextInputType.number,
            ),
            _gap,
            tf(
              'identityVerification.panNumber',
              'PAN number',
              required: true,
              placeholder: '10-character PAN',
              maxLength: 10,
              cap: TextCapitalization.characters,
            ),
            _gap,
            KeyedSubtree(
              key: keys.key('identityVerification.aadhaarConsent'),
              child: CheckTile(
                value: p.flag('identityVerification.aadhaarConsent'),
                onChanged: (v) =>
                    p.set('identityVerification.aadhaarConsent', v),
                label:
                    'I consent to Aadhaar verification for this application.',
                error: p.error('identityVerification.aadhaarConsent'),
              ),
            ),
            const SizedBox(height: 12),
            KeyedSubtree(
              key: keys.key('identityVerification.panConsent'),
              child: CheckTile(
                value: p.flag('identityVerification.panConsent'),
                onChanged: (v) => p.set('identityVerification.panConsent', v),
                label: 'I consent to PAN verification for this application. *',
                error: p.error('identityVerification.panConsent'),
              ),
            ),
            _gap,
            tf(
              'identityVerification.additionalNotes',
              'Additional verification notes',
              optional: true,
            ),
            _gap,
            segmented(
              'paymentInformation.submitted',
              'Bank details',
              const [('false', 'After approval'), ('true', 'Submit now')],
              required: true,
              hint: 'Share now, or after approval.',
            ),
            if (p.str('paymentInformation.submitted') == 'true') ...[
              _gap,
              tf(
                'paymentInformation.accountHolderName',
                'Account holder name',
                required: true,
                cap: TextCapitalization.words,
              ),
              _gap,
              tf(
                'paymentInformation.bankName',
                'Bank name',
                required: true,
                cap: TextCapitalization.words,
              ),
              _gap,
              tf(
                'paymentInformation.accountNumber',
                'Account number',
                required: true,
                type: TextInputType.number,
              ),
              _gap,
              tf(
                'paymentInformation.confirmAccountNumber',
                'Confirm account number',
                required: true,
                type: TextInputType.number,
              ),
              _gap,
              tf(
                'paymentInformation.ifscCode',
                'IFSC code',
                required: true,
                cap: TextCapitalization.characters,
              ),
              _gap,
              tf('paymentInformation.upiId', 'UPI ID', optional: true),
            ],
          ],
        );
      default:
        final docs = p.requiredDocs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final d in p.visibleDocs)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: KeyedSubtree(
                  key: keys.key('documents.${d.key}'),
                  child: DocumentUploadField(
                    label: d.label,
                    hint: d.hint,
                    required: docs.contains(d.key),
                    imageOnly: d.imageOnly,
                    file: p.files[d.key],
                    onChanged: (f) => p.setFile(d.key, f),
                    error: p.error('documents.${d.key}'),
                  ),
                ),
              ),
            KeyedSubtree(
              key: keys.key('consents.accurate'),
              child: CheckTile(
                value: p.flag('consents.accurate'),
                onChanged: (v) => p.set('consents.accurate', v),
                label: 'I confirm that the information and documents provided are accurate.',
                error: p.error('consents.accurate'),
              ),
            ),
            const SizedBox(height: 12),
            KeyedSubtree(
              key: keys.key('consents.terms'),
              child: CheckTile(
                value: p.flag('consents.terms'),
                onChanged: (v) => p.set('consents.terms', v),
                label: 'I agree to the rider terms and understand that submission is not approval or an offer of work.',
                error: p.error('consents.terms'),
              ),
            ),
            const SizedBox(height: 12),
            KeyedSubtree(
              key: keys.key('consents.processing'),
              child: CheckTile(
                value: p.flag('consents.processing'),
                onChanged: (v) => p.set('consents.processing', v),
                label: 'I consent to City Delivery Services processing my details for rider onboarding.',
                error: p.error('consents.processing'),
              ),
            ),
          ],
        );
    }
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.provider, required this.keys});
  final RiderApplicationProvider provider;
  final FieldKeys keys;

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  static const _path = 'personalInformation.dateOfBirth';

  @override
  Widget build(BuildContext context) {
    final iso = provider.str(_path);
    final parsed = DateTime.tryParse(iso);
    final shown = parsed == null
        ? ''
        : '${parsed.day} ${_months[parsed.month - 1]} ${parsed.year}';
    final e = provider.error(_path);
    return LabeledField(
      key: keys.key(_path),
      label: 'Date of birth',
      required: true,
      error: e,
      child: GestureDetector(
        onTap: () async {
          FocusScope.of(context).unfocus();
          final now = DateTime.now();
          final picked = await showDatePicker(
            context: context,
            initialDate: parsed ?? DateTime(now.year - 25, now.month, now.day),
            firstDate: DateTime(now.year - 90),
            lastDate: now,
            helpText: 'Date of birth',
          );
          if (picked != null) {
            final m = picked.month.toString().padLeft(2, '0');
            final d = picked.day.toString().padLeft(2, '0');
            provider.set(_path, '${picked.year}-$m-$d');
          }
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: e != null
                ? Color.alphaBlend(
                    AppColors.red50.withValues(alpha: 0.4),
                    Colors.white,
                  )
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: e != null ? AppColors.red500 : const Color(0x0D000000),
              width: e != null ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  shown.isEmpty ? 'Select date' : shown,
                  style: AppText.body(
                    size: 15,
                    color: shown.isEmpty
                        ? AppColors.muted.withValues(alpha: 0.7)
                        : AppColors.text,
                  ),
                ),
              ),
              const Icon(
                LucideIcons.calendarDays,
                size: 18,
                color: AppColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Success extends StatefulWidget {
  const _Success({required this.provider});
  final RiderApplicationProvider provider;

  @override
  State<_Success> createState() => _SuccessState();
}

class _SuccessState extends State<_Success> {
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.provider.result!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: AppShadows.lift,
        border: Border.all(color: const Color(0x0D000000)),
      ),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
              boxShadow: AppShadows.glow,
            ),
            child: const Icon(
              LucideIcons.checkCircle2,
              size: 52,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            r.duplicate
                ? 'Application already received'
                : 'Application received',
            textAlign: TextAlign.center,
            style: AppText.display(size: 30, height: 1.15),
          ),
          if (r.message.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              r.message,
              textAlign: TextAlign.center,
              style: AppText.body(
                size: 18,
                height: 1.6,
                color: AppColors.muted,
              ),
            ),
          ],
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.yellow.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                Text(
                  'APPLICATION ID',
                  style: AppText.body(
                    size: 13,
                    weight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppColors.muted,
                  ),
                ),
                SelectableText(
                  r.applicationId,
                  style: AppText.display(size: 20, letterSpacing: 0.5),
                ),
                Semantics(
                  button: true,
                  label: 'Copy application ID',
                  child: GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(
                        ClipboardData(text: r.applicationId),
                      );
                      if (!mounted) return;
                      setState(() => _copied = true);
                      Future.delayed(const Duration(milliseconds: 1800), () {
                        if (mounted) setState(() => _copied = false);
                      });
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _copied ? LucideIcons.check : LucideIcons.copy,
                        size: 17,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.light.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Save this ID to check your status. Submission is not approval or an offer of work.',
              style: AppText.body(
                size: 14,
                height: 1.6,
                color: AppColors.muted,
              ),
            ),
          ),
          const SizedBox(height: 36),
          BrandButton(
            label: 'Check application status',
            expand: true,
            onPressed: () => AppNav.push(context, Routes.riderStatus),
          ),
          if (!r.duplicate) ...[
            const SizedBox(height: 12),
            BrandButton(
              label: 'Submit another application',
              outline: true,
              expand: true,
              onPressed: widget.provider.reset,
            ),
          ],
        ],
      ),
    );
  }
}
