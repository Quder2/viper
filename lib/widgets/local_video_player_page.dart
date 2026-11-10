import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayerPage extends StatefulWidget {
  const LocalVideoPlayerPage({
    super.key,
    required this.title,
    required this.assetPath,
  });

  final String title;
  final String assetPath;

  @override
  State<LocalVideoPlayerPage> createState() => _LocalVideoPlayerPageState();
}

class _LocalVideoPlayerPageState extends State<LocalVideoPlayerPage> {
  VideoPlayerController? _controller;
  Object? _error;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    final controller = VideoPlayerController.asset(widget.assetPath);
    _controller = controller;

    try {
      await controller.initialize();
      await controller.setLooping(true);
      if (!mounted) return;
      setState(() => _isLoading = false);
      await controller.play();
    } catch (error) {
      await controller.dispose();
      if (!mounted) return;
      setState(() {
        _error = error;
        _isLoading = false;
        _controller = null;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _isLoading
              ? const CircularProgressIndicator()
              : _error != null || controller == null
                  ? _VideoMissingMessage(assetPath: widget.assetPath)
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          ),
                        ),
                        const SizedBox(height: 18),
                        IconButton.filled(
                          tooltip: controller.value.isPlaying
                              ? 'Пауза'
                              : 'Воспроизвести',
                          onPressed: () {
                            setState(() {
                              controller.value.isPlaying
                                  ? controller.pause()
                                  : controller.play();
                            });
                          },
                          icon: Icon(
                            controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class _VideoMissingMessage extends StatelessWidget {
  const _VideoMissingMessage({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.movie_outlined, size: 56, color: Color(0xFF65D84A)),
        const SizedBox(height: 16),
        const Text(
          'Локальное видео пока не добавлено',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        const Text(
          'Помести MP4-файл по указанному пути и перезапусти приложение.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        SelectableText(
          assetPath,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF73FF55)),
        ),
      ],
    );
  }
}
