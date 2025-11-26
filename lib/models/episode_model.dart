class EpisodeResponse {
  final String message;
  final EpisodeData data;

  EpisodeResponse({
    required this.message,
    required this.data,
  });

  factory EpisodeResponse.fromJson(Map<String, dynamic> json) {
    return EpisodeResponse(
      message: json['message'] ?? '',
      data: EpisodeData.fromJson(json['data']['data']),
    );
  }
}

class EpisodeData {
  final List<Episode> episodes;
  final int currentPage;
  final int lastPage;
  final int total;
  final String? nextPageUrl;
  final String? prevPageUrl;

  EpisodeData({
    required this.episodes,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    this.nextPageUrl,
    this.prevPageUrl,
  });

  factory EpisodeData.fromJson(Map<String, dynamic> json) {
    return EpisodeData(
      episodes: (json['data'] as List)
          .map((episode) => Episode.fromJson(episode))
          .toList(),
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      total: json['total'] ?? 0,
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
    );
  }
}

class Episode {
  final int id;
  final int podcastId;
  final String contentUrl;
  final String title;
  final String? pictureUrl;
  final String description;
  final bool explicit;
  final int duration;
  final String publishedAt;
  final int playCount;
  final int likeCount;
  final Podcast podcast;

  Episode({
    required this.id,
    required this.podcastId,
    required this.contentUrl,
    required this.title,
    this.pictureUrl,
    required this.description,
    required this.explicit,
    required this.duration,
    required this.publishedAt,
    required this.playCount,
    required this.likeCount,
    required this.podcast,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] ?? 0,
      podcastId: json['podcast_id'] ?? 0,
      contentUrl: json['content_url'] ?? '',
      title: json['title'] ?? '',
      pictureUrl: json['picture_url'],
      description: json['description'] ?? '',
      explicit: json['explicit'] ?? false,
      duration: json['duration'] ?? 0,
      publishedAt: json['published_at'] ?? '',
      playCount: json['play_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      podcast: Podcast.fromJson(json['podcast']),
    );
  }

  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')} min';
  }

  String get timeAgo {
    final published = DateTime.parse(publishedAt);
    final now = DateTime.now();
    final difference = now.difference(published);

    if (difference.inDays > 30) {
      final months = difference.inDays ~/ 30;
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else {
      return 'Just now';
    }
  }
}

class Podcast {
  final int id;
  final String title;
  final String author;
  final String categoryName;
  final String categoryType;
  final String? pictureUrl;
  final String description;
  final Publisher publisher;

  Podcast({
    required this.id,
    required this.title,
    required this.author,
    required this.categoryName,
    required this.categoryType,
    this.pictureUrl,
    required this.description,
    required this.publisher,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      categoryName: json['category_name'] ?? '',
      categoryType: json['category_type'] ?? '',
      pictureUrl: json['picture_url'],
      description: json['description'] ?? '',
      publisher: Publisher.fromJson(json['publisher']),
    );
  }
}

class Publisher {
  final int id;
  final String firstName;
  final String lastName;
  final String companyName;
  final String email;

  Publisher({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.companyName,
    required this.email,
  });

  factory Publisher.fromJson(Map<String, dynamic> json) {
    return Publisher(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      companyName: json['company_name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  String get fullName => '$firstName $lastName';
}
