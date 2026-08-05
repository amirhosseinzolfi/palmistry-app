import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PalmistryApp());
}

class PalmistryApp extends StatelessWidget {
  const PalmistryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'کف‌بین',
      debugShowCheckedModeBanner: false,
      
      // RTL Farsi Localization settings
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa', 'IR'), // Farsi
      ],
      locale: const Locale('fa', 'IR'),

      // Premium Unified Indigo & Dark Blue Cosmic Theme styling
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}

