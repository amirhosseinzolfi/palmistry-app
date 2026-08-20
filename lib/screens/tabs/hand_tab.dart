import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/hand_painter.dart';

/// Interactive Hand Tab with dynamic legend map overlay and vertical island menu
class HandTab extends StatelessWidget {
  final String? selectedId;
  final String activeFilter;
  final ValueChanged<String> onElementSelected;
  final ValueChanged<String> onFilterChanged;

  const HandTab({
    super.key,
    required this.selectedId,
    required this.activeFilter,
    required this.onElementSelected,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, 0),
          radius: 1.0,
          colors: [
            AppColors.surfaceLightCard.withValues(alpha: 0.3),
            AppColors.scaffoldBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.surfaceCardBorder, width: 0.8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Hand Widget taking the full background space
            Positioned.fill(
              child: InteractiveHandWidget(
                selectedId: selectedId,
                activeFilter: activeFilter,
                onSelected: onElementSelected,
              ),
            ),

            // Items Legend Overlay across FULL WIDTH at the top
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: _buildActiveLegendMap(),
            ),

            // Modern Vertical Island Pill Secondary Menu beside Hand
            _buildSecondaryMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveLegendMap() {
    switch (activeFilter) {
      case "major":
        return _buildMajorLinesLegendMap();
      case "minor":
        return _buildMinorLinesLegendMap();
      case "mounts":
        return _buildMountsLegendMap();
      case "symbols":
        return _buildSymbolsLegendMap();
      case "fingers":
        return _buildFingersLegendMap();
      case "all":
      default:
        return _buildAllLegendMap();
    }
  }

  Widget _buildAllLegendMap() {
    final List<Map<String, dynamic>> items = [
      {"id": "line-heart", "name": "خط قلب", "color": AppColors.lineHeart},
      {"id": "line-head", "name": "خط سر", "color": AppColors.lineHead},
      {"id": "line-life", "name": "خط زندگی", "color": AppColors.lineLife},
      {
        "id": "mount-jupiter",
        "name": "کوه مشتری",
        "color": AppColors.mountJupiter
      },
      {"id": "mount-venus", "name": "کوه ونوس", "color": AppColors.mountVenus},
      {
        "id": "symbol-star",
        "name": "ستاره",
        "color": AppColors.neonCelestialBlue
      },
      {"id": "finger-thumb", "name": "شست", "color": AppColors.primaryPurple},
    ];

    return _buildGenericLegendMap(items, title: "همه بخش‌های دست");
  }

  Widget _buildMountsLegendMap() {
    final List<Map<String, dynamic>> items = [
      {
        "id": "mount-jupiter",
        "name": "کوه مشتری",
        "color": AppColors.mountJupiter
      },
      {"id": "mount-saturn", "name": "کوه زحل", "color": AppColors.mountSaturn},
      {
        "id": "mount-apollo",
        "name": "کوه خورشید",
        "color": AppColors.mountApollo
      },
      {
        "id": "mount-mercury",
        "name": "کوه عطارد",
        "color": AppColors.mountMercury
      },
      {
        "id": "mount-mars-lower",
        "name": "مریخ مثبت",
        "color": AppColors.mountMarsLower
      },
      {
        "id": "mount-mars-upper",
        "name": "مریخ منفی",
        "color": AppColors.mountMarsUpper
      },
      {
        "id": "mount-mars-plain",
        "name": "دشت مریخ",
        "color": AppColors.mountMarsPlain
      },
      {"id": "mount-venus", "name": "کوه ونوس", "color": AppColors.mountVenus},
      {"id": "mount-moon", "name": "کوه ماه", "color": AppColors.mountMoon},
    ];

    return _buildGenericLegendMap(items, title: "تپه‌ها و کوه‌های دست");
  }

  Widget _buildMajorLinesLegendMap() {
    final List<Map<String, dynamic>> items = [
      {"id": "line-heart", "name": "خط قلب", "color": AppColors.lineHeart},
      {"id": "line-head", "name": "خط سر", "color": AppColors.lineHead},
      {"id": "line-life", "name": "خط زندگی", "color": AppColors.lineLife},
      {"id": "line-fate", "name": "خط سرنوشت", "color": AppColors.lineFate},
      {"id": "line-sun", "name": "خط خورشید", "color": AppColors.lineSun},
      {
        "id": "line-mercury",
        "name": "خط سلامت",
        "color": AppColors.lineMercury
      },
    ];

    return _buildGenericLegendMap(items, title: "خطوط اصلی دست");
  }

  Widget _buildMinorLinesLegendMap() {
    final List<Map<String, dynamic>> items = [
      {"id": "ring-saturn", "name": "حلقه زحل", "color": AppColors.ringSaturn},
      {
        "id": "ring-solomon",
        "name": "حلقه سلیمان",
        "color": AppColors.ringSolomon
      },
      {
        "id": "line-girdle-venus",
        "name": "کمربند ونوس",
        "color": AppColors.lineGirdle
      },
      {
        "id": "line-marriage",
        "name": "خط ازدواج",
        "color": AppColors.lineMarriage
      },
      {
        "id": "line-children",
        "name": "خطوط فرزندان",
        "color": AppColors.lineChildren
      },
      {
        "id": "line-intuition",
        "name": "خط شهود",
        "color": AppColors.lineIntuition
      },
      {"id": "line-travel", "name": "خطوط سفر", "color": AppColors.lineTravel},
      {
        "id": "line-influence",
        "name": "خطوط نفوذ",
        "color": AppColors.lineInfluence
      },
      {"id": "line-mars", "name": "خط مریخ", "color": AppColors.lineMars},
      {
        "id": "line-bracelets",
        "name": "خطوط مچ",
        "color": AppColors.lineBracelets
      },
    ];

    return _buildGenericLegendMap(items, title: "خطوط فرعی و حلقه‌های دست");
  }

  Widget _buildSymbolsLegendMap() {
    final List<Map<String, dynamic>> items = [
      {
        "id": "symbol-star",
        "name": "ستاره",
        "color": AppColors.neonCelestialBlue
      },
      {"id": "symbol-cross", "name": "صلیب", "color": AppColors.neonRose},
      {"id": "symbol-square", "name": "مربع", "color": AppColors.neonEmerald},
      {"id": "symbol-triangle", "name": "مثلث", "color": AppColors.lineHead},
      {"id": "symbol-island", "name": "جزیره", "color": AppColors.neonPurple},
      {"id": "symbol-grille", "name": "شبکه", "color": AppColors.neonPink},
      {"id": "symbol-dot", "name": "نقطه", "color": AppColors.neonCyan},
      {"id": "symbol-trident", "name": "سه‌شاخ", "color": AppColors.neonLime},
      {"id": "symbol-fish", "name": "ماهی", "color": AppColors.neonPurple},
    ];

    return _buildGenericLegendMap(items, title: "نشانه‌ها و علائم ویژه دست");
  }

  Widget _buildFingersLegendMap() {
    final List<Map<String, dynamic>> items = [
      {
        "id": "finger-thumb",
        "name": "انگشت شست",
        "color": AppColors.primaryPurple
      },
      {
        "id": "finger-jupiter",
        "name": "انگشت اشاره",
        "color": AppColors.neonLime
      },
      {"id": "finger-saturn", "name": "انگشت وسط", "color": AppColors.lineHead},
      {
        "id": "finger-apollo",
        "name": "انگشت حلقه",
        "color": AppColors.neonCelestialBlue
      },
      {
        "id": "finger-mercury",
        "name": "انگشت کوچک",
        "color": AppColors.neonCyan
      },
    ];

    return _buildGenericLegendMap(items, title: "انگشتان و فرم بندهای دست");
  }

  Widget _buildGenericLegendMap(List<Map<String, dynamic>> items,
      {required String title}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Title in BOLD WHITE text
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppStyles.fontTitle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),

        // Items pills wrapped across FULL WIDTH
        if (items.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: items.map((item) {
              final bool isSelected = selectedId == item["id"];
              final Color color = item["color"] as Color;

              return GestureDetector(
                onTap: () => onElementSelected(item["id"] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withValues(alpha: 0.3)
                        : AppColors.surfaceDark.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? color : color.withValues(alpha: 0.4),
                      width: 1.0,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7.5,
                        height: 7.5,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item["name"] as String,
                        style: AppStyles.fontCaption(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildSecondaryMenu() {
    return Positioned(
      right: 8,
      top: 60,
      bottom: 15,
      child: Center(
        child: Container(
          width: 46,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
          decoration: BoxDecoration(
            color: const Color(0xF20B0C22),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: const Color(0x35C084FC),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.50),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSecondaryMenuItem(
                icon: Icons.show_chart_rounded,
                label: "اصلی",
                filterValue: "major",
                accentColor: AppColors.neonCelestialBlue,
              ),
              const SizedBox(height: 2),
              _buildSecondaryMenuItem(
                icon: Icons.polyline_rounded,
                label: "فرعی",
                filterValue: "minor",
                accentColor: AppColors.neonPurple,
              ),
              const SizedBox(height: 2),
              _buildSecondaryMenuItem(
                icon: Icons.terrain_rounded,
                label: "کوه‌ها",
                filterValue: "mounts",
                accentColor: AppColors.neonEmerald,
              ),
              const SizedBox(height: 2),
              _buildSecondaryMenuItem(
                icon: Icons.auto_awesome_rounded,
                label: "نشانه‌ها",
                filterValue: "symbols",
                accentColor: AppColors.neonPink,
              ),
              const SizedBox(height: 2),
              _buildSecondaryMenuItem(
                icon: Icons.pan_tool_rounded,
                label: "انگشتان",
                filterValue: "fingers",
                accentColor: AppColors.lineMars,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryMenuItem({
    required IconData icon,
    required String label,
    required String filterValue,
    required Color accentColor,
  }) {
    final bool isSelected = activeFilter == filterValue;

    return GestureDetector(
      onTap: () => onFilterChanged(filterValue),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? accentColor.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? accentColor
                  : AppColors.textMuted.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: 40,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.fontCaption(
                  fontSize: 8.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                  color: isSelected
                      ? accentColor
                      : AppColors.textMuted.withValues(alpha: 0.65),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
