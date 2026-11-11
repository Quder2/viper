import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:viper/pages/sage_story_page.dart';
import 'package:viper/pages/agent_selection_page.dart';

import 'package:viper/theme/sage_theme.dart';
import 'package:viper/pages/sage_video_player_page.dart';
import 'package:viper/widgets/toxic_particles.dart';
import 'package:viper/widgets/video_asset_thumbnail.dart';

class SageHomePage extends StatefulWidget {
  const SageHomePage({super.key});

  @override
  State<SageHomePage> createState() => _SageHomePageState();
}

class _SageHomePageState extends State<SageHomePage> with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final AnimationController _heroMotion;
  late final AnimationController _heroPulse;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  late final AnimationController _tiltSmoothing;
  double _targetTiltX = 0;
  double _targetTiltY = 0;
  double _tiltX = 0;
  double _tiltY = 0;

  static const _abilities = <_AbilityData>[
    _AbilityData(
      code: 'C',
      title: 'Сфера барьера',
      image: 'assets/sage/abilities/barrier_orb.png',
      sound: 'sage/voice/C_act.mp3',
      description: 'Создаёт прочную ледяную стену, перекрывающую проход и меняющую геометрию боя. Используй её, чтобы закрыть опасное направление или поднять союзника на неожиданную позицию.',
      video: 'assets/sage/videos/barrier_orb.mp4',
      preview: 'assets/sage/images/1.jpg',
    ),
    _AbilityData(
      code: 'Q',
      title: 'Сфера замедления',
      image: 'assets/sage/abilities/slow_orb.png',
      sound: 'sage/voice/Q_act.mp3',
      description: 'Разбивает сферу о землю и создаёт поле, замедляющее проходящих через него противников. Осколки выдают движение врагов.',
      video: 'assets/sage/videos/slow_orb.mp4',
      preview: 'assets/sage/images/1.jpg',
    ),
    _AbilityData(
      code: 'E',
      title: 'Сфера лечения',
      image: 'assets/sage/abilities/healing_orb.png',
      sound: 'sage/voice/E_act.mp3',
      description: 'Восстанавливает здоровье себе или раненому союзнику. Выбери цель и верни её в бой.',
      video: 'assets/sage/videos/healing_orb.mp4',
      preview: 'assets/sage/images/1.jpg',
    ),
    _AbilityData(
      code: 'ULT',
      title: 'Воскрешение',
      image: 'assets/sage/abilities/resurrection.png',
      sound: 'sage/voice/X_act.mp3',
      description: 'Возвращает павшего союзника к жизни. Последний шанс переломить ход раунда.',
      video: 'assets/sage/videos/resurrection.mp4',
      preview: 'assets/sage/images/1.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _heroMotion = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat(reverse: true);
    _heroPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _heroPulse.reverse();
        }
      });
    // Sensor readings update targets; visual movement is interpolated on Flutter frames.
    _tiltSmoothing = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )
      ..addListener(_smoothDeviceTilt)
      ..repeat();
    _accelerometerSubscription = accelerometerEventStream().listen(
      _handleDeviceTilt,
      onError: (_) {},
    );
  }

  void _handleDeviceTilt(AccelerometerEvent event) {
    _targetTiltX = (event.z / 9.8).clamp(-1.0, 1.0).toDouble();
    _targetTiltY = (event.x / 9.8).clamp(-1.0, 1.0).toDouble();
  }

  void _smoothDeviceTilt() {
    if (!mounted) return;
    // A small per-frame interpolation removes sensor jitter without adding lag.
    const smoothing = .085;
    final nextX = _tiltX + (_targetTiltX - _tiltX) * smoothing;
    final nextY = _tiltY + (_targetTiltY - _tiltY) * smoothing;
    if ((nextX - _tiltX).abs() < .0005 &&
        (nextY - _tiltY).abs() < .0005) {
      return;
    }
    setState(() {
      _tiltX = nextX;
      _tiltY = nextY;
    });
  }

  void _triggerHeroPulse() {
    _heroPulse.forward(from: 0);
  }

  Future<void> _playSound(String asset) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(asset));
  }

  void _openAgentSelection() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const AgentSelectionPage()),
    );
  }

  void _openStory() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SageStoryPage()),
    );
  }

  void _openVideo(_AbilityData ability) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SageVideoPlayerPage(
          title: ability.title,
          assetPath: ability.video,
          code: ability.code,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _tiltSmoothing.dispose();
    _heroMotion.dispose();
    _heroPulse.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SageTheme.background,
      body: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(child: ToxicParticles()),
          ),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHero()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 24, 18, 36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _ArchiveLabel('AGENT DOSSIER  //  CLASSIFIED'),
                      const SizedBox(height: 12),
                      const Text(
                        'СПОКОЙСТВИЕ.\nЗАЩИТА.\nВОЗРОЖДЕНИЕ.',
                        style: TextStyle(
                          color: SageTheme.textPrimary,
                          fontSize: 27,
                          height: 1.08,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Химик из США Sage устанавливает контроль над полем боя с помощью источающих токсичный газ устройств и ограничивает обзор противникам. А тех, кого ей не удастся отравить, она непременно перехитрит.',
                        style: TextStyle(
                          color: SageTheme.muted,
                          height: 1.55,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Row(
                        children: [
                          _DataChip(icon: Icons.shield_outlined, label: 'СТРАЖ'),
                          SizedBox(width: 8),
                          _DataChip(icon: Icons.signal_cellular_alt, label: 'СЛОЖНОСТЬ  2/3'),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const _SectionHeading(
                        eyebrow: 'RADIANT LOADOUT',
                        title: 'АРСЕНАЛ',
                      ),
                      const SizedBox(height: 14),
                      ..._abilities.map(
                        (ability) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _AbilityPanel(
                            ability: ability,
                            onSound: () => _playSound(ability.sound),
                            onVideo: () => _openVideo(ability),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      const _SectionHeading(
                        eyebrow: 'RADIANT FOOTAGE',
                        title: 'ВИДЕОАРХИВ',
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Записи способностей • локальные материалы',
                        style: TextStyle(
                          color: SageTheme.mutedBright,
                          fontSize: 11,
                          letterSpacing: .5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 184,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _abilities.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final ability = _abilities[index];
                            return _VideoArchiveCard(
                              ability: ability,
                              onTap: () => _openVideo(ability),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 28),
                      _StoryButton(onTap: _openStory),
                      const SizedBox(height: 24),
                      const Center(
                        child: Text(
                          'SAGE // RADIANT ARCHIVE  •  END OF FILE',
                          style: TextStyle(
                            color: SageTheme.mutedDeep,
                            fontSize: 8,
                            letterSpacing: 1.7,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return SizedBox(
      height: 430,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_heroMotion, _heroPulse]),
            builder: (context, child) {
              final idle = _heroMotion.value;
              final pulse = math.sin(_heroPulse.value * math.pi);
              return ClipRect(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, .0012)
                    ..rotateX(_tiltX * -.14)
                    ..rotateY(_tiltY * .14),
                  child: Transform.translate(
                    offset: Offset(
                      -9 + idle * 18 + _tiltY * -30,
                      _tiltX * -26,
                    ),
                    child: Transform.scale(
                      scale: 1.045 + idle * .045 + pulse * .035,
                      child: child,
                    ),
                  ),
                ),
              );
            },
            child: Image.asset(
              'assets/sage/images/1.jpg',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _heroMotion,
              builder: (context, child) => DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      -.55 + _heroMotion.value * 1.1,
                      -.35,
                    ),
                    radius: 1.15,
                    colors: [
                      const SageTheme.cyan.withValues(
                        alpha: .035 + _heroMotion.value * .035,
                      ),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: child,
              ),
              child: const SizedBox.expand(),
            ),
          ),
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _heroPulse,
              builder: (context, child) => Opacity(
                opacity: .24 + _heroPulse.value * .5,
                child: Transform.scale(
                  scale: 1 + _heroPulse.value * .16,
                  child: child,
                ),
              ),
              child: const ToxicParticles(particleCount: 26, opacity: .24, color: SageTheme.toxicGreen),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  SageTheme.overlayTop,
                  SageTheme.overlayMid,
                  SageTheme.background,
                ],
                stops: [0, .42, 1],
              ),
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _triggerHeroPulse,
            ),
          ),
          Positioned(
            right: 20,
            bottom: 96,
            child: IgnorePointer(
              child: _TiltHint(tilt: _tiltX.abs() + _tiltY.abs()),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Material(
                        color: const SageTheme.overlayButton,
                        shape: const CircleBorder(
                          side: BorderSide(color: SageTheme.outlineSoft),
                        ),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: _openAgentSelection,
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.grid_view_rounded,
                                color: SageTheme.ice, size: 17),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.shield_moon_outlined,
                          color: SageTheme.cyan, size: 17),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'PROTOCOL // PERSONNEL FILE',
                          style: TextStyle(
                            color: SageTheme.ice,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.7,
                          ),
                        ),
                      ),
                      const _StatusPill(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'AGENT  S-07',
                        style: TextStyle(
                          color: SageTheme.cyan,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.4,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'SAGE',
                        style: TextStyle(
                          color: SageTheme.textPrimary,
                          fontSize: 54,
                          height: .98,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                          shadows: [
                            Shadow(color: SageTheme.glowStrong, blurRadius: 24),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '«ТВОЯ ОБЯЗАННОСТЬ ЕЩЁ НЕ ВЫПОЛНЕНА.»',
                        style: TextStyle(
                          color: SageTheme.ice,
                          fontSize: 10,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TiltHint extends StatelessWidget {
  const _TiltHint({required this.tilt});

  final double tilt;

  @override
  Widget build(BuildContext context) {
    final active = tilt > .12;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const SageTheme.overlayHint,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const SageTheme.cyan.withValues(alpha: active ? .7 : .28),
        ),
        boxShadow: [
          BoxShadow(
            color: const SageTheme.cyan.withValues(alpha: active ? .16 : .04),
            blurRadius: active ? 18 : 8,
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.screen_rotation_alt, color: SageTheme.ice, size: 13),
          SizedBox(width: 7),
          Text(
            'НАКЛОНЯЙ УСТРОЙСТВО',
            style: TextStyle(
              color: SageTheme.ice,
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: .8,
            ),
          ),
        ],
      ),
    );
  }
}

class _AbilityData {
  const _AbilityData({
    required this.code,
    required this.title,
    required this.image,
    required this.sound,
    required this.description,
    required this.video,
    required this.preview,
  });

  final String code;
  final String title;
  final String image;
  final String sound;
  final String description;
  final String video;
  final String preview;
}

class _ArchiveLabel extends StatelessWidget {
  const _ArchiveLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          color: SageTheme.cyan,
          fontSize: 9,
          letterSpacing: 1.8,
          fontWeight: FontWeight.w800,
        ),
      );
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.eyebrow, required this.title});
  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 3,
            height: 34,
            decoration: BoxDecoration(
              color: const SageTheme.cyan,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: SageTheme.glowMedium, blurRadius: 12),
              ],
            ),
          ),
          const SizedBox(width: 11),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: const TextStyle(
                  color: SageTheme.mutedBright,
                  fontSize: 8,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: const TextStyle(
                  color: SageTheme.textPrimary,
                  fontSize: 19,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      );
}

