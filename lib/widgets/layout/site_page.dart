import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'navigation.dart';
import 'site_footer.dart';
import 'site_navbar.dart';
import 'whatsapp_float.dart';

/// Equivalent of `MainLayout`: floating navbar + scrolling body + footer + WhatsApp button.
class SitePage extends StatefulWidget {
  const SitePage({
    super.key,
    required this.route,
    required this.children,
    this.dismissKeyboardOnDrag = true,
    this.controller,
  });

  final String route;
  final List<Widget> children;
  final bool dismissKeyboardOnDrag;
  final ScrollController? controller;

  @override
  State<SitePage> createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> {
  late final ScrollController _controller =
      widget.controller ?? ScrollController();
  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final s = _controller.hasClients && _controller.offset > 12;
      if (s != _scrolled) setState(() => _scrolled = s);
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: AppColors.light,
      body: Stack(
        children: [
          ListView(
            controller: _controller,
            padding: EdgeInsets.zero,
            keyboardDismissBehavior: widget.dismissKeyboardOnDrag
                ? ScrollViewKeyboardDismissBehavior.onDrag
                : ScrollViewKeyboardDismissBehavior.manual,
            children: [
              ...widget.children,
              SiteFooter(route: widget.route),
              const SiteFooterBar(),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SiteNavbar(route: widget.route, scrolled: _scrolled),
          ),
          Positioned(
            right: 12,
            bottom: 12 + bottom,
            child: const WhatsAppFloat(),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNav(route: widget.route),
    );
  }
}
