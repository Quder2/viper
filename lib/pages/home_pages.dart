import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:viper/pages/full_story_page.dart';
import 'package:viper/features/viper/toxic_lab/toxic_lab_page.dart';
import 'package:viper/theme/viper_theme.dart';
import 'package:viper/widgets/local_video_player_page.dart';
import 'package:viper/widgets/toxic_particles.dart';
import 'package:viper/widgets/video_asset_thumbnail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final AnimationController _heroMotion = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 18),
  )..repeat(reverse: true);

  static const _abilities = <_AbilityData>[
    _AbilityData(
      code: 'C',
      title: 'Змеиный укус',
      image: 'assets/abilities/C.png',
      sound: 'sound/C_act.mp3',
      description: 'ВЫБИРАЕТ капсулу с кислотой. Нажмите кнопку ОГОНЬ, чтобы запустить капсулу, которая разбивается при падении, оставляя после себя лужу кислоты. Попавшие в кислоту противники получают урон и становятся уязвимыми.',
      video: 'assets/videos/viper_ability_C.mp4',
      preview: 'assets/images/2.png',
    ),
    _AbilityData(
      code: 'Q',
      title: 'Ядовитое облако',
      image: 'assets/abilities/Q.png',
      sound: 'sound/Q_act.mp3',
      description: 'ВЫБИРАЕТ распылитель газа. Нажмите кнопку ОГОНЬ, чтобы выбросить распылитель, который остается на месте до конца раунда. Нажмите кнопку АЛЬТ. ОГОНЬ, чтобы сделать бросок снизу. Примените умение повторно, чтобы выпустить из распылителя облако ядовитого дыма, расходуя топливо. Можно использовать больше одного раза, а также подобрать и РАЗМЕСТИТЬ ЗАНОВО.',
      video: 'assets/videos/viper_ability_Q.mp4',
      preview: 'assets/images/3.png',
    ),
    _AbilityData(
      code: 'E',
      title: 'Токсичная завеса',
      image: 'assets/abilities/E.png',
      sound: 'sound/E_act.mp3',
      description: 'ВЫБИРАЕТ распылители газа, проникающие сквозь препятствия. Нажмите кнопку ОГОНЬ, чтобы выстрелить длинной очередью распылителей. При повторном использовании распылители образуют стену ядовитого дыма, расходуя топливо. Умение можно применять больше одного раза.',
      video: 'assets/videos/viper_ability_E.mp4',
      preview: 'assets/images/4.png',
    ),
    _AbilityData(
      code: 'ULT',
      title: 'Гнездо гадюки',
      image: 'assets/abilities/X.png',
      sound: 'sound/X_act.mp3',
      description: 'ВЫБИРАЕТ распылитель химикатов. Нажмите кнопку ОГОНЬ, чтобы распылить вокруг Viper облако химикатов, уменьшая дальность видимости игроков и максимальный запас здоровья находящихся в нем врагов. УДЕРЖИВАЙТЕ кнопку умения, чтобы остановить распыление.',
      video: 'assets/videos/viper_ability_ult.mp4',
      preview: 'assets/images/1.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _heroMotion;
  }

  Future<void> _playSound(String asset) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(asset));
  }

  void _openStory() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const FullStoryPage()),
    );
  }

  void _openToxicLab() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ToxicLabPage()),
    );
  }

  void _openVideo(_AbilityData ability) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LocalVideoPlayerPage(
          title: ability.title,
          assetPath: ability.video,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _heroMotion.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ViperTheme.background,
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
                        'КОНТРОЛЬ.\nТОКСИНЫ.\nПОБЕДА.',
                        style: TextStyle(
                          color: Color(0xFFE2FFD8),
                          fontSize: 27,
                          height: 1.08,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Химик из США Viper устанавливает контроль над полем боя с помощью источающих токсичный газ устройств и ограничивает обзор противникам. А тех, кого ей не удастся отравить, она непременно перехитрит.',
                        style: TextStyle(
                          color: Color(0xFF9BB5A0),
                          height: 1.55,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 22),
                      const Row(
                        children: [
                          _DataChip(icon: Icons.shield_outlined, label: 'СПЕЦИАЛИСТ'),
                          SizedBox(width: 8),
                          _DataChip(icon: Icons.signal_cellular_alt, label: 'СЛОЖНОСТЬ  2/3'),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const _SectionHeading(
                        eyebrow: 'CHEMICAL LOADOUT',
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
                        eyebrow: 'TACTICAL FOOTAGE',
                        title: 'ВИДЕОАРХИВ',
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Записи способностей • локальные материалы',
                        style: TextStyle(
                          color: Color(0xFF77917D),
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
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
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
                      _ToxicLabButton(onTap: _openToxicLab),
                      const SizedBox(height: 12),
                      _StoryButton(onTap: _openStory),
                      const SizedBox(height: 24),
                      const Center(
                        child: Text(
                          'VIPER // TOXIC ARCHIVE  •  END OF FILE',
                          style: TextStyle(
                            color: Color(0xFF55745D),
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
            animation: _heroMotion,
            builder: (context, child) {
              final progress = _heroMotion.value;
              return ClipRect(
                child: Transform.translate(
                  offset: Offset(-9 + progress * 18, 0),
                  child: Transform.scale(
                    scale: 1.045 + progress * .045,
                    child: child,
                  ),
                ),
              );
            },
            child: Image.asset(
              'assets/images/1.png',
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
                      const Color(0xFF9BFF83).withValues(
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
          const IgnorePointer(
            child: ToxicParticles(particleCount: 26, opacity: .24),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xAA030A06),
                  Color(0x22030A06),
                  Color(0xFF030A06),
                ],
                stops: [0, .42, 1],
              ),
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
                    children: const [
                      Icon(Icons.shield_moon_outlined,
                          color: Color(0xFF9BFF83), size: 17),
                      SizedBox(width: 8),
                      Text(
                        'KINGDOM // PERSONNEL FILE',
                        style: TextStyle(
                          color: Color(0xFFB8FF9B),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.7,
                        ),
                      ),
                      Spacer(),
                      _StatusPill(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'AGENT  V-01',
                        style: TextStyle(
                          color: Color(0xFF9BFF83),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.4,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'VIPER',
                        style: TextStyle(
                          color: Color(0xFFE2FFD8),
                          fontSize: 54,
                          height: .98,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                          shadows: [
                            Shadow(color: Color(0x9900E676), blurRadius: 24),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '«ДА, ЭТО МОЙ МИР. НА КОЛЕНИ.»',
                        style: TextStyle(
                          color: Color(0xFFB8FF9B),
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
          color: Color(0xFF9BFF83),
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
              color: const Color(0xFF9BFF83),
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Color(0x8800E676), blurRadius: 12),
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
                  color: Color(0xFF77917D),
                  fontSize: 8,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFE2FFD8),
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
          color: const Color(0xFF0B1710),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF9BFF83).withValues(alpha: .2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: const Color(0xFF9BFF83)),
            const SizedBox(width: 7),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFB8FF9B),
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
          color: const Color(0xFF102719),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF9BFF83).withValues(alpha: .55)),
        ),
        child: const Row(
          children: [
            Icon(Icons.circle, color: Color(0xFF9BFF83), size: 6),
            SizedBox(width: 6),
            Text(
              'ACTIVE',
              style: TextStyle(
                color: Color(0xFFB8FF9B),
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
          color: const Color(0xD90B1710),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF9BFF83).withValues(alpha: .17)),
          boxShadow: const [
            BoxShadow(color: Color(0x2200E676), blurRadius: 18, spreadRadius: 1),
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
                    color: const Color(0xFF102719),
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: const Color(0xFF9BFF83).withValues(alpha: .25)),
                  ),
                  child: Image.asset(ability.image, fit: BoxFit.contain),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VIPER // ${ability.code}',
                        style: const TextStyle(
                          color: Color(0xFF9BFF83),
                          fontSize: 8,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ability.title.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFFE2FFD8),
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
                  icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF9BFF83)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              ability.description,
              style: const TextStyle(
                color: Color(0xFF9BB5A0),
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
                  foregroundColor: const Color(0xFFB8FF9B),
                  side: BorderSide(color: const Color(0xFF9BFF83).withValues(alpha: .45)),
                  backgroundColor: const Color(0xFF9BFF83).withValues(alpha: .07),
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
          color: const Color(0xFF101812),
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
                      colors: [Color(0x55030A06), Color(0xF5030A06)],
                    ),
                  ),
                ),
                Positioned(
                  top: 11,
                  left: 11,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF071B11).withValues(alpha: .85),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF9BFF83).withValues(alpha: .55)),
                    ),
                    child: Text(
                      'VIPER // ${ability.code}',
                      style: const TextStyle(
                        color: Color(0xFFB8FF9B),
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
                      color: Color(0xAA071B11),
                      border: Border.fromBorderSide(
                        BorderSide(color: Color(0xFFB8FF9B), width: 1.4),
                      ),
                      boxShadow: [
                        BoxShadow(color: Color(0x8800E676), blurRadius: 20),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.play_arrow_rounded, color: Color(0xFFB8FF9B), size: 30),
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
                      color: Color(0xFFE2FFD8),
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
        color: const Color(0xFF102719),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF9BFF83).withValues(alpha: .48)),
              boxShadow: const [
                BoxShadow(color: Color(0x3300E676), blurRadius: 18),
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.folder_special_outlined, color: Color(0xFFB8FF9B), size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ПОЛНОЕ ДОСЬЕ АГЕНТА',
                        style: TextStyle(
                          color: Color(0xFFE2FFD8),
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Биография • личность • внешность',
                        style: TextStyle(color: Color(0xFF9BB5A0), fontSize: 9),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF9BFF83), size: 15),
              ],
            ),
          ),
        ),
      );
}

class _ToxicLabButton extends StatelessWidget {
  const _ToxicLabButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: const Color(0xFF102719),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF9BFF83).withValues(alpha: .58)),
              boxShadow: const [BoxShadow(color: Color(0x4400E676), blurRadius: 18)],
            ),
            child: const Row(
              children: [
                Icon(Icons.science_outlined, color: Color(0xFFB8FF9B), size: 23),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TOXIC LAB  //  ИНТЕРАКТИВНАЯ ЛАБОРАТОРИЯ',
                        style: TextStyle(color: Color(0xFFE2FFD8), fontSize: 10,
                          fontWeight: FontWeight.w900, letterSpacing: .7)),
                      SizedBox(height: 4),
                      Text('Изучи способности • настрой эффекты • запусти демонстрацию',
                        style: TextStyle(color: Color(0xFF9BB5A0), fontSize: 9)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF9BFF83), size: 15),
              ],
            ),
          ),
        ),
      );
}
