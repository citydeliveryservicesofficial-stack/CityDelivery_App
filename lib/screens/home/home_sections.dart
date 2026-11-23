import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/gallery_data.dart';
import '../../widgets/common/brand_button.dart';
import '../../widgets/common/reveal.dart';
import '../../widgets/common/section_widgets.dart';
import '../../widgets/layout/auto_marquee.dart';
import '../../widgets/layout/navigation.dart';

Widget _h2(
  String text, {
  Color color = AppColors.homeDark,
  List<InlineSpan> extra = const [],
}) => Text.rich(
  TextSpan(
    style: AppText.display(
      size: 34,
      height: 1.1,
      letterSpacing: -0.5,
      color: color,
    ),
    children: [
      TextSpan(text: text),
      ...extra,
    ],
  ),
  textAlign: TextAlign.center,
);

BoxDecoration _darkIconDeco() => BoxDecoration(
  borderRadius: BorderRadius.circular(16),
  gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2C2C34), Color(0xFF111115)],
  ),
  boxShadow: const [
    BoxShadow(color: Color(0xFF050507), offset: Offset(0, 6)),
    BoxShadow(color: Color(0x59000000), blurRadius: 30, offset: Offset(0, 22)),
  ],
);

BoxDecoration _yellowCubeDeco(double radius, double edge) => BoxDecoration(
  borderRadius: BorderRadius.circular(radius),
  gradient: const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFE066), AppColors.yellow],
  ),
  boxShadow: [
    BoxShadow(color: const Color(0xFFB98600), offset: Offset(0, edge)),
    const BoxShadow(
      color: Color(0x59B47800),
      blurRadius: 40,
      offset: Offset(0, 30),
    ),
  ],
);

