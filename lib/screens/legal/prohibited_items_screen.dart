import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/common/brand_button.dart';
import '../../widgets/common/cards.dart';
import '../../widgets/common/section_widgets.dart';
import '../../widgets/layout/navigation.dart';
import '../../widgets/layout/site_page.dart';

const _prohibited = [
  (
    'Illegal, stolen or counterfeit goods',
    'Any item that is illegal to possess, purchase, sell or transport in India; stolen property; counterfeit or pirated goods; and items that infringe another person’s rights.',
  ),
  (
    'Explosives, weapons and ammunition',
    'Fireworks, flares, detonators, gunpowder, ammunition, firearms, unlicensed weapons, martial-arts weapons and any other weapon that cannot lawfully be carried in a personal parcel.',
  ),
  (
    'Flammable and hazardous materials',
    'Petrol, diesel, lighter fluid, paint thinner, solvents, flammable adhesives, gas cylinders, fuel tablets, matches, aerosol cans, corrosive acids, alkalis, pesticides, poisons and toxic chemicals.',
  ),
  (
    'Radioactive, infectious and biological material',
    'Radioactive substances, medical or biological waste, used sharps, cultures, samples, pathogens and any material that could contaminate people, vehicles or other parcels.',
  ),
  (
    'Narcotics and controlled substances',
    'Illegal drugs, narcotics, controlled substances, prescription medicines without valid authorisation, and any medicine or supplement that is restricted or prohibited by law.',
  ),
  (
    'Live animals, humans and plants',
    'Live animals, birds, fish, insects, reptiles, plants with soil, and any living creature or human being. Service-animal arrangements are outside this request service.',
  ),
  (
    'Perishable and temperature-controlled goods without approval',
    'Fresh food, frozen food, dairy products, cooked food, flowers and other items that require temperature control, except where we have agreed suitable packaging and handling in advance.',
  ),
  (
    'Obscene, hateful or unlawful content',
    'Material that is obscene, hateful, defamatory, promotes violence, or is otherwise unlawful to possess or distribute.',
  ),
];

const _restricted = [
  (
    'Alcohol, tobacco and nicotine products',
    'Only where lawful, correctly sealed and handed over to an eligible adult. Age and local rules apply.',
  ),
  (
    'Ordinary medicines',
    'Non-hazardous, sealed, labelled and in-date medicines may be accepted when permitted by law. Controlled substances remain prohibited.',
  ),
  (
    'Liquids, gels, powders and aerosols',
    'Must be leak-proof, rigidly packed and declared. Hazardous versions remain prohibited.',
  ),
  (
    'Electronics and batteries',
    'Electronics with lithium or other batteries must be declared, protected from short-circuiting and packed securely. Damaged or recalled batteries are not accepted.',
  ),
  (
    'Fragile, sharp and high-value items',
    'Glassware, ceramics, tools with exposed blades, jewellery, watches, bullion, cash, cheques, passports, licences and important documents require prior agreement and suitable packing.',
  ),
  (
    'Oversized or unusually heavy goods',
    'Items must fit ordinary two-wheeler or car transport safely. We may decline anything that cannot be carried safely or legally.',
  ),
];

const _duties = [
  'I confirm that the parcel contains only permitted items and that my description of the product is accurate.',
  'I confirm that I am legally allowed to hand over the item and that I have any permission, licence or authorisation required for it.',
  'I will pack the item securely so that it does not leak, break, injure a person or damage another parcel.',
  'I will tell our team before collection if an item is fragile, valuable, temperature-sensitive or otherwise needs special handling.',
  'I will not place a prohibited item inside a parcel described as something else.',
  'I understand that City Delivery Services may inspect, refuse, return or stop delivery of any parcel that appears to breach this policy.',
];

class ProhibitedItemsScreen extends StatelessWidget {
  const ProhibitedItemsScreen({super.key});

  Widget _header(
    IconData icon,
    String kicker,
    String title, {
    Color bg = AppColors.yellow,
    Color fg = AppColors.dark,
  }) {
    return Row(
      children: [
        IconBadge(icon, color: bg, iconColor: fg),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kicker.toUpperCase(),
                style: AppText.body(
                  size: 12,
                  weight: FontWeight.w800,
                  letterSpacing: 1.8,
                  color: AppColors.green,
                ),
              ),
              const SizedBox(height: 2),
              Text(title, style: AppText.display(size: 24, height: 1.15)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _items(List<(String, String)> items) => Column(
    children: [
      for (final i in items)
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.light.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(i.$1, style: AppText.display(size: 16, height: 1.3)),
              const SizedBox(height: 6),
              Text(
                i.$2,
                style: AppText.body(
                  size: 14,
                  height: 1.6,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final body = AppText.body(size: 16, height: 1.7, color: AppColors.muted);
    return SitePage(
      route: Routes.prohibited,
      children: [
        const PageHero(
          eyebrow: 'Delivery policy',
          title: 'Prohibited Items Policy',
          description: 'A short, clear declaration of what cannot be sent and what needs prior approval before we arrange a delivery.',
        ),
        ContainerX(
          maxWidth: 860,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                WhiteCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(
                        LucideIcons.shieldCheck,
                        'Declaration',
                        'What the checkbox means',
                        bg: AppColors.green,
                        fg: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'When you tick “I agree that my parcel contains only permitted items” on the request form, you are confirming the declaration below. This policy applies to every product and delivery request submitted through this website. If you are unsure whether an item is allowed, contact us before submitting the request.',
                        style: body,
                      ),
                      const SizedBox(height: 18),
                      for (final d in _duties)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 3),
                                child: Icon(
                                  LucideIcons.checkCircle2,
                                  size: 18,
                                  color: AppColors.green,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  d,
                                  style: AppText.body(size: 15, height: 1.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                WhiteCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(
                        LucideIcons.alertTriangle,
                        'Do not submit',
                        'Prohibited items',
                        bg: AppColors.red100,
                        fg: AppColors.red700,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'We do not carry the following items as part of this request service. Do not include them in a parcel, and do not ask our team or a delivery partner to collect them.',
                        style: body,
                      ),
                      const SizedBox(height: 18),
                      _items(_prohibited),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                WhiteCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header(
                        LucideIcons.fileText,
                        'Prior approval needed',
                        'Restricted items',
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'These items are not always prohibited, but they must be declared and agreed before collection or delivery. We may ask for extra packaging, proof of eligibility, or may decline the item.',
                        style: body,
                      ),
                      const SizedBox(height: 18),
                      _items(_restricted),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                WhiteCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inspection, refusal and false declarations',
                        style: AppText.display(size: 24, height: 1.2),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'We may inspect a parcel before or at collection. If an item appears prohibited, unsafe, undeclared or unlawfully possessed, we may refuse it, stop the delivery, return it to the sender or contact the appropriate authority where required. A false declaration may also lead us to decline future requests from the same customer.',
                        style: body,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'This policy does not replace any legal requirement. The sender remains responsible for ensuring that the item, its packaging, its destination and the manner of carriage are lawful.',
                        style: body,
                      ),
                      const SizedBox(height: 22),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          BrandButton(
                            label: 'Back to request form',
                            onPressed: () =>
                                AppNav.push(context, Routes.request),
                          ),
                          BrandButton(
                            label: 'Contact us',
                            outline: true,
                            onPressed: () =>
                                AppNav.push(context, Routes.contact),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Policy version $kProhibitedItemsPolicyVersion · Effective 20 November 2026 · Canonical page: ${Site.websiteUrl}/prohibited-items-policy',
                  textAlign: TextAlign.center,
                  style: AppText.body(size: 13, color: AppColors.muted),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
