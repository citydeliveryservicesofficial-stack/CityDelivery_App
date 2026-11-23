import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// Scroll-to-first-error support: one GlobalKey + FocusNode per field id.
class FieldKeys {
  final Map<String, GlobalKey> _keys = {};
  final Map<String, FocusNode> _nodes = {};

  GlobalKey key(String id) => _keys.putIfAbsent(id, GlobalKey.new);
  FocusNode node(String id) => _nodes.putIfAbsent(id, FocusNode.new);

  Future<void> scrollTo(String id) async {
    final ctx = _keys[id]?.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      alignment: 0.25,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
    final n = _nodes[id];
    if (n != null && n.context != null) n.requestFocus();
  }

  void dispose() {
    for (final n in _nodes.values) {
      n.dispose();
    }
  }
}

/// `Field` component: label (+ required star / "(optional)"), control, hint or inline error.
class LabeledField extends StatelessWidget {
  const LabeledField({
    super.key,
    required this.label,
    required this.child,
    this.required = false,
    this.optional = false,
    this.hint,
    this.error,
  });

  final String label;
  final Widget child;
  final bool required;
  final bool optional;
  final String? hint;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text.rich(
            TextSpan(
              style: AppText.body(size: 14, weight: FontWeight.w700),
              children: [
                TextSpan(text: label),
                if (required)
                  TextSpan(
                    text: ' *',
                    style: AppText.body(
                      size: 14,
                      weight: FontWeight.w700,
                      color: AppColors.red500,
                    ),
                  ),
                if (optional)
                  TextSpan(
                    text: '  (optional)',
                    style: AppText.body(
                      size: 12,
                      weight: FontWeight.w600,
                      color: AppColors.muted,
                    ),
                  ),
              ],
            ),
          ),
        ),
        child,
        if (hint != null && error == null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              hint!,
              style: AppText.body(size: 12, color: AppColors.muted),
            ),
          ),
        if (error != null) FieldError(error!),
      ],
    );
  }
}

class FieldError extends StatelessWidget {
  const FieldError(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Semantics(
        liveRegion: true,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                LucideIcons.alertCircle,
                size: 15,
                color: AppColors.red600,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                message,
                style: AppText.body(
                  size: 14,
                  weight: FontWeight.w600,
                  color: AppColors.red600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const _fieldShadow = [
  BoxShadow(color: Color(0x0F111713), offset: Offset(0, 1)),
  BoxShadow(
    color: Color(0x40111713),
    blurRadius: 24,
    spreadRadius: -14,
    offset: Offset(0, 8),
  ),
];

OutlineInputBorder _border(Color c, double w) => OutlineInputBorder(
  borderRadius: BorderRadius.circular(16),
  borderSide: BorderSide(color: c, width: w),
);

/// `.field` — white rounded input, green border on focus, red on error.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.hint,
    this.hasError = false,
    this.keyboardType,
    this.textInputAction,
    this.maxLength,
    this.minLines = 1,
    this.maxLines = 1,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.inputFormatters,
    this.suffixIcon,
    this.monospace = false,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? hint;
  final bool hasError;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLength;
  final int minLines;
  final int maxLines;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final bool monospace;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final fill = hasError
        ? Color.alphaBlend(AppColors.red50.withValues(alpha: 0.4), Colors.white)
        : Colors.white;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _fieldShadow,
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType:
            keyboardType ??
            (maxLines > 1 ? TextInputType.multiline : TextInputType.text),
        textInputAction:
            textInputAction ??
            (maxLines > 1 ? TextInputAction.newline : TextInputAction.next),
        maxLength: maxLength,
        minLines: minLines,
        maxLines: maxLines,
        readOnly: readOnly,
        onTap: onTap,
        autofillHints: autofillHints,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        style: monospace
            ? AppText.body(size: 15).copyWith(
                fontFamily: 'monospace',
                fontFamilyFallback: const ['Courier'],
              )
            : AppText.body(size: 15),
        cursorColor: AppColors.green,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppText.body(
            size: 15,
            color: AppColors.muted.withValues(alpha: 0.7),
          ),
          counterText: '',
          filled: true,
          fillColor: fill,
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          enabledBorder: _border(
            hasError ? AppColors.red500 : const Color(0x0D000000),
            hasError ? 2 : 1,
          ),
          focusedBorder: _border(
            hasError ? AppColors.red500 : AppColors.green,
            2,
          ),
          border: _border(const Color(0x0D000000), 1),
        ),
      ),
    );
  }
}

