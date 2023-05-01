// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:animations/animations.dart';
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import 'package:chat_gpt_app/presentation/screens/home/home.dart';
import 'package:chat_gpt_app/presentation/screens/splash/splash.dart';

final appRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) {
        return CustomTransitionPage<void>(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionDuration: const Duration(milliseconds: 500),
          fullscreenDialog: true,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              curve: Curves.fastOutSlowIn,
              parent: animation,
              reverseCurve: Curves.fastOutSlowIn,
            );

            return SizeTransition(
              sizeFactor: curvedAnimation,
              child: FadeScaleTransition(
                animation: curvedAnimation,
                child: Material(
                  clipBehavior: Clip.antiAlias,
                  animationDuration: Duration.zero,
                  elevation: Tween<double>(
                    begin: 10,
                    end: 2,
                  ).evaluate(curvedAnimation),
                  shape: ShapeBorderTween(
                    begin: const CircleBorder(),
                    end: const RoundedRectangleBorder(),
                  ).evaluate(curvedAnimation),
                  child: child,
                ),
              ),
            );
          },
        );
      },
    ),
  ],
);
