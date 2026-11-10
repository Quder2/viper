import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:viper/pages/full_story_page.dart';
import 'package:viper/play_animation_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

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
                                makeVideoWodget(
                                    imagePath: 'assets/images/2.png'),
                                makeVideoWodget(
                                    imagePath: 'assets/images/3.png'),
                                makeVideoWodget(
                                    imagePath: 'assets/images/4.png')
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

Widget makeVideoWodget({imagePath}) {
  return AspectRatio(
    aspectRatio: 1.5 / 1,
    child: Container(
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          )),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(.9),
              Colors.black.withOpacity(.3),
            ],
          ),
        ),
        child: const Align(
          child: Icon(
            Icons.play_circle,
            color: Color.fromARGB(178, 24, 102, 5),
            size: 70,
          ),
        ),
      ),
    ),
  );
}
