import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/helpers.dart';

const _waPath =
    'M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.372-.025-.521-.075-.148-.669-1.611-.916-2.206-.242-.579-.487-.5-.669-.51l-.57-.01c-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.095 3.2 5.076 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.872.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347M12.004 2C6.48 2 2 6.477 2 12c0 1.757.46 3.407 1.262 4.857L2 22l5.255-1.238A9.95 9.95 0 0 0 12.004 22C17.523 22 22 17.523 22 12S17.523 2 12.004 2m0 18.283a8.25 8.25 0 0 1-4.214-1.157l-.302-.18-3.119.735.743-3.04-.197-.312A8.25 8.25 0 1 1 12.004 20.283';

/// Floating WhatsApp chat button (WhatsAppFloat.jsx).
class WhatsAppFloat extends StatefulWidget {
  const WhatsAppFloat({super.key});

  @override
  State<WhatsAppFloat> createState() => _WhatsAppFloatState();
}

class _WhatsAppFloatState extends State<WhatsAppFloat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Chat with City Delivery Services on WhatsApp',
      child: GestureDetector(
        onTap: () async {
          final ok = await Launcher.whatsapp();
          if (!ok && context.mounted)
            showSnack(context, 'Could not open WhatsApp.');
        },
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            final t = _c.value;
            final bob = -5 * (1 - (2 * t - 1).abs());
            return Transform.translate(
              offset: Offset(0, bob),
              child: SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: (0.65 * (1 - t)).clamp(0.0, 1.0),
                      child: Transform.scale(
                        scale: 1 + 0.45 * t,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.whatsapp,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AppColors.whatsapp,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x6625D366),
                            blurRadius: 24,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.string(
                        '<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path fill="#FFFFFF" d="$_waPath"/></svg>',
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
