import 'package:flutter/material.dart';
import 'package:viper/pages/agent_selection_page.dart';
import 'package:viper/theme/viper_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VALORANT Agent Archive',
      debugShowCheckedModeBanner: false,
      theme: ViperTheme.dark,
      home: const AgentSelectionPage(),
    );
  }
}
