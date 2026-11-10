import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayerPage extends StatefulWidget {
  const LocalVideoPlayerPage({super.key, required this.title, required this.assetPath});
  final String title;
  final String assetPath;
  @override
  State<LocalVideoPlayerPage> createState() => _LocalVideoPlayerPageState();
}

class _LocalVideoPlayerPageState extends State<LocalVideoPlayerPage> with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;
  late final AnimationController _glow;
  Object? _error;
  bool _loading = true, _controls = true, _muted = false, _loop = true, _fullscreen = false, _seeking = false;
  double _speed = 1, _seekMs = 0, _oldVolume = 1;

  String get _code => RegExp(r'viper_ability_(C|Q|E|ult)', caseSensitive: false)
      .firstMatch(widget.assetPath)?.group(1)?.toUpperCase() ?? 'VIDEO';

  @override
  void initState() {
    super.initState();
    _glow = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
    _initVideo();
  }

  Future<void> _initVideo() async {
    final c = VideoPlayerController.asset(widget.assetPath);
    _controller = c;
    c.addListener(_videoChanged);
    try {
      await c.initialize();
      await c.setLooping(_loop);
      if (!mounted) return;
      setState(() => _loading = false);
      await c.play();
    } catch (e) {
      c.removeListener(_videoChanged);
      await c.dispose();
      if (!mounted) return;
      setState(() { _error = e; _loading = false; _controller = null; });
    }
  }

  void _videoChanged() { if (mounted && !_seeking) setState(() {}); }

  Future<void> _playPause() async {
    final c = _controller;
    if (c == null) return;
    if (c.value.isPlaying) { await c.pause(); }
    else {
      if (c.value.position >= c.value.duration) await c.seekTo(Duration.zero);
      await c.play();
    }
    if (mounted) setState(() => _controls = true);
  }

  Future<void> _mute() async {
    final c = _controller;
    if (c == null) return;
    if (_muted) { await c.setVolume(_oldVolume); }
    else { _oldVolume = c.value.volume == 0 ? 1 : c.value.volume; await c.setVolume(0); }
    if (mounted) setState(() => _muted = !_muted);
  }

  Future<void> _loopToggle() async {
    _loop = !_loop;
    await _controller?.setLooping(_loop);
    if (mounted) setState(() {});
  }

  Future<void> _speedTo(double value) async {
    _speed = value;
    await _controller?.setPlaybackSpeed(value);
    if (mounted) setState(() {});
  }

  Future<void> _fullscreenToggle() async {
    _fullscreen = !_fullscreen;
    if (_fullscreen) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    } else {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    if (mounted) setState(() {});
  }

  String _time(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return d.inHours > 0 ? '\${d.inHours}:$mm:$ss' : '$mm:$ss';
  }

  @override
  void dispose() {
    _glow.dispose();
    _controller?.removeListener(_videoChanged);
    _controller?.dispose();
    if (_fullscreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    final v = c?.value;
    final duration = v?.duration ?? Duration.zero;
    final position = v?.position ?? Duration.zero;
    final maxMs = math.max(1, duration.inMilliseconds).toDouble();
    return Scaffold(
      backgroundColor: const Color(0xFF030A06),
      appBar: _fullscreen ? null : AppBar(
        backgroundColor: const Color(0xFF07150D),
        title: Text(widget.title),
        actions: [_badge(), const SizedBox(width: 14)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF9BFF83)))
          : _error != null || c == null
              ? Center(child: _VideoMissingMessage(assetPath: widget.assetPath))
              : GestureDetector(
                  onTap: () => setState(() => _controls = !_controls),
                  child: Stack(fit: StackFit.expand, children: [
                    const DecoratedBox(decoration: BoxDecoration(
                      gradient: RadialGradient(center: Alignment(0, -0.3), radius: 1.2,
                        colors: [Color(0xFF12351D), Color(0xFF030A06)]))),
                    Positioned.fill(child: IgnorePointer(child: AnimatedBuilder(
                      animation: _glow,
                      builder: (_, __) => CustomPaint(painter: _ToxicGlow(_glow.value))))),
                    Center(child: AspectRatio(
                      aspectRatio: v!.aspectRatio,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(color: Color(0x6600E676), blurRadius: 32, spreadRadius: 2)]),
                        child: ClipRRect(borderRadius: BorderRadius.circular(18), child: VideoPlayer(c)),
                      ))),
                    if (_controls) Positioned.fill(child: DecoratedBox(
                      decoration: BoxDecoration(gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Colors.black.withValues(alpha: .5), Colors.transparent, Colors.black.withValues(alpha: .8)],
                        stops: const [0, .45, 1])),
                      child: SafeArea(child: Column(children: [
                        if (_fullscreen) Align(alignment: Alignment.topRight,
                          child: IconButton(onPressed: _fullscreenToggle, icon: const Icon(Icons.fullscreen_exit), color: Colors.white)),
                        const Spacer(),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          IconButton(onPressed: () => c.seekTo(position - const Duration(seconds: 5)),
                            icon: const Icon(Icons.replay_5_rounded), color: Colors.white, iconSize: 34),
                          const SizedBox(width: 20),
                          _playButton(v.isPlaying),
                          const SizedBox(width: 20),
                          IconButton(onPressed: () => c.seekTo(position + const Duration(seconds: 5)),
                            icon: const Icon(Icons.forward_5_rounded), color: Colors.white, iconSize: 34),
                        ]),
                        const Spacer(),
                        Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 12), child: Column(children: [
                          Row(children: [
                            Text(_time(_seeking ? Duration(milliseconds: _seekMs.round()) : position),
                              style: const TextStyle(color: Colors.white, fontSize: 11)),
                            Expanded(child: Slider(
                              min: 0, max: maxMs,
                              value: (_seeking ? _seekMs : position.inMilliseconds.toDouble()).clamp(0, maxMs).toDouble(),
                              onChangeStart: (x) => setState(() { _seeking = true; _seekMs = x; }),
                              onChanged: (x) => setState(() => _seekMs = x),
                              onChangeEnd: (x) async {
                                await c.seekTo(Duration(milliseconds: x.round()));
                                if (mounted) setState(() => _seeking = false);
                              },
                              activeColor: const Color(0xFF9BFF83), inactiveColor: Colors.white24)),
                            Text(_time(duration), style: const TextStyle(color: Colors.white, fontSize: 11)),
                          ]),
                          Row(children: [
                            IconButton(tooltip: 'Звук', onPressed: _mute,
                              icon: Icon(_muted ? Icons.volume_off_rounded : Icons.volume_up_rounded), color: Colors.white),
                            IconButton(tooltip: 'Повтор', onPressed: _loopToggle,
                              icon: Icon(Icons.repeat_rounded, color: _loop ? const Color(0xFF9BFF83) : Colors.white)),
                            const Spacer(),
                            PopupMenuButton<double>(
                              tooltip: 'Скорость', initialValue: _speed, onSelected: _speedTo,
                              color: const Color(0xFF102719),
                              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text('\${_speed}x', style: const TextStyle(color: Color(0xFFB8FF9B), fontWeight: FontWeight.bold))),
                              itemBuilder: (_) => [0.5, 0.75, 1, 1.25, 1.5, 2]
                                .map((x) => PopupMenuItem(value: x, child: Text('\${x}x'))).toList()),
                            IconButton(tooltip: 'На весь экран', onPressed: _fullscreenToggle,
                              icon: const Icon(Icons.fullscreen_rounded), color: Colors.white),
                          ]),
                        ])),
                      ])),
                    )),
                  ]),
                ),
    );
  }

  Widget _badge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
    decoration: BoxDecoration(color: const Color(0xFF102719), borderRadius: BorderRadius.circular(30),
      border: Border.all(color: const Color(0xFF9BFF83).withValues(alpha: .6))),
    child: Text('VIPER // $_code', style: const TextStyle(color: Color(0xFFB8FF9B),
      fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2)));

  Widget _playButton(bool playing) => Container(
    decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF9BFF83).withValues(alpha: .18),
      border: Border.all(color: const Color(0xFFB8FF9B), width: 1.5),
      boxShadow: const [BoxShadow(color: Color(0x9900E676), blurRadius: 24, spreadRadius: 2)]),
    child: IconButton(onPressed: _playPause, iconSize: 42, color: const Color(0xFFB8FF9B),
      icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded)));
}

