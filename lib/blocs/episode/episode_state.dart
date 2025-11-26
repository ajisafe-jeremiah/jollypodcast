import 'package:equatable/equatable.dart';
import 'package:jollypodcast/models/episode_model.dart';

abstract class EpisodeState extends Equatable {
  const EpisodeState();

  @override
  List<Object?> get props => [];
}

class EpisodeInitial extends EpisodeState {
  const EpisodeInitial();
}

class EpisodeLoading extends EpisodeState {
  const EpisodeLoading();
}

class EpisodeLoaded extends EpisodeState {
  const EpisodeLoaded({
    required this.episodes,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    this.hasMore = true,
  });

  final List<Episode> episodes;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool hasMore;

  @override
  List<Object?> get props => [episodes, currentPage, lastPage, total, hasMore];

  EpisodeLoaded copyWith({
    List<Episode>? episodes,
    int? currentPage,
    int? lastPage,
    int? total,
    bool? hasMore,
  }) {
    return EpisodeLoaded(
      episodes: episodes ?? this.episodes,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class EpisodeRefreshing extends EpisodeState {
  const EpisodeRefreshing({required this.currentEpisodes});

  final List<Episode> currentEpisodes;

  @override
  List<Object?> get props => [currentEpisodes];
}

class EpisodeLoadingMore extends EpisodeState {
  const EpisodeLoadingMore({required this.currentEpisodes});

  final List<Episode> currentEpisodes;

  @override
  List<Object?> get props => [currentEpisodes];
}

class EpisodeError extends EpisodeState {
  const EpisodeError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class SingleEpisodeLoaded extends EpisodeState {
  const SingleEpisodeLoaded({required this.episode});

  final Episode episode;

  @override
  List<Object?> get props => [episode];
}
