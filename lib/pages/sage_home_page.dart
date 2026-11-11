import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:viper/pages/agent_selection_page.dart';
import 'package:viper/pages/sage_video_player_page.dart';
import 'package:viper/theme/sage_theme.dart';

class SageHomePage extends StatefulWidget {
  const SageHomePage({super.key});

  @override
  State<SageHomePage> createState() => _SageHomePageState();
}

class _SageHomePageState extends State<SageHomePage> {
  static const _agentId = '569fdd95-4d10-43ab-ca70-79becc718b46';
  static const _portrait = 'https://media.valorant-api.com/agents/$_agentId/fullportrait.png';
  static const _background = 'https://media.valorant-api.com/agents/$_agentId/background.png';
  static const _abilityBase = 'https://media.valorant-api.com/agents/$_agentId/abilities';
  static const _videoBase = 'https://cmsassets.rgpub.io/sanity/files/dsfx7636/game_data/';

  static const _abilities = <_SageAbility>[
    _SageAbility('C', 'СФЕРА БАРЬЕРА', 'Создаёт прочную ледяную стену, перекрывающую проход и меняющую геометрию боя.', '$_abilityBase/grenade/displayicon.png', '${_videoBase}a247d196383136d3de15b4d6d9c816e3c8054ba0.mp4'),
    _SageAbility('Q', 'СФЕРА ЗАМЕДЛЕНИЯ', 'Разбивает сферу о землю и создаёт поле, замедляющее проходящих через него противников.', '$_abilityBase/ability1/displayicon.png', '${_videoBase}df83929ed5da349c37a5bf4600c2b55010c72402.mp4'),
    _SageAbility('E', 'СФЕРА ЛЕЧЕНИЯ', 'Восстанавливает здоровье себе или раненому союзнику.', '$_abilityBase/ability2/displayicon.png', '${_videoBase}45053483528b96cbe003ac39e6b53c9866d5fea6.mp4'),
    _SageAbility('X', 'ВОЗРОЖДЕНИЕ', 'Возвращает павшего союзника к жизни. Последний шанс переломить ход раунда.', '$_abilityBase/ultimate/displayicon.png', '${_videoBase}a79b1d6838cee5572b428babd74a2db0c07f4ea5.mp4'),
  ];

