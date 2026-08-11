import 'dart:async';
import 'package:flutter/material.dart';
import '../services/pkg_database_service.dart';
import '../theme/app_theme.dart';
import '../widgets/hand_camera_overlay.dart';
import 'report_screen.dart';

class WizardScreen extends StatefulWidget {
  const WizardScreen({Key? key}) : super(key: key);

  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> with TickerProviderStateMixin {
  final PkgDatabaseService _dbService = PkgDatabaseService();
  final PageController _pageController = PageController();

  bool _isLoading = true;
  int _currentStep = 0;
  final Map<String, String> _selections = {};

  // Photo Capture & AI Scanning State
  bool _hasCapturedPhoto = false;
  bool _isScanningAi = false;
  double _aiScanProgress = 0.0;
  String _currentScanLog = "در حال آماده‌سازی موتور اسکن هوش مصنوعی...";
  Timer? _scanTimer;

  // Question Step keys (3 initial questions: hand shape question removed)
  final List<String> _questionKeys = [
    "activeHand",
    "skinTexture",
    "thumbType",
  ];

  @override
  void initState() {
    super.initState();
    _dbService.initialize().then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scanTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onOptionSelected(String key, String value) {
    setState(() {
      _selections[key] = value;
    });

    // Automatically slide to next step after a tiny delay for visual confirmation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_currentStep < 2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else if (_currentStep == 2) {
        // Advance from 3rd question to Photo Step (Index 3)
        _pageController.nextPage(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onCapturePhotoPressed() {
    setState(() {
      _hasCapturedPhoto = true;
    });
  }

  void _onRetakePhotoPressed() {
    setState(() {
      _hasCapturedPhoto = false;
    });
  }

  void _startAiScanningProcess() {
    setState(() {
      _currentStep = 4; // Move to AI Scanning Screen (Index 4)
      _isScanningAi = true;
      _aiScanProgress = 0.0;
      _currentScanLog = "در حال پردازش پیکسل‌های تصویر و نورسنجی...";
    });

    _pageController.animateToPage(
      4,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    // Simulated AI scanning timer (Demo value until AI backend is connected)
    const totalDurationMs = 3500;
    const intervalMs = 50;
    int elapsed = 0;

    _scanTimer?.cancel();
    _scanTimer = Timer.periodic(const Duration(milliseconds: intervalMs), (timer) {
      elapsed += intervalMs;
      final double progress = (elapsed / totalDurationMs).clamp(0.0, 1.0);

      if (mounted) {
        setState(() {
          _aiScanProgress = progress;

          if (progress < 0.25) {
            _currentScanLog = "در حال پردازش پیکسل‌های تصویر و نورسنجی...";
          } else if (progress < 0.55) {
            _currentScanLog = "شناسایی و استخراج خطوط اصلی (قلب، سر، زندگی)...";
          } else if (progress < 0.82) {
            _currentScanLog = "محاسبه انرژی برجستگی‌های سیاره‌ای و نسبت عناصر...";
          } else {
            _currentScanLog = "ترکیب الگوریتمی هوش مصنوعی و ساخت کارنامه نهایی...";
          }
        });
      }

      if (elapsed >= totalDurationMs) {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            _navigateToReport();
          }
        });
      }
    });
  }

  void _navigateToReport() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ReportScreen(selections: _selections),
      ),
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

    // Total workflow: 3 Questions + 1 Photo Step + 1 AI Scan Step = 5 steps
    const int totalSteps = 5;
    final double progress = (_currentStep + 1) / totalSteps;
    final bool isLeftHand = _selections["activeHand"] == "left_active";

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.appBarBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
            onPressed: () {
              if (_currentStep > 0 && !_isScanningAi) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          centerTitle: true,
          title: Column(
            children: [
              Text(
                _currentStep < 3
                    ? "پرسش‌نامه پایه کف‌بینی"
                    : _currentStep == 3
                        ? "ثبت تصویر هوشمند دست"
                        : "اسکن و تحلیل هوش مصنوعی",
                style: AppStyles.fontHeader(fontSize: 15.5, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                _currentStep < 3
                    ? "مرحله ${_currentStep + 1} از ۳ (سوالات پایه)"
                    : _currentStep == 3
                        ? "مرحله ۴ از ۵ (تصویر دست)"
                        : "مرحله ۵ از ۵ (اسکن AI)",
                style: AppStyles.fontCaption(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0x15FFFFFF),
              valueColor: AlwaysStoppedAnimation<Color>(
                _currentStep == 4 ? AppColors.neonElectricBlue : AppColors.primaryPurple,
              ),
              minHeight: 4.0,
            ),
          ),
        ),
        body: Column(
          children: [
            // PageView Container for the Steps
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalSteps,
                onPageChanged: (pageIndex) {
                  setState(() {
                    _currentStep = pageIndex;
                  });
                },
                itemBuilder: (context, index) {
                  if (index < 3) {
                    // Render Question Steps (0 to 2)
                    return _buildQuestionStep(index);
                  } else if (index == 3) {
                    // Render Photo Capture Step (Index 3)
                    return _buildPhotoCaptureStep(isLeftHand);
                  } else {
                    // Render AI Scanning Step (Index 4)
                    return _buildAiScanningStep(isLeftHand);
                  }
                },
              ),
            ),

            // Numbered Step Dots (Bottom Navigation Indicator)
            if (!_isScanningAi)
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(totalSteps, (i) {
                    final bool isCurrent = i == _currentStep;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: isCurrent ? 24 : 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: isCurrent ? AppColors.primaryPurple : const Color(0x18FFFFFF),
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                          color: isCurrent ? AppColors.neonPurple : const Color(0x15FFFFFF),
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          i == 3 ? "📷" : i == 4 ? "⚡" : "${i + 1}",
                          style: AppStyles.fontCaption(
                            fontSize: i >= 3 ? 9 : 9.5,
                            fontWeight: FontWeight.bold,
                            color: isCurrent ? Colors.white : AppColors.textMuted,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build Question Step Widget (Steps 0 to 2)
  Widget _buildQuestionStep(int questionIndex) {
    if (_dbService.wizardSteps.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final String targetKey = _questionKeys[questionIndex];
    final stepData = _dbService.wizardSteps.firstWhere(
      (s) => s['key'] == targetKey,
      orElse: () => _dbService.wizardSteps[questionIndex],
    );

    final String stepKey = stepData['key'];
    final savedVal = _selections[stepKey];
    final List<dynamic> options = stepData['options'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Question Number Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primaryPurple.withOpacity(0.4)),
                ),
                child: Text(
                  "سوال ${questionIndex + 1} از ۳",
                  style: AppStyles.fontCaption(
                    fontSize: 11,
                    color: AppColors.neonElectricBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Question Title
          Text(
            _dbService.translate(stepData['title_key']),
            style: AppStyles.fontHeader(
              color: AppColors.textPrimary,
              fontSize: 17.5,
            ),
          ),
          const SizedBox(height: 6),
          // Question Description
          Text(
            _dbService.translate(stepData['desc_key']),
            style: AppStyles.fontBody(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),

          // Options List
          ...options.map((opt) {
            final String optVal = opt['value'];
            final bool isSelected = savedVal == optVal;
            return GestureDetector(
              onTap: () => _onOptionSelected(stepKey, optVal),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(15),
                decoration: AppStyles.cardDecoration(
                  backgroundColor: isSelected
                      ? AppColors.primaryPurple.withOpacity(0.18)
                      : AppColors.surfaceCard,
                  borderColor: isSelected ? AppColors.primaryPurple : AppColors.surfaceCardBorder,
                  showGlow: isSelected,
                  glowColor: AppColors.primaryPurple,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Radio Check Icon
                    Container(
                      width: 34,
                      height: 34,
                      margin: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryPurple.withOpacity(0.3)
                            : const Color(0x12FFFFFF),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primaryPurple : const Color(0x18FFFFFF),
                          width: 1.0,
                        ),
                      ),
                      child: Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        color: isSelected ? AppColors.neonElectricBlue : AppColors.textMuted,
                        size: 18,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _dbService.translate(opt['label_key']),
                            style: AppStyles.fontTitle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _dbService.translate(opt['desc_key']),
                            style: AppStyles.fontBody(
                              color: AppColors.textSecondary,
                              fontSize: 12.5,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// Build Step 4: Modern Hand Photo Capture & Camera Screen
  Widget _buildPhotoCaptureStep(bool isLeftHand) {
    final String handLabel = isLeftHand ? "دست چپ" : "دست راست";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Instructions Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: AppStyles.textContainerDecoration(
              backgroundColor: AppColors.surfaceCard,
              borderColor: AppColors.surfaceCardBorder,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPurple.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt_rounded, color: AppColors.neonElectricBlue, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "عکاسی از کف $handLabel",
                        style: AppStyles.fontTitle(fontSize: 14, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "کف دست خود را کاملاً صاف رو به کادر راهنما قرار دهید.",
                        style: AppStyles.fontCaption(fontSize: 11.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Camera View / Image Preview Box
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Camera Simulation Feed / Captured Image
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C0C1E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.surfaceCardBorder),
                    ),
                    child: _hasCapturedPhoto
                        ? Image.asset(
                            'assets/images/hand.png',
                            fit: BoxFit.cover,
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              // Simulated Live Camera View Background
                              Image.asset(
                                'assets/images/hand.png',
                                fit: BoxFit.cover,
                                color: Colors.black.withOpacity(0.35),
                                colorBlendMode: BlendMode.darken,
                              ),
                              // Hand Vector Overlay Guide Frame
                              HandCameraOverlay(
                                isLeftHand: isLeftHand,
                                isScanning: false,
                              ),
                            ],
                          ),
                  ),

                  // Active Hand Indicator Tag
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.neonElectricBlue.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.pan_tool_rounded, color: AppColors.neonElectricBlue, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            "الگوی کادر: $handLabel",
                            style: AppStyles.fontCaption(
                              fontSize: 11,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
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

          const SizedBox(height: 10),

          // Gesture Guidance Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildGuidanceChip(Icons.wb_sunny_outlined, "نور کافی و مستقیم"),
                const SizedBox(width: 8),
                _buildGuidanceChip(Icons.back_hand_outlined, "کف دست صاف و باز"),
                const SizedBox(width: 8),
                _buildGuidanceChip(Icons.crop_free_rounded, "تطبیق با الگوی کادر"),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Action Buttons: Capture / Confirm / Retake
          if (!_hasCapturedPhoto)
            ElevatedButton.icon(
              onPressed: _onCapturePhotoPressed,
              icon: const Icon(Icons.camera_rounded, size: 20),
              label: Text("ثبت تصویر و بررسی", style: AppStyles.fontTitle(fontSize: 14, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryIndigo,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _onRetakePhotoPressed,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text("عکاسی مجدد", style: AppStyles.fontTitle(fontSize: 13, color: AppColors.textPrimary)),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.surfaceCard,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.surfaceCardBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.wizardButtonGradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _startAiScanningProcess,
                      icon: const Icon(Icons.auto_awesome_rounded, size: 18, color: Colors.white),
                      label: Text("تایید و اسکن AI", style: AppStyles.fontTitle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// Build Step 5: AI Scanning & Analyzing Animation Loading Screen
  Widget _buildAiScanningStep(bool isLeftHand) {
    final int pct = (_aiScanProgress * 100).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Glowing Scanning Frame
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/hand.png',
                    fit: BoxFit.cover,
                  ),
                  // Animated Scanning Laser & Overlay
                  HandCameraOverlay(
                    isLeftHand: isLeftHand,
                    isScanning: true,
                    scanProgress: _aiScanProgress,
                  ),

                  // Scanning Percentage Badge Center Overlay
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.neonElectricBlue, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonElectricBlue.withOpacity(0.3),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome, color: AppColors.neonElectricBlue, size: 28),
                          const SizedBox(height: 6),
                          Text(
                            "$pct%",
                            style: AppStyles.fontHeader(
                              fontSize: 26,
                              color: AppColors.neonElectricBlue,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            "در حال اسکن عمیق خطوط",
                            style: AppStyles.fontCaption(fontSize: 10.5, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Dynamic AI Status Text Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppStyles.cardDecoration(
              backgroundColor: AppColors.surfaceCard,
              borderColor: AppColors.neonElectricBlue.withOpacity(0.4),
              showGlow: true,
              glowColor: AppColors.neonElectricBlue,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: AppColors.neonElectricBlue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "تحلیل هوشمند تصویر دست",
                      style: AppStyles.fontTitle(fontSize: 14, color: AppColors.neonElectricBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _currentScanLog,
                  textAlign: TextAlign.center,
                  style: AppStyles.fontBody(
                    fontSize: 12.5,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildGuidanceChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.surfaceCardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.neonPurple),
          const SizedBox(width: 5),
          Text(
            text,
            style: AppStyles.fontCaption(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
