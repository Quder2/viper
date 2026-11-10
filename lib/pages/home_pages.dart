import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:viper/pages/full_story_page.dart';
import 'package:viper/play_animation_widget.dart';
import 'package:viper/widgets/local_video_player_page.dart';
import 'package:viper/widgets/toxic_particles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _playMusic(String fileName) async {
    await _audioPlayer.setSource(AssetSource(fileName));
    await _audioPlayer.resume();
  }

  void _navigateToFullStory() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FullStoryPage()),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Positioned.fill(
            child: IgnorePointer(child: ToxicParticles()),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400,
                backgroundColor: Colors.black,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/1.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [
                            Colors.black,
                            Colors.black.withOpacity(.4),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const PlayAnimationWidget(
                              delay: 1,
                              child: Text(
                                'VIPER',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 10, 150, 40),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: const [
                                PlayAnimationWidget(
                                  delay: 1.2,
                                  child: Text(
                                    'Да, это мой мир! ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 22, 99, 3),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                PlayAnimationWidget(
                                  delay: 1.2,
                                  child: Text(
                                    'На колени',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 22, 99, 3),
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PlayAnimationWidget(
                          delay: 1.6,
                          child: Text(
                            'Химик из США Viper устанавливает контроль над полем боя с помощью источающих токсичный газ устройств и ограничивает обзор противникам. А тех, кого ей не удастся отравить, она непременно перехитрит.',
                            style: TextStyle(
                              color: Colors.grey,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const PlayAnimationWidget(
                          delay: 1.6,
                          child: Text(
                            'РОЛЬ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 10, 150, 40),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: const [
                            PlayAnimationWidget(
                              delay: 1.6,
                              child: Image(
                                image: AssetImage('assets/abilities/Smoke.png'),
                                width: 30,
                                height: 30,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            const PlayAnimationWidget(
                              delay: 1.6,
                              child: Text(
                                '  Специалист',
                                style: TextStyle(
                                  color: Colors.grey,
                                  height: 1.4,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const PlayAnimationWidget(
                          delay: 1.6,
                          child: Text(
                            'СЛОЖНОСТЬ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 10, 150, 40),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: const [
                            PlayAnimationWidget(
                              delay: 1.6,
                              child: Icon(
                                Icons.star,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            PlayAnimationWidget(
                              delay: 1.6,
                              child: Icon(
                                Icons.star,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            PlayAnimationWidget(
                              delay: 1.6,
                              child: Icon(
                                Icons.star_border,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const PlayAnimationWidget(
                          delay: 1.6,
                          child: Text(
                            'СПОСОБНОСТИ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 10, 150, 40),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: const [
                            PlayAnimationWidget(
                              delay: 1.6,
                              child: Image(
                                image: AssetImage('assets/abilities/C.png'),
                                width: 45,
                                height: 45,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            const PlayAnimationWidget(
                              delay: 1.6,
                              child: Text(
                                '  ЗМЕИНЫЙ УКУС',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 10, 150, 40),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const PlayAnimationWidget(
                          delay: 1.6,
                          child: Text(
                            'ВЫБИРАЕТ капсулу с кислотой. Нажмите кнопку ОГОНЬ, чтобы запустить капсулу, которая разбивается при падении, оставляя после себя лужу кислоты. Попавшие в кислоту противники получают урон и становятся уязвимыми.',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () => _playMusic('sound/C_act.mp3'),
                          child: const Text(
                            'ЗМЕИНЫЙ УКУС',
                            style: TextStyle(
                              color: Color.fromARGB(255, 10, 150, 40),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: const [
                            PlayAnimationWidget(
                              delay: 1.6,
                              child: Image(
                                image: AssetImage('assets/abilities/Q.png'),
                                width: 45,
                                height: 45,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            const PlayAnimationWidget(
                              delay: 1.6,
                              child: Text(
                                '  ЯДОВИТОЕ ОБЛОКО',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 10, 150, 40),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const PlayAnimationWidget(
                          delay: 1.6,
                          child: Text(
                            'ВЫБИРАЕТ распылитель газа. Нажмите кнопку ОГОНЬ, чтобы выбросить распылитель, который остается на месте до конца раунда. Нажмите кнопку АЛЬТ. ОГОНЬ, чтобы сделать бросок снизу. Примените умение повторно, чтобы выпустить из распылителя облако ядовитого дыма, расходуя топливо. Можно использовать больше одного раза, а также подобрать и РАЗМЕСТИТЬ ЗАНОВО.',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () => _playMusic('sound/Q_act.mp3'),
                          child: const Text(
                            'ЯДОВИТОЕ ОБЛОКО',
                            style: TextStyle(
                              color: Color.fromARGB(255, 10, 150, 40),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: const [
                            PlayAnimationWidget(
                              delay: 1.6,
                              child: Image(
                                image: AssetImage('assets/abilities/E.png'),
                                width: 40,
                                height: 40,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            const PlayAnimationWidget(
                              delay: 1.6,
                              child: Text(
                                '  ТОКСИЧНАЯ ЗАВЕСА',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 10, 150, 40),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const PlayAnimationWidget(
                          delay: 1.6,
                          child: Text(
                            'ВЫБИРАЕТ распылители газа, проникающие сквозь препятствия. Нажмите кнопку ОГОНЬ, чтобы выстрелить длинной очередью распылителей. При повторном использовании распылители образуют стену ядовитого дыма, расходуя топливо. Умение можно применять больше одного раза.',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () => _playMusic('sound/E_act.mp3'),
                          child: const Text(
                            'ТОКСИЧНАЯ ЗАВЕСА',
                            style: TextStyle(
                              color: Color.fromARGB(255, 10, 150, 40),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: const [
                            PlayAnimationWidget(
                              delay: 1.6,
                              child: Image(
                                image: AssetImage('assets/abilities/X.png'),
                                width: 48,
                                height: 48,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            const PlayAnimationWidget(
                              delay: 1.6,
                              child: Text(
                                '  ГНЕЗДО ГАДЮКИ',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 10, 150, 40),
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const PlayAnimationWidget(
                          delay: 1.6,
                          child: Text(
                            'ВЫБИРАЕТ распылитель химикатов. Нажмите кнопку ОГОНЬ, чтобы распылить вокруг Viper облако химикатов, уменьшая дальность видимости игроков и максимальный запас здоровья находящихся в нем врагов. УДЕРЖИВАЙТЕ кнопку умения, чтобы остановить распыление.',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          onPressed: () => _playMusic('sound/X_act.mp3'),
                          child: const Text(
                            'ГНЕЗДО ГАДЮКИ',
                            style: TextStyle(
                              color: Color.fromARGB(255, 10, 150, 40),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const PlayAnimationWidget(
                          delay: 1.6,
                          child: Text(
                            'ВИДЕО',
                            style: TextStyle(
                              color: Color.fromARGB(255, 10, 150, 40),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PlayAnimationWidget(
                          delay: 1.6,
                          child: Container(
                            height: 200,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                makeVideoWidget(
                                  context: context,
                                  title: 'Змеиный укус',
                                  imagePath: 'assets/images/2.png',
                                  videoPath: 'assets/videos/viper_ability_1.mp4',
                                ),
                                makeVideoWidget(
                                  context: context,
                                  title: 'Ядовитое облако',
                                  imagePath: 'assets/images/3.png',
                                  videoPath: 'assets/videos/viper_ability_2.mp4',
                                ),
                                makeVideoWidget(
                                  context: context,
                                  title: 'Токсичная завеса',
                                  imagePath: 'assets/images/4.png',
                                  videoPath: 'assets/videos/viper_ability_3.mp4',
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  )
                ]),
              )
            ],
          ),
          Positioned.fill(
            bottom: 20,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: PlayAnimationWidget(
                  delay: 2,
                  child: GestureDetector(
                    onTap: _navigateToFullStory,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Color.fromARGB(255, 14, 58, 4),
                      ),
                      child: const Align(
                        child: Text(
                          'Полная история',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}

Widget makeVideoWidget({
  required BuildContext context,
  required String title,
  required String imagePath,
  required String videoPath,
}) {
  return AspectRatio(
    aspectRatio: 1.5,
    child: Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Material(
        color: ViperTheme.surface,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => LocalVideoPlayerPage(
                  title: title,
                  assetPath: videoPath,
                ),
              ),
            );
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.88),
                      Colors.black.withValues(alpha: 0.08),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF9BFF83),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
              const Center(
                child: Icon(
                  Icons.play_circle_fill_rounded,
                  color: Color(0xFF9BFF83),
                  size: 64,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
