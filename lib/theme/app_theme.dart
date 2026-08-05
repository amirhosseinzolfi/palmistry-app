import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized, unified design system and theme for Palmistry AI App ("کف‌بین").
/// Premium Dark Cosmic Violet & Deep Obsidian Theme inspired by PalmAI design system.
class AppColors {
  // Main Theme Base Colors (Deep Obsidian Cosmic Violet)
  static const Color background = Color(0xFF080816);
  static const Color scaffoldBackground = Color(0xFF080816);
  static const Color appBarBackground = Color(0xFF060612);
  static const Color navBarBackground = Color(0xFF060612);

  // Surface & Card Colors (Cosmic Violet Dark Surfaces with optimized contrast)
  static const Color surfaceDark = Color(0xFF0E0E24);
  static const Color surfaceCard = Color(0xFF13132E);
  static const Color surfaceCardBorder = Color(0x288B5CF6);
  static const Color surfaceLightCard = Color(0xFF1A1A3A);

  // Main Brand Colors (Electric Violet & Deep Indigo Palette)
  static const Color primaryIndigo = Color(0xFF6366F1); // Indigo 500
  static const Color primaryPurple = Color(0xFF8B5CF6); // Purple 500
  static const Color primaryViolet = Color(0xFF7C3AED); // Violet 600

  // Celestial Neon Accent Colors (Refined & Vibrant Palette)
  static const Color neonElectricBlue = Color(0xFF00F2FE); // Primary Neon Cyan
  static const Color neonPurple = Color(0xFFC084FC); // Soft Purple Glow
  static const Color neonPink = Color(0xFFEC4899); // Electric Pink Accent
  static const Color neonRose = Color(0xFFF43F5E); // Electric Rose Accent
  static const Color neonCelestialBlue = Color(0xFF38BDF8); // Celestial Sky Blue
  static const Color neonViolet = Color(0xFFA855F7); // Neon Violet
  static const Color neonEmerald = Color(0xFF10B981); // Emerald Green Accent
  static const Color neonLime = Color(0xFF84CC16); // Lime Accent
  static const Color neonCyan = Color(0xFF06B6D4); // Deep Cyan
  static const Color neonSkyBlue = Color(0xFF38BDF8); // Sky Blue Accent

  // High Readability Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC); // Clean crisp off-white (Highest contrast)
  static const Color textSecondary = Color(0xFFCBD5E1); // High contrast light blue-gray for body text
  static const Color textMuted = Color(0xFF818CF8); // Muted cosmic violet-gray
  static const Color textAccentCyan = Color(0xFF38BDF8); // Celestial cyan text highlight
  static const Color textAccentPurple = Color(0xFFC084FC); // Purple text highlight

  // Text Background Container Color (Optimized for maximum readability)
  static const Color textContainerBg = Color(0xFF0B0B20);
  static const Color textContainerBorder = Color(0x207C3AED);

  // Semantic Palm Lines Palette
  static const Color lineHeart = Color(0xFFF43F5E);    // Neon Crimson/Rose (Heart Line)
  static const Color lineHead = Color(0xFF38BDF8);     // Neon Sky Blue (Head Line)
  static const Color lineLife = Color(0xFF10B981);     // Neon Emerald (Life Line)
  static const Color lineFate = Color(0xFFA855F7);     // Neon Lavender/Purple (Fate Line)
  static const Color lineSun = Color(0xFF818CF8);      // Soft Cosmic Indigo (Sun Line)
  static const Color lineMercury = Color(0xFF06B6D4);  // Neon Cyan (Mercury Line)
  static const Color lineMarriage = Color(0xFFEC4899); // Neon Pink (Marriage Line)
  static const Color lineGirdle = Color(0xFFFB7185);   // Neon Rose (Girdle of Venus)
  static const Color lineIntuition = Color(0xFF84CC16);// Neon Lime (Intuition Line)
  static const Color lineMars = Color(0xFFF97316);     // Neon Orange (Mars Line)
  static const Color lineInfluence = Color(0xFF0284C7);// Deep Neon Blue (Influence Line)
  static const Color lineTravel = Color(0xFF0EA5E9);   // Cyan Blue (Travel Line)
  static const Color lineChildren = Color(0xFF14B8A6); // Teal (Children Line)
  static const Color lineBracelets = Color(0xFFFB923C); // Coral Orange (Wrist Lines)
  static const Color ringSolomon = Color(0xFF22C55E);  // Emerald (Solomon Ring)
  static const Color ringSaturn = Color(0xFF9333EA);   // Deep Violet (Saturn Ring)

