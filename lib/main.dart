import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PalmistryApp());
}

class PalmistryApp extends StatelessWidget {
  const PalmistryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'راهنمای تعاملی کف‌بینی',
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

      // Premium Indigo Cosmic Theme styling
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080A16),
        primaryColor: const Color(0xFF6366F1),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF00F2FE),
          background: Color(0xFF080A16),
          surface: Color(0xFF12162B),
          error: Color(0xFFEF4444),
        ),

        textTheme: const TextTheme(
          displayLarge: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn'),
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn'),
          bodyLarge: TextStyle(height: 1.6, fontFamily: 'Vazirmatn'),
          bodyMedium: TextStyle(height: 1.6, fontFamily: 'Vazirmatn'),
        ),

        // AppBar configurations
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B0E20),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.white,
            fontFamily: 'Vazirmatn',
          ),
        ),

        // Card default settings
        cardTheme: CardThemeData(
          color: const Color(0xFF12162B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0x15FFFFFF), width: 1),
          ),
          elevation: 0,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
