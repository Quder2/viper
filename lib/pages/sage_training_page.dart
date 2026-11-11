import 'package:flutter/material.dart';
import 'package:viper/theme/sage_theme.dart';

class SageTrainingPage extends StatefulWidget {
  const SageTrainingPage({super.key});

  @override
  State<SageTrainingPage> createState() => _SageTrainingPageState();
}

class _SageTrainingPageState extends State<SageTrainingPage> {
  static const _modules = <_TrainingModule>[
    _TrainingModule('C', 'СФЕРА БАРЬЕРА', 'Ледяная стена перекрывает проход и создаёт безопасную позицию.', 'assets/sage/abilities/barrier_orb.png'),
    _TrainingModule('Q', 'СФЕРА ЗАМЕДЛЕНИЯ', 'Поле замедляет противников и помогает удерживать узкий проход.', 'assets/sage/abilities/slow_orb.png'),
    _TrainingModule('E', 'СФЕРА ЛЕЧЕНИЯ', 'Восстанови здоровье себе или союзнику.', 'assets/sage/abilities/healing_orb.png'),
    _TrainingModule('X', 'ВОЗРОЖДЕНИЕ', 'Верни павшего союзника в строй.', 'assets/sage/abilities/resurrection.png'),
  ];

  int _selected = 0;
  bool _active = false;
  int _activations = 0;

  _TrainingModule get _module => _modules[_selected];

  @override
  Widget build(BuildContext context) {
    final module = _module;
    return Theme(
      data: SageTheme.dark,
      child: Scaffold(
        backgroundColor: SageTheme.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('RADIANT LAB', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              Text('SAGE // TRAINING SIMULATION', style: TextStyle(fontSize: 8, color: SageTheme.muted, letterSpacing: 1.3)),
            ],
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
          children: [
            Row(children: [
              const Icon(Icons.ac_unit_rounded, color: SageTheme.cyan, size: 17),
              const SizedBox(width: 8),
              const Expanded(child: Text('СЕКТОР 07 // ЛАБОРАТОРИЯ РАДИАНТА', style: TextStyle(
                color: SageTheme.cyan, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.2,
              ))),
              _StatusTag(active: _active),
            ]),
            const SizedBox(height: 7),
            const Text('Полигон способностей', style: TextStyle(color: SageTheme.muted, fontSize: 12)),
            const SizedBox(height: 20),
            const Text('ВЫБЕРИ МОДУЛЬ', style: TextStyle(color: SageTheme.ice, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1)),
            const SizedBox(height: 12),
            Row(
              children: List.generate(_modules.length, (index) {
                final selected = index == _selected;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: index == _modules.length - 1 ? 0 : 7),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(13),
                      onTap: () => setState(() { _selected = index; _active = false; }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? SageTheme.elevated : SageTheme.surface,
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: selected ? SageTheme.cyan : SageTheme.cyan.withValues(alpha: .2)),
                        ),
                        child: Column(children: [
                          Image.asset(_modules[index].icon, width: 30, height: 30, fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(Icons.ac_unit_rounded, color: SageTheme.ice, size: 26)),
                          const SizedBox(height: 5),
                          Text(_modules[index].code, style: TextStyle(
                            color: selected ? SageTheme.ice : SageTheme.muted,
                            fontSize: 10, fontWeight: FontWeight.w900,
                          )),
                        ]),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 230,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _active
                      ? const [Color(0xFF1B5365), Color(0xFF102532)]
                      : const [Color(0xFF173746), Color(0xFF0B1C27)],
                ),
                border: Border.all(color: SageTheme.cyan.withValues(alpha: _active ? .8 : .3)),
                boxShadow: _active ? const [BoxShadow(color: Color(0x4470D8E8), blurRadius: 24)] : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Image.asset(module.icon, width: 54, height: 54, fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Icon(Icons.ac_unit_rounded, color: SageTheme.ice, size: 48)),
                    const Spacer(),
                    _StatusTag(active: _active),
                  ]),
                  const Spacer(),
                  Text('SAGE // ${module.code} // LIVE FEED', style: const TextStyle(
                    color: SageTheme.cyan, fontSize: 8, letterSpacing: 1.5, fontWeight: FontWeight.w900,
                  )),
                  const SizedBox(height: 6),
                  Text(module.title, style: const TextStyle(color: SageTheme.ice, fontSize: 17, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 5),
                  Text(_active ? 'МОДУЛЬ АКТИВИРОВАН' : 'ОЖИДАНИЕ КОМАНДЫ', style: TextStyle(
                    color: _active ? SageTheme.ice : SageTheme.muted, fontSize: 9, letterSpacing: 1.1, fontWeight: FontWeight.w800,
                  )),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(module.description, style: const TextStyle(color: SageTheme.muted, fontSize: 12, height: 1.55)),
            const SizedBox(height: 20),
            SizedBox(
              height: 52,
              child: FilledButton.icon(
                onPressed: () => setState(() {
                  _active = !_active;
                  if (_active) _activations++;
                }),
                icon: Icon(_active ? Icons.power_settings_new_rounded : Icons.bolt_rounded),
                label: Text(_active ? 'ДЕАКТИВИРОВАТЬ МОДУЛЬ' : 'АКТИВИРОВАТЬ МОДУЛЬ'),
                style: FilledButton.styleFrom(
                  backgroundColor: _active ? const Color(0xFF284653) : SageTheme.cyan,
                  foregroundColor: _active ? SageTheme.ice : const Color(0xFF07131C),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: SageTheme.surface,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: SageTheme.cyan.withValues(alpha: .2)),
              ),
              child: Row(children: [
                const Icon(Icons.analytics_outlined, color: SageTheme.cyan),
                const SizedBox(width: 10),
                const Expanded(child: Text('АКТИВАЦИИ ЗА СЕССИЮ', style: TextStyle(
                  color: SageTheme.muted, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: .8,
                ))),
                Text('$_activations', style: const TextStyle(color: SageTheme.ice, fontSize: 20, fontWeight: FontWeight.w900)),
              ]),
            ),
            const SizedBox(height: 14),
            const Text('ПОЛИГОН: это визуальная тренировочная модель, а не точная симуляция игровых механик VALORANT.', style: TextStyle(
              color: SageTheme.muted, fontSize: 9, height: 1.5,
            )),
          ],
        ),
      ),
    );
  }
}

class _TrainingModule {
  const _TrainingModule(this.code, this.title, this.description, this.icon);
  final String code, title, description, icon;
}

class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: SageTheme.background.withValues(alpha: .75),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: (active ? SageTheme.cyan : SageTheme.muted).withValues(alpha: .5)),
    ),
    child: Text(active ? 'SYSTEM ONLINE' : 'SYSTEM READY', style: TextStyle(
      color: active ? SageTheme.cyan : SageTheme.muted, fontSize: 7, fontWeight: FontWeight.w900, letterSpacing: .7,
    )),
  );
}
