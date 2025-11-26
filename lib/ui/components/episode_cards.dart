import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jollypodcast/constants.dart';
import 'package:jollypodcast/models/episode_model.dart';

class EpisodeCard extends StatelessWidget {
  final Episode episode;
  final VoidCallback? onTap;

  const EpisodeCard({super.key, required this.episode, this.onTap});

  void _navigateToPlayer(BuildContext context) {
    context.push(
      '${kHomePath}${kPodcastPlayerPath}',
      extra: {
        'episodeTitle': episode.title,
        'episodeDescription': episode.description,
        'imageUrl': episode.pictureUrl ?? '',
        'audioUrl': episode.contentUrl,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F2626),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          } else {
            _navigateToPlayer(context);
          }
        },
        child: Row(
          children: [
            _buildThumbnail(context),
            const SizedBox(width: 12),
            Expanded(child: _buildEpisodeInfo()),
            _buildMoreButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToPlayer(context),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[800],
        ),
        child: episode.pictureUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  episode.pictureUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                ),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return const Icon(Icons.podcasts, color: Colors.white54, size: 30);
  }

  Widget _buildEpisodeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          episode.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          episode.podcast.title,
          style: TextStyle(color: Colors.grey[400], fontSize: 11),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${episode.timeAgo} • ${episode.formattedDuration}',
          style: TextStyle(color: Colors.grey[600], fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildMoreButton() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.more_vert, color: Colors.white, size: 14),
    );
  }
}

class TrendingEpisodeCard extends StatelessWidget {
  final Episode episode;
  final VoidCallback? onTap;

  const TrendingEpisodeCard({super.key, required this.episode, this.onTap});

  void _navigateToPlayer(BuildContext context) {
    context.push(
      '${kHomePath}${kPodcastPlayerPath}',
      extra: {
        'episodeTitle': episode.title,
        'episodeDescription': episode.description,
        'imageUrl': episode.pictureUrl ?? '',
        'audioUrl': episode.contentUrl,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 400,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E221A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          } else {
            _navigateToPlayer(context);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildBackgroundImage(),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 18),
                      _buildForegroundThumbnail(context),
                      const SizedBox(height: 12),
                      _buildPodcastInfo(),
                      const SizedBox(height: 6),
                      _buildTitle(),
                      const SizedBox(height: 6),
                      _buildDescription(),
                      const SizedBox(height: 12),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          episode.pictureUrl ?? '',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(color: const Color(0xFF0E221A));
          },
        ),

        // Soft green tint over entire image
        Container(color: const Color(0xFF0E221A).withOpacity(0.35)),

        // Stronger green gradient at bottom for text readability
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF0E221A).withOpacity(0.0),
                  const Color(0xFF0E221A).withOpacity(0.6),
                  const Color(0xFF0E221A).withOpacity(0.95),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildForegroundThumbnail(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToPlayer(context),
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                episode.pictureUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    Container(color: Colors.grey[700]),
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFF88D66C),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodcastInfo() {
    return Text(
      episode.podcast.title,
      style: TextStyle(
        color: Colors.grey[300],
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      episode.title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      episode.description,
      style: TextStyle(color: Colors.grey[300], fontSize: 13, height: 1.4),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        _action(Icons.favorite_border),
        const SizedBox(width: 10),
        _action(Icons.bookmark_add_outlined),
        const SizedBox(width: 10),
        _action(Icons.share),
        const SizedBox(width: 10),
        _action(Icons.add),
      ],
    );
  }

  Widget _action(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}

class FeaturedEpisodeCard extends StatelessWidget {
  final Episode episode;
  final VoidCallback? onPlay;

  const FeaturedEpisodeCard({super.key, required this.episode, this.onPlay});

  void _navigateToPlayer(BuildContext context) {
    context.push(
      '${kHomePath}${kPodcastPlayerPath}',
      extra: {
        'episodeTitle': episode.title,
        'episodeDescription': episode.description,
        'imageUrl': episode.pictureUrl ?? '',
        'audioUrl': episode.contentUrl,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A3A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildThumbnail(),
          const SizedBox(width: 16),
          Expanded(child: _buildContent(context)),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[800],
      ),
      child: episode.pictureUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                episode.pictureUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholder();
                },
              ),
            )
          : _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return const Center(
      child: Icon(Icons.podcasts, color: Colors.white54, size: 40),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          episode.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          episode.description,
          style: TextStyle(color: Colors.grey[400], fontSize: 12, height: 1.4),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildPlayButton(context),
            const SizedBox(width: 8),
            _buildSmallIconButton(Icons.share_outlined),
          ],
        ),
      ],
    );
  }

  Widget _buildPlayButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onPlay != null) {
          onPlay!();
        } else {
          _navigateToPlayer(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF88D66C),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          children: [
            Icon(Icons.play_arrow, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text(
              'Play',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
}
