import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:scanner/modules/home/domain/models/dtos/scanned_card_dto.dart';
import 'package:scanner/modules/home/presentation/contact_details/contact_details_page.dart';
import 'package:scanner/modules/home/presentation/contacts/contacts_page.dart';
import 'package:scanner/modules/home/presentation/scanner/scanner_page.dart';
import 'package:scanner/modules/home/presentation/splash/splash_page.dart';
import 'package:scanner/services/navigation/route_url.dart';

// private navigators
final _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');

// ignore: avoid_classes_with_only_static_members
/// Documentation for CustomRoute
class CustomRoutes {
  /// The code is creating an instance of the [GoRouter]
  ///  class and assigning it
  ///
  ///
  static final goRouter = GoRouter(
    initialLocation: '/splash',
    navigatorKey: _rootNavigatorKey,
    observers: kDebugMode ? [
      // The PosthogObserver to record screen views
      PosthogObserver(),
    ] : [],
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(
        path: '/scanner',
        name: PageUrl.scanner,
        builder: (context, state) => const ScannerPage(),
      ),
      GoRoute(
        path: '/splash',
        name: PageUrl.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/home',
        name: PageUrl.home,
        builder: (context, state) => ContactsPage(
          cards: state.extra as List<ScannedCardDto>?,
        ),
        routes: [
          GoRoute(
            path: 'details',
            name: PageUrl.details,
            builder: (context, state) {
              print(state.uri.queryParameters['id']);
              return ContactDetailsPage(
                id: int.parse(state.uri.queryParameters['id'] ?? '1'),
              );
            },
          ),
        ],
      ),
    ],
  );
}