  static const _voices = <_SageVoice>[
    _SageVoice('ПИК АГЕНТА', '«Я могу быть и щитом, и мечом — помните об этом».', 'SagePick.mp3', 'ПЕРЕД НАЧАЛОМ МАТЧА'),
    _SageVoice('БАРЬЕР УСТАНОВЛЕН', '«Стена готова».', 'SageBarr1.mp3', 'СФЕРА БАРЬЕРА'),
    _SageVoice('БАРЬЕР УСТАНОВЛЕН', '«Стена готова».', 'SageBarr2.mp3', 'СФЕРА БАРЬЕРА'),
    _SageVoice('БАРЬЕР УСТАНОВЛЕН', '«Барьер установлен».', 'SageBarr3.mp3', 'СФЕРА БАРЬЕРА'),
    _SageVoice('БАРЬЕР УСТАНОВЛЕН', '«Барьер установлен».', 'SageBarr4.mp3', 'СФЕРА БАРЬЕРА'),
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _playingFile;
  String? _audioError;
  StreamSubscription<void>? _audioCompleteSubscription;

  @override
  void initState() {
    super.initState();
    _audioCompleteSubscription = _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _playingFile = null);
    });
  }

  @override
  void dispose() {
    _audioCompleteSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playVoice(_SageVoice voice) async {
    final url = 'https://valorant.fandom.com/ru/wiki/Special:Redirect/file/${Uri.encodeComponent(voice.file)}';
    try {
      if (_playingFile == voice.file) {
        await _audioPlayer.stop();
        if (mounted) setState(() => _playingFile = null);
        return;
      }
      await _audioPlayer.stop();
      if (mounted) setState(() { _playingFile = voice.file; _audioError = null; });
      await _audioPlayer.play(UrlSource(url));
    } catch (_) {
      if (!mounted) return;
      setState(() { _playingFile = null; _audioError = 'Не удалось загрузить аудио. Проверь подключение или открой источник в браузере.'; });
    }
  }

  void _openVideo(_SageAbility ability) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => SageVideoPlayerPage(title: ability.title, videoUrl: ability.videoUrl, code: ability.code),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: SageTheme.dark,
      child: Scaffold(
        backgroundColor: SageTheme.background,
        body: Stack(children: [
          const Positioned.fill(child: _IceParticles()),
          CustomScrollView(slivers: [
            SliverToBoxAdapter(child: SizedBox(
              height: 440,
              child: Stack(fit: StackFit.expand, children: [
                Image.network(_background, fit: BoxFit.cover, alignment: Alignment.topCenter,
                  errorBuilder: (_, _, _) => const ColoredBox(color: Color(0xFF102B3A))),
                Image.network(_portrait, fit: BoxFit.contain, alignment: Alignment.bottomRight,
                  errorBuilder: (_, _, _) => const SizedBox.shrink()),
                const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Color(0x5507131C), Color(0x2207131C), Color(0xFF07131C)],
                  stops: [0, .45, 1],
                ))),
                SafeArea(child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [
                      _BackButton(onTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(builder: (_) => const AgentSelectionPage()),
                      )),
                      const SizedBox(width: 12),
                      const Text('PROTOCOL ARCHIVE', style: TextStyle(color: SageTheme.ice, fontSize: 9, letterSpacing: 1.8, fontWeight: FontWeight.w800)),
                      const Spacer(),
                      const _StatusPill(),
                    ]),
                    const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('AGENT PROFILE  //  S-07', style: TextStyle(color: SageTheme.cyan, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w800)),
                      SizedBox(height: 4),
                      Text('SAGE', style: TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.w900, letterSpacing: 3, shadows: [Shadow(color: Color(0xAA70D8E8), blurRadius: 24)])),
                      Text('ТВОЯ ОБЯЗАННОСТЬ ЕЩЁ НЕ ВЫПОЛНЕНА', style: TextStyle(color: SageTheme.ice, fontSize: 9, letterSpacing: 1.1, fontWeight: FontWeight.w700)),
                    ]),
                  ]),
                )),
              ]),
            )),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 36),
              sliver: SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const _Eyebrow('AGENT DOSSIER  //  CLASSIFIED'),
                const SizedBox(height: 12),
                const Text('СПОКОЙСТВИЕ.\nЗАЩИТА.\nВОЗРОЖДЕНИЕ.', style: TextStyle(color: SageTheme.ice, fontSize: 27, height: 1.08, fontWeight: FontWeight.w900, letterSpacing: 1)),
                const SizedBox(height: 14),
                const Text('Линь Инь Вэй — страж из Китая. Сейдж удерживает линию фронта, защищает союзников и возвращает их в бой. Её сила — не в разрушении, а в способности не дать команде пасть.',
                  style: TextStyle(color: SageTheme.muted, fontSize: 13, height: 1.6)),
                const SizedBox(height: 18),
                const Wrap(spacing: 8, runSpacing: 8, children: [
                  _InfoChip(icon: Icons.health_and_safety_outlined, label: 'СТРАЖ'),
                  _InfoChip(icon: Icons.favorite_border_rounded, label: 'ПОДДЕРЖКА'),
                  _InfoChip(icon: Icons.public_rounded, label: 'КИТАЙ'),
                ]),
                const SizedBox(height: 30),
                const _SectionTitle(kicker: 'OFFICIAL RIOT FOOTAGE', title: 'АРСЕНАЛ // ВИДЕО'),
                const SizedBox(height: 7),
                const Text('Официальные видеоролики способностей с CDN Riot Games. Нажми на карточку, чтобы открыть плеер.',
                  style: TextStyle(color: SageTheme.muted, fontSize: 11, height: 1.5)),
                const SizedBox(height: 14),
                ..._abilities.map((ability) => Padding(
                  padding: const EdgeInsets.only(bottom: 11),
                  child: _AbilityCard(ability: ability, onTap: () => _openVideo(ability)),
                )),
                const SizedBox(height: 22),
                const _SectionTitle(kicker: 'VOICE RECORDINGS // RU', title: 'ГОЛОСОВОЙ АРХИВ'),
                const SizedBox(height: 7),
                const Text('Русская озвучка. Сейчас подключены найденные и подтверждённые записи с русской страницы архива Sage.',
                  style: TextStyle(color: SageTheme.muted, fontSize: 11, height: 1.5)),
                if (_audioError != null) ...[
                  const SizedBox(height: 10),
                  Text(_audioError!, style: const TextStyle(color: Color(0xFFFFB4AB), fontSize: 11)),
                ],
                const SizedBox(height: 12),
                ..._voices.map((voice) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _VoiceCard(
                    voice: voice,
                    isPlaying: _playingFile == voice.file,
                    onTap: () => _playVoice(voice),
                  ),
                )),
                const SizedBox(height: 10),
                const _QuoteCard(
                  quote: '«Я могу быть и щитом, и мечом — помните об этом».',
                  attribution: 'SAGE // ФРАЗА ПРИ ВЫБОРЕ АГЕНТА',
                ),
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(builder: (_) => const AgentSelectionPage()),
                  ),
                  icon: const Icon(Icons.swap_horiz_rounded),
                  label: const Text('ВЫБРАТЬ ДРУГОГО АГЕНТА'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: SageTheme.ice,
                    side: BorderSide(color: SageTheme.cyan.withValues(alpha: .5)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                )),
                const SizedBox(height: 20),
                const Center(child: Text('SAGE // RADIANT ARCHIVE  •  END OF FILE', style: TextStyle(color: Color(0xFF557D8A), fontSize: 8, letterSpacing: 1.5))),
              ])),
            ),
          ]),
        ]),
      ),
    );
  }
}

