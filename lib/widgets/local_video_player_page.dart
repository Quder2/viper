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

  Future<void> _seekBy(Duration offset) async {
    final c = _controller;
    if (c == null) return;
    final target = c.value.position + offset;
    final boundedMs = target.inMilliseconds
        .clamp(0, c.value.duration.inMilliseconds)
        .toInt();
    await c.seekTo(Duration(milliseconds: boundedMs));
  }

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
    return d.inHours > 0 ? '${d.inHours}:$mm:$ss' : '$mm:$ss';
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
    return PopScope(
      canPop: !_fullscreen,
      onPopInvoked: (didPop) {
        if (!didPop && _fullscreen) {
          _fullscreenToggle();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF030A06),
        appBar: _fullscreen ? null : AppBar(
          backgroundColor: const Color(0xFF07150D),
          title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w800)),
            const Text('TACTICAL VIDEO ARCHIVE',
              style: TextStyle(fontSize: 8, letterSpacing: 1.8, color: Color(0xFF8DBA91))),
          ]),
          actions: [_badge(), const SizedBox(width: 14)],
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 380),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: .98, end: 1).animate(animation),
              child: child,
            ),
          ),
          child: _loading
            ? const Center(key: ValueKey('loading'), child: CircularProgressIndicator(color: Color(0xFF9BFF83)))
            : _error != null || _controller == null
              ? Center(key: const ValueKey('error'), child: _VideoMissingMessage(assetPath: widget.assetPath))
              : _fullscreen
                ? _buildFullscreen(_controller!, _controller!.value, key: const ValueKey('fullscreen'))
                : _buildPortrait(_controller!, _controller!.value, key: const ValueKey('portrait')),
        ),
      ),
    );
  }

  Widget _buildPortrait(VideoPlayerController c, VideoPlayerValue v, {required Key key}) {
    final maxMs = math.max(1, v.duration.inMilliseconds).toDouble();
    return Container(
      key: key,
      decoration: const BoxDecoration(gradient: LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Color(0xFF0B2113), Color(0xFF030A06), Color(0xFF030A06)])),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          children: [
            Row(children: [
              const Icon(Icons.shield_moon_outlined, color: Color(0xFF9BFF83), size: 18),
              const SizedBox(width: 8),
              const Text('VIPER // FIELD RECORDING',
                style: TextStyle(color: Color(0xFF9BFF83), fontSize: 9, letterSpacing: 1.8, fontWeight: FontWeight.w800)),
              const Spacer(),
              _badge(),
            ]),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _glow,
              builder: (_, child) => Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(
                    color: const Color(0xFF00E676).withValues(alpha: .08 + _glow.value * .10),
                    blurRadius: 24 + _glow.value * 12, spreadRadius: 1)]),
                child: child,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: v.aspectRatio,
                  child: Stack(fit: StackFit.expand, children: [
                    VideoPlayer(c),
                    Positioned(left: 12, top: 12, child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: .62),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF9BFF83).withValues(alpha: .45))),
                      child: Text(v.isPlaying ? 'PLAYING' : 'PAUSED',
                        style: const TextStyle(color: Color(0xFFB8FF9B), fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: 1.2)))),
                    Positioned(right: 10, bottom: 10, child: _cinemaButton(compact: true)),
                    if (!v.isPlaying) Center(child: _playButton(false)),
                  ]),
                ),
              ),
            ),
            const SizedBox(height: 22),
            Row(children: [
              Container(width: 4, height: 42, decoration: BoxDecoration(
                color: const Color(0xFF9BFF83), borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Color(0x8800E676), blurRadius: 12)])),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.title.toUpperCase(), style: const TextStyle(
                  color: Color(0xFFE2FFD8), fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1)),
                const SizedBox(height: 4),
                const Text('ЛОКАЛЬНОЕ ВИДЕО • ОБУЧАЮЩИЙ МАТЕРИАЛ',
                  style: TextStyle(color: Color(0xFF77917D), fontSize: 9, letterSpacing: .8)),
              ])),
            ]),
            const SizedBox(height: 18),
            Row(children: [
              Text(_time(_seeking ? Duration(milliseconds: _seekMs.round()) : v.position),
                style: const TextStyle(color: Colors.white70, fontSize: 10)),
              Expanded(child: SliderTheme(
                data: SliderTheme.of(context).copyWith(trackHeight: 3,
                  activeTrackColor: const Color(0xFF9BFF83), inactiveTrackColor: Colors.white12,
                  thumbColor: const Color(0xFF9BFF83), overlayColor: const Color(0xFF9BFF83).withValues(alpha: .14),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6)),
                child: Slider(
                  min: 0, max: maxMs,
                  value: (_seeking ? _seekMs : v.position.inMilliseconds.toDouble()).clamp(0, maxMs).toDouble(),
                  onChangeStart: (x) => setState(() { _seeking = true; _seekMs = x; }),
                  onChanged: (x) => setState(() => _seekMs = x),
                  onChangeEnd: (x) async {
                    await c.seekTo(Duration(milliseconds: x.round()));
                    if (mounted) setState(() => _seeking = false);
                  },
                ),
              )),
              Text(_time(v.duration), style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ]),
            const SizedBox(height: 4),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _portraitAction(Icons.replay_5_rounded, '−5 сек', () => _seekBy(const Duration(seconds: -5))),
              _playButton(v.isPlaying),
              _portraitAction(Icons.forward_5_rounded, '+5 сек', () => _seekBy(const Duration(seconds: 5))),
            ]),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFF0B1710),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF9BFF83).withValues(alpha: .14))),
              child: Row(children: [
                IconButton(tooltip: 'Звук', onPressed: _mute,
                  icon: Icon(_muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                    color: _muted ? Colors.white54 : const Color(0xFF9BFF83))),
                IconButton(tooltip: 'Повтор', onPressed: _loopToggle,
                  icon: Icon(Icons.repeat_rounded, color: _loop ? const Color(0xFF9BFF83) : Colors.white54)),
                const Spacer(),
                PopupMenuButton<double>(
                  tooltip: 'Скорость', initialValue: _speed, color: const Color(0xFF102719),
                  onSelected: _speedTo,
                  itemBuilder: (_) => <double>[0.5, 0.75, 1, 1.25, 1.5, 2]
                    .map((x) => PopupMenuItem<double>(value: x, child: Text('$x x'))).toList(),
                  child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Text(_speed.toString() + 'x',
                      style: const TextStyle(color: Color(0xFFB8FF9B), fontWeight: FontWeight.bold))),
                ),
              ]),
            ),
            const SizedBox(height: 18),
            const Center(child: Text('TOXIC ARCHIVE  /  CLASSIFIED FOOTAGE',
              style: TextStyle(color: Color(0xFF55745D), fontSize: 8, letterSpacing: 2))),
          ],
        ),
      ),
    );
  }

  Widget _buildFullscreen(VideoPlayerController c, VideoPlayerValue v, {required Key key}) {
    final maxMs = math.max(1, v.duration.inMilliseconds).toDouble();
    return Container(
      key: key,
      color: Colors.black,
      child: Stack(fit: StackFit.expand, children: [
        const DecoratedBox(decoration: BoxDecoration(gradient: RadialGradient(
          center: Alignment.center, radius: 1.2, colors: [Color(0xFF102719), Colors.black]))),
        Center(child: AspectRatio(aspectRatio: v.aspectRatio, child: VideoPlayer(c))),
        Positioned.fill(child: IgnorePointer(child: AnimatedBuilder(
          animation: _glow, builder: (_, __) => CustomPaint(painter: _ToxicGlow(_glow.value))))),
        if (_controls)
          Positioned.fill(child: AnimatedOpacity(
            opacity: _controls ? 1 : 0, duration: const Duration(milliseconds: 180),
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topCenter, end: Alignment.bottomCenter,
                colors: [Colors.black.withValues(alpha: .66), Colors.transparent,
                  Colors.black.withValues(alpha: .78)], stops: const [0, .48, 1])),
              child: SafeArea(child: Column(children: [
                Padding(padding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
                  child: Row(children: [
                    _cinemaButton(onTap: _fullscreenToggle),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(widget.title.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.2, fontSize: 12)),
                      const SizedBox(height: 3),
                      const Text('VIPER TACTICAL ARCHIVE',
                        style: TextStyle(color: Color(0xFF9BB5A0), fontSize: 8, letterSpacing: 2)),
                    ])),
                    _badge(),
                  ])),
                const Spacer(),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _bigSeek(Icons.replay_5_rounded, '−5', () => c.seekTo(v.position - const Duration(seconds: 5))),
                  const SizedBox(width: 26),
                  _playButton(v.isPlaying, large: true),
                  const SizedBox(width: 26),
                  _bigSeek(Icons.forward_5_rounded, '+5', () => c.seekTo(v.position + const Duration(seconds: 5))),
                ]),
                const Spacer(),
                Padding(padding: const EdgeInsets.fromLTRB(26, 0, 26, 14),
                  child: Column(children: [
                    Row(children: [
                      Text(_time(_seeking ? Duration(milliseconds: _seekMs.round()) : v.position),
                        style: const TextStyle(color: Colors.white70, fontSize: 10)),
                      Expanded(child: Slider(
                        min: 0, max: maxMs,
                        value: (_seeking ? _seekMs : v.position.inMilliseconds.toDouble()).clamp(0, maxMs).toDouble(),
                        activeColor: const Color(0xFF9BFF83), inactiveColor: Colors.white24,
                        onChangeStart: (x) => setState(() { _seeking = true; _seekMs = x; }),
                        onChanged: (x) => setState(() => _seekMs = x),
                        onChangeEnd: (x) async {
                          await c.seekTo(Duration(milliseconds: x.round()));
                          if (mounted) setState(() => _seeking = false);
                        },
                      )),
                      Text(_time(v.duration), style: const TextStyle(color: Colors.white70, fontSize: 10)),
                    ]),
                    Row(children: [
                      IconButton(tooltip: 'Звук', onPressed: _mute,
                        icon: Icon(_muted ? Icons.volume_off_rounded : Icons.volume_up_rounded, color: Colors.white)),
                      IconButton(tooltip: 'Повтор', onPressed: _loopToggle,
                        icon: Icon(Icons.repeat_rounded, color: _loop ? const Color(0xFF9BFF83) : Colors.white54)),
                      const Spacer(),
                      PopupMenuButton<double>(
                        tooltip: 'Скорость', initialValue: _speed, color: const Color(0xFF102719),
                        onSelected: _speedTo,
                        itemBuilder: (_) => <double>[0.5, 0.75, 1, 1.25, 1.5, 2]
                          .map((x) => PopupMenuItem<double>(value: x, child: Text('$x x'))).toList(),
                        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(_speed.toString() + 'x',
                            style: const TextStyle(color: Color(0xFFB8FF9B), fontWeight: FontWeight.bold))),
                      ),
                      const SizedBox(width: 8),
                      _cinemaButton(onTap: _fullscreenToggle),
                    ]),
                  ])),
              ])),
            ),
          )),
        if (!_controls)
          Positioned.fill(child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _controls = true),
            child: const SizedBox.expand())),
      ]),
    );
  }

  Widget _cinemaButton({bool compact = false, VoidCallback? onTap}) {
    return Material(
      color: const Color(0xFF9BFF83).withValues(alpha: .14),
      borderRadius: BorderRadius.circular(compact ? 13 : 30),
      child: InkWell(
        borderRadius: BorderRadius.circular(compact ? 13 : 30),
        onTap: onTap ?? _fullscreenToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: EdgeInsets.symmetric(horizontal: compact ? 10 : 13, vertical: compact ? 9 : 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 13 : 30),
            border: Border.all(color: const Color(0xFF9BFF83).withValues(alpha: .7)),
            boxShadow: const [BoxShadow(color: Color(0x4400E676), blurRadius: 12)]),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(_fullscreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
              color: const Color(0xFFB8FF9B), size: compact ? 22 : 20),
            if (!compact) ...[
              const SizedBox(width: 7),
              Text(_fullscreen ? 'Свернуть' : 'На весь экран',
                style: const TextStyle(color: Color(0xFFB8FF9B), fontSize: 10, fontWeight: FontWeight.w800)),
            ],
          ]),
        ),
      ),
    );
  }

  Widget _portraitAction(IconData icon, String label, VoidCallback onTap) => InkWell(
    borderRadius: BorderRadius.circular(14), onTap: onTap,
    child: Padding(padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(children: [
        Icon(icon, color: Colors.white, size: 26),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 10)),
      ])));

  Widget _bigSeek(IconData icon, String label, VoidCallback onTap) => Column(
    mainAxisSize: MainAxisSize.min, children: [
      IconButton(onPressed: onTap, icon: Icon(icon, color: Colors.white, size: 34)),
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
    ]);

  Widget _playButton(bool playing, {bool large = false}) => Container(
    width: large ? 76 : 62, height: large ? 76 : 62,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: const Color(0xFF9BFF83).withValues(alpha: .18),
      border: Border.all(color: const Color(0xFFB8FF9B), width: 1.5),
      boxShadow: const [BoxShadow(color: Color(0x9900E676), blurRadius: 24, spreadRadius: 2)]),
    child: IconButton(
      onPressed: _playPause,
      iconSize: large ? 44 : 38,
      color: const Color(0xFFB8FF9B),
      icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
    ));

  Widget _badge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
    decoration: BoxDecoration(color: const Color(0xFF102719), borderRadius: BorderRadius.circular(30),
      border: Border.all(color: const Color(0xFF9BFF83).withValues(alpha: .6))),
    child: Text('VIPER // $_code', style: const TextStyle(color: Color(0xFFB8FF9B),
      fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2)));

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
