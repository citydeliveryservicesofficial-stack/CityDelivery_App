import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../common/reveal.dart';
import '../common/section_widgets.dart';
import 'navigation.dart';

const _ftDark = Color(0xFF16161A);

/// Dark footer (Footer.jsx). The website's "Admin" shortcut is intentionally omitted from the app.
class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key, required this.route});
  final String route;

  @override
  Widget build(BuildContext context) {
    final links = <NavLink>[
      ...kNavLinks.skip(1),
      const NavLink(Routes.becomeRider, 'Become a Rider'),
      const NavLink(Routes.request, 'Request a Service'),
      const NavLink(Routes.prohibited, 'Prohibited Items Policy'),
      const NavLink(Routes.privacy, 'Privacy Policy'),
      const NavLink(Routes.terms, 'Terms and Conditions'),
    ];
    final socials = Site.social.entries
        .where((e) => e.value.isNotEmpty)
        .toList();
    const socialIcons = {
      'Instagram': LucideIcons.camera,
      'Facebook': LucideIcons.users,
      'X': LucideIcons.atSign,
      'WhatsApp': LucideIcons.messageCircle,
    };

    return Container(
      color: _ftDark,
      child: Stack(
        children: [
          Positioned.fill(
            child: ShaderMask(
              shaderCallback: (r) => const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.transparent],
                stops: [0, 0.85],
              ).createShader(r),
              blendMode: BlendMode.dstIn,
              child: CustomPaint(
                painter: GridPainter(
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
          ),
          Positioned(
            top: -120,
            right: -60,
            child: Orb(
              size: 320,
              color: AppColors.yellow.withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            bottom: -110,
            left: -80,
            child: Orb(
              size: 290,
              color: AppColors.homeGreen.withValues(alpha: 0.3),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 3,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.yellow,
                    AppColors.homeGreen,
                    AppColors.yellow,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Reveal(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            AppNav.goTop(context, Routes.home, current: route),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/logo_footer.webp',
                            height: 112,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Tell us the product, the store and where it should go. We handle the request from there.',
                        style: AppText.body(
                          size: 15,
                          height: 1.6,
                          color: Colors.white.withValues(alpha: 0.65),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _YellowButton(
                        label: 'Request a Service',
                        onTap: () => AppNav.goTop(
                          context,
                          Routes.request,
                          current: route,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 44),
                Reveal(
                  delay: const Duration(milliseconds: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FooterHeading('Explore'),
                      const SizedBox(height: 14),
                      for (final l in links)
                        InkWell(
                          onTap: () =>
                              AppNav.goTop(context, l.route, current: route),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              l.label,
                              style: AppText.body(
                                size: 15,
                                color: Colors.white.withValues(alpha: 0.75),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Reveal(
                  delay: const Duration(milliseconds: 130),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FooterHeading('City where we serve'),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          const Icon(
                            LucideIcons.mapPin,
                            size: 18,
                            color: AppColors.yellow,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            Site.serviceCity,
                            style: AppText.body(
                              size: 15,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Reveal(
                  delay: const Duration(milliseconds: 160),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FooterHeading('Get in touch'),
                      const SizedBox(height: 18),
                      if (Site.email.isNotEmpty)
                        _ContactRow(
                          icon: LucideIcons.mail,
                          text: Site.email,
                          onTap: () => Launcher.mail(Site.email),
                        ),
                      if (Site.phone.isNotEmpty)
                        _ContactRow(
                          icon: LucideIcons.phone,
                          text: Site.phone,
                          onTap: () => Launcher.tel(Site.phone),
                        ),
                      if (Site.address.isNotEmpty)
                        _ContactRow(
                          icon: LucideIcons.mapPin,
                          text: Site.address,
                        ),
                      if (Site.email.isEmpty &&
                          Site.phone.isEmpty &&
                          Site.address.isEmpty)
                        InkWell(
                          onTap: () => AppNav.goTop(
                            context,
                            Routes.contact,
                            current: route,
                          ),
                          child: Text(
                            'Use our contact form →',
                            style: AppText.body(color: Colors.white70),
                          ),
                        ),
                      if (socials.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 16,
                          children: [
                            for (final s in socials)
                              Semantics(
                                button: true,
                                label: s.key,
                                child: GestureDetector(
                                  onTap: () => Launcher.url(s.value),
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x8C000000),
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      socialIcons[s.key],
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 30),
                      Container(
                        padding: const EdgeInsets.only(left: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(color: AppColors.yellow, width: 4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FOUNDER & CHAIRMAN',
                              style: AppText.body(
                                size: 13,
                                weight: FontWeight.w700,
                                letterSpacing: 2,
                                color: AppColors.yellow,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Saranya Gopinath',
                              style: AppText.display(
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 44),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom bar is a separate widget so it sits below the decorative stack.
class SiteFooterBar extends StatelessWidget {
  const SiteFooterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final muted = AppText.body(
      size: 14,
      color: Colors.white.withValues(alpha: 0.5),
    );
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _ftDark,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        24,
        20,
        24 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Launcher.url(
                  'https://www.doormartdelivery.in/assets/leastactionlogo-SbXcJl_q.png',
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'https://www.doormartdelivery.in/assets/leastactionlogo-SbXcJl_q.png',
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const SizedBox(width: 40, height: 40),
                    semanticLabel: 'Least Action',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    style: muted,
                    children: [
                      const TextSpan(text: 'Powered by '),
                      _link(
                        'Least Action Company',
                        'https://www.leastactioncompany.com/',
                        bold: true,
                      ),
                      const TextSpan(text: ' · '),
                      _link(
                        'A unit of SG Foundation Trust',
                        'https://www.sgfoundationtrust.com/',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            '© ${DateTime.now().year} City Delivery Services. All rights reserved.',
            style: muted,
          ),
          const SizedBox(height: 8),
          Text(
            'Requests are reviewed by our team — availability and timing are confirmed with you directly.',
            style: muted,
          ),
        ],
      ),
    );
  }

  InlineSpan _link(String text, String url, {bool bold = false}) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: GestureDetector(
        onTap: () => Launcher.url(url),
        child: Text(
          text,
          style: AppText.body(
            size: 14,
            weight: bold ? FontWeight.w600 : FontWeight.w500,
            color: bold ? Colors.white : Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

class _FooterHeading extends StatelessWidget {
  const _FooterHeading(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text.toUpperCase(),
          style: AppText.display(
            size: 14,
            weight: FontWeight.w700,
            letterSpacing: 2.5,
            color: AppColors.yellow,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.yellow,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.text, this.onTap});
  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2C2C34), Color(0xFF111115)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Color(0xFF050507), offset: Offset(0, 4)),
                ],
              ),
              child: Icon(icon, size: 18, color: AppColors.yellow),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 9),
                child: Text(
                  text,
                  style: AppText.body(
                    size: 15,
                    height: 1.4,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _YellowButton extends StatefulWidget {
  const _YellowButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_YellowButton> createState() => _YellowButtonState();
}

class _YellowButtonState extends State<_YellowButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        transform: Matrix4.translationValues(0, _down ? 3 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFE066), AppColors.yellow],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFB98600),
              offset: Offset(0, _down ? 2 : 6),
            ),
            const BoxShadow(
              color: Color(0x4DFFC928),
              blurRadius: 26,
              offset: Offset(0, 16),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: AppText.body(
                size: 16,
                weight: FontWeight.w700,
                color: _ftDark,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(LucideIcons.arrowRight, size: 18, color: _ftDark),
          ],
        ),
      ),
    );
  }
}
