import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:viper/theme/viper_theme.dart';
import 'package:viper/widgets/toxic_particles.dart';

class FullStoryPage extends StatefulWidget {
  const FullStoryPage({super.key});

  @override
  State<FullStoryPage> createState() => _FullStoryPageState();

  static const _sections = <_StorySection>[
    _StorySection(
      code: '01',
      title: 'БИОГРАФИЯ',
      text: 'Сабина Каллас родом из США, возможно, связана с Сиэтлом. Обладая докторской степенью и такими наградами, как премия Р. Фрэнсиса и премия Дентона за выдающиеся инновации, ее предыдущая работа включала должность в Kingdom Corporation, в конечном итоге став ее первым главным научным сотрудником в совете консультантов, а также влияние на предприятия конгломерата в Рабате, Марокко. Ее коллеги-агенты также предположили, что раньше она была своего рода целительницей. Однако в какой-то момент во время ее пребывания в Kingdom произошел «инцидент». Мало что известно о том, что произошло, но в тот момент для Каллас все изменилось после всего, что она потеряла из-за этого, изолировавшись и посвятив себя вместо этого мести.',
    ),
    _StorySection(
      code: '02',
      title: 'ЛИЧНОСТЬ',
      text: 'Вайпер — свирепый и уверенный в себе агент, который не боится врагов и на самом деле желает страха врагов. Она не стесняется называть себя злодейкой и чудовищем и будет действовать как и то, и другое, если это означает достижение ее цели. Как и ее способности, она может быть довольно «ядовитой», однако считается, что она более дружелюбна и заботлива по отношению к своим товарищам по команде, но она без колебаний сделает им строгий выговор, если они допустят серьезные просчеты на поле боя.',
    ),
    _StorySection(
      code: '03',
      title: 'ВНЕШНОСТЬ',
      text: 'Привлекая внимание своими черными как смоль волосами и ядовито-зелеными глазами, Вайпер также носит черную маску. Когда Вайпер использует свою ультимативную способность, эта маска превращается в противогаз, который закрывает всю ее голову. Она надевает зеленое облегающее боди с острыми черными плечевыми пластинами и носит специальные перчатки, в которых она может выпускать свои токсичные газы. Она носит черные ботинки, доходящие ей до бедер, и несет на спине контейнер, в котором находятся ее токсины.',
    ),
  ];

}

class _FullStoryPageState extends State<FullStoryPage> with TickerProviderStateMixin {
  late final AnimationController _tiltSmoothing;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  double _targetTiltX = 0;
  double _targetTiltY = 0;
  double _tiltX = 0;
  double _tiltY = 0;

