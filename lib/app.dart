import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'data/services/api_client.dart';
import 'data/services/api_service.dart';
import 'data/services/draft_storage.dart';
import 'data/services/request_history_storage.dart';
import 'providers/contact_provider.dart';
import 'providers/franchise_provider.dart';
import 'providers/request_form_provider.dart';
import 'providers/request_history_provider.dart';
import 'providers/request_status_provider.dart';
import 'providers/rider_application_provider.dart';
import 'providers/rider_status_provider.dart';
import 'screens/about_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/gallery_detail_screen.dart';
import 'screens/home_screen.dart';
import 'screens/franchise/become_franchise_screen.dart';
import 'screens/franchise/franchise_register_screen.dart';
import 'screens/franchise/franchise_status_screen.dart';
import 'screens/how_it_works_screen.dart';
import 'screens/legal/privacy_screen.dart';
import 'screens/legal/prohibited_items_screen.dart';
import 'screens/legal/terms_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/request_screen.dart';
import 'screens/request_history_screen.dart';
import 'screens/request_status_screen.dart';
import 'screens/rider/become_rider_screen.dart';
import 'screens/rider/rider_register_screen.dart';
import 'screens/rider/rider_status_screen.dart';
import 'widgets/layout/navigation.dart';

class CityDeliveryApp extends StatelessWidget {
  const CityDeliveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiClient>(
          create: (_) => ApiClient(),
          dispose: (_, c) => c.dispose(),
        ),
        ProxyProvider<ApiClient, ApiService>(
          update: (_, c, __) => ApiService(c),
        ),
        Provider<DraftStorage>(create: (_) => DraftStorage()),
        Provider<RequestHistoryStorage>(create: (_) => RequestHistoryStorage()),
        ChangeNotifierProvider(
          create: (c) => RequestFormProvider(
            c.read<ApiService>(),
            c.read<DraftStorage>(),
            c.read<RequestHistoryStorage>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (c) => RequestStatusProvider(c.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (c) => RequestHistoryProvider(
            c.read<ApiService>(),
            c.read<RequestHistoryStorage>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (c) => ContactProvider(c.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (c) => RiderApplicationProvider(
            c.read<ApiService>(),
            c.read<DraftStorage>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (c) => RiderStatusProvider(c.read<ApiService>()),
        ),
        ChangeNotifierProvider(
          create: (c) => FranchiseProvider(
            c.read<ApiService>(),
            c.read<DraftStorage>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: Site.name,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: Routes.home,
        onGenerateRoute: _onGenerateRoute,
        onUnknownRoute: (s) => _fade(const NotFoundScreen(), s),
      ),
    );
  }

  static Route<dynamic> _fade(Widget page, RouteSettings s) =>
      PageRouteBuilder<void>(
        settings: s,
        pageBuilder: (_, __, ___) => page,
        transitionDuration: const Duration(milliseconds: 260),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.02),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          ),
        ),
      );

  static Route<dynamic> _onGenerateRoute(RouteSettings s) {
    final name = s.name ?? '/';
    if (name.startsWith('/gallery/')) {
      return _fade(
        GalleryDetailScreen(slug: name.substring('/gallery/'.length)),
        s,
      );
    }
    final Widget page = switch (name) {
      Routes.home => const HomeScreen(),
      Routes.request => const RequestScreen(),
      Routes.requestStatus => const RequestStatusScreen(),
      Routes.requestHistory => const RequestHistoryScreen(),
      Routes.howItWorks => const HowItWorksScreen(),
      Routes.about => const AboutScreen(),
      Routes.contact => const ContactScreen(),
      Routes.privacy => const PrivacyScreen(),
      Routes.terms => const TermsScreen(),
      Routes.prohibited => const ProhibitedItemsScreen(),
      Routes.becomeRider => const BecomeRiderScreen(),
      Routes.riderRegister => const RiderRegisterScreen(),
      Routes.riderStatus => const RiderStatusScreen(),
      Routes.becomeFranchise => const BecomeFranchiseScreen(),
      Routes.franchiseRegister => const FranchiseRegisterScreen(),
      Routes.franchiseStatus => const FranchiseStatusScreen(),
      _ => const NotFoundScreen(),
    };
    return _fade(page, s);
  }
}