class _SageAbility {
  const _SageAbility(this.code, this.title, this.description, this.image, this.videoUrl);
  final String code, title, description, image, videoUrl;
}

class _SageVoice {
  const _SageVoice(this.title, this.quote, this.file, this.group);
  final String title, quote, file, group;
}

class _AbilityCard extends StatelessWidget {
  const _AbilityCard({required this.ability, required this.onTap});
  final _SageAbility ability;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: SageTheme.surface.withValues(alpha: .96),
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: SageTheme.cyan.withValues(alpha: .2)),
      boxShadow: const [BoxShadow(color: Color(0x1870D8E8), blurRadius: 18)],
    ),
    child: Column(children: [
      Row(children: [
        Container(width: 50, height: 50, decoration: BoxDecoration(
          color: SageTheme.elevated, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: SageTheme.cyan.withValues(alpha: .35)),
        ), child: Padding(padding: const EdgeInsets.all(7), child: Image.network(ability.image, fit: BoxFit.contain,
          errorBuilder: (_, _, _) => const Icon(Icons.auto_awesome_rounded, color: SageTheme.ice, size: 24)))),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${ability.code}  //  ${ability.title}', style: const TextStyle(color: SageTheme.ice, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: .6)),
          const SizedBox(height: 6),
          Text(ability.description, style: const TextStyle(color: SageTheme.muted, fontSize: 11, height: 1.45)),
        ])),
      ]),
      const SizedBox(height: 13),
      SizedBox(width: double.infinity, child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
        label: const Text('СМОТРЕТЬ ВИДЕО СПОСОБНОСТИ'),
        style: OutlinedButton.styleFrom(
          foregroundColor: SageTheme.ice,
          side: BorderSide(color: SageTheme.cyan.withValues(alpha: .4)),
          backgroundColor: SageTheme.cyan.withValues(alpha: .06),
          textStyle: const TextStyle(fontSize: 9, letterSpacing: .8, fontWeight: FontWeight.w900),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      )),
    ]),
  );
}