// ------------------------------------------------------------------ How it works
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  static const _steps = [
    (
      LucideIcons.clipboardList,
      'Tell us the product',
      'Name it, describe it, add a photo if you have one.',
    ),
    (
      LucideIcons.store,
      'Share the store',
      'Tell us which store it is from and where to find it.',
    ),
    (
      LucideIcons.send,
      'Submit your request',
      'Add your delivery details and send it in one go.',
    ),
    (
      LucideIcons.bellRing,
      'Our team is notified',
      'Your request lands straight in our inbox.',
    ),
    (
      LucideIcons.phoneCall,
      'We contact you',
      'We reach out with the next steps and confirm details.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFF6D6), Colors.white],
          stops: [0, .6],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -140,
            top: -60,
            child: Orb(
              size: 280,
              color: AppColors.yellow.withValues(alpha: 0.3),
            ),
          ),
          Positioned(
            right: -140,
            bottom: -60,
            child: Orb(
              size: 300,
              color: AppColors.homeGreen.withValues(alpha: 0.15),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                children: [
                  const Reveal(child: DotPill('How it works')),
                  const SizedBox(height: 20),
                  Reveal(child: _h2('Five steps. One short form.')),
                  const SizedBox(height: 16),
                  Reveal(
                    child: Text(
                      "From your idea to our team's inbox in a couple of minutes.",
                      textAlign: TextAlign.center,
                      style: AppText.body(
                        size: 18,
                        color: AppColors.homeBody,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 56),
                  for (var i = 0; i < _steps.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: Reveal(
                        delay: Duration(milliseconds: 60 * i),
                        dy: 50,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.white, Color(0xFFFFF4CC)],
                            ),
                            border: Border.all(
                              color: AppColors.yellow.withValues(alpha: 0.4),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x59785000),
                                blurRadius: 50,
                                spreadRadius: -20,
                                offset: Offset(0, 25),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                top: -10,
                                child: Text(
                                  '${i + 1}',
                                  style:
                                      AppText.display(
                                        size: 60,
                                        weight: FontWeight.w900,
                                        color: AppColors.yellow,
                                      ).copyWith(
                                        shadows: const [
                                          Shadow(
                                            color: Color(0xFFE0A800),
                                            offset: Offset(0, 3),
                                          ),
                                          Shadow(
                                            color: Color(0x40000000),
                                            offset: Offset(0, 8),
                                            blurRadius: 14,
                                          ),
                                        ],
                                      ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: _darkIconDeco(),
                                    child: Icon(
                                      _steps[i].$1,
                                      size: 28,
                                      color: AppColors.yellow,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    _steps[i].$2,
                                    style: AppText.body(
                                      size: 18,
                                      weight: FontWeight.w800,
                                      color: AppColors.homeDark,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _steps[i].$3,
                                    style: AppText.body(
                                      size: 15,
                                      height: 1.55,
                                      color: AppColors.homeBody,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------- Gallery
class GallerySection extends StatelessWidget {
  const GallerySection({super.key});

  Widget _tile(BuildContext context, GalleryItem g, double height) {
    return GestureDetector(
      onTap: () => AppNav.push(context, Routes.gallery(g.slug)),
      child: Semantics(
        button: true,
        label: 'View details: ${g.title}',
        child: Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFE88F), Color(0xFFFED45D)],
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66785000),
                blurRadius: 40,
                spreadRadius: -18,
                offset: Offset(0, 22),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                g.asset,
                fit: BoxFit.cover,
                cacheWidth: 900,
                excludeFromSemantics: true,
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 36, 14, 12),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xD916161A), Color(0x0016161A)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        g.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.body(
                          size: 14,
                          weight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        g.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.body(
                          size: 12,
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cell = w >= 640 ? 200.0 : 140.0;
    const gap = 12.0;
    final g = kGalleryItems;
    Widget pair(int a, int b) => Padding(
      padding: const EdgeInsets.only(top: gap),
      child: Row(
        children: [
          Expanded(child: _tile(context, g[a], cell)),
          const SizedBox(width: gap),
          Expanded(child: _tile(context, g[b], cell)),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFFFF6D6)],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: -140,
            top: 40,
            child: Orb(
              size: 290,
              color: AppColors.yellow.withValues(alpha: 0.3),
            ),
          ),
          Positioned(
            right: -140,
            bottom: 20,
            child: Orb(
              size: 290,
              color: AppColors.homeGreen.withValues(alpha: 0.15),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                children: [
                  const Reveal(child: DotPill('Our gallery')),
                  const SizedBox(height: 20),
                  Reveal(
                    child: _h2(
                      'City Delivery Services, ',
                      extra: [
                        TextSpan(
                          text: 'in pictures.',
                          style: AppText.display(
                            size: 34,
                            height: 1.1,
                            letterSpacing: -0.5,
                            color: AppColors.homeGreen,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Reveal(
                    child: Text(
                      'A glimpse of the products, stores and everyday moments we help bring to your door.',
                      textAlign: TextAlign.center,
                      style: AppText.body(
                        size: 18,
                        color: AppColors.homeBody,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Reveal(child: _tile(context, g[0], cell * 2 + gap)),
                  Reveal(child: pair(1, 2)),
                  Reveal(child: pair(3, 4)),
                  Reveal(
                    child: Padding(
                      padding: const EdgeInsets.only(top: gap),
                      child: _tile(context, g[5], cell),
                    ),
                  ),
                  Reveal(child: pair(6, 7)),
                  const SizedBox(height: 56),
                  Reveal(
                    child: Chunky3DButton(
                      label: 'Request a Service',
                      icon: LucideIcons.arrowRight,
                      expand: false,
                      onPressed: () => AppNav.push(context, Routes.request),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------------- Why us
class WhySection extends StatelessWidget {
  const WhySection({super.key});

  static const _why = [
    (
      LucideIcons.mousePointerClick,
      'Simple by design',
      'One short form. No account, no app, no clutter.',
    ),
    (
      LucideIcons.store,
      'Your store, your pick',
      'You choose the product and the store — we work from your request.',
    ),
    (
      LucideIcons.shieldCheck,
      'Clear communication',
      'Every request gets a unique ID and a confirmation email.',
    ),
    (
      LucideIcons.heartHandshake,
      'A real team',
      'People review each request and contact you personally.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 20),
      decoration: const BoxDecoration(color: AppColors.homeDark),
      child: Stack(
        children: [
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (r) => const RadialGradient(
                colors: [Colors.white, Colors.transparent],
                stops: [.3, .75],
              ).createShader(r),
              blendMode: BlendMode.dstIn,
              child: CustomPaint(
                painter: GridPainter(
                  color: Colors.white.withValues(alpha: 0.05),
                  step: 48,
                ),
              ),
            ),
          ),
          Positioned(
            top: -80,
            right: -80,
            child: Orb(
              size: 300,
              color: AppColors.yellow.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Orb(
              size: 300,
              color: AppColors.homeGreen.withValues(alpha: 0.25),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Reveal(
                    dx: -50,
                    dy: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const DotPill('Why choose us', dark: true),
                        const SizedBox(height: 20),
                        Text.rich(
                          TextSpan(
                            style: AppText.display(
                              size: 34,
                              height: 1.05,
                              letterSpacing: -0.5,
                              color: Colors.white,
                            ),
                            children: [
                              const TextSpan(text: 'Less hassle. '),
                              TextSpan(
                                text: 'More clarity.',
                                style: AppText.display(
                                  size: 34,
                                  height: 1.05,
                                  letterSpacing: -0.5,
                                  color: AppColors.yellow,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'We built the request experience around what customers actually need: a clear form, a clear confirmation and a clear next step.',
                          style: AppText.body(
                            size: 18,
                            height: 1.6,
                            color: Colors.white.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 56),
                  for (var i = 0; i < _why.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Reveal(
                        delay: Duration(milliseconds: 80 * i),
                        dy: 60,
                        child: Container(
                          width: double.infinity,
                          clipBehavior: Clip.hardEdge,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.09),
                                Colors.white.withValues(alpha: 0.02),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: -4,
                                bottom: -40,
                                child: Text(
                                  '${i + 1}',
                                  style: AppText.display(
                                    size: 112,
                                    weight: FontWeight.w900,
                                    color: Colors.white.withValues(alpha: 0.04),
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: _yellowCubeDeco(16, 6),
                                    child: Icon(
                                      _why[i].$1,
                                      size: 26,
                                      color: AppColors.homeDark,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    _why[i].$2,
                                    style: AppText.body(
                                      size: 20,
                                      weight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _why[i].$3,
                                    style: AppText.body(
                                      size: 16,
                                      height: 1.6,
                                      color: Colors.white.withValues(
                                        alpha: 0.65,
                                      ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------- Request journey
class JourneySection extends StatelessWidget {
  const JourneySection({super.key});

  static const _nodes = [
    (LucideIcons.clipboardList, 'You request'),
    (LucideIcons.bellRing, 'Team notified'),
    (LucideIcons.phoneCall, 'We contact you'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFFFF6D6)],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            children: [
              const Reveal(child: DotPill('The request journey')),
              const SizedBox(height: 20),
              Reveal(child: _h2('What happens to your request')),
              const SizedBox(height: 16),
              Reveal(
                child: Text(
                  'A transparent path from the moment you press submit.',
                  textAlign: TextAlign.center,
                  style: AppText.body(
                    size: 18,
                    color: AppColors.homeBody,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 64),
              Stack(
                children: [
                  Positioned.fill(
                    top: 96,
                    bottom: 96,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0A800).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      for (var i = 0; i < _nodes.length; i++)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: i == _nodes.length - 1 ? 0 : 64,
                          ),
                          child: Reveal(
                            delay: Duration(milliseconds: 150 * i),
                            dy: 60,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 128,
                                  height: 128,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 112,
                                        height: 112,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            32,
                                          ),
                                          color: AppColors.yellow.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 128,
                                        height: 128,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            38,
                                          ),
                                          border: Border.all(
                                            color: const Color(0x99E0A800),
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 112,
                                        height: 112,
                                        decoration: _yellowCubeDeco(32, 9),
                                        child: Icon(
                                          _nodes[i].$1,
                                          size: 46,
                                          color: AppColors.homeDark,
                                        ),
                                      ),
                                      Positioned(
                                        right: -4,
                                        top: -4,
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: AppColors.homeGreen,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 4,
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Color(0x800F8A2F),
                                                blurRadius: 14,
                                                offset: Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            LucideIcons.check,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.homeDark,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'Step ${i + 1}',
                                    style: AppText.body(
                                      size: 12,
                                      weight: FontWeight.w700,
                                      color: AppColors.yellow,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _nodes[i].$2,
                                  style: AppText.body(
                                    size: 20,
                                    weight: FontWeight.w800,
                                    color: AppColors.homeDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------- FAQ
const kHomeFaqs = [
  (
    'How do I request a service?',
    'Open the Request a Service page, fill in your details, the product and store information and your delivery address, then submit. You will see a confirmation with your Request ID right away.',
  ),
  (
    'What happens after I submit?',
    'Your request is saved and our team is notified by email. You also get a confirmation email. A team member will then contact you with the next steps.',
  ),
  (
    'Is delivery automatic?',
    'No. Submitting a request does not place an automatic order. Our team reviews each request and confirms availability, price and timing with you directly.',
  ),
  (
    'Can I upload a photo of the product?',
    'Yes — an optional JPG, PNG or WebP image up to 5 MB can be attached to help us identify the exact item.',
  ),
  (
    'What if my confirmation email does not arrive?',
    'Your request is already saved once you see the success screen. Check your spam folder and keep your Request ID; our system also retries failed emails automatically.',
  ),
  (
    'How can I contact you?',
    'Use the contact form on the Contact page. Any email, phone or address details shown there are provided by the business.',
  ),
];

class FaqSection extends StatefulWidget {
  const FaqSection({super.key});

  @override
  State<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<FaqSection> {
  int _open = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 96),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            children: [
              const SectionHeading(
                eyebrow: 'FAQ',
                title: 'Questions, answered.',
              ),
              const SizedBox(height: 48),
              for (var i = 0; i < kHomeFaqs.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: _open == i
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _open == i
                            ? AppColors.green.withValues(alpha: 0.3)
                            : const Color(0x0D000000),
                      ),
                      boxShadow: _open == i ? AppShadows.soft : null,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () =>
                              setState(() => _open = _open == i ? -1 : i),
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 64),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    kHomeFaqs[i].$1,
                                    style: AppText.display(
                                      size: 17,
                                      weight: FontWeight.w700,
                                      height: 1.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                AnimatedRotation(
                                  turns: _open == i ? 0.125 : 0,
                                  duration: const Duration(milliseconds: 250),
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: const BoxDecoration(
                                      color: AppColors.yellow,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      LucideIcons.plus,
                                      size: 18,
                                      color: AppColors.dark,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 280),
                          alignment: Alignment.topCenter,
                          child: _open == i
                              ? Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    24,
                                    0,
                                    24,
                                    24,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      kHomeFaqs[i].$2,
                                      style: AppText.body(
                                        size: 16,
                                        height: 1.6,
                                        color: AppColors.muted,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(width: double.infinity),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------- Reviews
const _reviews = [
  (
    'Ananya R.',
    'Vellore',
    'Groceries',
    'I sent the store name and a photo of what I needed. Someone called me the same evening and everything was sorted.',
  ),
  (
    'Karthik M.',
    'Katpadi',
    'Medicines',
    'Needed medicine for my mother urgently. The team confirmed availability first and kept me updated the whole way.',
  ),
  (
    'Divya S.',
    'Vellore',
    'Gifts',
    'A birthday gift had to reach my friend across town. It arrived on time and in perfect condition.',
  ),
  (
    'Rahul P.',
    'Bagayam',
    'Electronics',
    'I was skeptical about requesting a product online, but the process was simple and the updates were genuinely useful.',
  ),
  (
    'Meera K.',
    'Sathyavedu',
    'Fashion',
    'They picked up the exact pair of shoes from the store I mentioned. No running around, no guesswork.',
  ),
  (
    'Vignesh T.',
    'Vellore',
    'Daily needs',
    'Clear communication from start to finish. I always knew who to contact and what was happening with my request.',
  ),
];

class ReviewsSection extends StatelessWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cardW = MediaQuery.of(context).size.width >= 640 ? 350.0 : 290.0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 96),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF4F9F3), Colors.white],
          stops: [0, .5, 1],
        ),
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SectionHeading(
              eyebrow: 'Reviews',
              title: 'Kind words from our customers.',
              description: 'Real requests, real people, and deliveries handled with care.',
            ),
          ),
          const SizedBox(height: 56),
          Semantics(
            label: 'Customer reviews',
            child: SizedBox(
              height: 360,
              child: AutoMarquee(
                interactive: true,
                pixelsPerSecond: 34,
                copyBuilder: (copy) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < _reviews.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: _ReviewCard(
                            width: cardW,
                            index: i,
                            name: _reviews[i].$1,
                            area: _reviews[i].$2,
                            tag: _reviews[i].$3,
                            quote: _reviews[i].$4,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.width,
    required this.index,
    required this.name,
    required this.area,
    required this.tag,
    required this.quote,
  });
  final double width;
  final int index;
  final String name, area, tag, quote;

  @override
  Widget build(BuildContext context) {
    final initials = name.split(' ').map((w) => w[0]).join().substring(0, 2);
    return Container(
      width: width,
      constraints: const BoxConstraints(minHeight: 268),
      padding: const EdgeInsets.all(28),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x0D000000)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40101814),
            blurRadius: 50,
            spreadRadius: -20,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 4,
            right: 4,
            top: -28,
            child: Container(
              height: 4,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                gradient: LinearGradient(
                  colors: [
                    AppColors.yellow,
                    AppColors.homeGreen,
                    AppColors.yellow,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: -4,
            top: -4,
            child: Icon(
              LucideIcons.quote,
              size: 48,
              color: AppColors.yellow.withValues(alpha: 0.25),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  for (var s = 0; s < 5; s++)
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(
                        Icons.star_rounded,
                        size: 18,
                        color: AppColors.yellow,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                '“$quote”',
                style: AppText.body(
                  size: 15,
                  height: 1.6,
                  color: const Color(0xFF4B4B46),
                ),
              ),
              const SizedBox(height: 22),
              Container(height: 1, color: Colors.black.withValues(alpha: 0.05)),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: index.isOdd
                            ? const [Color(0xFFB47A00), AppColors.yellow]
                            : const [Color(0xFF0A6E25), AppColors.homeGreen],
                      ),
                    ),
                    child: Text(
                      initials,
                      style: AppText.body(
                        size: 14,
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.display(
                            size: 16,
                            weight: FontWeight.w700,
                            color: AppColors.homeDark,
                          ),
                        ),
                        Text(
                          '$area · $tag',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.body(
                            size: 12,
                            color: const Color(0xFF7A7A73),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------------------------- CTA
class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width >= 640;
    return Padding(
      padding: EdgeInsets.fromLTRB(wide ? 24 : 12, 0, wide ? 24 : 12, 96),
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        padding: EdgeInsets.symmetric(horizontal: wide ? 48 : 24, vertical: 80),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          color: const Color(0xFF111713),
          gradient: RadialGradient(
            center: const Alignment(-0.84, -1),
            radius: 1.1,
            colors: [
              AppColors.yellow.withValues(alpha: 0.16),
              const Color(0xFF111713),
            ],
            stops: const [0, 0.65],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Orb(
                  size: 420,
                  color: AppColors.homeGreen.withValues(alpha: 0.5),
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: GridPainter(
                  color: Colors.white.withValues(alpha: 0.04),
                  step: 44,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Reveal(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.yellow,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'QUICK & SIMPLE',
                              style: AppText.body(
                                size: 12,
                                weight: FontWeight.w700,
                                letterSpacing: 1.9,
                                color: const Color(0xFFFFE08A),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Text.rich(
                        TextSpan(
                          style: AppText.display(
                            size: 34,
                            height: 1.08,
                            color: Colors.white,
                          ),
                          children: [
                            const TextSpan(text: 'Ready to request '),
                            TextSpan(
                              text: 'your service?',
                              style: AppText.display(
                                size: 34,
                                height: 1.08,
                                color: AppColors.yellow,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'It takes a couple of minutes. Tell us the product and the store, and we will take it from there.',
                        style: AppText.body(
                          size: 18,
                          height: 1.6,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Wrap(
                        spacing: 28,
                        runSpacing: 12,
                        children: [
                          for (final t in const [
                            'No sign-up needed',
                            'We confirm by phone',
                            'Request ID included',
                          ])
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: AppColors.yellow.withValues(
                                      alpha: 0.2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    LucideIcons.check,
                                    size: 12,
                                    color: AppColors.yellow,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  t,
                                  style: AppText.body(
                                    size: 14,
                                    color: Colors.white.withValues(alpha: 0.75),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: 36),
                      BrandButton(
                        label: 'Request a Service',
                        size: BrandButtonSize.lg,
                        expand: !wide,
                        trailing: LucideIcons.arrowRight,
                        onPressed: () => AppNav.push(context, Routes.request),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => AppNav.push(context, Routes.howItWorks),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'See how it works',
                                style: AppText.body(
                                  size: 14,
                                  weight: FontWeight.w700,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                LucideIcons.arrowRight,
                                size: 16,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 56),
                const Reveal(child: _CtaMock()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CtaMock extends StatefulWidget {
  const _CtaMock();

  @override
  State<_CtaMock> createState() => _CtaMockState();
}

class _CtaMockState extends State<_CtaMock>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _ghost(double angle) => Transform.rotate(
    angle: angle,
    child: Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
    ),
  );

  Widget _tag(IconData icon, String text) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    decoration: BoxDecoration(
      color: AppColors.yellow,
      borderRadius: BorderRadius.circular(999),
      boxShadow: const [
        BoxShadow(
          color: Color(0x4D000000),
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.homeDark),
        const SizedBox(width: 6),
        Text(
          text,
          style: AppText.body(
            size: 12,
            weight: FontWeight.w800,
            color: AppColors.homeDark,
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    const rows = [
      (LucideIcons.zap, 'Product', 'What you need'),
      (LucideIcons.store, 'Store', 'Where to pick it up'),
      (LucideIcons.truck, 'Delivery', 'Where it should go'),
    ];
    return ExcludeSemantics(
      child: SizedBox(
        height: 340,
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            final bob = -8 * Curves.easeInOut.transform(_c.value);
            return Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 290,
                  height: 290,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                _ghost(-0.175),
                _ghost(0.122),
                Transform.translate(
                  offset: Offset(0, bob),
                  child: Container(
                    width: 260,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x99000000),
                          blurRadius: 60,
                          spreadRadius: -20,
                          offset: Offset(0, 30),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.homeGreen,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    LucideIcons.clipboardList,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'New request',
                                  style: AppText.body(
                                    size: 14,
                                    weight: FontWeight.w800,
                                    color: AppColors.homeDark,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'STEP 1 OF 3',
                              style: AppText.body(
                                size: 10,
                                weight: FontWeight.w700,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 1,
                          color: Colors.black.withValues(alpha: 0.05),
                        ),
                        const SizedBox(height: 10),
                        for (final r in rows)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE7F6EA),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    r.$1,
                                    size: 15,
                                    color: AppColors.homeGreen,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.$2,
                                      style: AppText.body(
                                        size: 12,
                                        weight: FontWeight.w800,
                                        color: AppColors.homeDark,
                                      ),
                                    ),
                                    Text(
                                      r.$3,
                                      style: AppText.body(
                                        size: 11,
                                        color: const Color(0xFF7A7A73),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 4),
                        Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.homeGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Submit request',
                                style: AppText.body(
                                  size: 13,
                                  weight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                LucideIcons.arrowRight,
                                size: 14,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              LucideIcons.shieldCheck,
                              size: 12,
                              color: AppColors.homeGreen,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Request ID sent instantly',
                              style: AppText.body(
                                size: 11,
                                color: const Color(0xFF7A7A73),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 24,
                  child: _tag(LucideIcons.phoneCall, "We'll call you"),
                ),
                Positioned(
                  left: 0,
                  bottom: 24,
                  child: _tag(LucideIcons.shieldCheck, 'No sign-up needed'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
