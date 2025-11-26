import 'package:jollypodcast/models/episode_model.dart';
import 'package:jollypodcast/services/dio.dart';

class EpisodeRepository {
  EpisodeRepository({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;

  Future<EpisodeResponse> fetchLatestEpisodes({int page = 1}) async {
    try {
      final response = await _dioClient.get(
        path: "/episodes/latest",
        queryParameters: {'page': page},
      );

      return EpisodeResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<EpisodeResponse> fetchTrendingEpisodes({int page = 1}) async {
    try {
      final response = await _dioClient.get(
        path: "/episodes/trending",
        queryParameters: {'page': page},
      );

      return EpisodeResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Episode> fetchEpisodeById(int episodeId) async {
    try {
      final response = await _dioClient.get(
        path: "/episodes/$episodeId",
      );

      return Episode.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Episode>> fetchEpisodesByCategory({
    required String category,
    int page = 1,
  }) async {
    try {
      final response = await _dioClient.get(
        path: "/episodes/$category",
        queryParameters: {'page': page},
      );

      final episodeResponse = EpisodeResponse.fromJson(response.data);
      return episodeResponse.data.episodes;
    } catch (e) {
      rethrow;
    }
  }
}
