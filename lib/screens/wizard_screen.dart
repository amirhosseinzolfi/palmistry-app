import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/pkg_database_service.dart';
import '../theme/app_theme.dart';
import '../widgets/hand_camera_overlay.dart';
import 'report_screen.dart';

class WizardScreen extends StatefulWidget {
  const WizardScreen({super.key});

  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen>
    with TickerProviderStateMixin {
  final PkgDatabaseService _dbService = PkgDatabaseService();
  final PageController _pageController = PageController();
  final ImagePicker _imagePicker = ImagePicker();

  bool _isLoading = true;
  int _currentStep = 0;
  final Map<String, String> _selections = {};

  // Photo Capture State
  String? _capturedImagePath;
  bool _hasCapturedPhoto = false;
  bool _isCapturing = false;

  // AI Scanning State
  bool _isScanningAi = false;
  double _aiScanProgress = 0.0;
  String _currentScanLog = "در حال آماده‌سازی موتور اسکن هوش مصنوعی...";
  Timer? _scanTimer;

  // Question Step keys (3 initial questions)
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

    // Automatically slide to next step after short visual feedback
    Future.delayed(const Duration(milliseconds: 280), () {
      if (!mounted) return;
      if (_currentStep < 2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOutCubic,
        );
      } else if (_currentStep == 2) {
        // Advance from 3rd question to Photo Step (Index 3)
        _pageController.nextPage(
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() {
      _isCapturing = true;
    });

    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1400,
        maxHeight: 1400,
        imageQuality: 88,
      );

      if (pickedFile != null) {
        setState(() {
          _capturedImagePath = pickedFile.path;
          _hasCapturedPhoto = true;
          _selections['photo_path'] = pickedFile.path;
        });
      }
    } catch (e) {
      debugPrint("Camera / Image Picker error: $e");
      // Fallback for emulator or desktop: use demo image
      setState(() {
        _capturedImagePath = null;
        _hasCapturedPhoto = true;
        _selections['photo_path'] = 'demo_hand';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.surfaceLightCard,
            content: Text(
              "تصویر پیش‌فرض جهت آزمایش انتخاب شد.",
              style: AppStyles.fontCaption(color: AppColors.textPrimary),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  void _onRetakePhotoPressed() {
    setState(() {
      _hasCapturedPhoto = false;
      _capturedImagePath = null;
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
      curve: Curves.easeInOutCubic,
    );

    // Simulated AI scanning timer (Demo value until AI backend is connected)
    const totalDurationMs = 3600;
    const intervalMs = 50;
    int elapsed = 0;

    _scanTimer?.cancel();
    _scanTimer =
        Timer.periodic(const Duration(milliseconds: intervalMs), (timer) {
      elapsed += intervalMs;
      final double progress = (elapsed / totalDurationMs).clamp(0.0, 1.0);

      if (mounted) {
        setState(() {
          _aiScanProgress = progress;

          if (progress < 0.25) {
            _currentScanLog =
                "در حال پردازش پیکسل‌های تصویر و تنظیم نورسنجی...";
          } else if (progress < 0.55) {
            _currentScanLog =
                "شناسایی و استخراج خطوط اصلی (قلب، سر، زندگی و سرنوشت)...";
          } else if (progress < 0.82) {
            _currentScanLog =
                "محاسبه انرژی برجستگی‌های سیاره‌ای و هندسه کف دست...";
          } else {
            _currentScanLog =
                "ترکیب الگوریتمی هوش مصنوعی و تدوین کارنامه نهایی...";
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
        builder: (context) => ReportScreen(
          selections: _selections,
          imagePath: _capturedImagePath,
        ),
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
            // RTL-Optimized Back Arrow (Points right in RTL layout)
            icon: const Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.textPrimary, size: 19),
            tooltip: "بازگشت",
            onPressed: () {
              if (_currentStep > 0 && !_isScanningAi) {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                );
              } else {
                Navigator.pop(context);
              }
            },
          ),
          centerTitle: true,
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _currentStep < 3
                    ? "پرسش‌های پایه کف‌بینی"
                    : _currentStep == 3
                        ? "ثبت تصویر هوشمند دست"
                        : "اسکن و تحلیل هوش مصنوعی",
                style: AppStyles.fontHeader(
                    fontSize: 15.5, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                "گام ${_currentStep + 1} از ۵",
                style: AppStyles.fontCaption(
                    fontSize: 11, color: AppColors.neonElectricBlue),
              ),
            ],
          ),
          actions: const [
            // Clean symmetrical spacing on the other side
            SizedBox(width: 48),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Container(
                  height: 3.0,
                  color: const Color(0x18FFFFFF),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 300),
                      widthFactor: progress,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryPurple,
                              AppColors.neonElectricBlue
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: PageView.builder(
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
              return _buildQuestionStep(index);
            } else if (index == 3) {
              return _buildPhotoCaptureStep(isLeftHand);
            } else {
              return _buildAiScanningStep(isLeftHand);
            }
          },
        ),
      ),
    );
  }

  /// Build Question Step Widget (Steps 0 to 2) - Clean & Minimal without extra bottom buttons
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryPurple.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: AppColors.primaryPurple.withValues(alpha: 0.4)),
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
          const SizedBox(height: 18),

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
                      ? AppColors.primaryPurple.withValues(alpha: 0.18)
                      : AppColors.surfaceCard,
                  borderColor: isSelected
                      ? AppColors.primaryPurple
                      : AppColors.surfaceCardBorder,
                  showGlow: isSelected,
                  glowColor: AppColors.primaryPurple,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Radio Check Icon
                    Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryPurple.withValues(alpha: 0.3)
                            : const Color(0x12FFFFFF),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryPurple
                              : const Color(0x18FFFFFF),
                          width: 1.0,
                        ),
                      ),
                      child: Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: isSelected
                            ? AppColors.neonElectricBlue
                            : AppColors.textMuted,
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
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
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
          }),
        ],
      ),
    );
  }

  /// Build Step 4: Refined, Minimal Hand Photo Capture with Built-In Clean Guidance
  Widget _buildPhotoCaptureStep(bool isLeftHand) {
    final String handName = isLeftHand ? "دست چپ" : "دست راست";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Minimalist Modern Guidance Card (Always visible before photo capture)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.pan_tool_rounded,
                        color: AppColors.neonElectricBlue,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppStyles.fontTitle(
                              fontSize: 14, color: AppColors.textPrimary),
                          children: [
                            const TextSpan(text: "عکاسی از کف "),
                            TextSpan(
                              text: handName,
                              style: const TextStyle(
                                color: AppColors.neonElectricBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: " (دست فعال شما)"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "• کف دست را کاملاً صاف و باز رو به دوربین نگه دارید.\n• در محیطی با نور مناسب و بدون سایه شدید عکاسی کنید.",
                  style: AppStyles.fontBody(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Preset Hand Image & Camera Viewfinder Frame
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Image container: preset hand asset or user's captured photo
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0A18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _hasCapturedPhoto
                            ? AppColors.neonElectricBlue.withValues(alpha: 0.6)
                            : AppColors.surfaceCardBorder,
                        width: _hasCapturedPhoto ? 1.5 : 1.0,
                      ),
                    ),
                    child: _hasCapturedPhoto
                        ? Stack(
                            fit: StackFit.expand,
                            children: [
                              // Actual Captured Image or fallback
                              _capturedImagePath != null && !kIsWeb
                                  ? Image.file(
                                      File(_capturedImagePath!),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/hand.png',
                                      fit: BoxFit.cover,
                                    ),
                              // Minimal corner brackets
                              const HandCameraOverlay(
                                isScanning: false,
                                showVectorHand: false,
                              ),
                            ],
                          )
                        : Stack(
                            fit: StackFit.expand,
                            children: [
                              // Clean preset hand image (flipped for left hand if needed)
                              Transform.scale(
                                scaleX: isLeftHand ? -1.0 : 1.0,
                                child: Image.asset(
                                  'assets/images/hand.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Minimal corner brackets
                              const HandCameraOverlay(
                                isScanning: false,
                                showVectorHand: false,
                              ),
                            ],
                          ),
                  ),

                  // Minimal Hand Tag Badge Top-Right
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _hasCapturedPhoto
                              ? AppColors.neonElectricBlue
                              : AppColors.primaryPurple.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _hasCapturedPhoto
                                ? Icons.check_circle_rounded
                                : Icons.camera_alt_outlined,
                            color: _hasCapturedPhoto
                                ? AppColors.neonElectricBlue
                                : AppColors.neonPurple,
                            size: 13,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _hasCapturedPhoto ? "تصویر ثبت شد" : handName,
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

          const SizedBox(height: 14),

          // Action Section: Either Camera & Gallery Capture OR Review / Retake Actions
          if (!_hasCapturedPhoto) ...[
            // Capture Buttons (Camera + Gallery)
            Row(
              children: [
                // Gallery Button
                OutlinedButton.icon(
                  onPressed: _isCapturing
                      ? null
                      : () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_rounded, size: 18),
                  label: Text("گالری",
                      style: AppStyles.fontTitle(
                          fontSize: 13, color: AppColors.textPrimary)),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.surfaceCard,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    side: const BorderSide(color: AppColors.surfaceCardBorder),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(width: 10),

                // Main Camera Button
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.wizardButtonGradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppColors.primaryPurple.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _isCapturing
                          ? null
                          : () => _pickImage(ImageSource.camera),
                      icon: _isCapturing
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.camera_alt_rounded,
                              size: 20, color: Colors.white),
                      label: Text(
                        "عکاسی با دوربین",
                        style: AppStyles.fontTitle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Review Approval Prompt & Actions
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.neonElectricBlue.withValues(alpha: 0.35)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline_rounded,
                      color: AppColors.neonElectricBlue, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "آیا تصویر واضح است یا مایل به عکاسی مجدد هستید؟",
                      style: AppStyles.fontCaption(
                          fontSize: 12, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),

            // Retake vs Confirm Buttons
            Row(
              children: [
                // Retake Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _onRetakePhotoPressed,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text("عکاسی مجدد",
                        style: AppStyles.fontTitle(
                            fontSize: 13, color: AppColors.textPrimary)),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.surfaceCard,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side:
                          const BorderSide(color: AppColors.surfaceCardBorder),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Confirm and Send to AI
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.wizardButtonGradient,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color:
                              AppColors.primaryPurple.withValues(alpha: 0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _startAiScanningProcess,
                      icon: const Icon(Icons.auto_awesome_rounded,
                          size: 18, color: Colors.white),
                      label: Text(
                        "تایید و ارسال به AI",
                        style: AppStyles.fontTitle(
                            fontSize: 13.5,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Build Step 5: AI Scanning & Analyzing Animation Loading Screen
  Widget _buildAiScanningStep(bool isLeftHand) {
    final int pct = (_aiScanProgress * 100).toInt();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                  // Actual Captured User Photo or preset asset
                  _capturedImagePath != null && !kIsWeb
                      ? Image.file(
                          File(_capturedImagePath!),
                          fit: BoxFit.cover,
                        )
                      : Transform.scale(
                          scaleX: isLeftHand ? -1.0 : 1.0,
                          child: Image.asset(
                            'assets/images/hand.png',
                            fit: BoxFit.cover,
                          ),
                        ),

                  // Animated Scanning Laser & Overlay
                  HandCameraOverlay(
                    isLeftHand: isLeftHand,
                    isScanning: true,
                    scanProgress: _aiScanProgress,
                    showVectorHand: false,
                  ),

                  // Scanning Percentage Badge Center Overlay
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.80),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: AppColors.neonElectricBlue, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonElectricBlue
                                .withValues(alpha: 0.3),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome,
                              color: AppColors.neonElectricBlue, size: 28),
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
                            style: AppStyles.fontCaption(
                                fontSize: 10.5, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Dynamic AI Status Text Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppStyles.cardDecoration(
              backgroundColor: AppColors.surfaceCard,
              borderColor: AppColors.neonElectricBlue.withValues(alpha: 0.4),
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
                      style: AppStyles.fontTitle(
                          fontSize: 14, color: AppColors.neonElectricBlue),
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
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
