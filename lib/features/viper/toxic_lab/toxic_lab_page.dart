import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:viper/theme/viper_theme.dart';
import 'package:viper/widgets/local_video_player_page.dart';
import 'package:viper/widgets/toxic_particles.dart';
import 'package:viper/widgets/video_asset_thumbnail.dart';

class ToxicLabPage extends StatefulWidget {
  const ToxicLabPage({super.key});
  @override
  State<ToxicLabPage> createState() => _ToxicLabPageState();
}

class _ToxicLabPageState extends State<ToxicLabPage> with SingleTickerProviderStateMixin {
  static const _abilities = <_LabAbility>[
    _LabAbility('C','ЗМЕИНЫЙ УКУС','Кислотная капсула','assets/abilities/C.png','assets/images/2.png','assets/videos/viper_ability_C.mp4','Кислотный снаряд создаёт опасную зону и ослабляет противников.','sound/C_act.mp3',0),
    _LabAbility('Q','ЯДОВИТОЕ ОБЛАКО','Токсичный распылитель','assets/abilities/Q.png','assets/images/3.png','assets/videos/viper_ability_Q.mp4','Сфера выпускает токсичный дым. Поддержание облака расходует топливо.','sound/Q_act.mp3',4),
    _LabAbility('E','ТОКСИЧНАЯ ЗАВЕСА','Линия распылителей','assets/abilities/E.png','assets/images/4.png','assets/videos/viper_ability_E.mp4','Разворачивает протяжённую стену токсичного дыма и расходует топливо.','sound/E_act.mp3',5),
    _LabAbility('ULT','ГНЕЗДО ГАДЮКИ','Область химического заражения','assets/abilities/X.png','assets/images/1.png','assets/videos/viper_ability_ult.mp4','Создаёт большую зону заражения. Это самый затратный модуль симулятора.','sound/X_act.mp3',7),
  ];
  late final AnimationController _pulse = AnimationController(vsync:this,duration:const Duration(milliseconds:1700))..repeat(reverse:true);
  final AudioPlayer _audio = AudioPlayer();
  Timer? _timer;
  int _selected=0, _activations=0, _deactivations=0;
  bool _active=false, _soundEnabled=true;
  double _fuel=100, _intensity=.72, _activeSeconds=0, _deploymentSeconds=0;
  _LabAbility get _ability => _abilities[_selected];

  @override
  void initState() {
    super.initState();
    _timer=Timer.periodic(const Duration(milliseconds:100), (_) {
      if (!mounted) return;
      setState(() {
        if (_active) {
          _activeSeconds+=.1;
          _deploymentSeconds+=.1;
          if (_ability.fuelRate>0) _fuel=(_fuel-_ability.fuelRate*.1).clamp(0,100);
          if ((_ability.code=='C' && _deploymentSeconds>=5) || (_ability.fuelRate>0 && _fuel<=0)) {
            _active=false; _deactivations++; _audio.stop();
          }
        } else {
          _fuel=(_fuel+.28).clamp(0,100);
        }
      });
    });
  }

  @override
  void dispose() { _timer?.cancel(); _pulse.dispose(); _audio.dispose(); super.dispose(); }

  Future<void> _playSound() async {
    if (!_soundEnabled) return;
    try { await _audio.stop(); await _audio.play(AssetSource(_ability.sound)); } catch (_) {}
  }

