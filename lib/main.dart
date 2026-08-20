import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'services/onboarding_service.dart';
import 'services/user_info_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final onboardingService = OnboardingService();
  final userInfoService = UserInfoService();

  final bool onboardingComplete =
      await onboardingService.isOnboardingComplete();
  final user = await userInfoService.loadLocalUserInfo();
  final bool isLoggedIn = user != null;

  runApp(PalmistryApp(
    startScreen: !onboardingComplete
        ? const OnboardingScreen()
        : (isLoggedIn ? const HomeScreen() : const AuthScreen()),
  ));
}

class PalmistryApp extends StatelessWidget {
  final Widget startScreen;

  const PalmistryApp({super.key, required this.startScreen});

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
      home: startScreen,
    );
  }
}
