import 'package:flutter/material.dart';
import '../models/user_info.dart';
import '../services/pkg_database_service.dart';
import '../services/user_info_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/feature_detail_sheet.dart';
import '../widgets/island_navigation_bar.dart';
import 'tabs/hand_tab.dart';
import 'tabs/insight_tab.dart';
import 'tabs/manual_tab.dart';
import 'tabs/profile_tab.dart';
import 'wizard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PkgDatabaseService _dbService = PkgDatabaseService();
  final UserInfoService _userInfoService = UserInfoService();

  // Search & General State
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  int _currentTabIndex = 0; // 0: Home, 1: Learn, 2: Insights, 3: Profile

  // Hand Tab State
  String _handFilter =
      "major"; // "major", "minor", "mounts", "symbols", "fingers"
  String? _selectedSvgId;
  String _searchQuery = "";

  // Profile Form Controllers & State
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _gender = "مرد";
  String _dominantHand = "راست";
  String _handSize = "متوسط";
  bool _isSaving = false;
  bool _isSynced = false;

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadDatabase() async {
    await _dbService.initialize();
    await _loadUserData();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserData() async {
    final existingUser = await _userInfoService.loadLocalUserInfo();
    if (existingUser != null) {
      _usernameController.text = existingUser.username;
      _passwordController.text = existingUser.password;
      _firstNameController.text = existingUser.firstName;
      _lastNameController.text = existingUser.lastName;
      _dobController.text = existingUser.dateOfBirth;
      _gender = existingUser.gender.isNotEmpty ? existingUser.gender : "مرد";

      final palmInfo = existingUser.palmistryInfo;
      _dominantHand = palmInfo['dominant_hand'] ?? "راست";
      _handSize = palmInfo['hand_size'] ?? "متوسط";
      _notesController.text = palmInfo['notes'] ?? "";

      _isSynced = existingUser.isSynced;
    } else {
      _dobController.text = "1375/01/15";
    }
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1998, 5, 20),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryIndigo,
              onPrimary: Colors.white,
              surface: AppColors.surfaceDark,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
            "${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _saveAndSyncData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    final UserInfoModel user = UserInfoModel(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      dateOfBirth: _dobController.text.trim(),
      gender: _gender,
      palmistryInfo: {
        'dominant_hand': _dominantHand,
        'hand_size': _handSize,
        'notes': _notesController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      },
    );

    final result = await _userInfoService.saveAndSyncUserInfo(user);

    if (mounted) {
      setState(() {
        _isSaving = false;
        if (result['data'] != null) {
          final UserInfoModel updatedUser = result['data'];
          _isSynced = updatedUser.isSynced;
        }
      });

      final bool isSuccess = result['success'] == true;
      final String msg = result['message'] ?? "";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isSuccess
                    ? Icons.cloud_done_rounded
                    : Icons.phone_android_rounded,
                color: isSuccess
                    ? AppColors.neonElectricBlue
                    : const Color(0xFFFFB703),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  msg,
                  style: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 13),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.surfaceDark,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

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

  String? _getCoverImagePath(String featureId) {
    final normalized = featureId.toLowerCase().replaceAll('-', '_');
    if (normalized == 'line_head') {
      return 'assets/images/covers/head line hand.jpeg';
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

  void _showFeatureDetailBottomSheet(
      String featureId, String title, String desc) {
    final interpretations = _dbService.getInterpretationsForFeature(featureId);
    FeatureDetailSheet.show(
      context: context,
      featureId: featureId,
      title: title,
      desc: desc,
      coverImagePath: _getCoverImagePath(featureId),
      interpretations: interpretations,
    );
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
              // Sleek Island Header
              const AppHeader(),

              // Main Tab Content
              Expanded(
                child: IndexedStack(
                  index: _currentTabIndex,
                  children: [
                    HandTab(
                      selectedId: _selectedSvgId,
                      activeFilter: _handFilter,
                      onElementSelected: _onElementSelected,
                      onFilterChanged: (newFilter) {
                        setState(() {
                          _handFilter = newFilter;
                          _selectedSvgId = null;
                        });
                      },
                    ),
                    ManualTab(
                      dbService: _dbService,
                      searchController: _searchController,
                      searchQuery: _searchQuery,
                      onSearchChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      onClearSearch: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = "";
                        });
                      },
                      onFeatureSelected: (fid, title, desc) {
                        _showFeatureDetailBottomSheet(fid, title, desc);
                      },
                      getCoverImagePath: _getCoverImagePath,
                    ),
                    const InsightTab(),
                    ProfileTab(
                      formKey: _formKey,
                      usernameController: _usernameController,
                      firstNameController: _firstNameController,
                      lastNameController: _lastNameController,
                      dobController: _dobController,
                      gender: _gender,
                      isSynced: _isSynced,
                      isSaving: _isSaving,
                      onGenderChanged: (newGender) {
                        setState(() {
                          _gender = newGender;
                        });
                      },
                      onSelectDateOfBirth: _selectDateOfBirth,
                      onSaveAndSyncData: _saveAndSyncData,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Modern Floating Island Navigation Dock
        bottomNavigationBar: IslandNavigationBar(
          currentIndex: _currentTabIndex,
          onTabSelected: (index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
          onWizardPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WizardScreen()),
            );
          },
        ),
      ),
    );
  }
}
