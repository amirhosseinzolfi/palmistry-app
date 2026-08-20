import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Daily & Astrological Insight Tab (بینش‌های روزانه و کیهانی)
class InsightTab extends StatelessWidget {
  const InsightTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Archetype Banner
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppStyles.cardDecoration(
              backgroundColor: AppColors.surfaceCard,
              borderColor: AppColors.primaryPurple.withValues(alpha: 0.3),
              showGlow: true,
              glowColor: AppColors.primaryPurple,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.primaryPurple.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded,
                      color: AppColors.neonPurple, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "عنصر غالب شما: آتش",
                        style: AppStyles.fontHeader(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "خلاق، پرشور و عمل‌گرا. امروز انرژی درونی شما در بالاترین سطح است.",
                        style: AppStyles.fontBody(
                            fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          _buildSectionHeader(
              "طالع‌بینی و بینش روزانه", AppColors.neonElectricBlue),
          const SizedBox(height: 12),
          _buildInsightCard(
            title: "وضعیت ستارگان",
            content:
                "امروز هم‌راستایی مشتری و مریخ به شما قدرت تصمیم‌گیری فوق‌العاده‌ای می‌دهد. در کارهای گروهی پیش‌قدم شوید.",
            icon: Icons.wb_twilight_rounded,
            accentColor: AppColors.neonPurple,
            badge: "امروز",
          ),
          const SizedBox(height: 12),
          _buildInsightCard(
            title: "توصیه کیهانی",
            content:
                "از گوش دادن به شهود خود غافل نشوید. پاسخ سوالی که مدت‌هاست به دنبالش هستید، در سکوت ذهن شما نهفته است.",
            icon: Icons.psychology_rounded,
            accentColor: AppColors.neonElectricBlue,
            badge: "ویژه",
          ),
          const SizedBox(height: 24),

          _buildSectionHeader("عددشناسی (Numerology)", AppColors.neonPink),
          const SizedBox(height: 12),
          _buildInsightCard(
            title: "عدد مسیر زندگی (۸)",
            content:
                "عدد ۸ نماد فراوانی و تعادل است. امروز روی نظم بخشیدن به امور مالی و برنامه‌های بلندمدت خود تمرکز کنید.",
            icon: Icons.pin_rounded,
            accentColor: AppColors.neonPink,
            badge: "عدد شما",
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppStyles.fontTitle(
              color: AppColors.textPrimary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required String title,
    required String content,
    required IconData icon,
    required Color accentColor,
    required String badge,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppStyles.cardDecoration(
        backgroundColor: AppColors.surfaceCard,
        borderColor: AppColors.surfaceCardBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: accentColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.fontTitle(fontSize: 15),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  badge,
                  style: AppStyles.fontCaption(
                    fontSize: 10,
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            content,
            style: AppStyles.fontBody(fontSize: 13, height: 1.6),
          ),
        ],
      ),
    );
  }
}
