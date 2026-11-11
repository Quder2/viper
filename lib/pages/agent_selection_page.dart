import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:viper/pages/home_pages.dart';
import 'package:viper/pages/sage_home_page.dart';
import 'package:viper/config/sage_profile_config.dart';
import 'package:viper/theme/sage_theme.dart';

class AgentSelectionPage extends StatefulWidget {
  const AgentSelectionPage({super.key});

  @override
  State<AgentSelectionPage> createState() => _AgentSelectionPageState();
}

class _AgentSelectionPageState extends State<AgentSelectionPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ambient = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 12),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ambient.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070D10),
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _ambient,
              builder: (context, _) => DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(
                      -.55 + _ambient.value * 1.1,
                      -.9 + _ambient.value * .22,
                    ),
                    radius: 1.35,
                    colors: const [
                      Color(0xFF17352D),
                      Color(0xFF0B1B20),
                      Color(0xFF070D10),
                    ],
                    stops: const [0, .48, 1],
                  ),
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: IgnorePointer(child: _SelectionParticles()),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 30, 22, 22),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 34,
                              height: 2,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF9BFF83), Color(0xFF70D8E8)],
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'VALORANT PROTOCOL  //  PERSONNEL',
                              style: TextStyle(
                                color: Color(0xFFB4D9CE),
                                fontSize: 9,
                                letterSpacing: 1.8,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'ВЫБЕРИ\nАГЕНТА',
                          style: TextStyle(
                            color: Color(0xFFF0F6F1),
                            fontSize: 42,
                            height: .98,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(color: Color(0x5570D8E8), blurRadius: 24),
                            ],
                          ),
                        ),
                        const SizedBox(height: 13),
                        const Text(
                          'Каждый агент — отдельная история.\nВыбери, чьё досье открыть.',
                          style: TextStyle(
                            color: Color(0xFFA5B9B2),
                            fontSize: 12,
                            height: 1.55,
                          ),
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            const Icon(Icons.lock_outline_rounded,
                                color: Color(0xFF78958B), size: 12),
                            const SizedBox(width: 7),
                            const Text(
                              'ЗАЩИЩЁННЫЙ АРХИВ АГЕНТОВ',
                              style: TextStyle(
                                color: Color(0xFF78958B),
                                fontSize: 8,
                                letterSpacing: 1.35,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '02 / 02',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: .38),
                                fontSize: 9,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _AgentCard(
                        name: 'VIPER',
                        subtitle: 'КОНТРОЛЁР  •  США',
                        description:
                            'Токсичные зоны. Контроль пространства. Без права на ошибку.',
                        accent: const Color(0xFF9BFF83),
                        background: const Color(0xFF10251A),
                        image: 'assets/viper/images/1.png',
                        code: 'V-01',
                        index: 0,
                        onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => const HomePage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 17),
                      _AgentCard(
                        name: SageProfileConfig.profile.name,
                        subtitle: 'СТРАЖ  •  КИТАЙ',
                        description:
                            'Исцеление. Защита союзников. Возвращение павших.',
                        accent: SageTheme.cyan,
                        background: const Color(0xFF10232B),
                        image: SageProfileConfig.profile.heroImage,
                        code: 'S-07',
                        index: 1,
                        onTap: () => Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => const SageHomePage(),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(22, 27, 22, 30),
                    child: Center(
                      child: Text(
                        'PROTOCOL ARCHIVE  //  SELECT YOUR PATH',
                        style: TextStyle(
                          color: Color(0xFF60776D),
                          fontSize: 8,
                          letterSpacing: 1.6,
                          fontWeight: FontWeight.w700,
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

class _AgentCard extends StatefulWidget {
  const _AgentCard({
    required this.name,
    required this.subtitle,
    required this.description,
    required this.accent,
    required this.background,
    required this.image,
    required this.code,
    required this.index,
    required this.onTap,
  });

  final String name;
  final String subtitle;
  final String description;
  final Color accent;
  final Color background;
  final String image;
  final String code;
  final int index;
  final VoidCallback onTap;

  @override
  State<_AgentCard> createState() => _AgentCardState();
}

class _AgentCardState extends State<_AgentCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motion = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 4200 + widget.index * 900),
  )..repeat(reverse: true);

  bool _pressed = false;

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _motion,
      builder: (context, _) {
        final pulse = .5 + math.sin(_motion.value * math.pi) * .5;
        return AnimatedScale(
          scale: _pressed ? .985 : 1,
          duration: const Duration(milliseconds: 140),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              onTap: widget.onTap,
              onHighlightChanged: (value) => setState(() => _pressed = value),
              borderRadius: BorderRadius.circular(24),
              child: Container(
                height: 286,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: widget.accent.withValues(
                      alpha: .32 + pulse * .28,
                    ),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.background,
                      Color.lerp(widget.background, const Color(0xFF071116), .5)!,
                      const Color(0xFF081116),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.accent.withValues(alpha: .055 + pulse * .09),
                      blurRadius: 22 + pulse * 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned(
                      right: -22,
                      top: -12 - pulse * 5,
                      bottom: -24,
                      width: 218,
                      child: Transform.translate(
                        offset: Offset(0, -pulse * 5),
                        child: Image.asset(
                          widget.image,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.person_outline_rounded,
                            size: 145,
                            color: widget.accent.withValues(alpha: .3),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 22,
                      top: 25,
                      child: Container(
                        width: 94,
                        height: 94,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: widget.accent.withValues(alpha: .10 + pulse * .13),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: widget.accent.withValues(alpha: .10 + pulse * .12),
                              blurRadius: 34,
                              spreadRadius: 7,
                            ),
                          ],
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
                              widget.background.withValues(alpha: .99),
                              widget.background.withValues(alpha: .88),
                              widget.background.withValues(alpha: .28),
                              widget.background.withValues(alpha: .04),
                            ],
                            stops: const [0, .43, .72, 1],
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              const Color(0xFF071116).withValues(alpha: .88),
                              Colors.transparent,
                            ],
                            stops: const [0, .55],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 19),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: widget.accent,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.accent.withValues(alpha: .8),
                                      blurRadius: 9,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'PERSONNEL FILE  /  ${widget.code}',
                                style: TextStyle(
                                  color: widget.accent,
                                  fontSize: 8,
                                  letterSpacing: 1.4,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.north_east_rounded,
                                color: widget.accent.withValues(alpha: .75),
                                size: 17,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            widget.name.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: widget.accent,
                              fontSize: widget.name.length > 7 ? 29 : 35,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.8,
                              shadows: [
                                Shadow(
                                  color: widget.accent.withValues(alpha: .38),
                                  blurRadius: 19,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.subtitle,
                            style: const TextStyle(
                              color: Color(0xFFE1ECE8),
                              fontSize: 9,
                              letterSpacing: 1.25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 9),
                          SizedBox(
                            width: 220,
                            child: Text(
                              widget.description,
                              style: const TextStyle(
                                color: Color(0xFFB0C1BB),
                                fontSize: 11,
                                height: 1.45,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                'ОТКРЫТЬ ДОСЬЕ',
                                style: TextStyle(
                                  color: widget.accent,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.35,
                                ),
                              ),
                              const SizedBox(width: 9),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: widget.accent,
                                size: 16,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: widget.accent.withValues(alpha: .25),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SelectionParticles extends StatefulWidget {
  const _SelectionParticles();

  @override
  State<_SelectionParticles> createState() => _SelectionParticlesState();
}

class _SelectionParticlesState extends State<_SelectionParticles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 24),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _SelectionParticlePainter(_controller.value),
          child: const SizedBox.expand(),
        ),
      );
}

class _SelectionParticlePainter extends CustomPainter {
  const _SelectionParticlePainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (var i = 0; i < 34; i++) {
      final seed = i * 37.71;
      final x = ((math.sin(seed) + 1) * .5) * size.width;
      final travel = (progress + (i / 34)) % 1;
      final y = size.height * (1 - travel);
      final radius = 0.7 + (i % 3) * .45;
      final color = i.isEven
          ? const Color(0xFF9BFF83)
          : const Color(0xFF70D8E8);
      paint.color = color.withValues(alpha: .10 + (i % 4) * .035);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SelectionParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
