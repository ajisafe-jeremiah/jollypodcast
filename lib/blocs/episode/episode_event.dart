import 'package:equatable/equatable.dart';

abstract class EpisodeEvent extends Equatable {
  const EpisodeEvent();

  @override
  List<Object?> get props => [];
}

class FetchLatestEpisodes extends EpisodeEvent {
  const FetchLatestEpisodes({this.page = 1});

  final int page;

  @override
  List<Object?> get props => [page];
}

class RefreshEpisodes extends EpisodeEvent {
  const RefreshEpisodes();
}

class FetchTrendingEpisodes extends EpisodeEvent {
  const FetchTrendingEpisodes({this.page = 1});

  final int page;

  @override
  List<Object?> get props => [page];
}

class FetchEpisodeById extends EpisodeEvent {
  const FetchEpisodeById({required this.episodeId});

  final int episodeId;

  @override
  List<Object?> get props => [episodeId];
}

class FetchEpisodesByCategory extends EpisodeEvent {
  const FetchEpisodesByCategory({
    required this.category,
    this.page = 1,
  });

  final String category;
  final int page;

  @override
  List<Object?> get props => [category, page];
}
