import 'package:go_router/go_router.dart';

import 'router_constants.dart';
import '../../src/presentation/view/auth/auth_screen.dart';
import '../../src/presentation/view/bottom_nav/bottom_nav_view.dart';
import '../../src/presentation/view/initializer/app_initializer.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouterConstants.initializerRoute,
  routes: [
    /// App initializer
    GoRoute(
      path: RouterConstants.initializerRoute,
      builder: (context, state) => const AppInitializer(),
    ),

    /// Auth
    GoRoute(
      path: RouterConstants.mainLoginRoute,
      builder: (context, state) => const AuthScreen(),
    ),

    /// Bottom navigation (Home)// i copied this from previous so things remained same some places
    GoRoute(
      path: RouterConstants.bottomNavRoute,
      builder: (context, state) {
        return MainHomeScreen();
      },
    ),
  ],
);
