
import 'package:go_router/go_router.dart';

import '../models/monitor.dart';
import '../views/splash/splash_page.dart';
import '../views/home/home_page.dart';
import '../views/detalhes/detalhes_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/detalhes',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;

        return DetalhesPage(
          monitor: extra['monitor'] as Monitor,
          filtroOrigem: extra['filtroOrigem'] as String,
        );
      },
    ),
  ],
);
