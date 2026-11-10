import 'package:flutter/material.dart';
import 'package:viper/theme/viper_theme.dart';
import 'package:viper/widgets/local_video_player_page.dart';
import 'package:viper/widgets/toxic_particles.dart';

class ToxicLabPage extends StatefulWidget {
  const ToxicLabPage({super.key});

  @override
  State<ToxicLabPage> createState() => _ToxicLabPageState();
}

class _ToxicLabPageState extends State<ToxicLabPage>
    with SingleTickerProviderStateMixin {
  static const _abilities = <_LabAbility>[
    _LabAbility('C', 'ЗМЕИНЫЙ УКУС', 'Кислотная капсула', 'assets/abilities/C.png',
        'assets/images/2.png', 'assets/videos/viper_ability_C.mp4',
        'Кислота наносит урон и делает противников уязвимыми.'),
    _LabAbility('Q', 'ЯДОВИТОЕ ОБЛАКО', 'Токсичный распылитель', 'assets/abilities/Q.png',
        'assets/images/3.png', 'assets/videos/viper_ability_Q.mp4',
        'Сфера создаёт дымовую завесу и расходует запас топлива.'),
    _LabAbility('E', 'ТОКСИЧНАЯ ЗАВЕСА', 'Линия распылителей', 'assets/abilities/E.png',
        'assets/images/4.png', 'assets/videos/viper_ability_E.mp4',
        'Разворачивает протяжённую стену ядовитого дыма.'),
    _LabAbility('ULT', 'ГНЕЗДО ГАДЮКИ', 'Область химического заражения', 'assets/abilities/X.png',
        'assets/images/1.png', 'assets/videos/viper_ability_ult.mp4',
        'Облако ограничивает обзор и максимальный запас здоровья врагов.'),
  ];

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  int _selected = 0;
  bool _active = false;
  double _intensity = .72;

  _LabAbility get _ability => _abilities[_selected];

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _openRecording() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => LocalVideoPlayerPage(
        title: _ability.title,
        assetPath: _ability.video,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final ability = _ability;
    return Scaffold(
      backgroundColor: ViperTheme.background,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TOXIC LAB', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
            Text('VIPER // ABILITY SIMULATION',
                style: TextStyle(fontSize: 8, color: ViperTheme.secondaryText, letterSpacing: 1.5)),
          ],
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: IgnorePointer(child: ToxicParticles(particleCount: 30, opacity: .2))),
          ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 30),
            children: [
              const Text('ЛАБОРАТОРИЯ ТОКСИНОВ',
                  style: TextStyle(color: ViperTheme.toxicGreen, fontSize: 10,
                      fontWeight: FontWeight.w900, letterSpacing: 2)),
              const SizedBox(height: 7),
              const Text('Выбери способность и изучи её действие',
                  style: TextStyle(color: ViperTheme.secondaryText, fontSize: 12)),
              const SizedBox(height: 20),
              Row(
                children: List.generate(_abilities.length, (index) {
                  final item = _abilities[index];
                  final selected = index == _selected;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: index == _abilities.length - 1 ? 0 : 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(13),
                        onTap: () => setState(() { _selected = index; _active = false; }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: BoxDecoration(
                            color: selected ? ViperTheme.elevatedSurface : ViperTheme.surface,
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(color: selected ? ViperTheme.toxicGreen : ViperTheme.mutedGreen),
                            boxShadow: selected ? [const BoxShadow(color: Color(0x4400E676), blurRadius: 13)] : null,
                          ),
                          child: Column(children: [
                            Image.asset(item.icon, width: 29, height: 29, fit: BoxFit.contain),
                            const SizedBox(height: 5),
                            Text(item.code, style: TextStyle(
                              color: selected ? ViperTheme.toxicGreen : ViperTheme.secondaryText,
                              fontSize: 10, fontWeight: FontWeight.w900)),
                          ]),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 18),
              AnimatedBuilder(
                animation: _pulse,
                builder: (context, child) => Container(
                  height: 225,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: ViperTheme.toxicGreen.withValues(alpha: _active ? .45 + _pulse.value * .35 : .2)),
                    boxShadow: _active ? [BoxShadow(
                      color: ViperTheme.toxicGreen.withValues(alpha: .08 + _pulse.value * .12),
                      blurRadius: 22 + _pulse.value * 14)] : null,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: child,
                ),
                child: Stack(fit: StackFit.expand, children: [
                  Image.asset(ability.preview, fit: BoxFit.cover),
                  DecoratedBox(decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [Colors.black.withValues(alpha: .12), const Color(0xF5030A06)]))),
                  if (_active) const Positioned.fill(
                    child: IgnorePointer(child: ToxicParticles(particleCount: 42, opacity: .52))),
                  Positioned(left: 15, right: 15, bottom: 15, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('VIPER // ${ability.code}', style: const TextStyle(
                        color: ViperTheme.toxicGreen, fontSize: 9, letterSpacing: 1.8, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 5),
                      Text(ability.title, style: const TextStyle(
                        color: Color(0xFFE2FFD8), fontSize: 19, fontWeight: FontWeight.w900, letterSpacing: .8)),
                      const SizedBox(height: 4),
                      Text(_active ? 'СИСТЕМА АКТИВИРОВАНА' : 'СИСТЕМА ОЖИДАЕТ АКТИВАЦИИ',
                        style: TextStyle(color: _active ? ViperTheme.toxicGreen : ViperTheme.secondaryText,
                          fontSize: 9, letterSpacing: 1.2, fontWeight: FontWeight.w800)),
                    ],
                  )),
                ]),
              ),
              const SizedBox(height: 18),
              Text(ability.subtitle, style: const TextStyle(
                color: ViperTheme.brightGreen, fontSize: 14, fontWeight: FontWeight.w900)),
              const SizedBox(height: 7),
              Text(ability.description, style: const TextStyle(
                color: ViperTheme.secondaryText, fontSize: 12, height: 1.55)),
              const SizedBox(height: 20),
              Row(children: [
                const Expanded(child: Text('ИНТЕНСИВНОСТЬ ЭФФЕКТА',
                  style: TextStyle(color: ViperTheme.secondaryText, fontSize: 9,
                    letterSpacing: 1.1, fontWeight: FontWeight.w800))),
                Text('${(_intensity * 100).round()}%',
                  style: const TextStyle(color: ViperTheme.toxicGreen, fontWeight: FontWeight.w900)),
              ]),
              Slider(value: _intensity, onChanged: (value) => setState(() => _intensity = value)),
              const SizedBox(height: 12),
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => setState(() => _active = !_active),
                  icon: Icon(_active ? Icons.power_settings_new : Icons.science_outlined),
                  label: Text(_active ? 'ДЕАКТИВИРОВАТЬ' : 'АКТИВИРОВАТЬ СИСТЕМУ'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _active ? const Color(0xFF17351E) : ViperTheme.elevatedSurface,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: _openRecording,
                icon: const Icon(Icons.play_circle_outline_rounded),
                label: const Text('ОТКРЫТЬ ВИДЕОДЕМОНСТРАЦИЮ'),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
              ),
              const SizedBox(height: 16),
              const Text('SIMULATION NOTE',
                style: TextStyle(color: ViperTheme.toxicGreen, fontSize: 8,
                  letterSpacing: 1.7, fontWeight: FontWeight.w900)),
              const SizedBox(height: 5),
              const Text('Лаборатория демонстрирует визуальные эффекты и материалы досье. '
                  'Интенсивность влияет на оформление интерфейса, а не на игровую механику.',
                style: TextStyle(color: Color(0xFF718878), fontSize: 10, height: 1.5)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LabAbility {
  const _LabAbility(this.code, this.title, this.subtitle, this.icon,
      this.preview, this.video, this.description);
  final String code;
  final String title;
  final String subtitle;
  final String icon;
  final String preview;
  final String video;
  final String description;
}
