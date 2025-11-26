import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jollypodcast/blocs/bloc_observer/observer.dart';
import 'package:jollypodcast/blocs/episode/episode_bloc.dart';
import 'package:jollypodcast/blocs/login/login_cubit.dart';
import 'package:jollypodcast/repo/auth_repository.dart';
import 'package:jollypodcast/repo/episode_repository.dart';

import 'package:jollypodcast/services/dio.dart';
import 'package:jollypodcast/router.dart';
import 'package:jollypodcast/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    Bloc.observer = CustomBlocObserver();
  }

  // Initialize Dio Client
  final DioClient dioClient = DioClient();

  // Create repositories
  final AuthRepository authRepository = AuthRepository(dioClient: dioClient);
  final EpisodeRepository episodeRepository = EpisodeRepository(
    dioClient: dioClient,
  );
  await authRepository.init();

  AppRouter.init(authRepository);

  runApp(JollyPodcastApp(authRepository: authRepository , episodeRepository: episodeRepository));
}

class JollyPodcastApp extends StatelessWidget {
  final AuthRepository _authRepository;
  final EpisodeRepository _episodeRepository;

  const JollyPodcastApp({super.key, required AuthRepository authRepository, required EpisodeRepository episodeRepository})
    : _authRepository = authRepository,
      _episodeRepository = episodeRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => _authRepository),
        RepositoryProvider<EpisodeRepository>(
          create: (_) => _episodeRepository,
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<LoginCubit>(create: (_) => LoginCubit(authRepository: _authRepository)),
          BlocProvider<EpisodeBloc>(
            create: (_) => EpisodeBloc(episodeRepository: _episodeRepository),
          ),
        ],
        child: MaterialApp.router(
          title: "Jolly Podcast",
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
