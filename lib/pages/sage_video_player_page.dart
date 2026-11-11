import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:viper/theme/sage_theme.dart';

class SageVideoPlayerPage extends StatefulWidget {
  const SageVideoPlayerPage({super.key, required this.title, required this.videoUrl, required this.code});
  final String title;
  final String videoUrl;
  final String code;

  @override
  State<SageVideoPlayerPage> createState() => _SageVideoPlayerPageState();
}

class _SageVideoPlayerPageState extends State<SageVideoPlayerPage> {
  VideoPlayerController? _controller;
  Object? _error;
  bool _loading = true;
  bool _fullscreen = false;
  bool _loop = true;
  bool _muted = false;
  bool _seeking = false;
  double _seekMs = 0;
  double _speed = 1;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _controller = controller;
    controller.addListener(_changed);
    try {
      await controller.initialize();
      await controller.setLooping(_loop);
      if (!mounted) return;
      setState(() => _loading = false);
      await controller.play();
    } catch (error) {
      controller.removeListener(_changed);
      await controller.dispose();
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
        _controller = null;
      });
    }
  }

  void _changed() {
    if (mounted && !_seeking) setState(() {});
  }

  Future<void> _playPause() async {
    final c = _controller;
    if (c == null) return;
    if (c.value.isPlaying) {
      await c.pause();
    } else {
      if (c.value.position >= c.value.duration) await c.seekTo(Duration.zero);
      await c.play();
    }
    if (mounted) setState(() {});
  }

  Future<void> _seek(Duration delta) async {
    final c = _controller;
    if (c == null) return;
    final ms = (c.value.position + delta).inMilliseconds
        .clamp(0, c.value.duration.inMilliseconds);
    await c.seekTo(Duration(milliseconds: ms));
  }

  Future<void> _toggleFullscreen() async {
    _fullscreen = !_fullscreen;
    await SystemChrome.setEnabledSystemUIMode(
      _fullscreen ? SystemUiMode.immersiveSticky : SystemUiMode.edgeToEdge,
    );
    await SystemChrome.setPreferredOrientations(
      _fullscreen
          ? [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
          : [DeviceOrientation.portraitUp],
    );
    if (mounted) setState(() {});
  }

  String _time(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return d.inHours > 0 ? '${d.inHours}:$m:$s' : '$m:$s';
  }

  @override
  void dispose() {
    _controller?.removeListener(_changed);
    _controller?.dispose();
    if (_fullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_fullscreen,
    onPopInvokedWithResult: (didPop, result) {
      if (!didPop && _fullscreen) _toggleFullscreen();
    },
    child: Theme(
      data: SageTheme.dark,
      child: Scaffold(
        backgroundColor: SageTheme.background,
        appBar: _fullscreen ? null : AppBar(
          title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const Text('SAGE // CRYO-ARCHIVE', style: TextStyle(fontSize: 8, letterSpacing: 1.7, color: SageTheme.cyan)),
          ]),
          actions: [Center(child: _tag()), const SizedBox(width: 14)],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator(color: SageTheme.cyan))
            : _error != null || _controller == null
                ? _errorView()
                : _fullscreen
                    ? _fullPlayer(_controller!, _controller!.value)
                    : _portraitPlayer(_controller!, _controller!.value),
      ),
    ),
  );

  Widget _portraitPlayer(VideoPlayerController c, VideoPlayerValue v) {
    final max = v.duration.inMilliseconds.toDouble().clamp(1, double.infinity);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),
      children: [
        Row(children: [
          const Icon(Icons.ac_unit_rounded, color: SageTheme.cyan),
          const SizedBox(width: 8),
          const Text('RADIANT FIELD RECORDING', style: TextStyle(color: SageTheme.cyan, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w800)),
          const Spacer(),
          _tag(),
        ]),
        const SizedBox(height: 18),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [BoxShadow(color: Color(0x4470D8E8), blurRadius: 26)],
            border: Border.all(color: SageTheme.cyan.withValues(alpha: .35)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(19),
            child: AspectRatio(
              aspectRatio: v.aspectRatio > 0 ? v.aspectRatio : 16 / 9,
              child: Stack(fit: StackFit.expand, children: [
                VideoPlayer(c),
                if (!v.isPlaying)
                  Center(child: IconButton.filled(
                    onPressed: _playPause,
                    iconSize: 42,
                    style: IconButton.styleFrom(backgroundColor: SageTheme.cyan.withValues(alpha: .22), foregroundColor: SageTheme.ice),
                    icon: const Icon(Icons.play_arrow_rounded),
                  )),
                Positioned(right: 9, bottom: 9, child: _fullscreenButton()),
              ]),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(widget.title.toUpperCase(), style: const TextStyle(color: SageTheme.ice, fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: 1)),
        const SizedBox(height: 5),
        const Text('ОФИЦИАЛЬНЫЙ ВИДЕОФРАГМЕНТ VALORANT', style: TextStyle(color: SageTheme.muted, fontSize: 9, letterSpacing: 1)),
        const SizedBox(height: 16),
        _timeline(c, v, max),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _action(Icons.replay_5_rounded, '−5 сек', () => _seek(const Duration(seconds: -5))),
          IconButton.filled(
            onPressed: _playPause,
            iconSize: 34,
            style: IconButton.styleFrom(backgroundColor: SageTheme.cyan.withValues(alpha: .18), foregroundColor: SageTheme.ice),
            icon: Icon(v.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
          ),
          _action(Icons.forward_5_rounded, '+5 сек', () => _seek(const Duration(seconds: 5))),
        ]),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(color: SageTheme.surface, borderRadius: BorderRadius.circular(15)),
          child: Row(children: [
            IconButton(onPressed: () async {
              _muted = !_muted;
              await c.setVolume(_muted ? 0 : 1);
              if (mounted) setState(() {});
            }, icon: Icon(_muted ? Icons.volume_off_rounded : Icons.volume_up_rounded, color: SageTheme.cyan)),
            IconButton(onPressed: () async {
              _loop = !_loop;
              await c.setLooping(_loop);
              if (mounted) setState(() {});
            }, icon: Icon(Icons.repeat_rounded, color: _loop ? SageTheme.cyan : SageTheme.muted)),
            const Spacer(),
            PopupMenuButton<double>(
              initialValue: _speed,
              onSelected: (value) async {
                _speed = value;
                await c.setPlaybackSpeed(value);
                if (mounted) setState(() {});
              },
              itemBuilder: (_) => [0.5, 0.75, 1, 1.25, 1.5, 2]
                  .map((v) => PopupMenuItem(value: v, child: Text('${v}x'))).toList(),
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text('${_speed}x', style: const TextStyle(color: SageTheme.ice, fontWeight: FontWeight.bold))),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _timeline(VideoPlayerController c, VideoPlayerValue v, double max) => Row(children: [
    Text(_time(_seeking ? Duration(milliseconds: _seekMs.round()) : v.position), style: const TextStyle(color: SageTheme.muted, fontSize: 10)),
    Expanded(child: Slider(
      min: 0,
      max: max,
      value: (_seeking ? _seekMs : v.position.inMilliseconds.toDouble()).clamp(0, max),
      activeColor: SageTheme.cyan,
      inactiveColor: SageTheme.elevated,
      onChangeStart: (x) => setState(() { _seeking = true; _seekMs = x; }),
      onChanged: (x) => setState(() => _seekMs = x),
      onChangeEnd: (x) async {
        await c.seekTo(Duration(milliseconds: x.round()));
        if (mounted) setState(() => _seeking = false);
      },
    )),
    Text(_time(v.duration), style: const TextStyle(color: SageTheme.muted, fontSize: 10)),
  ]);

  Widget _fullPlayer(VideoPlayerController c, VideoPlayerValue v) => ColoredBox(
    color: Colors.black,
    child: Stack(fit: StackFit.expand, children: [
      Center(child: AspectRatio(aspectRatio: v.aspectRatio, child: VideoPlayer(c))),
      Positioned(left: 20, top: 18, child: _fullscreenButton()),
      Center(child: IconButton.filled(
        onPressed: _playPause,
        iconSize: 48,
        style: IconButton.styleFrom(backgroundColor: SageTheme.cyan.withValues(alpha: .2), foregroundColor: SageTheme.ice),
        icon: Icon(v.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
      )),
    ]),
  );

  Widget _fullscreenButton() => IconButton(
    onPressed: _toggleFullscreen,
    style: IconButton.styleFrom(backgroundColor: Colors.black54, foregroundColor: SageTheme.ice),
    icon: Icon(_fullscreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded),
  );

  Widget _action(IconData icon, String label, VoidCallback onTap) => TextButton.icon(
    onPressed: onTap,
    icon: Icon(icon, color: SageTheme.cyan),
    label: Text(label, style: const TextStyle(color: SageTheme.ice, fontSize: 10)),
  );

  Widget _tag() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: SageTheme.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: SageTheme.cyan.withValues(alpha: .4))),
    child: Text('SAGE // ${widget.code}', style: const TextStyle(color: SageTheme.ice, fontSize: 9, fontWeight: FontWeight.w800)),
  );

  Widget _errorView() => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.cloud_off_rounded, color: SageTheme.cyan, size: 52),
        const SizedBox(height: 14),
        const Text('Видеозапись недоступна', style: TextStyle(color: SageTheme.ice, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Проверь подключение к интернету. Источник видео находится на CDN Riot Games.', textAlign: TextAlign.center, style: TextStyle(color: SageTheme.muted, height: 1.5)),
        const SizedBox(height: 12),
        TextButton(onPressed: () { setState(() { _loading = true; _error = null; }); _init(); }, child: const Text('ПОВТОРИТЬ')),
      ]),
    ),
  );
}
