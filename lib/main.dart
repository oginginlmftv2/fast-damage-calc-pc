import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '最速ダメ計 for PC',
      theme: AppTheme.dark,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
