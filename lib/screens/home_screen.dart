import 'package:flutter/material.dart';
import '../services/pkg_database_service.dart';
import '../theme/app_theme.dart';
import '../widgets/hand_painter.dart';
import 'wizard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PkgDatabaseService _dbService = PkgDatabaseService();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = true;
  int _currentTabIndex = 0; // 0: Interactive Hand Tab, 1: Manual/Search Tab
  String _handFilter =
      "major"; // "major", "minor", "mounts", "symbols", "fingers"
  String _searchQuery = "";
  String? _selectedSvgId;

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    await _dbService.initialize();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Map the SVG target ID to our normalized PKG database IDs
  String? _mapSvgIdToFeatureId(String targetId) {
    if (targetId.startsWith("finger-")) {
      final fingerName = targetId.split("-")[1];
      if (fingerName == "thumb") return "thumb_length";
      if (fingerName == "jupiter") return "finger_index";
      if (fingerName == "saturn") return "finger_middle";
      if (fingerName == "apollo") return "finger_ring";
      if (fingerName == "mercury") return "finger_little";
    } else if (targetId.startsWith("mount-")) {
      if (targetId == "mount-jupiter") return "mount_jupiter";
      if (targetId == "mount-saturn") return "mount_saturn";
      if (targetId == "mount-apollo") return "mount_apollo";
      if (targetId == "mount-mercury") return "mount_mercury";
      if (targetId == "mount-venus") return "mount_venus";
      if (targetId == "mount-moon") return "mount_moon";
      if (targetId == "mount-mars-lower") return "mount_mars_positive";
      if (targetId == "mount-mars-upper") return "mount_mars_negative";
      if (targetId == "mount-mars-plain") return "mount_plain_mars";
    } else if (targetId.startsWith("line-")) {
      if (targetId == "line-life") return "line_life";
      if (targetId == "line-head") return "line_head";
      if (targetId == "line-heart") return "line_heart";
      if (targetId == "line-fate") return "line_fate";
      if (targetId == "line-sun") return "line_sun";
      if (targetId == "line-mercury") return "line_mercury";
      if (targetId == "line-marriage") return "line_marriage";
      if (targetId == "line-travel") return "line_travel";
      if (targetId == "line-children") return "line_children";
      if (targetId == "line-intuition") return "line_intuition";
      if (targetId == "line-girdle-venus") return "girdle_venus";
      if (targetId == "line-influence") return "line_influence";
      if (targetId == "line-bracelets") return "line_bracelets";
      if (targetId == "line-mars") return "line_influence";
    } else if (targetId.startsWith("ring-")) {
      if (targetId == "ring-solomon") return "ring_solomon";
      if (targetId == "ring-saturn") return "ring_saturn";
      if (targetId == "ring-apollo") return "ring_saturn";
      if (targetId == "ring-mercury") return "ring_saturn";
    } else if (targetId.startsWith("symbol-")) {
      if (targetId == "symbol-star") return "mark_star";
      if (targetId == "symbol-cross") return "mark_cross";
      if (targetId == "symbol-square") return "mark_square";
      if (targetId == "symbol-triangle") return "mark_triangle";
      if (targetId == "symbol-island") return "mark_island";
      if (targetId == "symbol-grille") return "mark_grille";
      if (targetId == "symbol-dot") return "mark_dot";
      if (targetId == "symbol-trident") return "mark_trident";
      if (targetId == "symbol-fish") return "mark_fish";
    }
    return null;
  }

  void _onElementSelected(String targetId) {
    setState(() {
      _selectedSvgId = targetId;
    });

    final String? featureId = _mapSvgIdToFeatureId(targetId);
    if (featureId != null) {
      final String title =
          _dbService.translate("${featureId}_name", fallback: targetId);
      final String desc =
          _dbService.translate("${featureId}_desc", fallback: "");
      _showFeatureDetailBottomSheet(featureId, title, desc);
    }
  }

  String? _getCoverImagePath(String featureId) {
    final normalized = featureId.toLowerCase().replaceAll('-', '_');
    if (normalized == 'line_head') {
      return 'assets/images/covers/head line hand.jpeg';
    }
    return null;
  }

  Widget _buildDefaultCoverGradient(Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            accentColor.withOpacity(0.35),
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
                color: accentColor.withOpacity(0.12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFullscreenImage(BuildContext context, String imagePath) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withOpacity(0.92),
        pageBuilder: (ctx, animation, _) {
          return FadeTransition(
            opacity: animation,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: GestureDetector(
                onTap: () => Navigator.of(ctx).pop(),
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Pinch-to-zoom interactive viewer
                      Center(
                        child: InteractiveViewer(
                          minScale: 0.8,
                          maxScale: 5.0,
                          child: Hero(
                            tag: imagePath,
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFeatureDetailBottomSheet(
      String featureId, String title, String desc) {
    final interpretations = _dbService.getInterpretationsForFeature(featureId);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.75),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.52,
          minChildSize: 0.38,
          maxChildSize: 0.90,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: const Border(
                  top: BorderSide(
                      color: AppColors.surfaceCardBorder, width: 1.0),
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
                          color: AppColors.primaryPurple.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),

                    // Modern Cover Banner Image inside Bottom Sheet (if available)
                    if (_getCoverImagePath(featureId) != null) ...[
                      GestureDetector(
                        onTap: () => _showFullscreenImage(
                          context,
                          _getCoverImagePath(featureId)!,
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: AppColors.primaryPurple.withOpacity(0.25),
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Stack(
                              children: [
                                // Full-aspect-ratio image (not cropped)
                                Hero(
                                  tag: _getCoverImagePath(featureId)!,
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.asset(
                                      _getCoverImagePath(featureId)!,
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
                                          AppColors.surfaceDark
                                              .withOpacity(0.7),
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

                    // Title Header with Glowing Icon Badge (Matching Reference UI Screen 4)
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          margin: const EdgeInsets.only(left: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple.withOpacity(0.18),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color:
                                    AppColors.primaryPurple.withOpacity(0.35),
                                width: 1.0),
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

                    // Interpretations list (Matching Reference UI Screen 4 & 6 Card Style)
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
                                      AppColors.primaryPurple.withOpacity(0.18),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.primaryPurple
                                          .withOpacity(0.3),
                                      width: 1.0),
                                ),
                                child: const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.neonPurple,
                                  size: 17,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
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
                      }).toList(),
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
          },
        );
      },
    );
  }

  // Filter dynamic lists on search queries
  List<dynamic> _filterFeatures(List<dynamic> originalList) {
    if (_searchQuery.trim().isEmpty) return originalList;
    final query = _searchQuery.toLowerCase();
    return originalList.where((item) {
      final String id = item['id'];
      final String name = _dbService.translate("${id}_name").toLowerCase();
      final String desc = _dbService.translate("${id}_desc").toLowerCase();
      return name.contains(query) || desc.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.neonElectricBlue),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Full-Width Sleek Island Container at top of page (Matching Reference UI Header style)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.surfaceCardBorder, width: 1.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // App Logo PNG (No neon shadow)
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: AppColors.primaryIndigo.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: AppColors.primaryIndigo.withOpacity(0.4),
                            width: 0.8),
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

                    // Description BESIDE name in ONE ROW!
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
              ),

              // Main Tab Content
              Expanded(
                child: IndexedStack(
                  index: _currentTabIndex,
                  children: [
                    _buildHandTab(),
                    _buildManualTab(),
                    _buildHistoryTab(),
                    _buildProfileTab(),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Modern Floating Island Navigation Dock (Matching Reference Image Menu Style)
        bottomNavigationBar: _buildModernIslandNavigationBar(),
      ),
    );
  }

  // Modern Floating Island Navigation Dock
  Widget _buildModernIslandNavigationBar() {
    return SafeArea(
      bottom: true,
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            // Glassmorphic Translucent Dark Island Container
            Container(
              height: 64,
              decoration: BoxDecoration(
                color: const Color(
                    0xF00D0E26), // Dark obsidian cosmic indigo background
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.surfaceCardBorder.withOpacity(0.4),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.45),
                    blurRadius: 18,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: AppColors.primaryPurple.withOpacity(0.10),
                    blurRadius: 12,
                    spreadRadius: -2,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Tab 0: Home / خانه
                  _buildNavItem(
                    index: 0,
                    activeIcon: Icons.home_rounded,
                    inactiveIcon: Icons.home_outlined,
                    label: "خانه",
                  ),

                  // Tab 1: Learn / دانشنامه
                  _buildNavItem(
                    index: 1,
                    activeIcon: Icons.menu_book_rounded,
                    inactiveIcon: Icons.menu_book_outlined,
                    label: "دانشنامه",
                  ),

                  // Empty gap for middle floating island circle button
                  const SizedBox(width: 58),

                  // Tab 2: History / سوابق
                  _buildNavItem(
                    index: 2,
                    activeIcon: Icons.access_time_filled_rounded,
                    inactiveIcon: Icons.access_time_rounded,
                    label: "سوابق",
                  ),

                  // Tab 3: Profile / پروفایل
                  _buildNavItem(
                    index: 3,
                    activeIcon: Icons.person_rounded,
                    inactiveIcon: Icons.person_outline_rounded,
                    label: "پروفایل",
                  ),
                ],
              ),
            ),

            // Middle Floating Circle AI Wizard Button (Vertically & Horizontally Centered)
            Positioned(
              top: -6,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WizardScreen()),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.wizardButtonGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple.withOpacity(0.50),
                        blurRadius: 16,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.neonPurple.withOpacity(0.35),
                      width: 1.0,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Minimal & Modern Navigation Item Widget
  Widget _buildNavItem({
    required int index,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
  }) {
    final bool isSelected = _currentTabIndex == index;
    final Color activeColor = AppColors.neonPurple;
    final Color inactiveColor = AppColors.textMuted.withOpacity(0.65);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _currentTabIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryPurple.withOpacity(0.20)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                color: isSelected ? activeColor : inactiveColor,
                size: 21,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppStyles.fontCaption(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.textPrimary : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandTab() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 4, 12, 8),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0, 0),
          radius: 1.0,
          colors: [
            AppColors.surfaceLightCard.withOpacity(0.3),
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
                selectedId: _selectedSvgId,
                activeFilter: _handFilter,
                onSelected: _onElementSelected,
              ),
            ),

            // Items Legend Overlay across FULL WIDTH at the top
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: _buildActiveLegendMap(),
            ),

            // Modern Vertical Island Pill Secondary Menu beside Hand (Matching Reference Image)
            _buildSecondaryMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveLegendMap() {
    switch (_handFilter) {
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

  // Generic Legend Overlay across FULL WIDTH with NO background container card!
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

        // Items pills wrapped across FULL WIDTH (NO background card wrapping them!)
        if (items.isNotEmpty)
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: items.map((item) {
              final bool isSelected = _selectedSvgId == item["id"];
              final Color color = item["color"] as Color;

              return GestureDetector(
                onTap: () => _onElementSelected(item["id"] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? color.withOpacity(0.3)
                        : AppColors.surfaceDark.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? color : color.withOpacity(0.4),
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

  // Modern Vertical Island Secondary Menu beside Hand — Minimal Pill Style
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
                color: Colors.black.withOpacity(0.50),
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
    final bool isSelected = _handFilter == filterValue;

    return GestureDetector(
      onTap: () {
        setState(() {
          _handFilter = filterValue;
          _selectedSvgId = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
        decoration: BoxDecoration(
          color:
              isSelected ? accentColor.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon only — no background circle or border
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? accentColor
                  : AppColors.textMuted.withOpacity(0.7),
            ),
            const SizedBox(height: 2),
            // Minimal label — compact, wraps to 2 lines max
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
                      : AppColors.textMuted.withOpacity(0.65),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManualTab() {
    final filteredLines = _filterFeatures(_dbService.majorLines);
    final filteredMinorLines = _filterFeatures(_dbService.minorLines);
    final filteredMounts = _filterFeatures(_dbService.mounts);
    final filteredSigns = _filterFeatures(_dbService.marks);
    final filteredFingers = _filterFeatures(_dbService.fingers);
    final filteredThumbs = _filterFeatures(_dbService.thumbFeatures);
    final filteredNails = _filterFeatures(_dbService.nails);
    final filteredFingerprints = _filterFeatures(_dbService.fingerprints);
    final filteredShapes = _filterFeatures(_dbService.handShapes);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search Header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: TextField(
            controller: _searchController,
            style:
                AppStyles.fontBody(color: AppColors.textPrimary, fontSize: 14),
            decoration: InputDecoration(
              hintText: "جستجو در خطوط، کوه‌ها، نشانه‌ها و ویژگی‌ها...",
              hintStyle: AppStyles.fontCaption(
                  color: AppColors.textMuted, fontSize: 13),
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.primaryPurple),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded,
                          color: Colors.white60),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = "";
                        });
                      },
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
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
        ),

        // Categories Cards Lists (Matching Reference UI Screen 4 Card Style)
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
                      color: accentColor.withOpacity(0.45),
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
                  accentColor.withOpacity(0.35),
                  accentColor.withOpacity(0.0),
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
              _dbService.translate("${fid}_name", fallback: fid);
          final String desc = _dbService.translate("${fid}_desc", fallback: "");
          final String? coverPath = _getCoverImagePath(fid);

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
            onTap: () => _showFeatureDetailBottomSheet(fid, title, desc),
            child: Container(
              width: 155,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              decoration: AppStyles.cardDecoration(
                backgroundColor: AppColors.surfaceCard,
                borderColor: AppColors.surfaceCardBorder.withOpacity(0.6),
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
                                  AppColors.surfaceCard.withOpacity(0.95),
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
                                    color:
                                        AppColors.surfaceDark.withOpacity(0.85),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: itemGlowColor.withOpacity(0.4),
                                        width: 1.0),
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
                                    color:
                                        AppColors.surfaceDark.withOpacity(0.65),
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
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = "";
              });
            },
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

  // History Tab (سوابق و تحلیل‌های انجام شده)
  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Title Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: AppStyles.cardDecoration(
              backgroundColor: AppColors.surfaceCard,
              borderColor: AppColors.surfaceCardBorder,
              showGlow: true,
              glowColor: AppColors.primaryPurple,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColors.primaryPurple.withOpacity(0.4)),
                  ),
                  child: const Icon(Icons.history_rounded,
                      color: AppColors.neonPurple, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "تاریخچه و سوابق تحلیل کیهانی",
                        style: AppStyles.fontTitle(
                            fontSize: 15, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "گزارش‌های ذخیره‌شده و تحلیل‌های هوشمند قبلی شما",
                        style: AppStyles.fontCaption(
                            fontSize: 11.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Sample History Items
          _buildHistoryCardItem(
            date: "امروز - ۱۷:۳۰",
            title: "تحلیل جامع دست راست (عنصر آتش)",
            summary:
                "کهن‌الگو: آتش | خط سر عمیق | خط قلب منحنی | کوه ونوس برجسته",
            isRecent: true,
          ),
          const SizedBox(height: 12),
          _buildHistoryCardItem(
            date: "دیروز - ۲۱:۱۵",
            title: "ارزیابی خطوط اصلی و تپه مشتری",
            summary:
                "خط سرنوشت مستقیم | خط زندگی شفاف | علامت ستاره روی کوه مشتری",
            isRecent: false,
          ),
          const SizedBox(height: 12),
          _buildHistoryCardItem(
            date: "۳ روز پیش",
            title: "تحلیل الگوهای ناخن و بندهای انگشت",
            summary:
                "بند منطق قوی | ناخن‌های بادامی | کهن‌الگو هوا و تفکر استراتژیک",
            isRecent: false,
          ),
          const SizedBox(height: 24),

          // Action Button to Start New Wizard Analysis
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.wizardButtonGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const WizardScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.auto_awesome_rounded,
                  color: Colors.white, size: 20),
              label: Text(
                "شروع تحلیل جدید با هوش مصنوعی",
                style: AppStyles.fontTitle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHistoryCardItem({
    required String date,
    required String title,
    required String summary,
    required bool isRecent,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppStyles.cardDecoration(
        backgroundColor: AppColors.surfaceCard,
        borderColor: isRecent
            ? AppColors.primaryPurple.withOpacity(0.6)
            : AppColors.surfaceCardBorder,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            margin: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              color: isRecent
                  ? AppColors.primaryPurple.withOpacity(0.2)
                  : const Color(0x12FFFFFF),
              shape: BoxShape.circle,
              border: Border.all(
                color: isRecent
                    ? AppColors.primaryPurple
                    : const Color(0x18FFFFFF),
                width: 1.0,
              ),
            ),
            child: Icon(
              Icons.auto_stories_rounded,
              color: isRecent ? AppColors.neonPurple : AppColors.textMuted,
              size: 18,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: AppStyles.fontTitle(
                          fontSize: 13.5, color: AppColors.textPrimary),
                    ),
                    Text(
                      date,
                      style: AppStyles.fontCaption(
                          fontSize: 10, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  summary,
                  style: AppStyles.fontBody(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Profile Tab (پروفایل کیهانی و تنظیمات)
  Widget _buildProfileTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile Header Avatar Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppStyles.cardDecoration(
              backgroundColor: AppColors.surfaceCard,
              borderColor: AppColors.surfaceCardBorder,
              showGlow: true,
              glowColor: AppColors.primaryIndigo,
            ),
            child: Column(
              children: [
                // Glowing Avatar Circle
                Container(
                  width: 72,
                  height: 72,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.neonGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple.withOpacity(0.4),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceDark,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: AppColors.neonPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "پروفایل کیهانی کاربر",
                  style: AppStyles.fontHeader(
                      fontSize: 17, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.primaryPurple.withOpacity(0.4)),
                  ),
                  child: Text(
                    "عنصر غالب: کهن‌الگو آتش 🔥",
                    style: AppStyles.fontCaption(
                        fontSize: 11,
                        color: AppColors.neonPurple,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stats Overview Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: AppStyles.cardDecoration(
                      backgroundColor: AppColors.surfaceCard),
                  child: Column(
                    children: [
                      Text("۲۴",
                          style: AppStyles.fontHeader(
                              fontSize: 20, color: AppColors.neonElectricBlue)),
                      const SizedBox(height: 2),
                      Text("نشانه‌شناسی",
                          style: AppStyles.fontCaption(
                              fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: AppStyles.cardDecoration(
                      backgroundColor: AppColors.surfaceCard),
                  child: Column(
                    children: [
                      Text("۵",
                          style: AppStyles.fontHeader(
                              fontSize: 20, color: AppColors.neonPurple)),
                      const SizedBox(height: 2),
                      Text("کارنامه کامل",
                          style: AppStyles.fontCaption(
                              fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: AppStyles.cardDecoration(
                      backgroundColor: AppColors.surfaceCard),
                  child: Column(
                    children: [
                      Text("۹۸٪",
                          style: AppStyles.fontHeader(
                              fontSize: 20, color: AppColors.neonEmerald)),
                      const SizedBox(height: 2),
                      Text("دقت تحلیل",
                          style: AppStyles.fontCaption(
                              fontSize: 11, color: AppColors.textMuted)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Settings & Info List
          _buildProfileTile(
            icon: Icons.menu_book_rounded,
            title: "راهنمای کامل خواندن خطوط دست",
            subtitle: "آموزش اصول و مبانی کف‌بینی قدم به قدم",
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildProfileTile(
            icon: Icons.palette_rounded,
            title: "پوسته و ظاهر برنامه",
            subtitle: "حالت کیهانی (کف‌بین Dark Obsidian)",
            onTap: () {},
          ),
          const SizedBox(height: 10),
          _buildProfileTile(
            icon: Icons.info_outline_rounded,
            title: "درباره کف‌بین AI",
            subtitle: "نسخه ۲.۴.۰ - سیستم هوشمند خودشناسی",
            onTap: () {},
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: AppStyles.cardDecoration(
          backgroundColor: AppColors.surfaceCard,
          borderColor: AppColors.surfaceCardBorder,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: AppColors.primaryIndigo.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.neonElectricBlue, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppStyles.fontTitle(
                          fontSize: 13.5, color: AppColors.textPrimary)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: AppStyles.fontCaption(
                          fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_left_rounded,
                color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