class _ToxicGlow extends CustomPainter {
  _ToxicGlow(this.t);
  final double t;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var i = 0; i < 14; i++) {
      final phase = t * math.pi * 2 + i * 1.7;
      final x = size.width * (.5 + math.sin(phase) * .43);
      final y = size.height * (.5 + math.cos(phase * .8) * .4);
      paint.color = const Color(0xFF79FF4D).withValues(alpha: .13);
      canvas.drawCircle(Offset(x, y), 2 + (math.sin(phase * 1.4) + 1) * 2.5, paint);
    }
  }
  @override
  bool shouldRepaint(covariant _ToxicGlow old) => old.t != t;
}

class _VideoMissingMessage extends StatelessWidget {
  const _VideoMissingMessage({required this.assetPath});
  final String assetPath;
  @override
  Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min, children: [
    const Icon(Icons.movie_outlined, size: 56, color: Color(0xFF65D84A)),
    const SizedBox(height: 16),
    const Text('Локальное видео пока не добавлено', textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    const SizedBox(height: 10),
    const Text('Помести MP4-файл по указанному пути и перезапусти приложение.', textAlign: TextAlign.center),
    const SizedBox(height: 12),
    SelectableText(assetPath, textAlign: TextAlign.center,
      style: const TextStyle(color: Color(0xFF73FF55))),
  ]);
}
