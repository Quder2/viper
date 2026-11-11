import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:viper/config/sage_profile_config.dart';
import 'package:viper/theme/sage_theme.dart';
import 'package:viper/widgets/sage_particles.dart';

class SageStoryPage extends StatefulWidget {
  const SageStoryPage({super.key});

  @override
  State<SageStoryPage> createState() => _SageStoryPageState();
}

class _SageStoryPageState extends State<SageStoryPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ambient = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 16),
  )..repeat(reverse: true);

  static const _sections = <_StorySection>[
    _StorySection(
      '01',
      'БИОГРАФИЯ',
      'Линь Инь Вэй, известная под позывным Sage, — радиант из Китая и один из ключевых стражей протокола VALORANT. Её способности позволяют создавать защитные барьеры, сдерживать продвижение противника и возвращать павших союзников в бой. В команде она стала символом стойкости и надежды.',
    ),
    _StorySection(
      '02',
      'ЛИЧНОСТЬ',
      'Сейдж спокойна, собранна и ответственна. Она верит, что жизнь каждого союзника имеет значение, и готова взять на себя роль опоры команды. Её мягкость не означает слабость: в критический момент она действует решительно и не позволяет эмоциям помешать долгу.',
    ),
    _StorySection(
      '03',
      'ВНЕШНОСТЬ И ОБРАЗ',
      'Образ Сейдж построен вокруг светлых тонов, бирюзовых акцентов и мотивов нефрита. Длинные тёмные волосы, боевой костюм и сияющие нефритовые сферы подчёркивают её связь с радиантной энергией. Визуально её сила ощущается не как разрушение, а как защита и восстановление.',
    ),
    _StorySection(
      '04',
      'РАДИАНТНЫЕ СПОСОБНОСТИ',
      'Сфера барьера возводит ледяную стену и перекрывает опасные проходы. Сфера замедления создаёт поле, мешающее противникам быстро продвигаться. Сфера лечения восстанавливает здоровье выбранной цели. Абсолютная способность — воскрешение — возвращает павшего союзника в строй.',
    ),
    _StorySection(
      '05',
      'РОЛЬ В ПРОТОКОЛЕ',
      'Sage — страж, который помогает команде удерживать позиции и переживать давление противника. Она не стремится быть в центре атаки: её преимущество — грамотный выбор момента, контроль пространства и способность сохранить боеспособность отряда. Там, где другие видят конец раунда, Сейдж находит шанс продолжить бой.',
    ),
  ];

  @override
  void dispose() {
    _ambient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: SageTheme.dark,
      child: Scaffold(
        backgroundColor: SageTheme.background,
        body: Stack(
          children: [
            const Positioned.fill(
              child: IgnorePointer(
                child: SageParticles(count: 34, opacity: .16),
              ),
            ),
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHero()),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 36),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const _ArchiveEyebrow(),
                      const SizedBox(height: 10),
                      const Text(
                        'ЛИНЬ ИНЬ ВЭЙ',
                        style: TextStyle(
                          color: SageTheme.ice,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      const Text(
                        'Досье агента • VALORANT Protocol • Китай',
                        style: TextStyle(color: SageTheme.muted, fontSize: 11),
                      ),
                      const SizedBox(height: 18),
                      const _IdentityPanel(),
                      const SizedBox(height: 22),
                      ..._sections.map(
                        (section) => Padding(
                          padding: const EdgeInsets.only(bottom: 13),
                          child: _StoryCard(section: section),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: const Text('ВЕРНУТЬСЯ К ДОСЬЕ'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: SageTheme.ice,
                            side: BorderSide(
                              color: SageTheme.cyan.withValues(alpha: .45),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Center(
                        child: Text(
                          'END OF PERSONNEL FILE // S-07',
                          style: TextStyle(
                            color: SageTheme.mutedDeep,
                            fontSize: 8,
                            letterSpacing: 1.7,
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return SizedBox(
      height: 360,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedBuilder(
            animation: _ambient,
            builder: (context, child) => Transform.translate(
              offset: Offset(
                math.sin(_ambient.value * math.pi) * 6,
                -88 - _ambient.value * 6,
              ),
              child: Transform.scale(
                scale: 1.18 + _ambient.value * .025,
                child: child,
              ),
            ),
            child: Image.asset(
              SageProfileConfig.profile.heroImage,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: SageTheme.background,
                child: Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: SageTheme.muted,
                    size: 42,
                  ),
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _ambient,
              builder: (context, child) => DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(-.65 + _ambient.value * 1.3, -.35),
                    radius: 1.15,
                    colors: [
                      SageTheme.cyan.withValues(
                        alpha: .08 + _ambient.value * .07,
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
            child: SageParticles(count: 42, opacity: .46),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, .38, .62, .82, 1],
                colors: [
                  Color(0x9907131C),
                  Color(0x2207131C),
                  Color(0xAA07131C),
                  Color(0xF507131C),
                  SageTheme.background,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Material(
                        color: SageTheme.overlayButton,
                        shape: CircleBorder(
                          side: BorderSide(
                            color: SageTheme.cyan.withValues(alpha: .45),
                          ),
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: SageTheme.ice,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'PROTOCOL ARCHIVE',
                        style: TextStyle(
                          color: SageTheme.cyan,
                          fontSize: 9,
                          letterSpacing: 1.8,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      const _ClassifiedPill(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AGENT PROFILE  //  S-07',
                        style: TextStyle(
                          color: SageTheme.cyan,
                          fontSize: 9,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'SAGE',
                        style: TextStyle(
                          color: SageTheme.ice,
                          fontSize: 52,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                          shadows: [
                            Shadow(color: Color(0xAA70D8E8), blurRadius: 25),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        SageProfileConfig.profile.quote,
                        style: const TextStyle(
                          color: SageTheme.jade,
                          fontSize: 10,
                          letterSpacing: 1.2,
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

class _ArchiveEyebrow extends StatelessWidget {
  const _ArchiveEyebrow();

  @override
  Widget build(BuildContext context) => const Text(
        'RADIANT // CLASSIFIED PERSONNEL RECORD',
        style: TextStyle(
          color: SageTheme.cyan,
          fontSize: 8,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w900,
        ),
      );
}

class _IdentityPanel extends StatelessWidget {
  const _IdentityPanel();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: SageTheme.panelGlass,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: SageTheme.cyan.withValues(alpha: .24)),
          boxShadow: const [
            BoxShadow(color: Color(0x1870D8E8), blurRadius: 18),
          ],
        ),
        child: const Row(
          children: [
            Expanded(child: _IdentityItem(label: 'ПОЗЫВНОЙ', value: 'SAGE')),
            Expanded(child: _IdentityItem(label: 'КЛАСС', value: 'СТРАЖ')),
            Expanded(child: _IdentityItem(label: 'КОД', value: 'S-07')),
          ],
        ),
      );
}

class _IdentityItem extends StatelessWidget {
  const _IdentityItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: SageTheme.mutedBright,
              fontSize: 7,
              letterSpacing: 1,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: SageTheme.ice,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      );
}

class _ClassifiedPill extends StatelessWidget {
  const _ClassifiedPill();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: SageTheme.cyan.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: SageTheme.cyan.withValues(alpha: .42)),
          boxShadow: const [
            BoxShadow(color: Color(0x3370D8E8), blurRadius: 12),
          ],
        ),
        child: const Text(
          'CLASSIFIED',
          style: TextStyle(
            color: SageTheme.ice,
            fontSize: 8,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      );
}

class _StorySection {
  const _StorySection(this.code, this.title, this.text);

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
          color: SageTheme.surface.withValues(alpha: .94),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: SageTheme.cyan.withValues(alpha: .2)),
          boxShadow: const [
            BoxShadow(color: Color(0x1870D8E8), blurRadius: 17),
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
                    color: SageTheme.muted,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 3,
                  height: 22,
                  decoration: BoxDecoration(
                    color: SageTheme.cyan,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(color: Color(0x6670D8E8), blurRadius: 9),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  section.title,
                  style: const TextStyle(
                    color: SageTheme.ice,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              section.text,
              style: const TextStyle(
                color: SageTheme.muted,
                fontSize: 12,
                height: 1.65,
              ),
            ),
          ],
        ),
      );
}
