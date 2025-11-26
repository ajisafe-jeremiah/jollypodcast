import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PodcastPlayerScreen extends StatefulWidget {
  final String episodeTitle;
  final String episodeDescription;
  final String imageUrl;
  final String audioUrl;

  const PodcastPlayerScreen({
    super.key,
    required this.episodeTitle,
    required this.episodeDescription,
    required this.imageUrl,
    required this.audioUrl,
  });

  @override
  State<PodcastPlayerScreen> createState() => _PodcastPlayerScreenState();
}

class _PodcastPlayerScreenState extends State<PodcastPlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    // Listen to player state
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    // Listen to duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    // Listen to position
    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.audioUrl));
    }
  }

  Future<void> _seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> _skipForward() async {
    final newPosition = position + const Duration(seconds: 10);
    await _audioPlayer.seek(newPosition);
  }

  Future<void> _skipBackward() async {
    final newPosition = position - const Duration(seconds: 10);
    await _audioPlayer.seek(
      newPosition > Duration.zero ? newPosition : Duration.zero,
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2D9F5B), Color(0xFF1A7A42)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    _buildTopBar(),
                    const SizedBox(height: 20),
                    _buildArtwork(),
                    const SizedBox(height: 25),
                    _buildEpisodeInfo(),
                    const SizedBox(height: 20),
                    _buildProgressBar(),
                    const SizedBox(height: 20),
                    _buildControls(),
                    const Spacer(),
                    _buildActionButtons(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtwork() {
    return Container(
      width: 280,
      height: 280,
      margin: const EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          widget.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFF1E3A4F),
              child: const Center(
                child: Icon(Icons.podcasts, color: Colors.white54, size: 80),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEpisodeInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            widget.episodeTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            widget.episodeDescription,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              thumbColor: Colors.white,
              overlayColor: Colors.white.withOpacity(0.2),
            ),
            child: Slider(
              value: position.inSeconds.toDouble(),
              max: duration.inSeconds.toDouble() > 0
                  ? duration.inSeconds.toDouble()
                  : 1,
              onChanged: (value) {
                _seek(Duration(seconds: value.toInt()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(position),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                Text(
                  _formatDuration(duration),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildControlButton(
          icon: Icons.skip_previous,
          size: 38,
          onTap: () {
            // Previous episode logic
          },
        ),
        const SizedBox(width: 18),
        _buildControlButton(
          icon: Icons.replay_10,
          size: 42,
          onTap: _skipBackward,
        ),
        const SizedBox(width: 22),
        _buildPlayPauseButton(),
        const SizedBox(width: 22),
        _buildControlButton(
          icon: Icons.forward_10,
          size: 42,
          onTap: _skipForward,
        ),
        const SizedBox(width: 18),
        _buildControlButton(
          icon: Icons.skip_next,
          size: 38,
          onTap: () {
            // Next episode logic
          },
        ),
      ],
    );
  }

  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: _playPause,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
          color: const Color(0xFF2D9F5B),
          size: 38,
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required double size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.6),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.playlist_add,
                  label: 'Add to queue',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.favorite_border,
                  label: 'Save',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionButton(icon: Icons.share, label: 'Share'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.add,
                  label: 'Add to playlist',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.article_outlined,
                  label: 'Episode page',
                  showArrow: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    bool showArrow = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (showArrow) ...[
            const SizedBox(width: 3),
            const Icon(Icons.arrow_forward, color: Colors.white, size: 14),
          ],
        ],
      ),
    );
  }
}
