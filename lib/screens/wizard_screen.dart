import 'package:flutter/material.dart';
import '../services/pkg_database_service.dart';
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
        backgroundColor: Color(0xFF070A13),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00F2FE)),
        ),
      );
    }

    final int totalSteps = _dbService.wizardSteps.length;
    final double progress = (_currentStep + 1) / totalSteps;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF070A13),
        appBar: AppBar(
          backgroundColor: const Color(0xFF04060C),
          elevation: 0,
          title: const Text(
            "طالع‌خوان تعاملی کف‌بینی",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazirmatn',
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(6.0),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0x15FFFFFF),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00F2FE)),
              minHeight: 4.0,
            ),
          ),
        ),
        body: Column(
          children: [
            // Step counter indicator
            Padding(
              padding: const EdgeInsets.only(top: 15, right: 20, left: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "مرحله ${_currentStep + 1} از $totalSteps",
                    style: const TextStyle(
                      color: Color(0xFF00F2FE),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                  Text(
                    "${(progress * 100).toInt()}% کامل شده",
                    style: const TextStyle(
                      color: Color(0xFF6C7A9C),
                      fontSize: 11,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                ],
              ),
            ),

            // Main Slide Container
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Force using buttons or option taps
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
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _dbService.translate(step['title_key']),
                          style: const TextStyle(
                            color: Color(0xFFFFB703),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Vazirmatn',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _dbService.translate(step['desc_key']),
                          style: const TextStyle(
                            color: Color(0xFFA9B2C3),
                            fontSize: 13,
                            height: 1.6,
                            fontFamily: 'Vazirmatn',
                          ),
                        ),
                        const SizedBox(height: 25),
                        
                        // Options grid/list
                        ...options.map((opt) {
                          final String optVal = opt['value'];
                          final bool isSelected = savedVal == optVal;
                          return GestureDetector(
                            onTap: () => _onOptionSelected(stepKey, optVal),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? const Color(0xFF6366F1).withOpacity(0.12)
                                    : const Color(0xFF12162B),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF6366F1) : const Color(0x10FFFFFF),
                                  width: isSelected ? 1.5 : 1.0,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(0xFF6366F1).withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        )
                                      ]
                                    : null,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Selected Radio Icon
                                  Container(
                                    margin: const EdgeInsets.only(top: 3, left: 12),
                                    child: Icon(
                                      isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                      color: isSelected ? const Color(0xFF00F2FE) : const Color(0xFF6C7A9C),
                                      size: 20,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          _dbService.translate(opt['label_key']),
                                          style: TextStyle(
                                            color: isSelected ? const Color(0xFFFFB703) : Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Vazirmatn',
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          _dbService.translate(opt['desc_key']),
                                          style: const TextStyle(
                                            color: Color(0xFFA9B2C3),
                                            fontSize: 12,
                                            height: 1.5,
                                            fontFamily: 'Vazirmatn',
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

            // Footer navigation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                color: Color(0xFF0B0E20),
                border: Border(top: BorderSide(color: Color(0x10FFFFFF))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Prev Btn
                  TextButton.icon(
                    onPressed: _currentStep > 0
                        ? () {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text("مرحله قبل", style: TextStyle(fontFamily: 'Vazirmatn')),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.white24,
                    ),
                  ),

                  // Step Indicators (Dots)
                  Row(
                    children: List.generate(totalSteps, (i) {
                      final bool isCurrent = i == _currentStep;
                      final bool isDone = i < _currentStep;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isCurrent ? 8 : 6,
                        height: isCurrent ? 8 : 6,
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? const Color(0xFF00F2FE)
                              : isDone
                                  ? const Color(0xFF6366F1)
                                  : const Color(0x30FFFFFF),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),

                  // Next / Finish Btn
                  ElevatedButton(
                    onPressed: () {
                      final step = _dbService.wizardSteps[_currentStep];
                      final String stepKey = step['key'];
                      final List<dynamic> options = step['options'] ?? [];
                      // Select first option as default if nothing selected yet
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
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentStep == totalSteps - 1 ? "دریافت نتیجه" : "مرحله بعد",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn'),
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
