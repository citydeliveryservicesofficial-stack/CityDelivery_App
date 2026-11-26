import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';
import 'package:provider/provider.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_theme.dart';
import '../providers/request_form_provider.dart';
import '../providers/request_status_provider.dart';
import '../widgets/common/brand_button.dart';
import '../widgets/common/cards.dart';
import '../widgets/common/reveal.dart';
import '../widgets/common/section_widgets.dart';
import '../widgets/form/form_widgets.dart';
import '../widgets/form/upload_fields.dart';
import '../widgets/layout/navigation.dart';
import '../widgets/layout/site_page.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _keys = FieldKeys();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _keys.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _submit(RequestFormProvider p) async {
    FocusScope.of(context).unfocus();
    await p.submit();
    if (!mounted) return;
    if (p.result != null) {
      if (_scroll.hasClients)
        _scroll.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
    } else if (p.errors.isNotEmpty) {
      final k = p.firstErrorKey;
      if (k != null) await _keys.scrollTo(k);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<RequestFormProvider>();
    return SitePage(
      route: Routes.request,
      controller: _scroll,
      children: [
        const PageHero(
          eyebrow: 'Request a Service',
          title: 'Request a Delivery Service',
          description: 'Submit your product, store and delivery details. Our team will review your request and contact you with the next steps.',
        ),
        ContainerX(
          maxWidth: 860,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: p.result != null
                  ? _Success(provider: p)
                  : _FormBody(
                      provider: p,
                      keys: _keys,
                      onSubmit: () => _submit(p),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.children,
  });
  final IconData icon;
  final int step;
  final String title;
  final String subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Reveal(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(32),
          boxShadow: AppShadows.soft,
          border: Border.all(color: const Color(0x0D000000)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconBadge(icon, size: 56),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STEP $step OF 3',
                        style: AppText.body(
                          size: 12,
                          weight: FontWeight.w800,
                          letterSpacing: 1.9,
                          color: AppColors.green,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        title,
                        style: AppText.body(
                          size: 24,
                          weight: FontWeight.w800,
                          color: AppColors.dark,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppText.body(size: 14, color: AppColors.muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _FormBody extends StatelessWidget {
  const _FormBody({
    required this.provider,
    required this.keys,
    required this.onSubmit,
  });
  final RequestFormProvider provider;
  final FieldKeys keys;
  final VoidCallback onSubmit;

  static const _gap = SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    final p = provider;
    String? err(String k) => p.errors[k];

    Widget text(
      String id,
      String label, {
      bool required = false,
      bool optional = false,
      String? hint,
      String? placeholder,
      int? maxLength,
      TextInputType? type,
      int lines = 1,
      Iterable<String>? autofill,
      TextCapitalization cap = TextCapitalization.none,
      TextInputAction? action,
    }) {
      return LabeledField(
        key: keys.key(id),
        label: label,
        required: required,
        optional: optional,
        hint: hint,
        error: err(id),
        child: AppTextField(
          controller: p.controllers[id]!,
          focusNode: keys.node(id),
          hasError: err(id) != null,
          hint: placeholder,
          maxLength: maxLength,
          keyboardType: type,
          minLines: lines,
          maxLines: lines == 1 ? 1 : lines + 2,
          autofillHints: autofill,
          textCapitalization: cap,
          textInputAction: action,
          onChanged: (_) => p.clearError(id),
        ),
      );
    }

    return Column(
      key: const ValueKey('form'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionCard(
          icon: LucideIcons.user,
          step: 1,
          title: 'About you',
          subtitle: 'So we know who to get back to.',
          children: [
            text(
              'customerName',
              'Full name',
              required: true,
              placeholder: 'e.g. Priya Raman',
              maxLength: 80,
              autofill: const [AutofillHints.name],
              cap: TextCapitalization.words,
            ),
            _gap,
            text(
              'email',
              'Email address',
              optional: true,
              placeholder: 'you@example.com',
              maxLength: 120,
              type: TextInputType.emailAddress,
              autofill: const [AutofillHints.email],
            ),
            _gap,
            text(
              'phone',
              'Mobile number',
              required: true,
              placeholder: '+91 98765 43210',
              maxLength: 20,
              type: TextInputType.phone,
              autofill: const [AutofillHints.telephoneNumber],
            ),
          ],
        ),
        const SizedBox(height: 28),
        _SectionCard(
          icon: LucideIcons.package,
          step: 2,
          title: 'The product',
          subtitle: 'What you want and any helpful details.',
          children: [
            text(
              'productName',
              'Product name',
              required: true,
              placeholder: 'e.g. Cold-pressed olive oil 1L',
              maxLength: 120,
            ),
            _gap,
            LabeledField(
              key: keys.key('productCategory'),
              label: 'Product category',
              required: true,
              error: err('productCategory'),
              child: SelectField(
                value: p.productCategory,
                options: kCategories,
                placeholder: 'Choose a category',
                hasError: err('productCategory') != null,
                onChanged: p.setCategory,
              ),
            ),
            _gap,
            text(
              'productDescription',
              'Product description',
              optional: true,
              hint: 'Brand, size, colour, flavour — anything that helps us find the right one.',
              placeholder: 'Describe the product in as much detail as you can…',
              maxLength: 1500,
              type: TextInputType.multiline,
              lines: 4,
            ),
            _gap,
            text(
              'quantity',
              'Quantity',
              required: true,
              type: TextInputType.number,
            ),
            _gap,
            text(
              'estimatedBudget',
              'Estimated budget',
              optional: true,
              hint: 'In ₹ — a rough number is fine.',
              placeholder: 'e.g. 850',
              type: const TextInputType.numberWithOptions(decimal: true),
            ),
            _gap,
            LabeledField(
              key: keys.key('productImage'),
              label: 'Product image',
              optional: true,
              hint: 'A photo helps us identify the exact item.',
              child: ImageUploadField(
                file: p.image,
                onChanged: p.setImage,
                error: err('productImage'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        _SectionCard(
          icon: LucideIcons.truck,
          step: 3,
          title: 'Pickup & Delivery',
          subtitle: 'Pickup point and delivery destination in one place.',
          children: [
            const _FromToStrip(),
            const SizedBox(height: 20),
            _TintedCard(
              tint: AppColors.yellow,
              icon: LucideIcons.store,
              iconBg: AppColors.yellow,
              iconFg: AppColors.dark,
              heading: 'From',
              badge: 'Pickup',
              note: 'Where should we collect it? Optional if you are still deciding.',
              children: [
                text(
                  'storeName',
                  'Store name',
                  optional: true,
                  placeholder: 'e.g. Fresh Mart',
                  maxLength: 120,
                ),
                _gap,
                text(
                  'storeLocation',
                  'Store location',
                  optional: true,
                  hint: 'Area, street or landmark.',
                  placeholder: 'e.g. Anna Nagar, near the main roundabout',
                  maxLength: 200,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: AppShadows.soft,
                  border: Border.all(
                    color: AppColors.yellow.withValues(alpha: 0.4),
                  ),
                ),
                child: const Icon(
                  LucideIcons.arrowDown,
                  size: 18,
                  color: AppColors.green,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _TintedCard(
              tint: AppColors.green,
              icon: LucideIcons.mapPin,
              iconBg: AppColors.green,
              iconFg: Colors.white,
              heading: 'To',
              badge: 'Delivery',
              note: 'Where should we deliver it?',
              children: [
                text(
                  'deliveryAddress',
                  'Delivery address',
                  required: true,
                  placeholder: 'House / flat no., street, area',
                  maxLength: 300,
                  type: TextInputType.streetAddress,
                  lines: 3,
                  autofill: const [AutofillHints.fullStreetAddress],
                ),
                _gap,
                text(
                  'city',
                  'City',
                  required: true,
                  placeholder: 'e.g. Madurai',
                  maxLength: 80,
                  autofill: const [AutofillHints.addressCity],
                  cap: TextCapitalization.words,
                ),
                _gap,
                text(
                  'postalCode',
                  'Postal code',
                  required: true,
                  placeholder: 'e.g. 625001',
                  maxLength: 12,
                  autofill: const [AutofillHints.postalCode],
                  cap: TextCapitalization.characters,
                ),
                _gap,
                text(
                  'additionalInstructions',
                  'Additional instructions',
                  optional: true,
                  placeholder: 'Landmarks, preferred contact time, substitutions you accept…',
                  maxLength: 600,
                  type: TextInputType.multiline,
                  lines: 3,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 28),
        Reveal(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                key: keys.key('prohibitedItemsAccepted'),
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppShadows.soft,
                  border: Border.all(color: const Color(0x0D000000)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => p.setProhibited(!p.prohibitedItemsAccepted),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 22,
                            height: 22,
                            child: Checkbox(
                              value: p.prohibitedItemsAccepted,
                              onChanged: (v) => p.setProhibited(v ?? false),
                              activeColor: AppColors.green,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                style: AppText.body(
                                  size: 14,
                                  weight: FontWeight.w700,
                                  color: AppColors.dark,
                                  height: 1.5,
                                ),
                                children: [
                                  const TextSpan(
                                    text: 'I agree that my parcel contains only permitted items. ',
                                  ),
                                  TextSpan(
                                    text: '*',
                                    style: AppText.body(
                                      size: 14,
                                      color: AppColors.red500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 34, top: 4),
                      child: GestureDetector(
                        onTap: () => AppNav.push(context, Routes.prohibited),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            'Read Prohibited Items Policy',
                            style: AppText.body(
                              size: 14,
                              weight: FontWeight.w700,
                              color: AppColors.green,
                            ).copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                    ),
                    if (err('prohibitedItemsAccepted') != null)
                      FieldError(err('prohibitedItemsAccepted')!),
                  ],
                ),
              ),
              if (p.formError.isNotEmpty) ...[
                const SizedBox(height: 20),
                ErrorBanner(p.formError),
              ],
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.dark,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            LucideIcons.shieldCheck,
                            size: 20,
                            color: AppColors.yellow,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              style: AppText.body(
                                size: 14,
                                height: 1.6,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                              children: [
                                const TextSpan(
                                  text: 'By submitting you agree to be contacted about this request. See our ',
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: GestureDetector(
                                    onTap: () =>
                                        AppNav.push(context, Routes.privacy),
                                    child: Text(
                                      'Privacy Policy',
                                      style: AppText.body(
                                        size: 14,
                                        weight: FontWeight.w700,
                                        color: AppColors.yellow,
                                      ),
                                    ),
                                  ),
                                ),
                                const TextSpan(text: '.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    BrandButton(
                      label: p.submitting ? 'Sending…' : 'Submit request',
                      size: BrandButtonSize.lg,
                      expand: true,
                      loading: p.submitting,
                      trailing: LucideIcons.send,
                      onPressed: p.submitting ? null : onSubmit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FromToStrip extends StatelessWidget {
  const _FromToStrip();

  Widget _dash() => Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: CustomPaint(
        painter: _DashLine(),
        size: const Size(double.infinity, 2),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.soft,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.yellow,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.store,
              size: 16,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'From',
            style: AppText.body(
              size: 14,
              weight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          _dash(),
          const Icon(LucideIcons.truck, size: 18, color: AppColors.yellow),
          _dash(),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.mapPin,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'To',
            style: AppText.body(
              size: 14,
              weight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashLine extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 2;
    for (double x = 0; x < size.width; x += 8) {
      canvas.drawLine(Offset(x, 1), Offset(x + 4, 1), p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _TintedCard extends StatelessWidget {
  const _TintedCard({
    required this.tint,
    required this.icon,
    required this.iconBg,
    required this.iconFg,
    required this.heading,
    required this.badge,
    required this.note,
    required this.children,
  });

  final Color tint;
  final IconData icon;
  final Color iconBg;
  final Color iconFg;
  final String heading;
  final String badge;
  final String note;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final isGreen = tint == AppColors.green;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tint.withValues(alpha: isGreen ? 0.10 : 0.20),
            Colors.white,
            Colors.white,
          ],
        ),
        boxShadow: AppShadows.soft,
        border: Border.all(color: tint.withValues(alpha: isGreen ? 0.2 : 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconBadge(icon, size: 48, color: iconBg, iconColor: iconFg),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        Text(
                          heading.toUpperCase(),
                          style: AppText.body(
                            size: 12,
                            weight: FontWeight.w800,
                            letterSpacing: 1.9,
                            color: AppColors.dark,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(color: const Color(0x0D000000)),
                          ),
                          child: Text(
                            badge.toUpperCase(),
                            style: AppText.body(
                              size: 11,
                              weight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: AppColors.muted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      note,
                      style: AppText.body(size: 14, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}

class _Success extends StatefulWidget {
  const _Success({required this.provider});
  final RequestFormProvider provider;

  @override
  State<_Success> createState() => _SuccessState();
}

class _SuccessState extends State<_Success> {
  bool _copied = false;

  Future<void> _copy(String id) async {
    await Clipboard.setData(ClipboardData(text: id));
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.provider.result!;
    return Container(
      key: const ValueKey('ok'),
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
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            builder: (_, v, child) => Transform.scale(scale: v, child: child),
            child: Container(
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
          ),
          const SizedBox(height: 28),
          Text(
            r.duplicate ? 'We already have it!' : 'Request received!',
            textAlign: TextAlign.center,
            style: AppText.display(size: 32, height: 1.15),
          ),
          const SizedBox(height: 16),
          Text(
            r.message,
            textAlign: TextAlign.center,
            style: AppText.body(size: 18, height: 1.6, color: AppColors.muted),
          ),
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
                  'REQUEST ID',
                  style: AppText.body(
                    size: 13,
                    weight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppColors.muted,
                  ),
                ),
                SelectableText(
                  r.requestId,
                  style: AppText.display(size: 22, letterSpacing: 0.5),
                ),
                Semantics(
                  button: true,
                  label: 'Copy request ID',
                  child: GestureDetector(
                    onTap: () => _copy(r.requestId),
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
          if (!r.teamOk) ...[
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.amber50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(
                      LucideIcons.alertTriangle,
                      size: 18,
                      color: AppColors.amber900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your request is safely saved. The notification email to our team is being retried automatically — you do not need to submit again.',
                      style: AppText.body(
                        size: 14,
                        height: 1.5,
                        color: AppColors.amber900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (r.confirmationEmail == 'failed') ...[
            const SizedBox(height: 12),
            Text(
              'We could not send your confirmation email yet. Please keep the Request ID above.',
              textAlign: TextAlign.center,
              style: AppText.body(size: 14, color: AppColors.muted),
            ),
          ],
          const SizedBox(height: 36),
          BrandButton(
            label: 'Check request status',
            expand: true,
            leading: LucideIcons.search,
            onPressed: () {
              context.read<RequestStatusProvider>().prefill(r.requestId);
              AppNav.push(context, Routes.requestStatus);
            },
          ),
          const SizedBox(height: 12),
          BrandButton(
            label: 'My requests',
            expand: true,
            outline: true,
            leading: LucideIcons.history,
            onPressed: () => AppNav.push(context, Routes.requestHistory),
          ),
          const SizedBox(height: 12),
          BrandButton(
            label: 'Submit another request',
            expand: true,
            outline: true,
            onPressed: widget.provider.reset,
          ),
          const SizedBox(height: 12),
          BrandButton(
            label: 'Back to home',
            outline: true,
            expand: true,
            onPressed: () => AppNav.goTop(context, Routes.home),
          ),
        ],
      ),
    );
  }
}
