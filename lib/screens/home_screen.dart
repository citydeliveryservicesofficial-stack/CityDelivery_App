import 'package:flutter/material.dart';

import '../widgets/layout/navigation.dart';
import '../widgets/layout/site_page.dart';
import 'home/hero_section.dart';
import 'home/home_sections.dart';
import 'home/marquee_section.dart';

/// Home page: same section order as `Home.jsx`.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SitePage(
      route: Routes.home,
      children: [
        HeroSection(),
        MarqueeSection(),
        HowItWorksSection(),
        GallerySection(),
        WhySection(),
        JourneySection(),
        FaqSection(),
        ReviewsSection(),
        CtaSection(),
      ],
    );
  }
}