/// Custom listbox -> native bottom sheet on mobile (CustomSelect.jsx).
class SelectField extends StatelessWidget {
  const SelectField({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.placeholder = 'Select…',
    this.hasError = false,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final String placeholder;
  final bool hasError;

  Future<void> _open(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(ctx).size.height * 0.7,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              for (final opt in options)
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => Navigator.of(ctx).pop(opt),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 52),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: opt == value
                          ? AppColors.yellow.withValues(alpha: 0.4)
                          : null,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            opt,
                            style: AppText.body(
                              size: 15,
                              weight: FontWeight.w600,
                              color: opt == value
                                  ? AppColors.green
                                  : AppColors.text,
                            ),
                          ),
                        ),
                        if (opt == value)
                          const Icon(
                            LucideIcons.check,
                            size: 16,
                            color: AppColors.green,
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
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final fill = hasError
        ? Color.alphaBlend(AppColors.red50.withValues(alpha: 0.4), Colors.white)
        : Colors.white;
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: () => _open(context),
        child: Container(
          constraints: const BoxConstraints(minHeight: 52),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _fieldShadow,
            border: Border.all(
              color: hasError ? AppColors.red500 : const Color(0x0D000000),
              width: hasError ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value.isEmpty ? placeholder : value,
                  style: AppText.body(
                    size: 15,
                    color: value.isEmpty
                        ? AppColors.muted.withValues(alpha: 0.7)
                        : AppColors.text,
                  ),
                ),
              ),
              const Icon(
                LucideIcons.chevronDown,
                size: 18,
                color: AppColors.muted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pill / rounded toggle used for yes-no choices and weekdays in the rider form.
class ChoicePill extends StatelessWidget {
  const ChoicePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.round = false,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool round;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        constraints: const BoxConstraints(minHeight: 44),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.green : Colors.white,
          borderRadius: BorderRadius.circular(round ? 999 : 12),
          border: Border.all(
            color: selected ? AppColors.green : const Color(0x1A000000),
          ),
        ),
        child: Text(
          label,
          style: AppText.body(
            size: 14,
            weight: FontWeight.w700,
            color: selected ? Colors.white : AppColors.dark,
          ),
        ),
      ),
    );
  }
}

/// Rider-form checkbox row (`rounded-2xl bg-brand-light/70 p-4`).
class CheckTile extends StatelessWidget {
  const CheckTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.error,
  });
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(!value),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.light.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: error != null ? AppColors.red500 : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 22,
                  height: 22,
                  child: Checkbox(
                    value: value,
                    onChanged: (v) => onChanged(v ?? false),
                    activeColor: AppColors.green,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: AppText.body(
                      size: 14,
                      weight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (error != null) FieldError(error!),
      ],
    );
  }
}

/// Red banner used for form-level errors.
class ErrorBanner extends StatelessWidget {
  const ErrorBanner(this.message, {super.key});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.red50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFFECACA)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 1),
              child: Icon(
                LucideIcons.alertTriangle,
                size: 20,
                color: AppColors.red700,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppText.body(
                  size: 14,
                  weight: FontWeight.w600,
                  color: AppColors.red700,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dashed rounded border for the upload drop zones.
class DashedBorderPainter extends CustomPainter {
  const DashedBorderPainter({
    required this.color,
    this.radius = 16,
    this.dash = 7,
    this.gap = 5,
    this.width = 2,
  });
  final Color color;
  final double radius, dash, gap, width;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter old) => old.color != color;
}