  void _toggle() {
    if (_active) {
      setState(() { _active=false; _deactivations++; });
      _audio.stop();
      return;
    }
    if (_ability.fuelRate>0 && _fuel<1) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Недостаточно топлива. Дождись перезарядки резервуара.')));
      return;
    }
    setState(() { _active=true; _deploymentSeconds=0; _activations++; });
    _playSound();
  }

  void _select(int index) {
    if (index==_selected) return;
    if (_active) { _audio.stop(); _deactivations++; }
    setState(() { _selected=index; _active=false; _deploymentSeconds=0; });
  }

  void _reset() {
    _audio.stop();
    setState(() { _active=false; _fuel=100; _activeSeconds=0; _deploymentSeconds=0; _activations=0; _deactivations=0; });
  }

  void _openVideo() => Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (_) => LocalVideoPlayerPage(title:_ability.title,assetPath:_ability.video)));

  @override
  Widget build(BuildContext context) {
    final a=_ability;
    final fuelColor=_fuel>35 ? ViperTheme.toxicGreen : (_fuel>15 ? const Color(0xFFFFC857) : const Color(0xFFFF5D5D));
    return Scaffold(
      backgroundColor:ViperTheme.background,
      appBar:AppBar(
        title:const Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          Text('TOXIC LAB',style:TextStyle(fontWeight:FontWeight.w900,letterSpacing:1.2)),
          Text('VIPER // COMBAT SIMULATION',style:TextStyle(fontSize:8,color:ViperTheme.secondaryText,letterSpacing:1.5)),
        ]),
        actions:[IconButton(tooltip:_soundEnabled?'Выключить звук':'Включить звук',
          onPressed:()=>setState(()=>_soundEnabled=!_soundEnabled),
          icon:Icon(_soundEnabled?Icons.volume_up_rounded:Icons.volume_off_rounded,
            color:_soundEnabled?ViperTheme.toxicGreen:ViperTheme.secondaryText))]),
      body:Stack(children:[
        const Positioned.fill(child:IgnorePointer(child:ToxicParticles(particleCount:28,opacity:.17))),
        ListView(padding:const EdgeInsets.fromLTRB(16,8,16,30),children:[
          Row(children:[
            const Icon(Icons.science_outlined,color:ViperTheme.toxicGreen,size:16),
            const SizedBox(width:7),
            const Expanded(child:Text('СЕКТОР 07 // ЛАБОРАТОРИЯ ТОКСИНОВ',
              style:TextStyle(color:ViperTheme.toxicGreen,fontSize:9,fontWeight:FontWeight.w900,letterSpacing:1.4))),
            _MiniTag(text:_active?'SYSTEM ONLINE':'SYSTEM READY',color:_active?ViperTheme.toxicGreen:ViperTheme.secondaryText),
          ]),
          const SizedBox(height:7),
          const Text('Боевой полигон способностей',style:TextStyle(color:ViperTheme.secondaryText,fontSize:12)),
          const SizedBox(height:16),
          const _SectionHeader('АРСЕНАЛ','ВЫБЕРИ МОДУЛЬ'),
          const SizedBox(height:9),
          Row(children:List.generate(_abilities.length,(i){
            final item=_abilities[i]; final selected=i==_selected;
            return Expanded(child:Padding(
              padding:EdgeInsets.only(right:i==_abilities.length-1?0:7),
              child:InkWell(borderRadius:BorderRadius.circular(13),onTap:()=>_select(i),
                child:AnimatedContainer(duration:const Duration(milliseconds:200),
                  padding:const EdgeInsets.symmetric(vertical:10),
                  decoration:BoxDecoration(color:selected?ViperTheme.elevatedSurface:ViperTheme.surface,
                    borderRadius:BorderRadius.circular(13),
                    border:Border.all(color:selected?ViperTheme.toxicGreen:ViperTheme.mutedGreen),
                    boxShadow:selected?[const BoxShadow(color:Color(0x3300E676),blurRadius:12)]:null),
                  child:Column(children:[
                    Image.asset(item.icon,width:28,height:28,fit:BoxFit.contain),
                    const SizedBox(height:5),
                    Text(item.code,style:TextStyle(color:selected?ViperTheme.toxicGreen:ViperTheme.secondaryText,fontSize:10,fontWeight:FontWeight.w900)),
                  ]))))); })),
          const SizedBox(height:14),
          AnimatedBuilder(animation:_pulse,builder:(context,child)=>Container(height:218,
            decoration:BoxDecoration(borderRadius:BorderRadius.circular(18),
              border:Border.all(color:ViperTheme.toxicGreen.withValues(alpha:_active?.4+_pulse.value*.4:.2)),
              boxShadow:_active?[BoxShadow(color:ViperTheme.toxicGreen.withValues(alpha:.08+_pulse.value*.12),blurRadius:18+_pulse.value*14)]:null),
            clipBehavior:Clip.antiAlias,child:child),
            child:Stack(fit:StackFit.expand,children:[
              VideoAssetThumbnail(videoAsset:a.video,fallbackAsset:a.preview,
                timeMs:switch(a.code){'C'=>2200,'Q'=>2600,'E'=>2400,'ULT'=>3200,_=>1800}),
              DecoratedBox(decoration:BoxDecoration(gradient:LinearGradient(begin:Alignment.topCenter,end:Alignment.bottomCenter,
                colors:[Colors.black.withValues(alpha:.08),const Color(0xF5030A06)]))),
              if(_active) Positioned.fill(child:IgnorePointer(child:CustomPaint(
                painter:_AbilityEffectPainter(code:a.code,progress:_pulse.value,intensity:_intensity)))),
              if(_active) const Positioned.fill(child:IgnorePointer(child:ToxicParticles(particleCount:34,opacity:.45))),
              Positioned(left:14,right:14,bottom:13,child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                Text('VIPER // \${a.code} // LIVE FEED',style:const TextStyle(color:ViperTheme.toxicGreen,fontSize:8,letterSpacing:1.5,fontWeight:FontWeight.w900)),
                const SizedBox(height:5),
                Text(a.title,style:const TextStyle(color:Color(0xFFE2FFD8),fontSize:18,fontWeight:FontWeight.w900,letterSpacing:.6)),
                const SizedBox(height:4),
                Text(_active?'СИСТЕМА АКТИВИРОВАНА':'ОЖИДАНИЕ КОМАНДЫ',
                  style:TextStyle(color:_active?ViperTheme.toxicGreen:ViperTheme.secondaryText,fontSize:9,letterSpacing:1.1,fontWeight:FontWeight.w800)),
              ])),
              Positioned(top:10,right:10,child:_MiniTag(text:_active?'● LIVE':'STANDBY',color:_active?ViperTheme.toxicGreen:ViperTheme.secondaryText)),
            ])),
          const SizedBox(height:13),
          Text(a.subtitle,style:const TextStyle(color:ViperTheme.brightGreen,fontSize:14,fontWeight:FontWeight.w900)),
          const SizedBox(height:5),
          Text(a.description,style:const TextStyle(color:ViperTheme.secondaryText,fontSize:11,height:1.5)),
          const SizedBox(height:17),
          const _SectionHeader('ТОПЛИВНЫЙ КОНТУР','RESERVE // 100 UNITS'),
          const SizedBox(height:9),
          Container(padding:const EdgeInsets.all(13),decoration:BoxDecoration(color:ViperTheme.surface,
            borderRadius:BorderRadius.circular(15),border:Border.all(color:ViperTheme.mutedGreen.withValues(alpha:.55))),
            child:Column(children:[
              Row(children:[
                const Icon(Icons.propane_tank_outlined,color:ViperTheme.toxicGreen,size:18),
                const SizedBox(width:8),
                const Expanded(child:Text('ЗАПАС ТОКСИНА',style:TextStyle(color:ViperTheme.secondaryText,fontSize:9,fontWeight:FontWeight.w900,letterSpacing:1))),
                Text('\${_fuel.round()}%',style:TextStyle(color:fuelColor,fontWeight:FontWeight.w900,fontSize:16)),
              ]),
              const SizedBox(height:10),
              ClipRRect(borderRadius:BorderRadius.circular(20),child:LinearProgressIndicator(value:_fuel/100,minHeight:8,
                backgroundColor:const Color(0xFF17231B),valueColor:AlwaysStoppedAnimation<Color>(fuelColor))),
              const SizedBox(height:8),
              Row(children:[
                Expanded(child:Text(_active&&a.fuelRate>0?'РАСХОД: \${a.fuelRate.toStringAsFixed(1)} ЕД./СЕК':'ВОССТАНОВЛЕНИЕ: 2.8 ЕД./СЕК',
                  style:const TextStyle(color:ViperTheme.secondaryText,fontSize:8,letterSpacing:.7))),
                Text(a.fuelRate==0?'БЕЗ РАСХОДА':'ПОД КОНТРОЛЕМ',style:const TextStyle(color:ViperTheme.toxicGreen,fontSize:8,fontWeight:FontWeight.w800)),
              ]),
            ])),
          const SizedBox(height:16),
          const _SectionHeader('ПАРАМЕТРЫ ЭФФЕКТА','VISUAL CONTROL'),
          Row(children:[
            const Text('ИНТЕНСИВНОСТЬ ВИЗУАЛИЗАЦИИ',style:TextStyle(color:ViperTheme.secondaryText,fontSize:8,letterSpacing:.8,fontWeight:FontWeight.w800)),
            const Spacer(),
            Text('\${(_intensity*100).round()}%',style:const TextStyle(color:ViperTheme.toxicGreen,fontWeight:FontWeight.w900,fontSize:11)),
          ]),
          Slider(value:_intensity,onChanged:(v)=>setState(()=>_intensity=v)),
          const SizedBox(height:7),
          SizedBox(height:50,child:ElevatedButton.icon(onPressed:_toggle,
            icon:Icon(_active?Icons.power_settings_new:Icons.bolt_rounded),
            label:Text(_active?'ОТКЛЮЧИТЬ СИСТЕМУ':'АКТИВИРОВАТЬ МОДУЛЬ'),
            style:ElevatedButton.styleFrom(backgroundColor:_active?const Color(0xFF263A2B):ViperTheme.elevatedSurface,
              foregroundColor:_active?const Color(0xFFFFD2C8):ViperTheme.toxicGreen,
              side:BorderSide(color:_active?const Color(0xFF9A5146):ViperTheme.toxicGreen),
              shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(13))))),
          const SizedBox(height:9),
          OutlinedButton.icon(onPressed:_openVideo,icon:const Icon(Icons.play_circle_outline_rounded),
            label:const Text('ВИДЕОДЕМОНСТРАЦИЯ СПОСОБНОСТИ'),
            style:OutlinedButton.styleFrom(padding:const EdgeInsets.symmetric(vertical:13))),
          const SizedBox(height:17),
          const _SectionHeader('БОЕВАЯ СТАТИСТИКА','SESSION DATA'),
          const SizedBox(height:9),
          Row(children:[
            Expanded(child:_StatTile(icon:Icons.rocket_launch_outlined,label:'АКТИВАЦИИ',value:'$_activations')),
            const SizedBox(width:8),
            Expanded(child:_StatTile(icon:Icons.timer_outlined,label:'ВРЕМЯ РАБОТЫ',value:'\${_activeSeconds.toStringAsFixed(1)}с')),
            const SizedBox(width:8),
            Expanded(child:_StatTile(icon:Icons.power_settings_new,label:'ОТКЛЮЧЕНИЯ',value:'$_deactivations')),
          ]),
          const SizedBox(height:9),
          OutlinedButton.icon(onPressed:_reset,icon:const Icon(Icons.restart_alt_rounded,size:17),
            label:const Text('СБРОСИТЬ ДАННЫЕ СЕССИИ'),
            style:OutlinedButton.styleFrom(foregroundColor:ViperTheme.secondaryText,
              side:BorderSide(color:ViperTheme.mutedGreen.withValues(alpha:.6)))),
          const SizedBox(height:14),
          Container(padding:const EdgeInsets.all(11),decoration:BoxDecoration(color:const Color(0xFF101B14),
            borderRadius:BorderRadius.circular(12),border:Border.all(color:ViperTheme.mutedGreen.withValues(alpha:.45))),
            child:const Row(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Icon(Icons.info_outline,color:ViperTheme.toxicGreen,size:15),SizedBox(width:8),
              Expanded(child:Text('ПОЛИГОН: расход топлива, восстановление и время работы — условная модель тренировки, а не точные игровые значения Valorant. Звуковые сигналы воспроизводятся локально.',
                style:TextStyle(color:Color(0xFF829487),fontSize:9,height:1.45))),
            ])),
        ]),
      ]),
    );
  }
}

