import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

enum BrandButtonSize { sm, md, lg }

/// The website's single `.btn` style: green pill, glow shadow, press-scale, outline variant.
class BrandButton extends StatefulWidget {
  const BrandButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailing,
    this.leading,
    this.outline = false,
    this.size = BrandButtonSize.md,
    this.loading = false,
    this.expand = false,
    this.color,
    this.foreground,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? trailing;
  final IconData? leading;
  final bool outline;
  final BrandButtonSize size;
  final bool loading;
  final bool expand;
  final Color? color;
  final Color? foreground;

  @override
  State<BrandButton> createState() => _BrandButtonState();
}

class _BrandButtonState extends State<BrandButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null || widget.loading;
    final (
      double h,
      double padX,
      double fs,
      double icon,
    ) = switch (widget.size) {
      BrandButtonSize.sm => (40.0, 20.0, 14.0, 16.0),
      BrandButtonSize.md => (48.0, 28.0, 15.0, 18.0),
      BrandButtonSize.lg => (56.0, 36.0, 16.0, 20.0),
    };
    final bg = widget.outline
        ? Colors.transparent
        : (widget.color ?? AppColors.green);
    final fg =
        widget.foreground ?? (widget.outline ? AppColors.green : Colors.white);

    final content = Row(
      mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.loading) ...[
          SizedBox(
            width: icon,
            height: icon,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: fg),
          ),
          const SizedBox(width: 8),
        ] else if (widget.leading != null) ...[
          Icon(widget.leading, size: icon, color: fg),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: AppText.body(size: fs, weight: FontWeight.w700, color: fg),
          ),
        ),
        if (widget.trailing != null && !widget.loading) ...[
          const SizedBox(width: 8),
          Icon(widget.trailing, size: icon, color: fg),
        ],
      ],
    );

    return Semantics(
      button: true,
      enabled: !disabled,
      label: widget.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: disabled ? null : (_) => setState(() => _down = true),
        onTapCancel: () => setState(() => _down = false),
        onTapUp: (_) => setState(() => _down = false),
        onTap: disabled ? null : widget.onPressed,
        child: AnimatedScale(
          scale: _down ? 0.97 : 1,
          duration: const Duration(milliseconds: 120),
          child: Opacity(
            opacity: widget.onPressed == null && !widget.loading ? 0.6 : 1,
            child: Container(
              constraints: BoxConstraints(minHeight: h),
              padding: EdgeInsets.symmetric(horizontal: padX, vertical: 10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(999),
                border: widget.outline
                    ? Border.all(
                        color: widget.color ?? AppColors.green,
                        width: 2,
                      )
                    : null,
                boxShadow: widget.outline || widget.onPressed == null
                    ? null
                    : AppShadows.glow,
              ),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

/// Home-page "3D" CTA (green gradient with a solid lower edge) — used by the hero and gallery.
class Chunky3DButton extends StatefulWidget {
  const Chunky3DButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.white = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool white;
  final bool expand;

  @override
  State<Chunky3DButton> createState() => _Chunky3DButtonState();
}

class _Chunky3DButtonState extends State<Chunky3DButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final edge = widget.white
        ? const Color(0xFFF3D56B)
        : const Color(0xFF0A6B22);
    final shadowTint = widget.white
        ? const Color(0x14000000)
        : const Color(0x660F8A2F);
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        transform: Matrix4.translationValues(0, _down ? 4 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: widget.white ? Colors.white : null,
          gradient: widget.white
              ? null
              : const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF19A23E), AppColors.homeGreen],
                ),
          border: widget.white
              ? Border.all(color: const Color(0xFFFFE9A0), width: 2)
              : null,
          boxShadow: [
            BoxShadow(color: edge, offset: Offset(0, _down ? 2 : 6)),
            BoxShadow(
              color: shadowTint,
              blurRadius: 26,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: widget.expand ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                widget.label,
                style: AppText.body(
                  size: 18,
                  weight: FontWeight.w700,
                  color: widget.white ? AppColors.homeDark : Colors.white,
                ),
              ),
            ),
            if (widget.icon != null) ...[
              const SizedBox(width: 12),
              Icon(
                widget.icon,
                size: 20,
                color: widget.white ? AppColors.homeDark : Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
