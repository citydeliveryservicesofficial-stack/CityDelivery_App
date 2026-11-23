import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/brand_button.dart';
import '../../widgets/common/cards.dart';
import '../../widgets/common/reveal.dart';
import '../../widgets/common/section_widgets.dart';
import '../../widgets/layout/navigation.dart';
import '../../widgets/layout/site_page.dart';

const _faq = [
  (
    'Who can apply to become a rider?',
    'Applicants must be at least 18 years old, hold a valid driving licence, and be available for local work in Vellore. You can apply with your own vehicle or ask about available assistance options.',
  ),
  (
    'Does submitting an application mean approval?',
    'No. Submission only means we have received your details and documents. Our team reviews every application before approval, and approval does not automatically activate deliveries.',
  ),
  (
    'Which documents are needed?',
    'A profile photo, both sides of your driving licence, PAN proof and, if you own a vehicle, its RC and vehicle photo. Insurance and identity proof may be required depending on your application. PUC documents are not collected.',
  ),
  (
    'Do I have to share bank details immediately?',
    'No. You can submit bank details with the application or after approval. Bank information is kept separate from ordinary admin views and is only accessible with a dedicated sensitive-data key.',
  ),
  (
    'How do I check my application status?',
    'After submitting, save the Application ID shown on the confirmation screen and use the Check Status page. If you provided an email address, status updates are also emailed to you.',
  ),
  (
    'Is a rider app available?',
    'Not yet. This website currently supports applications, status checks and onboarding. Delivery assignment and tracking tools are not enabled.',
  ),
];

const _features = [
  (
    LucideIcons.clipboardCheck,
    'Simple application',
    'Complete the form in clear steps and upload documents from your phone or computer.',
  ),
  (
    LucideIcons.shieldCheck,
    'Private document handling',
    'Documents are stored privately and bank or identity details are restricted.',
  ),
  (
    LucideIcons.mapPin,
    'Local work in Vellore',
    'Tell us the areas and hours you prefer so our team can review your fit.',
  ),
  (
    LucideIcons.checkCircle2,
    'Clear status updates',
    'Use your Application ID to see where your application stands.',
  ),
];

const _journey = [
  ('01', 'Apply', 'Fill the multi-step form and upload your documents.'),
  (
    '02',
    'Review',
    'Our team reviews your details and may request more documents.',
  ),
  ('03', 'Approval', 'Approved applicants receive a Rider ID by email.'),
  (
    '04',
    'Activation',
    'An administrator activates the account separately when onboarding is complete.',
  ),
];

const _docs = [
  'Profile photo',
  'Driving licence — front and back',
  'PAN number and PAN proof',
  'Vehicle RC — front and back, if you own a vehicle',
  'Vehicle photo and insurance where applicable',
  'Identity or bank proof — only if provided or requested',
];

class BecomeRiderScreen extends StatelessWidget {
  const BecomeRiderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SitePage(
      route: Routes.becomeRider,
      children: [
        PageHero(
          eyebrow: 'Rider onboarding',
          title: 'Ride with City Delivery Services',
          description: 'We are accepting rider applications in Vellore. Submit your details, track your status and complete onboarding if approved.',
          child: Column(
            children: [
              BrandButton(
                label: 'Apply now',
                expand: true,
                onPressed: () => AppNav.push(context, Routes.riderRegister),
              ),
              const SizedBox(height: 12),
              BrandButton(
                label: 'Check application status',
                outline: true,
                expand: true,
                onPressed: () => AppNav.push(context, Routes.riderStatus),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: ContainerX(
            maxWidth: 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Reveal(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: AppShadows.lift,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/hero_visual.webp',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: 'Delivery rider with a scooter',
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Eyebrow('Who can apply'),
                const SizedBox(height: 16),
                Text(
                  'Built for local riders',
                  style: AppText.display(size: 34, height: 1.1),
                ),
                const SizedBox(height: 20),
                Text(
                  'We review each application individually. You must be at least 18, hold a valid driving licence and be available for local work in Vellore. Vehicle options and requirements are confirmed by our team.',
                  style: AppText.body(
                    size: 17,
                    height: 1.65,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 28),
                for (final f in _features)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.light.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconBadge(f.$1, size: 44, radius: 16, shadow: false),
                          const SizedBox(height: 16),
                          Text(
                            f.$2,
                            style: AppText.display(size: 18, height: 1.2),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            f.$3,
                            style: AppText.body(
                              size: 14,
                              height: 1.6,
                              color: AppColors.muted,
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
        Container(
          color: AppColors.light,
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: ContainerX(
            child: Column(
              children: [
                const Eyebrow('How it works'),
                const SizedBox(height: 16),
                Text(
                  'From application to activation',
                  textAlign: TextAlign.center,
                  style: AppText.display(size: 34, height: 1.1),
                ),
                const SizedBox(height: 40),
                for (var i = 0; i < _journey.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Reveal(
                      delay: Duration(milliseconds: 80 * i),
                      child: WhiteCard(
                        radius: 24,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _journey[i].$1,
                              style: AppText.display(
                                size: 30,
                                color: AppColors.yellowDeep,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _journey[i].$2,
                              style: AppText.display(size: 20),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _journey[i].$3,
                              style: AppText.body(
                                size: 14,
                                height: 1.6,
                                color: AppColors.muted,
                              ),
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
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 64),
          child: ContainerX(
            maxWidth: 900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('Documents'),
                const SizedBox(height: 16),
                Text(
                  'What to keep ready',
                  style: AppText.display(size: 34, height: 1.1),
                ),
                const SizedBox(height: 24),
                for (final d in _docs)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.light.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            LucideIcons.fileText,
                            size: 19,
                            color: AppColors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            d,
                            style: AppText.body(
                              size: 15,
                              weight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 40),
                const Eyebrow('Questions'),
                const SizedBox(height: 16),
                Text(
                  'Rider FAQs',
                  style: AppText.display(size: 34, height: 1.1),
                ),
                const SizedBox(height: 24),
                for (final q in _faq) _FaqTile(question: q.$1, answer: q.$2),
              ],
            ),
          ),
        ),
        Container(
          color: AppColors.dark,
          padding: const EdgeInsets.fromLTRB(20, 56, 20, 56),
          child: Column(
            children: [
              const Icon(LucideIcons.bike, size: 42, color: AppColors.yellow),
              const SizedBox(height: 20),
              Text(
                'Ready to apply?',
                textAlign: TextAlign.center,
                style: AppText.display(size: 30, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                'Have your documents ready. You can save your Application ID and check your status at any time.',
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
                onPressed: () => AppNav.push(context, Routes.riderRegister),
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
                        LucideIcons.fileText,
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
          color: AppColors.light.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
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
                      color: AppColors.dark,
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
