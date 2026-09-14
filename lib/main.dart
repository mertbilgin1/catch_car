import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const CatchCarApp());
}

class CatchCarApp extends StatelessWidget {
  const CatchCarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatchCar',
      theme: AppTheme.darkTheme,
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