class _DataChip extends StatelessWidget {
  const _DataChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
        decoration: BoxDecoration(
          color: const SageTheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const SageTheme.cyan.withValues(alpha: .2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const SageTheme.cyan),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(
                color: SageTheme.ice,
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: .8,
              ),
            ),
          ],
        ),
      );
}

class _StatusPill extends StatelessWidget {
  const _StatusPill();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const SageTheme.elevated,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const SageTheme.cyan.withValues(alpha: .55)),
        ),
        child: const Row(
          children: [
            Icon(Icons.circle, color: SageTheme.cyan, size: 6),
            SizedBox(width: 6),
            Text(
              'ACTIVE',
              style: TextStyle(
                color: SageTheme.ice,
                fontSize: 8,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      );
}

class _AbilityPanel extends StatelessWidget {
  const _AbilityPanel({
    required this.ability,
    required this.onSound,
    required this.onVideo,
  });

  final _AbilityData ability;
  final VoidCallback onSound;
  final VoidCallback onVideo;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const SageTheme.panelGlass,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const SageTheme.cyan.withValues(alpha: .17)),
          boxShadow: const [
            BoxShadow(color: SageTheme.glowSubtle, blurRadius: 18, spreadRadius: 1),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const SageTheme.elevated,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: const SageTheme.cyan.withValues(alpha: .25)),
                  ),
                  child: Image.asset(ability.image, fit: BoxFit.contain),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SAGE // ${ability.code}',
                        style: const TextStyle(
                          color: SageTheme.cyan,
                          fontSize: 8,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ability.title.toUpperCase(),
                        style: const TextStyle(
                          color: SageTheme.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: .7,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Прослушать звук способности',
                  onPressed: onSound,
                  icon: const Icon(Icons.volume_up_rounded, color: SageTheme.cyan),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              ability.description,
              style: const TextStyle(
                color: SageTheme.muted,
                fontSize: 11,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 13),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onVideo,
                icon: const Icon(Icons.play_arrow_rounded, size: 19),
                label: const Text('ОТКРЫТЬ ЗАПИСЬ'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const SageTheme.ice,
                  side: BorderSide(color: const SageTheme.cyan.withValues(alpha: .45)),
                  backgroundColor: const SageTheme.cyan.withValues(alpha: .07),
                  textStyle: const TextStyle(
                    fontSize: 9,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w900,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                ),
              ),
            ),
          ],
        ),
      );
}


