import 'package:flutter/material.dart';
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
import '../../widgets/layout/auto_marquee.dart';
import '../../widgets/layout/navigation.dart';
import '../../widgets/layout/site_page.dart';

const _why = [
  (
    LucideIcons.mapPin,
    'Local opportunity',
    'Tell us the city, district and operating area you want to support.',
  ),
  (
    LucideIcons.clipboardCheck,
    'Clear review process',
    'Every application is reviewed by our team before any next steps are offered.',
  ),
  (
    LucideIcons.truck,
    'Delivery operations support',
    'Discuss local delivery operations, vehicle capacity and office readiness with our team.',
  ),
  (
    LucideIcons.eye,
    'Status transparency',
    'Track your application using your Application ID at any time.',
  ),
];

const _showcase = [
  (
    LucideIcons.package,
    'Parcel & document delivery',
    'Local pickups and drop-offs coordinated from your area.',
    'assets/images/gallery/gal1.webp',
  ),
  (
    LucideIcons.bike,
    'Bike rider network',
    'Arrange riders for quick, last-mile local deliveries.',
    'assets/images/gallery/gal7.webp',
  ),
  (
    LucideIcons.truck,
    'Vehicle capacity',
    'Bikes, cars, lorries or other vehicles you can arrange.',
    'assets/images/gallery/gal8.webp',
  ),
  (
    LucideIcons.store,
    'Local coordination hub',
    'A shop or office base to manage orders and customers.',
    'assets/images/gallery/gal2.webp',
  ),
  (
    LucideIcons.map,
    'Area coverage',
    'Grow delivery coverage across your city and district.',
    'assets/images/gallery/gal3.webp',
  ),
  (
    LucideIcons.users,
    'Team & riders',
    'Organise people and day-to-day local operations.',
    'assets/images/gallery/gal4.webp',
  ),
  (
    LucideIcons.messageCircle,
    'Customer support',
    'Support customers in your area with clear communication.',
    'assets/images/gallery/gal5.webp',
  ),
];

const _chips = [
  'Local delivery',
  'Last-mile coordination',
  'Rider management',
  'Vehicle planning',
  'Office operations',
  'Customer support',
  'Area expansion',
  'Status tracking',
  'Written agreement',
  'Individual review',
];

const _review = [
  (
    LucideIcons.mapPin,
    'Operating area',
    'The city, district and local area you propose to support.',
  ),
  (
    LucideIcons.store,
    'Office readiness',
    'Whether you already have a shop or office for local coordination.',
  ),
  (
    LucideIcons.truck,
    'Vehicle capacity',
    'How many bikes, cars, lorries or other vehicles you can arrange.',
  ),
  (
    LucideIcons.briefcase,
    'Business readiness',
    'Your experience, investment capacity and optional supporting documents.',
  ),
];

const _who = [
  (
    'Local shop or office owners',
    'You have a base to coordinate deliveries and communicate with customers.',
  ),
  (
    'Delivery operations teams',
    'You can arrange vehicles, riders and day-to-day local delivery processes.',
  ),
  (
    'Area-focused operators',
    'You understand your locality and want to grow delivery coverage in it.',
  ),
];

const _needs = [
  'Your name, mobile number and email address',
  'State, district, city, PIN code and proposed operating area',
  'Business experience and investment capacity',
  'Office or shop availability and vehicle count',
  'Optional business or address proof documents',
];

const _faq = [
  (
    'What does a City Delivery Services franchise partner do?',
    'A franchise partner helps expand local delivery operations in an assigned area. The exact operating scope, responsibilities and territory are confirmed only after review and in a written agreement.',
  ),
  (
    'Is the initial payment mandatory?',
    'No. You can submit your application without paying. If you choose to pay, the payment policy shown with your application applies. Submission does not guarantee approval, an agreement, territory or income.',
  ),
  (
    'Does applying guarantee approval or income?',
    'No. Submission and payment do not guarantee approval, an agreement, exclusive territory, deliveries or income. Every application is reviewed individually.',
  ),
  (
    'Can I pay after submitting the application?',
    'Yes. The initial payment is optional. Save your Application ID and use the status page to pay any time that suits you. Your application stays under review.',
  ),
  (
    'What happens after I apply?',
    'Your application starts under review. Our team may contact you for more information, then update the status as approved, rejected, agreement pending or active.',
  ),
  (
    'Can I check my application status?',
    'Yes. Save the Application ID shown after submission and use the franchise status page. No login is needed.',
  ),
];

