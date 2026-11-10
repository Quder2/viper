import 'package:flutter/material.dart';
import 'package:viper/pages/home_pages.dart';
import 'package:viper/play_animation_widget.dart';

class FullStoryPage extends StatelessWidget {
  const FullStoryPage({super.key});

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
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
                                    'ИСТОРИЯ ПЕРСОНАЖА',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 10, 150, 40),
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
                          child: Row(
                            children: const [
                              PlayAnimationWidget(
                                delay: 1.6,
                                child: Icon(
                                  Icons.lens,
                                  color: Colors.grey,
                                  weight: 5,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              const PlayAnimationWidget(
                                delay: 1.6,
                                child: Text(
                                  '  БИОГРАФИЯ',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 10, 150, 40),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const PlayAnimationWidget(
                          delay: 1.6,
                          child: Text(
                            'Сабина Каллас родом из США, возможно, связана с Сиэтлом. Обладая докторской степенью и такими наградами, как премия Р. Фрэнсиса и премия Дентона за выдающиеся инновации, ее предыдущая работа включала должность в Kingdom Corporation, в конечном итоге став ее первым главным научным сотрудником в совете консультантов, а также влияние на предприятия конгломерата в Рабате, Марокко. Ее коллеги-агенты также предположили, что раньше она была своего рода целительницей. Однако в какой-то момент во время ее пребывания в Kingdom произошел "инцидент". Мало что известно о том, что произошло, но в тот момент для Каллас все изменилось после всего, что она потеряла из-за этого, изолировавшись и посвятив себя вместо этого мести.',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const PlayAnimationWidget(
                            delay: 1.6,
                            child: Row(
                              children: const [
                                PlayAnimationWidget(
                                  delay: 1.6,
                                  child: Icon(
                                    Icons.lens,
                                    color: Colors.grey,
                                    weight: 5,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                const PlayAnimationWidget(
                                  delay: 1.6,
                                  child: Text(
                                    '  ЛИЧНОСТЬ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 10, 150, 40),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        const PlayAnimationWidget(
                          delay: 1.6,
                          child: Text(
                            'Вайпер - свирепый и уверенный в себе агент, который не боится врагов и на самом деле желает страха врагов. Она не стесняется называть себя злодейкой и чудовищем и будет действовать как и то, и другое, если это означает достижение ее цели. Как и ее способности, она может быть довольно "ядовитой", однако считается, что она более дружелюбна и заботлива по отношению к своим товарищам по команде, но она без колебаний сделает им строгий выговор, если они допустят серьезные просчеты на поле боя.',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const PlayAnimationWidget(
                            delay: 1.6,
                            child: Row(
                              children: const [
                                PlayAnimationWidget(
                                  delay: 1.6,
                                  child: Icon(
                                    Icons.lens,
                                    color: Colors.grey,
                                    weight: 5,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                const PlayAnimationWidget(
                                  delay: 1.6,
                                  child: Text(
                                    '  ВНЕШНОСТЬ',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 10, 150, 40),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        const PlayAnimationWidget(
                          delay: 1.6,
                          child: Text(
                            'Привлекая внимание своими черными как смоль волосами и ядовито-зелеными глазами, Вайпер также носит черную маску. Когда Вайпер использует свою ультимативную способность, эта маска превращается в противогаз, который закрывает всю ее голову. Она надевает зеленое облегающее боди с острыми черными плечевыми пластинами и носит специальные перчатки, в которых она может выпускать свои токсичные газы. Она носит черные ботинки, доходящие ей до бедер, и несет на спине контейнер, в котором находятся ее токсины.',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 80,
                        )
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
          Positioned.fill(
            bottom: 20,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: PlayAnimationWidget(
                delay: 2,
                child: GestureDetector(
                  onTap: () =>
                      _navigateToHome(context), // Переход на главный экран
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromARGB(255, 14, 58, 4),
                    ),
                    child: const Align(
                      child: Text(
                        'Назад на главную',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
