import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jollypodcast/blocs/episode/episode_event.dart';
import 'package:jollypodcast/blocs/episode/episode_state.dart';
import 'package:jollypodcast/models/episode_model.dart';
import 'package:jollypodcast/repo/episode_repository.dart';

class EpisodeBloc extends Bloc<EpisodeEvent, EpisodeState> {
  EpisodeBloc({required EpisodeRepository episodeRepository})
      : _episodeRepository = episodeRepository,
        super(const EpisodeInitial()) {
    on<FetchLatestEpisodes>(_onFetchLatestEpisodes);
    on<RefreshEpisodes>(_onRefreshEpisodes);
    on<FetchTrendingEpisodes>(_onFetchTrendingEpisodes);
    on<FetchEpisodeById>(_onFetchEpisodeById);
    on<FetchEpisodesByCategory>(_onFetchEpisodesByCategory);
  }

  final EpisodeRepository _episodeRepository;

  Future<void> _onFetchLatestEpisodes(
    FetchLatestEpisodes event,
    Emitter<EpisodeState> emit,
  ) async {
    try {
      // If we're loading more, show loading more state
      if (state is EpisodeLoaded && event.page > 1) {
        final currentState = state as EpisodeLoaded;
        emit(EpisodeLoadingMore(currentEpisodes: currentState.episodes));
      } else {
        emit(const EpisodeLoading());
      }

      final response = await _episodeRepository.fetchLatestEpisodes(
        page: event.page,
      );

      final episodes = response.data.episodes;
      final hasMore = response.data.currentPage < response.data.lastPage;

      // If loading more, append to existing episodes
      if (state is EpisodeLoadingMore) {
        final currentState = state as EpisodeLoadingMore;
        emit(EpisodeLoaded(
          episodes: [...currentState.currentEpisodes, ...episodes],
          currentPage: response.data.currentPage,
          lastPage: response.data.lastPage,
          total: response.data.total,
          hasMore: hasMore,
        ));
      } else {
        emit(EpisodeLoaded(
          episodes: episodes,
          currentPage: response.data.currentPage,
          lastPage: response.data.lastPage,
          total: response.data.total,
          hasMore: hasMore,
        ));
      }
    } catch (e) {
      emit(EpisodeError(message: e.toString()));
    }
  }

  Future<void> _onRefreshEpisodes(
    RefreshEpisodes event,
    Emitter<EpisodeState> emit,
  ) async {
    try {
      List<Episode> currentEpisodes = [];
      if (state is EpisodeLoaded) {
        currentEpisodes = (state as EpisodeLoaded).episodes;
      }

      emit(EpisodeRefreshing(currentEpisodes: currentEpisodes));

      final response = await _episodeRepository.fetchLatestEpisodes(page: 1);

      final episodes = response.data.episodes;
      final hasMore = response.data.currentPage < response.data.lastPage;

      emit(EpisodeLoaded(
        episodes: episodes,
        currentPage: response.data.currentPage,
        lastPage: response.data.lastPage,
        total: response.data.total,
        hasMore: hasMore,
      ));
    } catch (e) {
      emit(EpisodeError(message: e.toString()));
    }
  }

  Future<void> _onFetchTrendingEpisodes(
    FetchTrendingEpisodes event,
    Emitter<EpisodeState> emit,
  ) async {
    try {
      emit(const EpisodeLoading());

      final response = await _episodeRepository.fetchTrendingEpisodes(
        page: event.page,
      );

      final episodes = response.data.episodes;
      final hasMore = response.data.currentPage < response.data.lastPage;

      emit(EpisodeLoaded(
        episodes: episodes,
        currentPage: response.data.currentPage,
        lastPage: response.data.lastPage,
        total: response.data.total,
        hasMore: hasMore,
      ));
    } catch (e) {
      emit(EpisodeError(message: e.toString()));
    }
  }

  Future<void> _onFetchEpisodeById(
    FetchEpisodeById event,
    Emitter<EpisodeState> emit,
  ) async {
    try {
      emit(const EpisodeLoading());

      final episode = await _episodeRepository.fetchEpisodeById(
        event.episodeId,
      );

      emit(SingleEpisodeLoaded(episode: episode));
    } catch (e) {
      emit(EpisodeError(message: e.toString()));
    }
  }

  Future<void> _onFetchEpisodesByCategory(
    FetchEpisodesByCategory event,
    Emitter<EpisodeState> emit,
  ) async {
    try {
      if (state is EpisodeLoaded && event.page > 1) {
        final currentState = state as EpisodeLoaded;
        emit(EpisodeLoadingMore(currentEpisodes: currentState.episodes));
      } else {
        emit(const EpisodeLoading());
      }

      final episodes = await _episodeRepository.fetchEpisodesByCategory(
        category: event.category,
        page: event.page,
      );

      if (state is EpisodeLoadingMore) {
        final currentState = state as EpisodeLoadingMore;
        emit(EpisodeLoaded(
          episodes: [...currentState.currentEpisodes, ...episodes],
          currentPage: event.page,
          lastPage: event.page,
          total: episodes.length,
          hasMore: episodes.isNotEmpty,
        ));
      } else {
        emit(EpisodeLoaded(
          episodes: episodes,
          currentPage: event.page,
          lastPage: event.page,
          total: episodes.length,
          hasMore: episodes.isNotEmpty,
        ));
      }
    } catch (e) {
      emit(EpisodeError(message: e.toString()));
    }
  }
}
