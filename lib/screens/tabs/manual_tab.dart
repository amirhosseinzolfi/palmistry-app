import 'package:flutter/material.dart';
import '../../services/pkg_database_service.dart';
import '../../theme/app_theme.dart';

/// Encyclopedia Manual Tab with search and categorized horizontal card lists
class ManualTab extends StatelessWidget {
  final PkgDatabaseService dbService;
  final TextEditingController searchController;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final void Function(String fid, String title, String desc) onFeatureSelected;
  final String? Function(String fid) getCoverImagePath;

  const ManualTab({
    super.key,
    required this.dbService,
    required this.searchController,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onFeatureSelected,
    required this.getCoverImagePath,
  });

  List<dynamic> _filterFeatures(List<dynamic> originalList) {
    if (searchQuery.trim().isEmpty) return originalList;
    final query = searchQuery.toLowerCase();
    return originalList.where((item) {
      final String id = item['id'];
      final String name = dbService.translate("${id}_name").toLowerCase();
      final String desc = dbService.translate("${id}_desc").toLowerCase();
      return name.contains(query) || desc.contains(query);
    }).toList();
  }

  Widget _buildDefaultCoverGradient(Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.35),
            AppColors.surfaceDark,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -15,
            top: -15,
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: 0.12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredLines = _filterFeatures(dbService.majorLines);
    final filteredMinorLines = _filterFeatures(dbService.minorLines);
    final filteredMounts = _filterFeatures(dbService.mounts);
    final filteredSigns = _filterFeatures(dbService.marks);
    final filteredFingers = _filterFeatures(dbService.fingers);
    final filteredThumbs = _filterFeatures(dbService.thumbFeatures);
    final filteredNails = _filterFeatures(dbService.nails);
    final filteredFingerprints = _filterFeatures(dbService.fingerprints);
    final filteredShapes = _filterFeatures(dbService.handShapes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: TextField(
            controller: searchController,
            style:
                AppStyles.fontBody(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: "جستجو در خطوط، کوه‌ها، نشانه‌ها و ویژگی‌ها...",
              hintStyle: AppStyles.fontCaption(
                  color: AppColors.textMuted, fontSize: 13),
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.primaryPurple),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded,
                          color: Colors.white60),
                      onPressed: onClearSearch,
                    )
                  : null,
              fillColor: AppColors.surfaceDark,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    const BorderSide(color: AppColors.surfaceCardBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide:
                    const BorderSide(color: AppColors.surfaceCardBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                    color: AppColors.primaryPurple, width: 1.2),
              ),
            ),
            onChanged: onSearchChanged,
          ),
        ),

        // Categories Cards Lists
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (filteredLines.isNotEmpty)
                  _buildSectionHeader(
                      "خطوط اصلی دست (CORE LINES)", AppColors.primaryPurple),
                if (filteredLines.isNotEmpty)
                  _buildHorizontalList(
                      filteredLines, AppColors.primaryPurple, "line"),
                if (filteredMinorLines.isNotEmpty)
                  _buildSectionHeader("خطوط فرعی و حلقه‌ها (MINOR LINES)",
                      AppColors.neonPurple),
                if (filteredMinorLines.isNotEmpty)
                  _buildHorizontalList(
                      filteredMinorLines, AppColors.neonPurple, "minor_line"),
                if (filteredMounts.isNotEmpty)
                  _buildSectionHeader("کوه‌ها و تپه‌ها (THE MOUNTS)",
                      AppColors.neonCelestialBlue),
                if (filteredMounts.isNotEmpty)
                  _buildHorizontalList(
                      filteredMounts, AppColors.neonCelestialBlue, "mount"),
                if (filteredSigns.isNotEmpty)
                  _buildSectionHeader("نشانه‌ها و علائم (SIGNS & SYMBOLS)",
                      AppColors.neonPurple),
                if (filteredSigns.isNotEmpty)
                  _buildHorizontalList(
                      filteredSigns, AppColors.neonPurple, "sign"),
                if (filteredFingers.isNotEmpty)
                  _buildSectionHeader(
                      "انگشتان دست (THE FINGERS)", AppColors.neonEmerald),
                if (filteredFingers.isNotEmpty)
                  _buildHorizontalList(
                      filteredFingers, AppColors.neonEmerald, "finger"),
                if (filteredThumbs.isNotEmpty)
                  _buildSectionHeader("ویژگی‌های انگشت شست (THUMB DETAILS)",
                      AppColors.lineMars),
                if (filteredThumbs.isNotEmpty)
                  _buildHorizontalList(
                      filteredThumbs, AppColors.lineMars, "thumb"),
                if (filteredNails.isNotEmpty)
                  _buildSectionHeader("شکل و فرم ناخن‌ها (NAILS DETAILS)",
                      AppColors.lineChildren),
                if (filteredNails.isNotEmpty)
                  _buildHorizontalList(
                      filteredNails, AppColors.lineChildren, "nail"),
                if (filteredFingerprints.isNotEmpty)
                  _buildSectionHeader(
                      "الگوهای اثر انگشت (FINGERPRINTS)", AppColors.lineGirdle),
                if (filteredFingerprints.isNotEmpty)
                  _buildHorizontalList(filteredFingerprints,
                      AppColors.lineGirdle, "fingerprint"),
                if (filteredShapes.isNotEmpty)
                  _buildSectionHeader("انواع فرم‌های دست (HAND SHAPES)",
                      AppColors.lineMarriage),
                if (filteredShapes.isNotEmpty)
                  _buildHorizontalList(
                      filteredShapes, AppColors.lineMarriage, "shape"),
                if (filteredLines.isEmpty &&
                    filteredMinorLines.isEmpty &&
                    filteredMounts.isEmpty &&
                    filteredSigns.isEmpty &&
                    filteredFingers.isEmpty &&
                    filteredThumbs.isEmpty &&
                    filteredNails.isEmpty &&
                    filteredFingerprints.isEmpty &&
                    filteredShapes.isEmpty)
                  _buildEmptyState()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // Vibrant accent pill bar
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.45),
                      blurRadius: 8,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.fontHeader(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Subtle divider that fades out
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withValues(alpha: 0.35),
                  accentColor.withValues(alpha: 0.0),
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(
      List<dynamic> list, Color accentColor, String type) {
    return SizedBox(
      height: 215,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          final String fid = item['id'];
          final String title =
              dbService.translate("${fid}_name", fallback: fid);
          final String desc = dbService.translate("${fid}_desc", fallback: "");
          final String? coverPath = getCoverImagePath(fid);

          // Determine specific colors/icons per type
          IconData iconData = Icons.star_rounded;
          Color itemGlowColor = accentColor;

          if (type == "line") {
            if (fid == "line_life") {
              iconData = Icons.favorite_rounded;
              itemGlowColor = AppColors.lineLife;
            } else if (fid == "line_head") {
              iconData = Icons.psychology_rounded;
              itemGlowColor = AppColors.lineHead;
            } else if (fid == "line_heart") {
              iconData = Icons.volunteer_activism_rounded;
              itemGlowColor = AppColors.lineHeart;
            } else if (fid == "line_fate") {
              iconData = Icons.auto_awesome;
              itemGlowColor = AppColors.lineFate;
            } else if (fid == "line_sun") {
              iconData = Icons.wb_sunny_rounded;
              itemGlowColor = AppColors.lineSun;
            } else if (fid == "line_mercury") {
              iconData = Icons.spa_rounded;
              itemGlowColor = AppColors.lineMercury;
            }
          } else if (type == "minor_line") {
            if (fid == "ring_solomon") {
              iconData = Icons.workspace_premium_rounded;
            } else if (fid == "ring_saturn") {
              iconData = Icons.circle_outlined;
            } else if (fid == "girdle_venus") {
              iconData = Icons.gesture_rounded;
            } else if (fid == "line_marriage") {
              iconData = Icons.favorite_border_rounded;
            } else if (fid == "line_travel") {
              iconData = Icons.flight_takeoff_rounded;
            } else if (fid == "line_children") {
              iconData = Icons.child_care_rounded;
            } else if (fid == "line_influence") {
              iconData = Icons.people_outline_rounded;
            } else if (fid == "line_intuition") {
              iconData = Icons.lens_blur_rounded;
            } else if (fid == "line_bracelets") {
              iconData = Icons.menu_rounded;
            } else {
              iconData = Icons.linear_scale_rounded;
            }
          } else if (type == "mount") {
            if (fid == "mount_jupiter") {
              iconData = Icons.grade_rounded;
            } else if (fid == "mount_saturn") {
              iconData = Icons.public_rounded;
            } else if (fid == "mount_apollo") {
              iconData = Icons.wb_sunny_rounded;
            } else if (fid == "mount_mercury") {
              iconData = Icons.chat_bubble_rounded;
            } else if (fid == "mount_venus") {
              iconData = Icons.favorite_rounded;
            } else if (fid == "mount_moon") {
              iconData = Icons.brightness_2_rounded;
            } else {
              iconData = Icons.shield_rounded;
            }
          } else if (type == "sign") {
            if (fid == "mark_star") {
              iconData = Icons.star_rounded;
            } else if (fid == "mark_triangle") {
              iconData = Icons.change_history_rounded;
            } else if (fid == "mark_square") {
              iconData = Icons.crop_square_rounded;
            } else if (fid == "mark_cross") {
              iconData = Icons.add_rounded;
            } else if (fid == "mark_island") {
              iconData = Icons.lens_blur_rounded;
            } else if (fid == "mark_dot") {
              iconData = Icons.circle;
            } else if (fid == "mark_trident") {
              iconData = Icons.alt_route_rounded;
            } else if (fid == "mark_fish") {
              iconData = Icons.set_meal_rounded;
            } else {
              iconData = Icons.grid_goldenratio_rounded;
            }
          } else if (type == "finger") {
            iconData = Icons.back_hand_rounded;
          } else if (type == "thumb") {
            if (fid == "thumb_length") {
              iconData = Icons.height_rounded;
            } else if (fid == "thumb_will_phalange") {
              iconData = Icons.psychology_rounded;
            } else if (fid == "thumb_logic_phalange") {
              iconData = Icons.lightbulb_rounded;
            } else if (fid == "thumb_flexibility") {
              iconData = Icons.sync_alt_rounded;
            } else {
              iconData = Icons.navigation_rounded;
            }
          } else if (type == "nail") {
            iconData = Icons.crop_original_rounded;
          } else if (type == "fingerprint") {
            iconData = Icons.fingerprint_rounded;
          } else if (type == "shape") {
            iconData = Icons.category_rounded;
          }

          return GestureDetector(
            onTap: () => onFeatureSelected(fid, title, desc),
            child: Container(
              width: 155,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              decoration: AppStyles.cardDecoration(
                backgroundColor: AppColors.surfaceCard,
                borderColor: AppColors.surfaceCardBorder.withValues(alpha: 0.6),
                borderRadius: 18,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Modern Cover Banner (Top Section)
                    SizedBox(
                      height: 105,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (coverPath != null)
                            Image.asset(
                              coverPath,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) =>
                                  _buildDefaultCoverGradient(itemGlowColor),
                            )
                          else
                            _buildDefaultCoverGradient(itemGlowColor),

                          // Dark gradient transition at bottom of cover image
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.surfaceCard.withValues(alpha: 0.95),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),

                          // Top Badges & Icon Overlay
                          Positioned(
                            top: 8,
                            left: 8,
                            right: 8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceDark
                                        .withValues(alpha: 0.85),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          itemGlowColor.withValues(alpha: 0.4),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Icon(
                                    iconData,
                                    color: itemGlowColor,
                                    size: 16,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceDark
                                        .withValues(alpha: 0.65),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chevron_left_rounded,
                                    color: AppColors.textMuted,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Card Content Body (Bottom Section)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.fontTitle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              desc,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppStyles.fontBody(
                                fontSize: 10.5,
                                height: 1.35,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
      decoration: AppStyles.cardDecoration(
        backgroundColor: AppColors.surfaceCard,
        borderColor: AppColors.surfaceCardBorder,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded,
              size: 44, color: AppColors.textMuted),
          const SizedBox(height: 10),
          Text(
            "موردی یافت نشد",
            style: AppStyles.fontTitle(
                color: AppColors.textPrimary, fontSize: 14.5),
          ),
          const SizedBox(height: 5),
          Text(
            "عبارت دیگری را جستجو کنید.",
            textAlign: TextAlign.center,
            style:
                AppStyles.fontCaption(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 18),
          TextButton(
            onPressed: onClearSearch,
            child: Text(
              "پاک کردن جستجو",
              style: AppStyles.fontTitle(
                  color: AppColors.neonElectricBlue, fontSize: 13),
            ),
          )
        ],
      ),
    );
  }
}