class _VoiceCard extends StatelessWidget {
  const _VoiceCard({required this.voice, required this.isPlaying, required this.onTap});
  final _SageVoice voice;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: SageTheme.surface,
    borderRadius: BorderRadius.circular(14),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12), child: Row(children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(
          color: SageTheme.elevated, shape: BoxShape.circle,
          border: Border.all(color: SageTheme.cyan.withValues(alpha: .35)),
        ), child: Icon(isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded, color: SageTheme.ice)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(voice.title, style: const TextStyle(color: SageTheme.ice, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: .6)),
          const SizedBox(height: 4),
          Text(voice.quote, style: const TextStyle(color: SageTheme.muted, fontSize: 11, height: 1.35)),
          const SizedBox(height: 4),
          Text(voice.group, style: const TextStyle(color: SageTheme.cyan, fontSize: 8, letterSpacing: 1)),
        ])),
        Icon(isPlaying ? Icons.graphic_eq_rounded : Icons.headphones_rounded, color: SageTheme.cyan, size: 18),
      ])),
    ),
  );
}

class _IceParticles extends StatefulWidget {
  const _IceParticles();
  @override
  State<_IceParticles> createState() => _IceParticlesState();
}

class _IceParticlesState extends State<_IceParticles> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 16))..repeat();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => IgnorePointer(child: AnimatedBuilder(
    animation: _controller,
    builder: (context, _) => CustomPaint(painter: _IcePainter(_controller.value)),
  ));
}

class _IcePainter extends CustomPainter {
  const _IcePainter(this.progress);
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;
    final paint = Paint()..color = SageTheme.ice.withValues(alpha: .22);
    for (var i = 0; i < 34; i++) {
      final x = ((i * 67.0) % size.width);
      final baseY = ((i * 113.0) % size.height);
      final y = (baseY + progress * (24 + (i % 5) * 12)) % size.height;
      canvas.drawCircle(Offset(x, y), 1.0 + (i % 3) * .45, paint);
    }
  }
  @override
  bool shouldRepaint(covariant _IcePainter oldDelegate) => oldDelegate.progress != progress;
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0xAA102532),
    shape: const CircleBorder(side: BorderSide(color: Color(0x6670D8E8))),
    child: InkWell(customBorder: const CircleBorder(), onTap: onTap,
      child: const Padding(padding: EdgeInsets.all(9), child: Icon(Icons.arrow_back_rounded, color: SageTheme.ice, size: 19))),
  );
}

class _StatusPill extends StatelessWidget {
  const _StatusPill();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: SageTheme.surface, borderRadius: BorderRadius.circular(30), border: Border.all(color: SageTheme.cyan.withValues(alpha: .4))),
    child: const Text('CLASSIFIED', style: TextStyle(color: SageTheme.ice, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 1.1)),
  );
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.value);
  final String value;
  @override
  Widget build(BuildContext context) => Text(value, style: const TextStyle(color: SageTheme.cyan, fontSize: 8, letterSpacing: 1.5, fontWeight: FontWeight.w800));
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.kicker, required this.title});
  final String kicker, title;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(kicker, style: const TextStyle(color: SageTheme.cyan, fontSize: 8, letterSpacing: 1.7, fontWeight: FontWeight.w800)),
    const SizedBox(height: 4),
    Text(title, style: const TextStyle(color: SageTheme.ice, fontSize: 21, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
  ]);
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
    decoration: BoxDecoration(color: SageTheme.surface, borderRadius: BorderRadius.circular(30), border: Border.all(color: SageTheme.cyan.withValues(alpha: .2))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: SageTheme.cyan, size: 14),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(color: SageTheme.ice, fontSize: 8, fontWeight: FontWeight.w800, letterSpacing: .6)),
    ]),
  );
}

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({required this.quote, required this.attribution});
  final String quote, attribution;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: SageTheme.surface, borderRadius: BorderRadius.circular(17), border: Border.all(color: SageTheme.cyan.withValues(alpha: .22))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Icon(Icons.format_quote_rounded, color: SageTheme.cyan, size: 25),
      const SizedBox(height: 8),
      Text(quote, style: const TextStyle(color: SageTheme.ice, fontSize: 13, height: 1.55, fontStyle: FontStyle.italic)),
      const SizedBox(height: 12),
      Text(attribution, style: const TextStyle(color: SageTheme.muted, fontSize: 8, letterSpacing: 1.2, fontWeight: FontWeight.w800)),
    ]),
  );
}