  @override
  void initState() {
    super.initState();
    _tiltSmoothing = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )
      ..addListener(_smoothDeviceTilt)
      ..repeat();
    _accelerometerSubscription = accelerometerEventStream().listen(
      (event) {
        _targetTiltX = (event.z / 9.8 * .24).clamp(-.24, .24).toDouble();
        _targetTiltY = (event.x / 9.8 * .30).clamp(-.30, .30).toDouble();
      },
      onError: (_) {},
    );
  }

  void _smoothDeviceTilt() {
    _tiltX += (_targetTiltX - _tiltX) * .085;
    _tiltY += (_targetTiltY - _tiltY) * .085;
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _tiltSmoothing.dispose();
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
              SliverToBoxAdapter(child: _hero(context)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 25, 18, 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'KINGDOM // CLASSIFIED PERSONNEL RECORD',
                        style: TextStyle(
                          color: Color(0xFF9BFF83),
                          fontSize: 8,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'САБИНА КАЛЛАС',
                        style: TextStyle(
                          color: Color(0xFFE2FFD8),
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Досье агента • VALORANT Protocol',
                        style: TextStyle(
                          color: Color(0xFF77917D),
                          fontSize: 11,
                          letterSpacing: .5,
                        ),
                      ),
                      const SizedBox(height: 22),
                      ...FullStoryPage._sections.map(
                        (section) => Padding(
                          padding: const EdgeInsets.only(bottom: 13),
                          child: _StoryCard(section: section),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _BackButton(onTap: () => Navigator.of(context).pop()),
                      const SizedBox(height: 18),
                      const Center(
                        child: Text(
                          'END OF PERSONNEL FILE  //  VIPER',
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

  Widget _hero(BuildContext context) {
    return SizedBox(
      height: 330,
      child: ColoredBox(
        color: const Color(0xFF030A06),
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRect(
                child: AnimatedBuilder(
                  animation: _tiltSmoothing,
                  child: Image.asset(
                    'assets/images/1.png',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                  builder: (context, child) => Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, .0012)
                      ..rotateX(_tiltX)
                      ..rotateY(_tiltY)
                      ..translateByDouble(_tiltY * 18, 22 + _tiltX * 8, 0, 1)
                      ..scaleByDouble(1.08, 1.08, 1.08, 1),
                    child: child,
                  ),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, .48, .70, .88, 1],
                    colors: [
                      Color(0x99030A06),
                      Color(0x33030A06),
                      Color(0x88030A06),
                      Color(0xE6030A06),
                      Color(0xFF030A06),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _BackIcon(onTap: () => Navigator.of(context).pop()),
                          const SizedBox(width: 12),
                          const Text(
                            'TACTICAL ARCHIVE',
                            style: TextStyle(
                              color: Color(0xFFB8FF9B),
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.8,
                            ),
                          ),
                          const Spacer(),
                          const _ClassifiedPill(),
                        ],
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AGENT PROFILE  //  V-01',
                            style: TextStyle(
                              color: Color(0xFF9BFF83),
                              fontSize: 9,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'VIPER',
                            style: TextStyle(
                              color: Color(0xFFE2FFD8),
                              fontSize: 48,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                              shadows: [Shadow(color: Color(0x9900E676), blurRadius: 22)],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'ИСТОРИЯ ПЕРСОНАЖА',
                            style: TextStyle(
                              color: Color(0xFFB8FF9B),
                              fontSize: 10,
                              letterSpacing: 1.5,
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
        ),
      ),
    );
  }
}

class _StorySection {
  const _StorySection({
    required this.code,
    required this.title,
    required this.text,
  });

  final String code;
  final String title;
  final String text;
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.section});
  final _StorySection section;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xD90B1710),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF9BFF83).withValues(alpha: .17)),
          boxShadow: const [
            BoxShadow(color: Color(0x1F00E676), blurRadius: 17, spreadRadius: 1),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  section.code,
                  style: const TextStyle(
                    color: Color(0xFF55745D),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 3,
                  height: 23,
                  decoration: BoxDecoration(
                    color: const Color(0xFF9BFF83),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [BoxShadow(color: Color(0x8800E676), blurRadius: 10)],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  section.title,
                  style: const TextStyle(
                    color: Color(0xFFB8FF9B),
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            Text(
              section.text,
              style: const TextStyle(
                color: Color(0xFF9BB5A0),
                fontSize: 12,
                height: 1.62,
              ),
            ),
          ],
        ),
      );
}

class _BackIcon extends StatelessWidget {
  const _BackIcon({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: const Color(0xFF102719).withValues(alpha: .88),
        shape: const CircleBorder(
          side: BorderSide(color: Color(0x669BFF83)),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: const Padding(
            padding: EdgeInsets.all(9),
            child: Icon(Icons.arrow_back_rounded, color: Color(0xFFB8FF9B), size: 19),
          ),
        ),
      );
}

class _ClassifiedPill extends StatelessWidget {
  const _ClassifiedPill();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF102719),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF9BFF83).withValues(alpha: .5)),
        ),
        child: const Text(
          'CLASSIFIED',
          style: TextStyle(
            color: Color(0xFFB8FF9B),
            fontSize: 8,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      );
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.arrow_back_rounded, size: 17),
          label: const Text('ВЕРНУТЬСЯ К ДОСЬЕ'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFB8FF9B),
            backgroundColor: const Color(0xFF9BFF83).withValues(alpha: .06),
            side: BorderSide(color: const Color(0xFF9BFF83).withValues(alpha: .45)),
            padding: const EdgeInsets.symmetric(vertical: 15),
            textStyle: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          ),
        ),
      );
}
