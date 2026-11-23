import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// `rounded-4xl bg-white shadow-soft ring-1 ring-black/5`
class WhiteCard extends StatelessWidget {
  const WhiteCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.radius = 32,
    this.color,
  });
  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: AppShadows.soft,
        border: Border.all(color: const Color(0x0D000000)),
      ),
      child: child,
    );
  }
}

/// Yellow rounded icon tile.
class IconBadge extends StatelessWidget {
  const IconBadge(
    this.icon, {
    super.key,
    this.size = 56,
    this.color = AppColors.yellow,
    this.iconColor = AppColors.dark,
    this.radius = 16,
    this.shadow = true,
  });
  final IconData icon;
  final double size;
  final Color color;
  final Color iconColor;
  final double radius;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow ? AppShadows.soft : null,
      ),
      child: Icon(icon, size: size * 0.46, color: iconColor),
    );
  }
}

/// Max-width centred page column with the website's `container-x` side padding.
class ContainerX extends StatelessWidget {
  const ContainerX({
    super.key,
    required this.child,
    this.maxWidth = 1100,
    this.padding = const EdgeInsets.symmetric(horizontal: 20),
  });
  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