  // Semantic Mount Colors
  static const Color mountJupiter = Color(0xFF84CC16);  // Lime (Jupiter)
  static const Color mountSaturn = Color(0xFF8B5CF6);   // Purple (Saturn)
  static const Color mountApollo = Color(0xFF818CF8);   // Celestial Indigo (Apollo/Sun)
  static const Color mountMercury = Color(0xFF06B6D4);  // Cyan (Mercury)
  static const Color mountMarsLower = Color(0xFF10B981); // Emerald (Mars Positive)
  static const Color mountMarsUpper = Color(0xFFF97316); // Orange (Mars Negative)
  static const Color mountMarsPlain = Color(0xFF38BDF8); // Sky Blue (Plain of Mars)
  static const Color mountVenus = Color(0xFFF43F5E);     // Coral Rose (Venus)
  static const Color mountMoon = Color(0xFFA855F7);      // Lavender (Moon)

  // Premium Cosmic Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient neonGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF00F2FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF161636), Color(0xFF0F0F26)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient wizardButtonGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppStyles {
  // GoogleFonts typography using Vazirmatn (Premier Persian Font for Headers & Body)
  static TextStyle fontHeader({
    double fontSize = 18,
    FontWeight fontWeight = FontWeight.bold,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.vazirmatn(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1.35,
    );
  }

  static TextStyle fontTitle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w700,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.vazirmatn(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1.4,
    );
  }

  static TextStyle fontBody({
    double fontSize = 13.5,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textSecondary,
    double height = 1.65,
  }) {
    return GoogleFonts.vazirmatn(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static TextStyle fontCaption({
    double fontSize = 11.5,
    FontWeight fontWeight = FontWeight.w500,
    Color color = AppColors.textMuted,
  }) {
    return GoogleFonts.vazirmatn(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1.4,
    );
  }

  // Minimal, Modern Card Box Decorations
  static BoxDecoration cardDecoration({
    Color? borderColor,
    Color? backgroundColor,
    double borderRadius = 18,
    bool showGlow = false,
    Color? glowColor,
  }) {
    final borderClr = borderColor ?? AppColors.surfaceCardBorder;
    final bgClr = backgroundColor ?? AppColors.surfaceCard;
    final glow = glowColor ?? AppColors.primaryPurple;

    return BoxDecoration(
      color: bgClr,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderClr, width: 1.0),
      boxShadow: [
        BoxShadow(
          color: showGlow ? glow.withOpacity(0.10) : Colors.black.withOpacity(0.25),
          blurRadius: showGlow ? 8 : 4,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration textContainerDecoration({
    Color? borderColor,
    Color? backgroundColor,
    double borderRadius = 16,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? AppColors.textContainerBg,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? AppColors.textContainerBorder,
        width: 1.0,
      ),
    );
  }
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      primaryColor: AppColors.primaryIndigo,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryIndigo,
        secondary: AppColors.neonElectricBlue,
        surface: AppColors.surfaceDark,
        error: AppColors.neonRose,
      ),

      textTheme: TextTheme(
        displayLarge: GoogleFonts.vazirmatn(fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        titleLarge: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        titleMedium: GoogleFonts.vazirmatn(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        bodyLarge: GoogleFonts.vazirmatn(height: 1.65, color: AppColors.textSecondary),
        bodyMedium: GoogleFonts.vazirmatn(height: 1.65, color: AppColors.textSecondary),
        bodySmall: GoogleFonts.vazirmatn(height: 1.5, color: AppColors.textMuted),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.appBarBackground,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: GoogleFonts.vazirmatn(
          fontWeight: FontWeight.bold,
          fontSize: 16.5,
          color: AppColors.textPrimary,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.surfaceCardBorder, width: 1),
        ),
        elevation: 0,
      ),
    );
  }
}
