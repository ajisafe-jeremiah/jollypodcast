import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jollypodcast/blocs/episode/episode_bloc.dart';
import 'package:jollypodcast/blocs/episode/episode_event.dart';
import 'package:jollypodcast/blocs/episode/episode_state.dart';
import 'package:jollypodcast/constants.dart';
import 'package:jollypodcast/models/episode_model.dart';
import 'package:jollypodcast/ui/components/episode_cards.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  void initState() {
    super.initState();
    // Fetch episodes when page loads
    context.read<EpisodeBloc>().add(const FetchLatestEpisodes());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EpisodeBloc, EpisodeState>(
      builder: (context, state) {
        if (state is EpisodeLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF88D66C)),
          );
        }

        if (state is EpisodeError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error loading episodes',
                  style: TextStyle(color: Colors.grey[400], fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    context.read<EpisodeBloc>().add(
                      const FetchLatestEpisodes(),
                    );
                  },
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: Color(0xFF88D66C)),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is EpisodeLoaded || state is EpisodeRefreshing) {
          final episodes = state is EpisodeLoaded
              ? state.episodes
              : (state as EpisodeRefreshing).currentEpisodes;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<EpisodeBloc>().add(const RefreshEpisodes());
            },
            color: const Color(0xFF88D66C),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hot & Trending Section
                  _buildHotAndTrending(episodes),
                  const SizedBox(height: 32),

                  // Editor's Pick Section
                  if (episodes.isNotEmpty) _buildEditorsPickSection(episodes),
                  const SizedBox(height: 32),

                  // Newest Episodes Section
                  _buildNewestEpisodesSection(episodes),
                  const SizedBox(height: 32),

                  // Mixed by Interest & Categories
                  _buildMixedByInterestSection(episodes),
                  const SizedBox(height: 32),

                  // Handpicked for You Section
                  if (episodes.length > 1) _buildHandpickedSection(episodes),
                  const SizedBox(height: 32),

                  // Category Pills
                  _buildCategoryPills(episodes),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHotAndTrending(List<Episode> episodes) {
    final trendingEpisodes = episodes.take(20).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: Color(0xFFFF6B6B),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Hot & trending episodes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: trendingEpisodes.length,
            itemBuilder: (context, index) {
              return SizedBox(
                child: TrendingEpisodeCard(
                  episode: trendingEpisodes[index],
                  onTap: () {
                    // Handle episode tap
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEditorsPickSection(List<Episode> episodes) {
    final featuredEpisode = episodes.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(Icons.star, color: Color(0xFFFFD700), size: 20),
              SizedBox(width: 8),
              Text(
                "Editor's pick",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FeaturedEpisodeCard(
          episode: featuredEpisode,
          onPlay: () {
            _goToPlayer(featuredEpisode);
          },
        ),
      ],
    );
  }

  void _goToPlayer(Episode episode) {
    context.push(
      '${kHomePath}${kPodcastPlayerPath}',
      extra: {
        'episodeTitle': episode.title,
        'episodeDescription': episode.description,
        'imageUrl': episode.pictureUrl,
        'audioUrl': episode.contentUrl,
      },
    );
  }


  Widget _buildNewestEpisodesSection(List<Episode> episodes) {
    final newestEpisodes = episodes.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Newest episodes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  
                },
                child: const Text(
                  'See All',
                  style: TextStyle(color: Color(0xFF88D66C), fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: newestEpisodes.length,
          itemBuilder: (context, index) {
            return EpisodeCard(
              episode: newestEpisodes[index],
              onTap: () {
                _goToPlayer(newestEpisodes[index]);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildMixedByInterestSection(List<Episode> episodes) {
    // Group episodes by category
    final categorizedEpisodes = <String, List<Episode>>{};
    for (var episode in episodes) {
      final category = episode.podcast.categoryName;
      if (!categorizedEpisodes.containsKey(category)) {
        categorizedEpisodes[category] = [];
      }
      categorizedEpisodes[category]!.add(episode);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Mixed by interest & categories',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categorizedEpisodes.keys.length,
            itemBuilder: (context, index) {
              final category = categorizedEpisodes.keys.elementAt(index);
              final categoryEpisodes = categorizedEpisodes[category]!
                  .take(4)
                  .toList();

              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(4, (i) {
                          if (i < categoryEpisodes.length) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.grey[800],
                              ),
                              child: categoryEpisodes[i].pictureUrl != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        categoryEpisodes[i].pictureUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.podcasts,
                                                color: Colors.white54,
                                                size: 20,
                                              );
                                            },
                                      ),
                                    )
                                  : const Icon(
                                      Icons.podcasts,
                                      color: Colors.white54,
                                      size: 20,
                                    ),
                            );
                          }
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[800],
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHandpickedSection(List<Episode> episodes) {
    final handpickedEpisode = episodes[1];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: Color(0xFFFF6B6B),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Handpicked for you',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A3A3A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[800],
                    ),
                    child: handpickedEpisode.pictureUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              handpickedEpisode.pictureUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.podcasts,
                                  color: Colors.white54,
                                  size: 30,
                                );
                              },
                            ),
                          )
                        : const Icon(
                            Icons.podcasts,
                            color: Colors.white54,
                            size: 30,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          handpickedEpisode.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          handpickedEpisode.podcast.title,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                handpickedEpisode.description,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 13,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildSmallIconButton(Icons.favorite_border),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF88D66C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, color: Colors.white, size: 18),
                          SizedBox(width: 4),
                          Text(
                            'Play',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    handpickedEpisode.formattedDuration,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallIconButton(IconData icon) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 14),
    );
  }

  Widget _buildCategoryPills(List<Episode> episodes) {
    // Extract unique categories from episodes
    final categories = episodes
        .map((e) => e.podcast.categoryName)
        .toSet()
        .take(6)
        .map((cat) => '#${cat.toLowerCase().replaceAll(' ', '')}')
        .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: categories.map((category) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1A3A3A),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              category,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          );
        }).toList(),
      ),
    );
  }
}