class _LabAbility {
  const _LabAbility(this.code,this.title,this.subtitle,this.icon,this.preview,this.video,this.description,this.sound,this.fuelRate);
  final String code,title,subtitle,icon,preview,video,description,sound;
  final double fuelRate;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title,this.trailing);
  final String title,trailing;
  @override
  Widget build(BuildContext context)=>Row(children:[
    Expanded(child:Text(title,style:const TextStyle(color:ViperTheme.toxicGreen,fontSize:9,letterSpacing:1.2,fontWeight:FontWeight.w900))),
    Text(trailing,style:const TextStyle(color:ViperTheme.secondaryText,fontSize:7,letterSpacing:.8)),
  ]);
}

class _MiniTag extends StatelessWidget {
  const _MiniTag({required this.text,required this.color});
  final String text; final Color color;
  @override
  Widget build(BuildContext context)=>Container(
    padding:const EdgeInsets.symmetric(horizontal:8,vertical:5),
    decoration:BoxDecoration(color:Colors.black.withValues(alpha:.55),borderRadius:BorderRadius.circular(6),
      border:Border.all(color:color.withValues(alpha:.45))),
    child:Text(text,style:TextStyle(color:color,fontSize:7,fontWeight:FontWeight.w900,letterSpacing:.7)));
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon,required this.label,required this.value});
  final IconData icon; final String label,value;
  @override
  Widget build(BuildContext context)=>Container(
    padding:const EdgeInsets.symmetric(horizontal:9,vertical:12),
    decoration:BoxDecoration(color:ViperTheme.surface,borderRadius:BorderRadius.circular(12),
      border:Border.all(color:ViperTheme.mutedGreen.withValues(alpha:.5))),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
      Icon(icon,color:ViperTheme.toxicGreen,size:16),const SizedBox(height:9),
      Text(value,style:const TextStyle(color:Color(0xFFE2FFD8),fontSize:16,fontWeight:FontWeight.w900)),
      const SizedBox(height:3),
      Text(label,maxLines:1,overflow:TextOverflow.ellipsis,
        style:const TextStyle(color:ViperTheme.secondaryText,fontSize:7,letterSpacing:.5,fontWeight:FontWeight.w800)),
    ]));
}

