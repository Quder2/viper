import 'package:flutter/material.dart';
import 'package:viper/theme/sage_theme.dart';

class SageStoryPage extends StatelessWidget {
  const SageStoryPage({super.key});

  static const _sections = <_StorySection>[
    _StorySection('01', 'БИОГРАФИЯ', 'Линь Инь Вэй, известная под позывным Sage, — агент из Китая и один из ключевых стражей протокола VALORANT. Она использует радиантные способности, чтобы защищать союзников, контролировать пространство и возвращать павших бойцов в строй.'),
    _StorySection('02', 'ЛИЧНОСТЬ', 'Сейдж спокойна, собранна и ответственна. Она верит, что жизнь каждого союзника имеет значение, и готова взять на себя роль опоры команды. За внешней мягкостью скрываются твёрдая воля и решительность.'),
    _StorySection('03', 'СПОСОБНОСТИ', 'Её сферы создают ледяные барьеры, замедляют противников и исцеляют раненых. Главная способность Сейдж — возрождение — позволяет вернуть павшего союзника в бой и изменить ход раунда.'),
    _StorySection('04', 'РОЛЬ В ПРОТОКОЛЕ', 'Sage — страж и защитник. Она удерживает позиции, помогает команде пережить натиск и создаёт возможности для ответной атаки. Её сила раскрывается там, где важны выдержка, командная работа и точный выбор момента.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: SageTheme.dark,
      child: Scaffold(
        backgroundColor: SageTheme.background,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 300,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset('assets/sage/images/background.png', fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const ColoredBox(color: SageTheme.background)),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0x6607131C), Color(0xFF07131C)],
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.arrow_back_rounded, color: SageTheme.ice),
                              ),
                              const Text('PROTOCOL ARCHIVE', style: TextStyle(
                                color: SageTheme.cyan, fontSize: 9, letterSpacing: 1.6,
                                fontWeight: FontWeight.w900,
                              )),
                              const Spacer(),
                              const Text('CLASSIFIED', style: TextStyle(
                                color: SageTheme.ice, fontSize: 8, letterSpacing: 1.2,
                              )),
                            ]),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('AGENT PROFILE // S-07', style: TextStyle(
                                  color: SageTheme.cyan, fontSize: 9, letterSpacing: 1.8,
                                  fontWeight: FontWeight.w900,
                                )),
                                SizedBox(height: 5),
                                Text('SAGE', style: TextStyle(
                                  color: SageTheme.ice, fontSize: 48, letterSpacing: 3,
                                  fontWeight: FontWeight.w900,
                                )),
                                Text('ИСТОРИЯ ПЕРСОНАЖА', style: TextStyle(
                                  color: SageTheme.jade, fontSize: 10, letterSpacing: 1.4,
                                  fontWeight: FontWeight.w800,
                                )),
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
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 36),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text('RADIANT // CLASSIFIED PERSONNEL RECORD', style: TextStyle(
                    color: SageTheme.cyan, fontSize: 8, letterSpacing: 1.5,
                    fontWeight: FontWeight.w900,
                  )),
                  const SizedBox(height: 10),
                  const Text('ЛИНЬ ИНЬ ВЭЙ', style: TextStyle(
                    color: SageTheme.ice, fontSize: 23, fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  )),
                  const SizedBox(height: 8),
                  const Text('Досье агента • VALORANT Protocol', style: TextStyle(
                    color: SageTheme.muted, fontSize: 11,
                  )),
                  const SizedBox(height: 22),
                  ..._sections.map((section) => Padding(
                    padding: const EdgeInsets.only(bottom: 13),
                    child: _StoryCard(section: section),
                  )),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('ВЕРНУТЬСЯ К ДОСЬЕ'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: SageTheme.ice,
                        side: BorderSide(color: SageTheme.cyan.withValues(alpha: .45)),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Center(child: Text('END OF PERSONNEL FILE // SAGE', style: TextStyle(
                    color: SageTheme.muted, fontSize: 8, letterSpacing: 1.5,
                  ))),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StorySection {
  const _StorySection(this.code, this.title, this.text);
  final String code, title, text;
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.section});
  final _StorySection section;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: SageTheme.surface,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: SageTheme.cyan.withValues(alpha: .2)),
      boxShadow: const [BoxShadow(color: Color(0x1870D8E8), blurRadius: 17)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text(section.code, style: const TextStyle(
            color: SageTheme.muted, fontSize: 10, fontWeight: FontWeight.w900,
          )),
          const SizedBox(width: 10),
          Container(width: 3, height: 22, decoration: BoxDecoration(
            color: SageTheme.cyan, borderRadius: BorderRadius.circular(8),
          )),
          const SizedBox(width: 10),
          Text(section.title, style: const TextStyle(
            color: SageTheme.ice, fontSize: 12, fontWeight: FontWeight.w900,
            letterSpacing: 1.1,
          )),
        ]),
        const SizedBox(height: 12),
        Text(section.text, style: const TextStyle(
          color: SageTheme.muted, fontSize: 12, height: 1.6,
        )),
      ],
    ),
  );
}
