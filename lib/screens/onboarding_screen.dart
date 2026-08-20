import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/onboarding_service.dart';
import 'auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "خودشناسی مدرن با هوش مصنوعی",
      description: "ترکیب هنر باستانی کف‌بینی با تکنولوژی مدرن و هوش مصنوعی برای درک عمیق‌تر از خود و مسیر زندگی.",
      icon: Icons.auto_awesome_rounded,
      color: AppColors.primaryIndigo,
    ),
    OnboardingData(
      title: "دانشنامه جامع کف‌بینی",
      description: "آموزش کامل و تفسیر دقیق تمامی خطوط، علائم و نشانه‌های کف دست برای یادگیری هنر تحلیلگری.",
      icon: Icons.menu_book_rounded,
      color: AppColors.neonElectricBlue,
    ),
    OnboardingData(
      title: "تحلیلگر هوشمند و اختصاصی",
      description: "تجربه‌ای منحصر‌به‌فرد با تحلیل تصاویر دست و پاسخ به سوالات کلیدی برای دریافت تفسیری دقیق و شخصی‌سازی شده.",
      icon: Icons.psychology_rounded,
      color: AppColors.primaryPurple,
    ),
    OnboardingData(
      title: "بینش روزانه و عددشناسی",
      description: "تحلیل روزانه، طالع‌بینی و عددشناسی بر اساس نام و تاریخ تولد برای دریافت راهنمایی‌های اختصاصی هر روز.",
      icon: Icons.insights_rounded,
      color: AppColors.neonPink,
    ),
  ];

  void _onNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  Future<void> _finishOnboarding() async {
    await OnboardingService().setOnboardingComplete();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return OnboardingPageWidget(data: _pages[index]);
            },
          ),

          // Navigation controls
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Column(
              children: [
                // Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? _pages[_currentPage].color
                            : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Action Button
                GestureDetector(
                  onTap: _onNextPage,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _pages[_currentPage].color,
                          _pages[_currentPage].color.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: _pages[_currentPage].color.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _currentPage == _pages.length - 1 ? "بزن بریم" : "بعدی",
                        style: AppStyles.fontHeader(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Skip button
          if (_currentPage < _pages.length - 1)
            Positioned(
              top: 50,
              left: 20,
              child: TextButton(
                onPressed: _finishOnboarding,
                child: Text(
                  "رد کردن",
                  style: AppStyles.fontCaption(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPageWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: data.color.withOpacity(0.1),
              border: Border.all(color: data.color.withOpacity(0.2), width: 2),
            ),
            child: Icon(
              data.icon,
              size: 100,
              color: data.color,
            ),
          ),
          const SizedBox(height: 50),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: AppStyles.fontHeader(fontSize: 24),
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: AppStyles.fontBody(fontSize: 16),
          ),
          const SizedBox(height: 100), // Space for indicator and button
        ],
      ),
    );
  }
}
