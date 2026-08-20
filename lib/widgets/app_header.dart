import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Full-Width Sleek Island Header Container at top of screen
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceCardBorder, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // App Logo PNG
          ClipOval(
            child: Image.asset(
              'assets/images/app inside logi.png',
              width: 34,
              height: 34,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/app icon logo.png',
                  width: 34,
                  height: 34,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(width: 10),

          // App Name "کف‌بین"
          Text(
            "کف‌بین",
            style: AppStyles.fontHeader(
              fontSize: 17.5,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),

          const SizedBox(width: 8),

          // Minimal AI badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
            decoration: BoxDecoration(
              color: AppColors.primaryIndigo.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppColors.primaryIndigo.withValues(alpha: 0.4),
                width: 0.8,
              ),
            ),
            child: Text(
              "هوشمند",
              style: AppStyles.fontCaption(
                fontSize: 9,
                color: AppColors.neonElectricBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Dot Separator
          Container(
            width: 3.5,
            height: 3.5,
            decoration: const BoxDecoration(
              color: AppColors.textMuted,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 8),

          // Tagline description beside name
          Expanded(
            child: Text(
              "دستیار هوشمند خودشناسی",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.fontCaption(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
