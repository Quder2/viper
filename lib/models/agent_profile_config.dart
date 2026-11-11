import 'package:viper/models/agent_ability_data.dart';

/// All agent-specific copy and media references for the shared profile layout.
/// A new agent should only need a config instance and a palette.
class AgentProfileConfig {
  const AgentProfileConfig({
    required this.name,
    required this.agentCode,
    required this.heroImage,
    required this.headerLabel,
    required this.quote,
    required this.headline,
    required this.description,
    required this.role,
    required this.difficulty,
    required this.loadoutKicker,
    required this.footageKicker,
    required this.footageDescription,
    required this.footer,
    required this.abilities,
  });

  final String name;
  final String agentCode;
  final String heroImage;
  final String headerLabel;
  final String quote;
  final String headline;
  final String description;
  final String role;
  final String difficulty;
  final String loadoutKicker;
  final String footageKicker;
  final String footageDescription;
  final String footer;
  final List<AgentAbilityData> abilities;
}
