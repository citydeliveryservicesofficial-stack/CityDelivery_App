import 'package:flutter/material.dart';
import 'package:lucide_icons_lite/lucide_icons_lite.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/helpers.dart';
import '../../data/models/api_models.dart';
import '../../providers/request_history_provider.dart';
import '../../providers/request_status_provider.dart';
import '../../screens/request_status_screen.dart';
import '../../widgets/common/brand_button.dart';
import '../../widgets/common/cards.dart';
import '../../widgets/common/reveal.dart';
import '../../widgets/layout/navigation.dart';
import '../../widgets/layout/site_page.dart';

class RequestHistoryScreen extends StatefulWidget {
  const RequestHistoryScreen({super.key});

  @override
  State<RequestHistoryScreen> createState() => _RequestHistoryScreenState();
}

class _RequestHistoryScreenState extends State<RequestHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RequestHistoryProvider>().load();
  }

  Future<void> _confirmRemove(String requestId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: AppShadows.lift,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.red50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.red100),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    size: 26,
                    color: AppColors.red600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Remove this request?',
                  style: AppText.display(size: 24, color: AppColors.dark),
                ),
                const SizedBox(height: 12),
                Text(
                  'This removes the saved shortcut from this phone. The original request and its live status are not deleted.',
                  style: AppText.body(size: 14, height: 1.6, color: AppColors.muted),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.light,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0x0D000000)),
                  ),
                  child: Text(
                    requestId,
                    style: AppText.body(
                      size: 14,
                      weight: FontWeight.w800,
                      color: AppColors.dark,
                    ).copyWith(fontFamily: 'monospace'),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: BrandButton(
                        label: 'Cancel',
                        expand: true,
                        outline: true,
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: BrandButton(
                        label: 'Remove',
                        expand: true,
                        color: AppColors.red600,
                        foreground: Colors.white,
                        leading: LucideIcons.trash2,
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (!mounted || confirmed != true) return;
    await context.read<RequestHistoryProvider>().forget(requestId);
  }

  Future<void> _confirmClear() async {
    final count = context.read<RequestHistoryProvider>().entries.length;
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: AppShadows.lift,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.red50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.red100),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    size: 26,
                    color: AppColors.red600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Clear all saved requests?',
                  style: AppText.display(size: 24, color: AppColors.dark),
                ),
                const SizedBox(height: 12),
                Text(
                  'This removes all $count saved Request IDs from this phone. Your original requests and their live statuses are not deleted.',
                  style: AppText.body(size: 14, height: 1.6, color: AppColors.muted),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: BrandButton(
                        label: 'Cancel',
                        expand: true,
                        outline: true,
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: BrandButton(
                        label: 'Clear all',
                        expand: true,
                        color: AppColors.red600,
                        foreground: Colors.white,
                        leading: LucideIcons.trash2,
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (!mounted || confirmed != true) return;
    await context.read<RequestHistoryProvider>().clear();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<RequestHistoryProvider>();
    final activeCount = p.entries.where((entry) {
      final status = p.statuses[entry.requestId]?.status;
      return status != null && status != 'Completed' && status != 'Cancelled';
    }).length;
    final completedCount = p.entries.where((entry) => p.statuses[entry.requestId]?.status == 'Completed').length;

    return SitePage(
      route: Routes.requestHistory,
      children: [
        _HistoryHero(
          saved: p.entries.length,
          active: activeCount,
          completed: completedCount,
          syncing: p.busy,
        ),
        ContainerX(
          maxWidth: 760,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              children: [
                const SizedBox(height: 20),
                WhiteCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const IconBadge(
                            LucideIcons.clock3,
                            size: 48,
                            color: AppColors.yellow,
                            radius: 16,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Live tracking dashboard',
                                  style: AppText.display(size: 16, color: AppColors.dark),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Statuses refresh from your saved Request IDs.',
                                  style: AppText.body(size: 12, color: AppColors.muted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          BrandButton(
                            label: p.busy ? 'Refreshing…' : 'Refresh status',
                            size: BrandButtonSize.sm,
                            loading: p.busy,
                            leading: LucideIcons.refreshCw,
                            onPressed: p.busy ? null : p.load,
                          ),
                          if (p.entries.isNotEmpty)
                            BrandButton(
                              label: 'Clear',
                              size: BrandButtonSize.sm,
                              outline: true,
                              leading: LucideIcons.trash2,
                              onPressed: _confirmClear,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (p.entries.isEmpty && !p.busy) ...[
                  const SizedBox(height: 24),
                  WhiteCard(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.yellow, AppColors.yellowSoft],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: AppShadows.glow,
                          ),
                          child: const Icon(
                            LucideIcons.clipboardList,
                            size: 34,
                            color: AppColors.dark,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text('No saved requests yet', style: AppText.display(size: 25, color: AppColors.dark)),
                        const SizedBox(height: 12),
                        Text(
                          'After you submit a request, it appears here with a live status. It stays private to this device.',
                          textAlign: TextAlign.center,
                          style: AppText.body(size: 15, height: 1.6, color: AppColors.muted),
                        ),
                        const SizedBox(height: 24),
                        BrandButton(
                          label: 'Submit a request',
                          expand: true,
                          trailing: Icons.north_east,
                          onPressed: () => AppNav.goTop(context, Routes.request),
                        ),
                        const SizedBox(height: 12),
                        BrandButton(
                          label: 'Check with Request ID',
                          outline: true,
                          expand: true,
                          onPressed: () => AppNav.push(context, Routes.requestStatus),
                        ),
                      ],
                    ),
                  ),
                ],
                for (final item in p.entries) ...[
                  const SizedBox(height: 20),
                  Reveal(
                    dy: 18,
                    child: _HistoryCard(
                      requestId: item.requestId,
                      result: p.statuses[item.requestId],
                      error: p.errors[item.requestId] ?? '',
                      onRemove: () => _confirmRemove(item.requestId),
                      onView: () {
                        context
                            .read<RequestStatusProvider>()
                            .prefill(item.requestId);
                        AppNav.push(context, Routes.requestStatus);
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                _PrivacyCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryHero extends StatelessWidget {
  const _HistoryHero({
    required this.saved,
    required this.active,
    required this.completed,
    required this.syncing,
  });

  final int saved;
  final int active;
  final int completed;
  final bool syncing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 140, 20, 68),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.dark, Color(0xFF173725), AppColors.green],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -80,
            top: 40,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                color: AppColors.green.withValues(alpha: 0.28),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            right: -60,
            bottom: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: AppColors.yellow.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
            ),
          ),
          ContainerX(
            maxWidth: 760,
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, size: 14, color: AppColors.yellow),
                      const SizedBox(width: 8),
                      Text(
                        'MY REQUESTS',
                        style: AppText.body(
                          size: 11,
                          weight: FontWeight.w800,
                          letterSpacing: 2.2,
                          color: AppColors.yellow,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Your request history',
                  style: AppText.display(size: 42, color: Colors.white, height: 1.05),
                ),
                const SizedBox(height: 14),
                Text(
                  'A private, live tracking dashboard for requests saved on this device — no login, no noise.',
                  style: AppText.body(size: 16, height: 1.6, color: Colors.white.withValues(alpha: 0.72)),
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _HeroStat(
                      icon: LucideIcons.clipboardList,
                      label: 'Saved',
                      value: '$saved',
                      color: AppColors.yellow,
                    ),
                    _HeroStat(
                      icon: LucideIcons.clock3,
                      label: 'In progress',
                      value: '$active',
                      color: Colors.white,
                    ),
                    _HeroStat(
                      icon: LucideIcons.checkCircle2,
                      label: 'Completed',
                      value: '$completed',
                      color: const Color(0xFF86EFAC),
                    ),
                    _HeroStat(
                      icon: Icons.auto_awesome,
                      label: 'Live sync',
                      value: syncing ? 'Syncing' : 'Ready',
                      color: AppColors.yellowSoft,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 116),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppText.display(size: 17, color: Colors.white),
              ),
              const SizedBox(height: 2),
              Text(
                label.toUpperCase(),
                style: AppText.body(
                  size: 10,
                  weight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: Colors.white.withValues(alpha: 0.55),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.requestId,
    required this.result,
    required this.error,
    required this.onRemove,
    required this.onView,
  });

  final String requestId;
  final RequestStatusResult? result;
  final String error;
  final VoidCallback onRemove;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final label = result?.status ?? (error.isEmpty ? 'Checking…' : 'Unavailable');
    final (bg, fg) = requestStatusColors(label);
    return WhiteCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.yellow, AppColors.yellowSoft, AppColors.green],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const IconBadge(
                        LucideIcons.clipboardList,
                        size: 48,
                        color: AppColors.yellowSoft,
                        radius: 16,
                        shadow: false,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'REQUEST ID',
                              style: AppText.body(
                                size: 11,
                                weight: FontWeight.w800,
                                letterSpacing: 2,
                                color: AppColors.muted,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              requestId,
                              style: AppText.body(
                                size: 17,
                                weight: FontWeight.w800,
                                color: AppColors.dark,
                              ).copyWith(fontFamily: 'monospace'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: fg.withValues(alpha: 0.18)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          label,
                          style: AppText.body(size: 14, weight: FontWeight.w800, color: fg),
                        ),
                      ],
                    ),
                  ),
                  if (result != null && result!.nextSteps.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.yellowSoft.withValues(alpha: 0.28),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.yellow.withValues(alpha: 0.35)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.auto_awesome, size: 18, color: AppColors.green),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              result!.nextSteps,
                              style: AppText.body(size: 14, height: 1.6, color: AppColors.dark),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (error.isNotEmpty) ...[
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.red50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.red100),
                      ),
                      child: Text(
                        error,
                        style: AppText.body(size: 13, weight: FontWeight.w600, color: AppColors.red700),
                      ),
                    ),
                  ],
                  if (result != null) ...[
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoTile(
                            icon: LucideIcons.clock3,
                            label: 'Submitted',
                            value: formatDateTime(result!.createdAt),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoTile(
                            icon: LucideIcons.refreshCw,
                            label: 'Updated',
                            value: formatDateTime(result!.updatedAt),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: BrandButton(
                          label: 'View status',
                          expand: true,
                          trailing: Icons.north_east,
                          onPressed: onView,
                        ),
                      ),
                      const SizedBox(width: 10),
                      _RemoveButton(onPressed: onRemove),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Remove from this device',
      child: Semantics(
        button: true,
        label: 'Remove request',
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            constraints: const BoxConstraints(minHeight: 40),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.red50,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.red100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.trash2, size: 16, color: AppColors.red600),
                const SizedBox(width: 8),
                Text(
                  'Remove',
                  style: AppText.body(size: 13, weight: FontWeight.w700, color: AppColors.red700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.light.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x0D000000)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.muted),
              const SizedBox(width: 6),
              Text(
                label.toUpperCase(),
                style: AppText.body(
                  size: 10,
                  weight: FontWeight.w800,
                  letterSpacing: 1.4,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppText.body(size: 13, weight: FontWeight.w700, color: AppColors.dark),
          ),
        ],
      ),
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.dark, Color(0xFF173725)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              top: -60,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.lock_outline, size: 20, color: AppColors.yellow),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Private to this device',
                      style: AppText.display(size: 17, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'This list is stored only on this phone. It is not an account and will not appear on another device. Uninstalling or clearing app data removes it. Statuses are fetched live using the saved Request IDs.',
                  style: AppText.body(size: 14, height: 1.6, color: Colors.white.withValues(alpha: 0.68)),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'NO LOGIN',
                    style: AppText.body(
                      size: 10,
                      weight: FontWeight.w800,
                      letterSpacing: 1.6,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
