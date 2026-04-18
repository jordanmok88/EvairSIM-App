import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../domain/entities/order.dart';
import '../../domain/entities/package.dart';
import '../../domain/entities/payment_session.dart';
import '../../presentation/pages/auth/forgot_password_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/register_page.dart';
import '../../presentation/pages/checkout/checkout_page.dart';
import '../../presentation/pages/checkout/order_confirmation_page.dart';
import '../../presentation/pages/profile/contact_us_page.dart';
import '../../presentation/pages/profile/inbox_page.dart';
import '../../presentation/pages/profile/live_chat_page.dart';
import '../../presentation/pages/profile/orders_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../presentation/pages/shell/root_shell.dart';
import '../../presentation/pages/shop/shop_page.dart';
import '../../presentation/pages/sims/connect_esim_page.dart';
import '../../presentation/pages/sims/my_sims_page.dart';
import '../../presentation/pages/sims/physical_sim_page.dart';
import '../../presentation/pages/sims/sim_detail_page.dart';
import '../../presentation/pages/sims/top_up_page.dart';
import '../../presentation/pages/welcome/welcome_page.dart';
import '../../presentation/providers/auth_providers.dart';
import 'route_names.dart';

final _rootNavKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shopNavKey = GlobalKey<NavigatorState>(debugLabel: 'shop');
final _simsNavKey = GlobalKey<NavigatorState>(debugLabel: 'sims');
final _profileNavKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.welcome,
    navigatorKey: _rootNavKey,
    debugLogDiagnostics: false,
    refreshListenable: _GoRouterRefreshStream(
      ref.watch(authControllerProvider.notifier).stream,
    ),
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final loc = state.matchedLocation;
      final atAuthScreen = loc == RouteNames.login ||
          loc == RouteNames.register ||
          loc == RouteNames.forgotPassword ||
          loc == RouteNames.welcome;

      if (!auth.bootstrapped) return null;

      if (!auth.isAuthenticated && !atAuthScreen) return RouteNames.login;
      if (auth.isAuthenticated &&
          (loc == RouteNames.welcome ||
              loc == RouteNames.login ||
              loc == RouteNames.register)) {
        return RouteNames.shop;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.welcome,
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // Checkout flow (full-screen, not part of shell)
      GoRoute(
        path: RouteNames.checkout,
        builder: (context, state) {
          final pkg = state.extra as Package?;
          if (pkg == null) return const _MissingExtra(label: 'package');
          return CheckoutPage(package: pkg);
        },
      ),
      GoRoute(
        path: RouteNames.orderConfirmation,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final order = extra?['order'] as AppOrder?;
          final session = extra?['session'] as PaymentSession?;
          final package = extra?['package'] as Package?;
          if (order == null || session == null || package == null) {
            return const _MissingExtra(label: 'order confirmation');
          }
          return OrderConfirmationPage(
            order: order,
            session: session,
            package: package,
          );
        },
      ),

      // Main tabbed shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            RootShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _shopNavKey,
            routes: [
              GoRoute(
                path: RouteNames.shop,
                builder: (context, state) => const ShopPage(),
                // NOTE: the `country/:code` child route (CountryPackagesPage)
                // was removed in the April 2026 pivot — we no longer sell
                // eSIMs by country from inside the app.
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _simsNavKey,
            routes: [
              GoRoute(
                path: RouteNames.mySims,
                builder: (context, state) => const MySimsPage(),
                routes: [
                  GoRoute(
                    path: ':iccid',
                    builder: (context, state) => SimDetailPage(
                      iccid: state.pathParameters['iccid'] ?? '',
                    ),
                    routes: [
                      GoRoute(
                        path: 'topup',
                        builder: (context, state) => TopUpPage(
                          iccid: state.pathParameters['iccid'] ?? '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _profileNavKey,
            routes: [
              GoRoute(
                path: RouteNames.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      // Root-level profile sub-routes so they overlay the shell.
      GoRoute(
        path: RouteNames.physicalSim,
        builder: (context, state) => const PhysicalSimPage(),
      ),
      GoRoute(
        path: RouteNames.connectEsim,
        builder: (context, state) => const ConnectEsimPage(),
      ),
      GoRoute(
        path: RouteNames.inbox,
        builder: (context, state) => const InboxPage(),
      ),
      GoRoute(
        path: RouteNames.contact,
        builder: (context, state) => const ContactUsPage(),
      ),
      GoRoute(
        path: RouteNames.liveChat,
        builder: (context, state) => const LiveChatPage(),
      ),
      GoRoute(
        path: RouteNames.orders,
        builder: (context, state) => const OrdersPage(),
      ),
    ],
  );
});

class _MissingExtra extends StatelessWidget {
  const _MissingExtra({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Missing $label — reopen from the previous screen.'),
      ),
    );
  }
}

/// Bridges a Riverpod state-notifier stream to Listenable for GoRouter.
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
