import 'package:flutter/material.dart';
import '../services/pkg_database_service.dart';
import '../theme/app_theme.dart';
import 'report_screen.dart';

class WizardScreen extends StatefulWidget {
  const WizardScreen({Key? key}) : super(key: key);

  @override
  State<WizardScreen> createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  final PkgDatabaseService _dbService = PkgDatabaseService();
  final PageController _pageController = PageController();
  
  bool _isLoading = true;
  int _currentStep = 0;
  final Map<String, String> _selections = {};

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
    _pageController.dispose();
    super.dispose();
  }

  void _onOptionSelected(String key, String value) {
    setState(() {
      _selections[key] = value;
    });

    // Automatically slide to next page after a tiny delay for visual confirmation
    Future.delayed(const Duration(milliseconds: 350), () {
      if (_currentStep < _dbService.wizardSteps.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _navigateToReport();
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

    final int totalSteps = _dbService.wizardSteps.length;
    final double progress = (_currentStep + 1) / totalSteps;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.appBarBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Column(
            children: [
              Text(
                "تحلیل هوشمند کف‌بینی",
                style: AppStyles.fontHeader(fontSize: 16, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 2),
              Text(
                "مرحله ${_currentStep + 1} از $totalSteps",
                style: AppStyles.fontCaption(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0x15FFFFFF),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryPurple),
              minHeight: 4.0,
            ),
          ),
        ),
        body: Column(
          children: [
            // Main Slide Container
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
                  final step = _dbService.wizardSteps[index];
                  final String stepKey = step['key'];
                  final savedVal = _selections[stepKey];
                  final List<dynamic> options = step['options'] ?? [];

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Step Title
                        Text(
                          _dbService.translate(step['title_key']),
                          style: AppStyles.fontHeader(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Step Description
                        Text(
                          _dbService.translate(step['desc_key']),
                          style: AppStyles.fontBody(
                            color: AppColors.textSecondary,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Options list matching Reference Image Style
                        ...options.map((opt) {
                          final String optVal = opt['value'];
                          final bool isSelected = savedVal == optVal;
                          return GestureDetector(
                            onTap: () => _onOptionSelected(stepKey, optVal),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
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
                                  // Selected Circular Icon Badge (Matching Reference UI)
                                  Container(
                                    width: 36,
                                    height: 36,
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
                                            color: isSelected ? AppColors.textPrimary : AppColors.textPrimary,
                                            fontSize: 14.5,
                                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          _dbService.translate(opt['desc_key']),
                                          style: AppStyles.fontBody(
                                            color: AppColors.textSecondary,
                                            fontSize: 12.5,
                                            height: 1.55,
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
                },
              ),
            ),

            // Numbered Step Dots (Matching Reference UI Screen 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(totalSteps, (i) {
                  final bool isCurrent = i == _currentStep;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isCurrent ? 24 : 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? AppColors.primaryPurple
                          : const Color(0x18FFFFFF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isCurrent ? AppColors.neonPurple : const Color(0x15FFFFFF),
                        width: 1.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${i + 1}",
                        style: AppStyles.fontCaption(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isCurrent ? Colors.white : AppColors.textMuted,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Footer Navigation Bar (Matching Reference UI Action Buttons)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                color: AppColors.navBarBackground,
                border: Border(top: BorderSide(color: AppColors.surfaceCardBorder, width: 1.0)),
              ),
              child: Row(
                children: [
                  // Back Button (Outline pill button matching Reference UI)
                  if (_currentStep > 0)
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                          label: Text("قبلی", style: AppStyles.fontTitle(fontSize: 13, color: AppColors.textPrimary)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            backgroundColor: AppColors.surfaceCard,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: AppColors.surfaceCardBorder, width: 1.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),

                  // Next / Finish Button (Gradient action button matching Reference UI)
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.wizardButtonGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withOpacity(0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          final step = _dbService.wizardSteps[_currentStep];
                          final String stepKey = step['key'];
                          final List<dynamic> options = step['options'] ?? [];
                          if (!_selections.containsKey(stepKey) && options.isNotEmpty) {
                            _selections[stepKey] = options[0]['value'];
                          }

                          if (_currentStep < totalSteps - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _navigateToReport();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _currentStep == totalSteps - 1 ? "دریافت نتیجه تحلیل" : "مرحله بعدی",
                              style: AppStyles.fontTitle(fontSize: 13.5, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_back_rounded, size: 18, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
