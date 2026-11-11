import 'package:flutter/material.dart';
import 'package:viper/pages/home_pages.dart';
import 'package:viper/pages/sage_home_page.dart';

class AgentSelectionPage extends StatelessWidget {
  const AgentSelectionPage({super.key});

  static const _sagePortrait =
      'https://media.valorant-api.com/agents/5f8d3a7f-467b-97f3-062c-13acf203c006/fullportrait.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070D10),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -.8),
                  radius: 1.2,
                  colors: [Color(0xFF17352D), Color(0xFF070D10)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 34, 22, 18),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'VALORANT PROTOCOL  //  PERSONNEL',
                          style: TextStyle(
                            color: Color(0xFF9BFF83),
                            fontSize: 9,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'ВЫБЕРИ\nАГЕНТА',
                          style: TextStyle(
                            color: Color(0xFFF0F6F1),
                            fontSize: 38,
                            height: 1,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Выбери досье, чтобы открыть персональный архив агента.',
                          style: TextStyle(
                            color: Color(0xFF9BAFA5),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _AgentCard(
                        name: 'VIPER',
                        subtitle: 'КОНТРОЛЁР  •  США',
                        description: 'Токсичные зоны. Контроль пространства. Без права на ошибку.',
                        accent: const Color(0xFF9BFF83),
                        background: const Color(0xFF10251A),
                        image: 'assets/images/1.png',
                        localImage: true,
                        code: 'V-01',
                        onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(builder: (_) => const HomePage()),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _AgentCard(
                        name: 'SAGE',
                        subtitle: 'СТРАЖ  •  КИТАЙ',
                        description: 'Исцеление. Защита союзников. Возвращение павших.',
                        accent: const Color(0xFF9DEBEE),
                        background: const Color(0xFF102A38),
                        image: _sagePortrait,
                        code: 'S-07',
                        onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(builder: (_) => const SageHomePage()),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(22, 26, 22, 30),
                    child: Center(
                      child: Text(
                        'PROTOCOL ARCHIVE  //  SELECT YOUR PATH',
                        style: TextStyle(
                          color: Color(0xFF60776D),
                          fontSize: 8,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AgentCard extends StatelessWidget {
  const _AgentCard({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.accent,
    required this.background,
    required this.image,
    required this.code,
    required this.onTap,
    this.localImage = false,
  });

  final String name;
  final String subtitle;
  final String description;
  final Color accent;
  final Color background;
  final String image;
  final String code;
  final VoidCallback onTap;
  final bool localImage;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 260,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: accent.withValues(alpha: .35)),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [background, const Color(0xFF091116)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -18,
                top: -8,
                bottom: -24,
                width: 205,
                child: localImage
                    ? Image.asset(image, fit: BoxFit.cover, alignment: Alignment.topCenter)
                    : Image.network(
                        image,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.person_outline_rounded,
                          size: 130,
                          color: accent.withValues(alpha: .35),
                        ),
                      ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        background.withValues(alpha: .98),
                        background.withValues(alpha: .78),
                        background.withValues(alpha: .05),
                      ],
                      stops: const [0, .54, 1],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(code, style: TextStyle(color: accent, fontSize: 9, letterSpacing: 2)),
                    const Spacer(),
                    Text(name, style: TextStyle(color: accent, fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    const SizedBox(height: 5),
                    Text(subtitle, style: const TextStyle(color: Color(0xFFDCE8E3), fontSize: 9, letterSpacing: 1.2, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 9),
                    SizedBox(
                      width: 205,
                      child: Text(description, style: const TextStyle(color: Color(0xFFA9BBB5), fontSize: 11, height: 1.45)),
                    ),
                    const SizedBox(height: 13),
                    Row(
                      children: [
                        Text('ОТКРЫТЬ ДОСЬЕ', style: TextStyle(color: accent, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, color: accent, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
