import 'package:flutter/material.dart';
import 'package:viper/pages/home_pages.dart';
import 'package:viper/theme/viper_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Viper',
      debugShowCheckedModeBanner: false,
      theme: ViperTheme.dark,
      home: const HomePage(),
    );
  }
}