class BecomeFranchiseScreen extends StatelessWidget {
  const BecomeFranchiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final franchise = context.watch<FranchiseProvider>();
    final fee = franchise.config.feeLabel;
    final policy = franchise.config.refundPolicy.isEmpty
        ? 'as shown at payment'
        : franchise.config.refundPolicy;
    final steps = [
      ('01', 'Apply', 'Share your details, location and operating capacity.'),
      ('02', 'Initial payment', 'Optional: pay $fee now or later from the status page.'),
      ('03', 'Review', 'Our team reviews your application and may contact you.'),
      ('04', 'Agreement', 'Approved partners move through agreement and activation.'),
    ];

    return SitePage(
      route: Routes.becomeFranchise,
      children: [
        PageHero(
          eyebrow: 'Franchise partner',
          title: 'Grow delivery with City Delivery Services',
          description:
              'We are accepting franchise partner applications in and around ${Site.serviceCity}. Review the opportunity, submit your details and track your application.',
          child: Column(
            children: [
              BrandButton(
                label: 'Apply now',
                expand: true,
                onPressed: () => AppNav.push(context, Routes.franchiseRegister),
              ),
              const SizedBox(height: 12),
              BrandButton(
                label: 'Check application status',
                outline: true,
                expand: true,
                onPressed: () => AppNav.push(context, Routes.franchiseStatus),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: ContainerX(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('Your city. Local delivery.'),
                const SizedBox(height: 20),
                Text(
                  'A clear process to build your own delivery base',
                  style: AppText.display(size: 34, height: 1.1),
                ),
                const SizedBox(height: 20),
                const Text(
                  'We are building a local delivery network. Franchise partners help expand coverage, coordinate local operations and support customers in their area.',
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.6,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 24),
                for (final item in [
                  'Applications are reviewed individually',
                  'Terms are confirmed in writing',
                  'Track progress any time with your Application ID',
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          LucideIcons.checkCircle2,
                          size: 22,
                          color: AppColors.yellowDeep,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item,
                            style: AppText.body(
                              size: 15,
                              weight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: BrandButton(
                        label: 'Start application',
                        expand: true,
                        onPressed: () =>
                            AppNav.push(context, Routes.franchiseRegister),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: BrandButton(
                    label: 'Check status',
                    outline: true,
                    expand: true,
                    onPressed: () => AppNav.push(context, Routes.franchiseStatus),
                  ),
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _Stat(value: fee, label: 'Optional initial payment'),
                    const _Stat(value: '4 steps', label: 'Apply to activation'),
                    const _Stat(
                      value: 'No login',
                      label: 'Track with Application ID',
                    ),
                    const _Stat(
                      value: '1-by-1',
                      label: 'Every application reviewed',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          color: AppColors.light,
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: ContainerX(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  center: false,
                  eyebrow: 'Why partner with us',
                  title: 'Opportunity with clear expectations',
                  description:
                      'Everything you need to know before you apply — in plain language.',
                ),
                const SizedBox(height: 32),
                for (final item in _why) ...[
                  _InfoCard(
                    icon: item.$1,
                    title: item.$2,
                    text: item.$3,
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: ContainerX(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  center: false,
                  eyebrow: 'What you can support',
                  title: 'Local delivery, built around your area',
                  description:
                      'A glimpse of the day-to-day work franchise partners discuss with our team. Exact scope is confirmed in a written agreement.',
                ),
                const SizedBox(height: 32),
                const _ShowcaseMarquee(),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [for (final chip in _chips) _Chip(label: chip)],
                ),
              ],
            ),
          ),
        ),
        Container(
          color: AppColors.yellow.withValues(alpha: 0.16),
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: ContainerX(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  center: false,
                  eyebrow: 'How it works',
                  title: 'From application to activation',
                ),
                const SizedBox(height: 32),
                for (final step in steps) ...[
                  _StepCard(
                    number: step.$1,
                    title: step.$2,
                    text: step.$3,
                  ),
                  const SizedBox(height: 14),
                ],
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.dark,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'The initial payment policy ($policy) is displayed before payment. Submission does not guarantee approval, an agreement, exclusive territory or income.',
                    style: AppText.body(
                      size: 13,
                      height: 1.55,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: ContainerX(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  center: false,
                  eyebrow: 'Review criteria',
                  title: 'What our team looks at',
                  description:
                      'We review the details you share to understand whether the proposed local setup can support delivery operations. Review does not guarantee approval.',
                ),
                const SizedBox(height: 32),
                for (final item in _review) ...[
                  _InfoCard(
                    icon: item.$1,
                    title: item.$2,
                    text: item.$3,
                  ),
                  const SizedBox(height: 14),
                ],
                const SizedBox(height: 12),
                BrandButton(
                  label: 'Start application',
                  trailing: LucideIcons.arrowRight,
                  onPressed: () =>
                      AppNav.push(context, Routes.franchiseRegister),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: AppColors.light,
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: ContainerX(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  center: false,
                  eyebrow: 'Flexible initial payment',
                  title: 'Apply first. Pay when you are ready.',
                  description:
                      'The initial payment is optional. Submit your application, save your Application ID and return to the status page whenever you want to complete the payment.',
                ),
                const SizedBox(height: 28),
                for (final step in [
                  'Submit your franchise application',
                  'Save the Application ID shown afterwards',
                  'Open the status page and pay any time',
                ]) ...[
                  _NumberRow(text: step),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 18),
                BrandButton(
                  label: 'Open status page',
                  outline: true,
                  trailing: LucideIcons.arrowRight,
                  onPressed: () => AppNav.push(context, Routes.franchiseStatus),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.dark,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: AppShadows.lift,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        LucideIcons.wallet,
                        size: 38,
                        color: AppColors.yellow,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        fee,
                        style: AppText.display(
                          size: 42,
                          color: AppColors.yellow,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Optional initial payment',
                        style: AppText.body(
                          size: 12,
                          weight: FontWeight.w800,
                          color: Colors.white54,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(color: Colors.white24),
                      const SizedBox(height: 20),
                      const _PaymentRow(
                        icon: LucideIcons.clock3,
                        title: 'Pay now or later',
                        text: 'Your Application ID unlocks the payment option on the status page.',
                      ),
                      const _PaymentRow(
                        icon: LucideIcons.shieldCheck,
                        title: 'Secure payment flow',
                        text: 'Payment is handled by the payment provider when online payment is enabled.',
                      ),
                      const _PaymentRow(
                        icon: LucideIcons.checkCircle2,
                        title: 'Review continues',
                        text: 'Your application remains under review whether or not you pay.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: ContainerX(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(
                  center: false,
                  eyebrow: 'Who can apply',
                  title: 'Local operators with a clear plan',
                  description:
                      'If you can support local delivery coordination in a defined area, we would like to review your application. Terms are confirmed only after review and in writing.',
                ),
                const SizedBox(height: 32),
                for (final item in _who) ...[
                  _InfoCard(
                    icon: LucideIcons.store,
                    title: item.$1,
                    text: item.$2,
                  ),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        ),
        Container(
          color: AppColors.light,
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: ContainerX(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('What you will need'),
                const SizedBox(height: 20),
                Text(
                  'Keep these ready',
                  style: AppText.display(size: 34, height: 1.1),
                ),
                const SizedBox(height: 24),
                for (final item in _needs) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        LucideIcons.checkCircle2,
                        size: 20,
                        color: AppColors.green,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item,
                          style: AppText.body(size: 15, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 36),
                const Eyebrow('Questions'),
                const SizedBox(height: 20),
                Text(
                  'Franchise FAQs',
                  style: AppText.display(size: 34, height: 1.1),
                ),
                const SizedBox(height: 24),
                for (final faq in _faq)
                  _FaqTile(question: faq.$1, answer: faq.$2),
              ],
            ),
          ),
        ),
        Container(
          color: AppColors.dark,
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 56),
          child: Column(
            children: [
              const Icon(
                LucideIcons.handshake,
                size: 42,
                color: AppColors.yellow,
              ),
              const SizedBox(height: 20),
              Text(
                'Ready to apply?',
                textAlign: TextAlign.center,
                style: AppText.display(size: 30, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Complete the application, review the optional initial payment and save your Application ID to track progress.',
                textAlign: TextAlign.center,
                style: AppText.body(
                  size: 16,
                  height: 1.6,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 32),
              BrandButton(
                label: 'Start application',
                expand: true,
                color: AppColors.yellow,
                foreground: AppColors.dark,
                onPressed: () =>
                    AppNav.push(context, Routes.franchiseRegister),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => AppNav.push(context, Routes.contact),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        LucideIcons.messageCircle,
                        size: 17,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Ask a question',
                        style: AppText.body(
                          size: 14,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: WhiteCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppText.display(size: 24, color: AppColors.green),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppText.body(size: 12, color: AppColors.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Reveal(
      child: WhiteCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconBadge(icon, size: 44, radius: 14, shadow: false),
            const SizedBox(height: 16),
            Text(title, style: AppText.display(size: 18, height: 1.2)),
            const SizedBox(height: 8),
            Text(
              text,
              style: AppText.body(
                size: 14,
                height: 1.6,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowcaseMarquee extends StatelessWidget {
  const _ShowcaseMarquee();

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.of(context).size.width < 600;
    final cardWidth = compact ? 220.0 : 280.0;
    final cardHeight = compact ? 280.0 : 340.0;
    return Stack(
      children: [
        AutoMarquee(
          pixelsPerSecond: 38,
          interactive: true,
          copyBuilder: (copy) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final item in _showcase) ...[
                _ShowcaseCard(
                  icon: item.$1,
                  title: item.$2,
                  text: item.$3,
                  image: item.$4,
                  width: cardWidth,
                  height: cardHeight,
                ),
                const SizedBox(width: 16),
              ],
            ],
          ),
        ),
        const Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.white,
                  ],
                  stops: [0, 0.08, 0.92, 1],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShowcaseCard extends StatelessWidget {
  const _ShowcaseCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.image,
    required this.width,
    required this.height,
  });

  final IconData icon;
  final String title;
  final String text;
  final String image;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: AppShadows.lift,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(image, fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00111713),
                  Color(0x66111713),
                  Color(0xE6111713),
                ],
                stops: [0, 0.35, 1],
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 16,
            child: Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppShadows.soft,
              ),
              child: Icon(icon, size: 22, color: AppColors.dark),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.display(
                    size: 18,
                    height: 1.2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: AppText.body(
                    size: 13,
                    height: 1.5,
                    color: const Color(0xD9FFFFFF),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.title,
    required this.text,
  });

  final String number;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: AppText.display(size: 26, color: AppColors.yellowDeep),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.display(size: 18, height: 1.2)),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: AppText.body(
                    size: 14,
                    height: 1.55,
                    color: AppColors.muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberRow extends StatelessWidget {
  const _NumberRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.dark, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.dark,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                text.substring(0, 1),
                style: AppText.body(
                  size: 14,
                  weight: FontWeight.w800,
                  color: AppColors.yellow,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text.substring(2),
              style: AppText.body(size: 14, weight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.yellow.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppText.body(
          size: 12,
          weight: FontWeight.w700,
          color: AppColors.dark,
        ),
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.yellow),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppText.body(
                    size: 14,
                    weight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: AppText.body(
                    size: 13,
                    height: 1.5,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  const _FaqTile({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _open = !_open),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppShadows.soft,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: AppText.body(
                      size: 15,
                      weight: FontWeight.w800,
                      height: 1.35,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: _open ? 0.125 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    LucideIcons.plus,
                    size: 20,
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              alignment: Alignment.topCenter,
              child: _open
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        widget.answer,
                        style: AppText.body(
                          size: 14,
                          height: 1.6,
                          color: AppColors.muted,
                        ),
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