int _previewTimeForAbility(String code) => switch (code) {
      'C' => 2200,
      'Q' => 2600,
      'E' => 2400,
      'ULT' => 3200,
      _ => 1800,
    };

class _VideoArchiveCard extends StatelessWidget {
  const _VideoArchiveCard({required this.ability, required this.onTap});
  final _AbilityData ability;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: 238,
        child: Material(
          color: const SageTheme.deepSurface,
          borderRadius: BorderRadius.circular(17),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              fit: StackFit.expand,
              children: [
                VideoAssetThumbnail(
                  videoAsset: ability.video,
                  fallbackAsset: ability.preview,
                  timeMs: _previewTimeForAbility(ability.code),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x5507131C), Color(0xF507131C)],
                    ),
                  ),
                ),
                Positioned(
                  top: 11,
                  left: 11,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: const SageTheme.surface.withValues(alpha: .85),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const SageTheme.cyan.withValues(alpha: .55)),
                    ),
                    child: Text(
                      'SAGE // ${ability.code}',
                      style: const TextStyle(
                        color: SageTheme.ice,
                        fontSize: 8,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: SageTheme.overlayButton,
                      border: Border.fromBorderSide(
                        BorderSide(color: SageTheme.ice, width: 1.4),
                      ),
                      boxShadow: [
                        BoxShadow(color: SageTheme.glowMedium, blurRadius: 20),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.play_arrow_rounded, color: SageTheme.ice, size: 30),
                    ),
                  ),
                ),
                Positioned(
                  left: 13,
                  right: 13,
                  bottom: 12,
                  child: Text(
                    ability.title.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: SageTheme.textPrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _StoryButton extends StatelessWidget {
  const _StoryButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: const SageTheme.elevated,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const SageTheme.cyan.withValues(alpha: .48)),
              boxShadow: const [
                BoxShadow(color: Color(0x3339B9D3), blurRadius: 18),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.folder_special_outlined, color: SageTheme.ice, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ПОЛНОЕ ДОСЬЕ АГЕНТА',
                        style: TextStyle(
                          color: SageTheme.textPrimary,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Биография • личность • внешность',
                        style: TextStyle(color: SageTheme.muted, fontSize: 9),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: SageTheme.cyan, size: 15),
              ],
            ),
          ),
        ),
      );
}

