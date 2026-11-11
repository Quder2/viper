import 'package:viper/models/agent_ability_data.dart';
import 'package:viper/models/agent_profile_config.dart';

/// Sage-specific content. New agents should get their own profile config
/// and palette; the profile page layout/effects can stay unchanged.
abstract final class SageProfileConfig {
  static const name = 'SAGE';
  static const agentCode = 'S-07';
  static const heroImage = 'assets/sage/images/1.jpg';
  static const headerLabel = 'PROTOCOL // PERSONNEL FILE';
  static const quote = '«ТВОЯ ОБЯЗАННОСТЬ ЕЩЁ НЕ ВЫПОЛНЕНА.»';
  static const headline = 'СПОКОЙСТВИЕ.\nЗАЩИТА.\nВОЗРОЖДЕНИЕ.';
  static const description =
      'Линь Инь Вэй — страж из Китая. Сейдж удерживает линию фронта, защищает союзников и возвращает павших бойцов в бой. Её сила — в контроле пространства и поддержке команды.';
  static const role = 'СТРАЖ';
  static const difficulty = 'СЛОЖНОСТЬ  2/3';
  static const loadoutKicker = 'RADIANT LOADOUT';
  static const footageKicker = 'RADIANT FOOTAGE';
  static const footageDescription =
      'Записи способностей • локальные материалы';
  static const footer = 'SAGE // RADIANT ARCHIVE  •  END OF FILE';

  static const abilities = <AgentAbilityData>[
    AgentAbilityData(
      code: 'C',
      title: 'Сфера барьера',
      image: 'assets/sage/abilities/barrier_orb.png',
      sound: 'sage/voice/C_act.mp3',
      description: 'Создаёт прочную ледяную стену, перекрывающую проход и меняющую геометрию боя. Используй её, чтобы закрыть опасное направление или поднять союзника на неожиданную позицию.',
      video: 'assets/sage/videos/barrier_orb.mp4',
      preview: heroImage,
    ),
    AgentAbilityData(
      code: 'Q',
      title: 'Сфера замедления',
      image: 'assets/sage/abilities/slow_orb.png',
      sound: 'sage/voice/Q_act.mp3',
      description: 'Разбивает сферу о землю и создаёт поле, замедляющее проходящих через него противников. Осколки выдают движение врагов.',
      video: 'assets/sage/videos/slow_orb.mp4',
      preview: heroImage,
    ),
    AgentAbilityData(
      code: 'E',
      title: 'Сфера лечения',
      image: 'assets/sage/abilities/healing_orb.png',
      sound: 'sage/voice/E_act.mp3',
      description: 'Восстанавливает здоровье себе или раненому союзнику. Выбери цель и верни её в бой.',
      video: 'assets/sage/videos/healing_orb.mp4',
      preview: heroImage,
    ),
    AgentAbilityData(
      code: 'ULT',
      title: 'Воскрешение',
      image: 'assets/sage/abilities/resurrection.png',
      sound: 'sage/voice/X_act.mp3',
      description: 'Возвращает павшего союзника к жизни. Последний шанс переломить ход раунда.',
      video: 'assets/sage/videos/resurrection.mp4',
      preview: heroImage,
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
