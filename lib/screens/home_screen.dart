import 'package:flutter/material.dart';
import '../services/pkg_database_service.dart';
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
  String _handFilter = "all"; // "all", "lines", "mounts", "symbols", "fingers"
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
      final String title = _dbService.translate("${featureId}_name", fallback: targetId);
      final String desc = _dbService.translate("${featureId}_desc", fallback: "");
      _showFeatureDetailBottomSheet(featureId, title, desc);
    }
  }

  void _showFeatureDetailBottomSheet(String featureId, String title, String desc) {
    final interpretations = _dbService.getInterpretationsForFeature(featureId);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.7),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.45,
          minChildSize: 0.35,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0B0E17),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                border: Border(
                  top: BorderSide(color: Color(0x406366F1), width: 1.5),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
                  children: [
                    // Pull Indicator
                    Center(
                      child: Container(
                        width: 45,
                        height: 5,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),

                    // Title Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Color(0xFF00F2FE),
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Vazirmatn',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white54, size: 22),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Description
                    Text(
                      desc,
                      style: const TextStyle(
                        color: Color(0xFFA9B2C3),
                        fontSize: 14.5,
                        height: 1.7,
                        fontFamily: 'Vazirmatn',
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Slide up Tip
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.keyboard_double_arrow_up_rounded, size: 16, color: Color(0xFF6366F1)),
                        const SizedBox(width: 6),
                        Text(
                          "برای مشاهده جزئیات حالت‌ها بالا بکشید",
                          style: TextStyle(
                            color: const Color(0xFF6366F1).withOpacity(0.9),
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Vazirmatn',
                          ),
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Divider(color: Color(0x15FFFFFF), height: 1),
                    ),

                    // Interpretations lists
                    if (interpretations.isNotEmpty) ...[
                      const Text(
                        "معانی و حالات مختلف در کف‌بینی:",
                        style: TextStyle(
                          color: Color(0xFFFFB703),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Vazirmatn',
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...interpretations.map((interp) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF14172C).withOpacity(0.65),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0x08FFFFFF), width: 1.2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                interp['state'] ?? '',
                                style: const TextStyle(
                                  color: Color(0xFF00F2FE),
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Vazirmatn',
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                interp['explanation'] ?? '',
                                style: const TextStyle(
                                  color: Color(0xFFA9B2C3),
                                  fontSize: 13,
                                  height: 1.6,
                                  fontFamily: 'Vazirmatn',
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ] else ...[
                      const Text(
                        "تفاسیر و جزئیات بیشتر به زودی افزوده می‌شود.",
                        style: TextStyle(
                          color: Colors.white30,
                          fontSize: 13,
                          fontFamily: 'Vazirmatn',
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
        backgroundColor: Color(0xFF070A13),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00F2FE)),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF070A13),
        appBar: AppBar(
          backgroundColor: const Color(0xFF04060C),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF00F2FE)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.back_hand, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Text(
                "طالع‌بین کیهانی تعاملی",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazirmatn',
                ),
              ),
            ],
          ),
        ),
        body: IndexedStack(
          index: _currentTabIndex,
          children: [
            _buildHandTab(),
            _buildManualTab(),
          ],
        ),
        bottomNavigationBar: Container(
          height: 75,
          decoration: const BoxDecoration(
            color: Color(0xFF04060C),
            border: Border(
              top: BorderSide(color: Color(0x15FFFFFF), width: 1),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Tab 1: Interactive Map
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _currentTabIndex = 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.back_hand_rounded,
                          color: _currentTabIndex == 0 ? const Color(0xFF00F2FE) : const Color(0x50FFFFFF),
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "نقشه تعاملی",
                          style: TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 11,
                            fontWeight: _currentTabIndex == 0 ? FontWeight.bold : FontWeight.normal,
                            color: _currentTabIndex == 0 ? const Color(0xFF00F2FE) : const Color(0x50FFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Shiny, round, purple wizard button in the middle
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const WizardScreen()),
                    );
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)], // Purple to Indigo shiny gradient
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B5CF6).withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFFC084FC), // Light purple shiny border highlight
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
                
                // Tab 2: Cosmic Encyclopedia
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() => _currentTabIndex = 1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.grid_view_rounded,
                          color: _currentTabIndex == 1 ? const Color(0xFF00F2FE) : const Color(0x50FFFFFF),
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "دانشنامه کیهانی",
                          style: TextStyle(
                            fontFamily: 'Vazirmatn',
                            fontSize: 11,
                            fontWeight: _currentTabIndex == 1 ? FontWeight.bold : FontWeight.normal,
                            color: _currentTabIndex == 1 ? const Color(0xFF00F2FE) : const Color(0x50FFFFFF),
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
      ),
    );
  }

  Widget _buildHandTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Helper hint text
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
          child: Text(
            "روی بخش‌های رنگی دست ضربه بزنید تا معنی و تفسیر را درجا ببینید",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6C7A9C),
              fontSize: 12,
              fontFamily: 'Vazirmatn',
            ),
          ),
        ),
        
        // Interactive Hand Map Widget Container
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, 0),
                radius: 1.0,
                colors: [
                  const Color(0xFF131832).withOpacity(0.3),
                  const Color(0xFF070A13),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x10FFFFFF)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                )
              ],
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

                  // Mounts Legend Map Overlay - displayed ONLY when mounts filter is active
                  if (_handFilter == "mounts")
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 65,
                      child: _buildMountsLegendMap(),
                    ),

                  // Major Lines Legend Map Overlay - displayed ONLY when major filter is active
                  if (_handFilter == "major")
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 65,
                      child: _buildMajorLinesLegendMap(),
                    ),

                  // Minor Lines Legend Map Overlay - displayed ONLY when minor filter is active
                  if (_handFilter == "minor")
                    Positioned(
                      top: 12,
                      left: 12,
                      right: 65,
                      child: _buildMinorLinesLegendMap(),
                    ),

                  // Minimal Vertical Island of Filter Buttons on the Right Side (inside the container)
                  Positioned(
                    right: 15,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        decoration: const BoxDecoration(
                          color: Colors.transparent, // No background, shares the hand background!
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildHandFilterIconButton(Icons.layers_rounded, "همه بخش‌ها", "all"),
                            const SizedBox(height: 12),
                            _buildHandFilterIconButton(Icons.timeline_rounded, "خطوط اصلی", "major"),
                            const SizedBox(height: 12),
                            _buildHandFilterIconButton(Icons.alt_route_rounded, "خطوط فرعی", "minor"),
                            const SizedBox(height: 12),
                            _buildHandFilterIconButton(Icons.blur_circular_rounded, "تپه‌ها (کوه‌ها)", "mounts"),
                            const SizedBox(height: 12),
                            _buildHandFilterIconButton(Icons.auto_awesome_rounded, "نشانه‌ها", "symbols"),
                            const SizedBox(height: 12),
                            _buildHandFilterIconButton(Icons.back_hand_rounded, "انگشتان", "fingers"),
                          ],
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
    );
  }

  Widget _buildMountsLegendMap() {
    final List<Map<String, dynamic>> items = [
      {"id": "mount-jupiter", "name": "کوه مشتری", "color": const Color(0xFF84CC16)},
      {"id": "mount-saturn", "name": "کوه زحل", "color": const Color(0xFF8B5CF6)},
      {"id": "mount-apollo", "name": "کوه خورشید", "color": const Color(0xFFEAB308)},
      {"id": "mount-mercury", "name": "کوه عطارد", "color": const Color(0xFF06B6D4)},
      {"id": "mount-mars-lower", "name": "مریخ مثبت", "color": const Color(0xFF84CC16)},
      {"id": "mount-mars-upper", "name": "مریخ منفی", "color": const Color(0xFFF97316)},
      {"id": "mount-mars-plain", "name": "دشت مریخ", "color": const Color(0xFFFACC15)},
      {"id": "mount-venus", "name": "کوه ونوس", "color": const Color(0xFFF43F5E)},
      {"id": "mount-moon", "name": "کوه ماه", "color": const Color(0xFFA855F7)},
    ];

    return _buildGenericLegendMap(items);
  }

  Widget _buildMajorLinesLegendMap() {
    final List<Map<String, dynamic>> items = [
      {"id": "line-heart", "name": "خط قلب", "color": const Color(0xFFEF4444)},
      {"id": "line-head", "name": "خط سر", "color": const Color(0xFF3B82F6)},
      {"id": "line-life", "name": "خط زندگی", "color": const Color(0xFF10B981)},
      {"id": "line-fate", "name": "خط سرنوشت", "color": const Color(0xFFEAB308)},
      {"id": "line-sun", "name": "خط خورشید", "color": const Color(0xFF8B5CF6)},
      {"id": "line-mercury", "name": "خط سلامت", "color": const Color(0xFF06B6D4)},
    ];

    return _buildGenericLegendMap(items);
  }

  Widget _buildMinorLinesLegendMap() {
    final List<Map<String, dynamic>> items = [
      {"id": "ring-saturn", "name": "حلقه زحل", "color": const Color(0xFF8B5CF6)},
      {"id": "ring-solomon", "name": "حلقه سلیمان", "color": const Color(0xFF22C55E)},
      {"id": "line-girdle-venus", "name": "کمربند ونوس", "color": const Color(0xFFEC4899)},
      {"id": "line-marriage", "name": "خط ازدواج", "color": const Color(0xFFA855F7)},
      {"id": "line-children", "name": "خطوط فرزندان", "color": const Color(0xFF06B6D4)},
      {"id": "line-intuition", "name": "خط شهود", "color": const Color(0xFF84CC16)},
      {"id": "line-travel", "name": "خطوط سفر", "color": const Color(0xFF0284C7)},
      {"id": "line-influence", "name": "خطوط نفوذ", "color": const Color(0xFF38BDF8)},
      {"id": "line-mars", "name": "خط مریخ", "color": const Color(0xFFF59E0B)},
      {"id": "line-bracelets", "name": "خطوط مچ", "color": const Color(0xFFF97316)},
    ];

    return _buildGenericLegendMap(items);
  }

  Widget _buildGenericLegendMap(List<Map<String, dynamic>> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x306366F1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: items.map((item) {
            final bool isSelected = _selectedSvgId == item["id"];
            final Color color = item["color"] as Color;

            return GestureDetector(
              onTap: () => _onElementSelected(item["id"] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? color.withOpacity(0.3) : const Color(0x15FFFFFF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : color.withOpacity(0.4),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.6),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      item["name"] as String,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                        fontSize: 10.5,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontFamily: 'Vazirmatn',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHandFilterIconButton(IconData icon, String label, String filterValue) {
    final bool isSelected = _handFilter == filterValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _handFilter = filterValue;
          _selectedSvgId = null;
        });
      },
      child: Tooltip(
        message: label,
        textStyle: const TextStyle(fontFamily: 'Vazirmatn', color: Colors.white, fontSize: 11),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(8),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF6366F1).withOpacity(0.2) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? const Color(0xFF6366F1) : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isSelected ? const Color(0xFF00F2FE) : const Color(0xFFA9B2C3),
          ),
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
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: "جستجو در خطوط، کوه‌ها، نشانه‌ها و ویژگی‌ها...",
              hintStyle: const TextStyle(color: Color(0xFF6C7A9C), fontSize: 13, fontFamily: 'Vazirmatn'),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF6366F1)),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white60),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = "";
                        });
                      },
                    )
                  : null,
              fillColor: const Color(0xFF14172C),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0x10FFFFFF)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0x08FFFFFF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF6366F1)),
              ),
            ),
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
          ),
        ),

        // Categories Cards Lists
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (filteredLines.isNotEmpty)
                  _buildSectionHeader("خطوط اصلی دست (THE CORE LINES)", const Color(0xFF6366F1)),
                if (filteredLines.isNotEmpty)
                  _buildHorizontalList(filteredLines, const Color(0xFF6366F1), "line"),

                if (filteredMinorLines.isNotEmpty)
                  _buildSectionHeader("خطوط فرعی و حلقه‌ها (MINOR LINES)", const Color(0xFFC084FC)),
                if (filteredMinorLines.isNotEmpty)
                  _buildHorizontalList(filteredMinorLines, const Color(0xFFC084FC), "minor_line"),

                if (filteredMounts.isNotEmpty)
                  _buildSectionHeader("کوه‌ها و تپه‌ها (THE MOUNTS)", const Color(0xFF00F2FE)),
                if (filteredMounts.isNotEmpty)
                  _buildHorizontalList(filteredMounts, const Color(0xFF00F2FE), "mount"),

                if (filteredSigns.isNotEmpty)
                  _buildSectionHeader("نشانه‌ها و علائم (SIGNS & SYMBOLS)", const Color(0xFFFFB703)),
                if (filteredSigns.isNotEmpty)
                  _buildHorizontalList(filteredSigns, const Color(0xFFFFB703), "sign"),

                if (filteredFingers.isNotEmpty)
                  _buildSectionHeader("انگشتان دست (THE FINGERS)", const Color(0xFF10B981)),
                if (filteredFingers.isNotEmpty)
                  _buildHorizontalList(filteredFingers, const Color(0xFF10B981), "finger"),

                if (filteredThumbs.isNotEmpty)
                  _buildSectionHeader("ویژگی‌های انگشت شست (THUMB DETAILS)", const Color(0xFFFB923C)),
                if (filteredThumbs.isNotEmpty)
                  _buildHorizontalList(filteredThumbs, const Color(0xFFFB923C), "thumb"),

                if (filteredNails.isNotEmpty)
                  _buildSectionHeader("شکل و فرم ناخن‌ها (NAILS DETAILS)", const Color(0xFF2DD4BF)),
                if (filteredNails.isNotEmpty)
                  _buildHorizontalList(filteredNails, const Color(0xFF2DD4BF), "nail"),

                if (filteredFingerprints.isNotEmpty)
                  _buildSectionHeader("الگوهای اثر انگشت (FINGERPRINTS)", const Color(0xFFFB7185)),
                if (filteredFingerprints.isNotEmpty)
                  _buildHorizontalList(filteredFingerprints, const Color(0xFFFB7185), "fingerprint"),

                if (filteredShapes.isNotEmpty)
                  _buildSectionHeader("انواع فرم‌های دست (HAND SHAPES)", const Color(0xFFEC4899)),
                if (filteredShapes.isNotEmpty)
                  _buildHorizontalList(filteredShapes, const Color(0xFFEC4899), "shape"),

                if (filteredLines.isEmpty && filteredMinorLines.isEmpty && filteredMounts.isEmpty && filteredSigns.isEmpty && filteredFingers.isEmpty && filteredThumbs.isEmpty && filteredNails.isEmpty && filteredFingerprints.isEmpty && filteredShapes.isEmpty)
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
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazirmatn',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<dynamic> list, Color accentColor, String type) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          final String fid = item['id'];
          final String title = _dbService.translate("${fid}_name", fallback: fid);
          final String desc = _dbService.translate("${fid}_desc", fallback: "");

          // Determine specific colors/icons per type
          IconData iconData = Icons.star_rounded;
          Color itemGlowColor = accentColor;

          if (type == "line") {
            if (fid == "line_life") { iconData = Icons.favorite_rounded; itemGlowColor = Colors.redAccent; }
            else if (fid == "line_head") { iconData = Icons.psychology_rounded; itemGlowColor = Colors.cyan; }
            else if (fid == "line_heart") { iconData = Icons.volunteer_activism_rounded; itemGlowColor = Colors.purpleAccent; }
            else if (fid == "line_fate") { iconData = Icons.auto_awesome; itemGlowColor = Colors.amber; }
            else if (fid == "line_sun") { iconData = Icons.wb_sunny_rounded; itemGlowColor = Colors.orangeAccent; }
            else if (fid == "line_mercury") { iconData = Icons.spa_rounded; itemGlowColor = Colors.greenAccent; }
          } else if (type == "minor_line") {
            if (fid == "ring_solomon") iconData = Icons.workspace_premium_rounded;
            else if (fid == "ring_saturn") iconData = Icons.circle_outlined;
            else if (fid == "girdle_venus") iconData = Icons.gesture_rounded;
            else if (fid == "line_marriage") iconData = Icons.favorite_border_rounded;
            else if (fid == "line_travel") iconData = Icons.flight_takeoff_rounded;
            else if (fid == "line_children") iconData = Icons.child_care_rounded;
            else if (fid == "line_influence") iconData = Icons.people_outline_rounded;
            else if (fid == "line_intuition") iconData = Icons.lens_blur_rounded;
            else if (fid == "line_bracelets") iconData = Icons.menu_rounded;
            else iconData = Icons.linear_scale_rounded;
          } else if (type == "mount") {
            if (fid == "mount_jupiter") iconData = Icons.grade_rounded;
            else if (fid == "mount_saturn") iconData = Icons.public_rounded;
            else if (fid == "mount_apollo") iconData = Icons.wb_sunny_rounded;
            else if (fid == "mount_mercury") iconData = Icons.chat_bubble_rounded;
            else if (fid == "mount_venus") iconData = Icons.favorite_rounded;
            else if (fid == "mount_moon") iconData = Icons.brightness_2_rounded;
            else iconData = Icons.shield_rounded;
          } else if (type == "sign") {
            if (fid == "mark_star") iconData = Icons.star_rounded;
            else if (fid == "mark_triangle") iconData = Icons.change_history_rounded;
            else if (fid == "mark_square") iconData = Icons.crop_square_rounded;
            else if (fid == "mark_cross") iconData = Icons.add_rounded;
            else if (fid == "mark_island") iconData = Icons.lens_blur_rounded;
            else if (fid == "mark_dot") iconData = Icons.circle;
            else if (fid == "mark_trident") iconData = Icons.alt_route_rounded;
            else if (fid == "mark_fish") iconData = Icons.set_meal_rounded;
            else iconData = Icons.grid_goldenratio_rounded;
          } else if (type == "finger") {
            iconData = Icons.back_hand_rounded;
          } else if (type == "thumb") {
            if (fid == "thumb_length") iconData = Icons.height_rounded;
            else if (fid == "thumb_will_phalange") iconData = Icons.psychology_rounded;
            else if (fid == "thumb_logic_phalange") iconData = Icons.lightbulb_rounded;
            else if (fid == "thumb_flexibility") iconData = Icons.sync_alt_rounded;
            else iconData = Icons.navigation_rounded;
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
              width: 145,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF14172C).withOpacity(0.65),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: itemGlowColor.withOpacity(0.15), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: itemGlowColor.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: itemGlowColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: itemGlowColor.withOpacity(0.2),
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: Icon(
                        iconData,
                        color: itemGlowColor,
                        size: 24,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Title
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Short Desc
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFFA9B2C3).withOpacity(0.7),
                      fontSize: 10.5,
                      height: 1.4,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFF14172C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x10FFFFFF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: Color(0xFF6C7A9C)),
          const SizedBox(height: 12),
          const Text(
            "موردی یافت نشد",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Vazirmatn'),
          ),
          const SizedBox(height: 6),
          const Text(
            "عبارت دیگری را جستجو کنید.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF6C7A9C), fontSize: 12.5, fontFamily: 'Vazirmatn'),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = "";
              });
            },
            child: const Text("پاک کردن جستجو", style: TextStyle(color: Color(0xFF00F2FE), fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn')),
          )
        ],
      ),
    );
  }
}
