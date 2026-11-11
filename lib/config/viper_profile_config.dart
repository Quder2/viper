import 'package:viper/models/agent_ability_data.dart';
import 'package:viper/models/agent_profile_config.dart';

abstract final class ViperProfileConfig {
  static const name = 'VIPER';
  static const agentCode = 'V-01';
  static const heroImage = 'assets/viper/images/1.png';
  static const headerLabel = 'KINGDOM // PERSONNEL FILE';
  static const quote = '«ДА, ЭТО МОЙ МИР. НА КОЛЕНИ.»';
  static const headline = 'КОНТРОЛЬ.\nТОКСИНЫ.\nПОБЕДА.';
  static const description =
      'Химик из США Viper устанавливает контроль над полем боя с помощью источающих токсичный газ устройств и ограничивает обзор противникам. А тех, кого ей не удастся отравить, она непременно перехитрит.';
  static const role = 'СПЕЦИАЛИСТ';
  static const difficulty = 'СЛОЖНОСТЬ  2/3';
  static const loadoutKicker = 'CHEMICAL LOADOUT';
  static const footageKicker = 'TACTICAL FOOTAGE';
  static const footageDescription = 'Записи способностей • локальные материалы';
  static const footer = 'VIPER // TOXIC ARCHIVE  •  END OF FILE';

  static const abilities = <AgentAbilityData>[
    AgentAbilityData(
      code: 'C',
      title: 'Змеиный укус',
      image: 'assets/viper/abilities/C.png',
      sound: 'viper/voice/C_act.mp3',
      description: 'ВЫБИРАЕТ капсулу с кислотой. Нажмите кнопку ОГОНЬ, чтобы запустить капсулу, которая разбивается при падении, оставляя после себя лужу кислоты. Попавшие в кислоту противники получают урон и становятся уязвимыми.',
      video: 'assets/viper/videos/viper_ability_C.mp4',
      preview: 'assets/viper/images/2.png',
    ),
    AgentAbilityData(
      code: 'Q',
      title: 'Ядовитое облако',
      image: 'assets/viper/abilities/Q.png',
      sound: 'viper/voice/Q_act.mp3',
      description: 'ВЫБИРАЕТ распылитель газа. Нажмите кнопку ОГОНЬ, чтобы выбросить распылитель, который остается на месте до конца раунда. Нажмите кнопку АЛЬТ. ОГОНЬ, чтобы сделать бросок снизу. Примените умение повторно, чтобы выпустить из распылителя облако ядовитого дыма, расходуя топливо. Можно использовать больше одного раза, а также подобрать и РАЗМЕСТИТЬ ЗАНОВО.',
      video: 'assets/viper/videos/viper_ability_Q.mp4',
      preview: 'assets/viper/images/3.png',
    ),
    AgentAbilityData(
      code: 'E',
      title: 'Токсичная завеса',
      image: 'assets/viper/abilities/E.png',
      sound: 'viper/voice/E_act.mp3',
      description: 'ВЫБИРАЕТ распылители газа, проникающие сквозь препятствия. Нажмите кнопку ОГОНЬ, чтобы выстрелить длинной очередью распылителей. При повторном использовании распылители образуют стену ядовитого дыма, расходуя топливо. Умение можно применять больше одного раза.',
      video: 'assets/viper/videos/viper_ability_E.mp4',
      preview: 'assets/viper/images/4.png',
    ),
    AgentAbilityData(
      code: 'ULT',
      title: 'Гнездо гадюки',
      image: 'assets/viper/abilities/X.png',
      sound: 'viper/voice/X_act.mp3',
      description: 'ВЫБИРАЕТ распылитель химикатов. Нажмите кнопку ОГОНЬ, чтобы распылить вокруг Viper облако химикатов, уменьшая дальность видимости игроков и максимальный запас здоровья находящихся в нем врагов. УДЕРЖИВАЙТЕ кнопку умения, чтобы остановить распыление.',
      video: 'assets/viper/videos/viper_ability_ult.mp4',
      preview: 'assets/viper/images/1.png',
    ),
  ];

  static const profile = AgentProfileConfig(
    name: name,
    agentCode: agentCode,
    heroImage: heroImage,
    headerLabel: headerLabel,
    quote: quote,
    headline: headline,
    description: description,
    role: role,
    difficulty: difficulty,
    loadoutKicker: loadoutKicker,
    footageKicker: footageKicker,
    footageDescription: footageDescription,
    footer: footer,
    abilities: abilities,
  );
}
