import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:jollypodcast/constants.dart';
import 'package:jollypodcast/repo/auth_repository.dart';
import 'package:jollypodcast/ui/pages/home/categories_page.dart';
import 'package:jollypodcast/ui/pages/home/discover_page.dart';
import 'package:jollypodcast/ui/pages/home/home.dart';
import 'package:jollypodcast/ui/pages/home/library_page.dart';
import 'package:jollypodcast/ui/pages/home/podcast_player_screen.dart';
import 'package:jollypodcast/ui/pages/login.dart';
import 'package:jollypodcast/ui/pages/splash_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> _shellNavKey =
      GlobalKey<NavigatorState>();

  static late AuthRepository _auth;

  /// MUST be called in main.dart before using router
  static void init(AuthRepository auth) {
    _auth = auth;
  }

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: kSplashPath,

    routes: [
      GoRoute(
        path: kSplashPath,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: kLoginPath, builder: (context, state) => const LoginPage()),
      ShellRoute(
        navigatorKey: _shellNavKey,
        builder: (context, state, child) {
          return HomePage(child: child);
        },
        routes: [
          GoRoute(
            path: kHomePath,
            pageBuilder: (context, state) {
              return NoTransitionPage(
                child: const DiscoverPage(),
              );
            },
            routes: [
              GoRoute(
                path: kPodcastPlayerPath,
                builder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>;
                  return PodcastPlayerScreen(
                    episodeTitle: extra['episodeTitle'] as String,
                    episodeDescription: extra['episodeDescription'] as String,
                    imageUrl: extra['imageUrl'] as String,
                    audioUrl: extra['audioUrl'] as String,
                  );
                },
              ),
            ]
          ),
          GoRoute(
            path: kCategoryPath,
            builder: (context, state) => const CategoriesPage(),
          ),
          GoRoute(
            path: kLibraryPath,
            builder: (context, state) => const LibraryPage(),
          ),
        ],
      ),

    ],

    redirect: (context, state) async {
      final String path = state.uri.toString();
      final bool loggedIn = await _auth.isLoggedIn();

      if (path == kSplashPath) return null;

      if (!loggedIn && path != kLoginPath) {
        return kLoginPath;
      }

      if (loggedIn && path == kLoginPath) {
        return kHomePath; // your actual home path
      }

      return null;
    },
  );
}
