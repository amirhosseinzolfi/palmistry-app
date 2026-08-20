import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'fullscreen_image_viewer.dart';

/// Draggable bottom sheet displaying feature details, cover banner, and interpretations
class FeatureDetailSheet extends StatelessWidget {
  final String featureId;
  final String title;
  final String desc;
  final String? coverImagePath;
  final List<Map<String, String>> interpretations;
  final ScrollController scrollController;

  const FeatureDetailSheet({
    super.key,
    required this.featureId,
    required this.title,
    required this.desc,
    this.coverImagePath,
    required this.interpretations,
    required this.scrollController,
  });

  static void show({
    required BuildContext context,
    required String featureId,
    required String title,
    required String desc,
    String? coverImagePath,
    required List<Map<String, String>> interpretations,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.52,
          minChildSize: 0.38,
          maxChildSize: 0.90,
          expand: false,
          builder: (context, scrollController) {
            return FeatureDetailSheet(
              featureId: featureId,
              title: title,
              desc: desc,
              coverImagePath: coverImagePath,
              interpretations: interpretations,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(color: AppColors.surfaceCardBorder, width: 1.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 30),
          children: [
            // Pull Indicator
            Center(
              child: Container(
                width: 42,
                height: 4.5,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

            // Modern Cover Banner Image inside Bottom Sheet (if available)
            if (coverImagePath != null) ...[
              GestureDetector(
                onTap: () =>
                    FullscreenImageViewer.show(context, coverImagePath!),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.primaryPurple.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Stack(
                      children: [
                        Hero(
                          tag: coverImagePath!,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Image.asset(
                              coverImagePath!,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) =>
                                  const SizedBox(),
                            ),
                          ),
                        ),
                        // Subtle gradient at bottom
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.surfaceDark.withValues(alpha: 0.7),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],

            // Title Header with Glowing Icon Badge
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryPurple.withValues(alpha: 0.35),
                      width: 1.0,
                    ),
                  ),
                  child: const Icon(Icons.auto_awesome,
                      color: AppColors.neonPurple, size: 18),
                ),
                Expanded(
                  child: Text(
                    title,
                    style: AppStyles.fontHeader(
                      fontSize: 19,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Main Explanation in BOLD text directly below topic
            Text(
              desc,
              style: AppStyles.fontBody(
                fontSize: 14.5,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                height: 1.65,
              ),
            ),

            const SizedBox(height: 20),

            // Interpretations list
            if (interpretations.isNotEmpty) ...[
              Text(
                "معانی و حالات مختلف در کف‌بینی:",
                style: AppStyles.fontTitle(
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...interpretations.map((interp) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: AppStyles.cardDecoration(
                    backgroundColor: AppColors.surfaceCard,
                    borderColor: AppColors.surfaceCardBorder,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Glowing Icon Circle Badge on the right
                      Container(
                        width: 34,
                        height: 34,
                        margin: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                          color:
                              AppColors.primaryPurple.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                AppColors.primaryPurple.withValues(alpha: 0.3),
                            width: 1.0,
                          ),
                        ),
                        child: const Icon(
                          Icons.star_rounded,
                          color: AppColors.neonPurple,
                          size: 17,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              interp['state'] ?? '',
                              style: AppStyles.fontTitle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              interp['explanation'] ?? '',
                              style: AppStyles.fontBody(
                                fontSize: 13.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ] else ...[
              Text(
                "تفاسیر و جزئیات بیشتر به زودی افزوده می‌شود.",
                style: AppStyles.fontCaption(
                  fontSize: 13,
                  color: AppColors.textMuted,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