class _AbilityEffectPainter extends CustomPainter {
  _AbilityEffectPainter({required this.code,required this.progress,required this.intensity});
  final String code; final double progress,intensity;
  @override
  void paint(Canvas canvas,Size size) {
    final center=Offset(size.width*.5,size.height*.48);
    final glow=Paint()..color=const Color(0xFF55FF72).withValues(alpha:.12*intensity)
      ..maskFilter=const MaskFilter.blur(BlurStyle.normal,18);
    final stroke=Paint()..color=const Color(0xFF71FF83).withValues(alpha:.48*intensity)
      ..style=PaintingStyle.stroke..strokeWidth=2;
    final fill=Paint()..color=const Color(0xFF43E85D).withValues(alpha:.13*intensity);
    if(code=='C') {
      final r=Rect.fromCenter(center:Offset(size.width*.5,size.height*.78),
        width:size.width*(.28+progress*.05),height:size.height*.13);
      canvas.drawOval(r.inflate(9),glow);canvas.drawOval(r,fill);canvas.drawOval(r,stroke);
      for(var i=0;i<5;i++){final x=r.left+r.width*i/4;canvas.drawLine(Offset(x,r.top),Offset(x+4,r.bottom),
        Paint()..color=const Color(0xFF9BFF75).withValues(alpha:.35*intensity)..strokeWidth=1);}
    } else if(code=='Q') {
      final radius=size.height*(.23+progress*.025)*intensity.clamp(.5,1.2);
      canvas.drawCircle(center,radius+8,glow);canvas.drawCircle(center,radius,fill);
      canvas.drawCircle(center,radius,stroke);canvas.drawCircle(center,radius*.68,stroke..strokeWidth=1);
      for(var i=0;i<8;i++){canvas.save();canvas.translate(center.dx,center.dy);
        canvas.rotate(i*3.14159/4+progress*.5);
        canvas.drawLine(Offset(0,-radius*.72),Offset(0,-radius*1.25),
          Paint()..color=const Color(0xFF75FF86).withValues(alpha:.5*intensity)..strokeWidth=2);canvas.restore();}
    } else if(code=='E') {
      final wall=Rect.fromLTWH(size.width*.12,size.height*.27,size.width*.76,size.height*.34);
      final rr=RRect.fromRectAndRadius(wall,const Radius.circular(12));
      canvas.drawRRect(rr,glow);canvas.drawRRect(rr,fill);canvas.drawRRect(rr,stroke);
      for(var i=0;i<9;i++){final x=wall.left+wall.width*i/8;final wave=(i.isEven?1:-1)*progress*7;
        canvas.drawLine(Offset(x,wall.top+5+wave),Offset(x,wall.bottom-5-wave),
          Paint()..color=const Color(0xFF8BFF91).withValues(alpha:.4*intensity)..strokeWidth=1.2);}
    } else {
      final radius=size.height*(.3+progress*.035);
      canvas.drawCircle(center,radius+12,glow);canvas.drawCircle(center,radius,fill);
      canvas.drawCircle(center,radius,stroke..strokeWidth=3);
      canvas.drawCircle(center,radius*.72,stroke..strokeWidth=1.5);
      canvas.drawCircle(center,radius*.4,stroke..strokeWidth=1);
      for(var i=0;i<12;i++){canvas.save();canvas.translate(center.dx,center.dy);
        canvas.rotate(i*3.14159/6+progress*.35);
        canvas.drawLine(Offset(0,-radius*.78),Offset(0,-radius*1.1),
          Paint()..color=const Color(0xFF75FF86).withValues(alpha:.55*intensity)..strokeWidth=2);canvas.restore();}
    }
  }
  @override
  bool shouldRepaint(covariant _AbilityEffectPainter old)=>old.code!=code||old.progress!=progress||old.intensity!=intensity;
}
