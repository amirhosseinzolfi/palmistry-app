import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Modern Floating Island Navigation Dock with center AI Wizard Action Button
class IslandNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onWizardPressed;

  const IslandNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onWizardPressed,
  });

  @override
  Widget build(BuildContext context) {
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
                  color: AppColors.surfaceCardBorder.withValues(alpha: 0.4),
                  width: 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 18,
                    spreadRadius: 1,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: AppColors.primaryPurple.withValues(alpha: 0.10),
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

                  // Tab 2: Insights / بینش‌ها
                  _buildNavItem(
                    index: 2,
                    activeIcon: Icons.auto_awesome_mosaic_rounded,
                    inactiveIcon: Icons.auto_awesome_mosaic_outlined,
                    label: "بینش‌ها",
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
                onTap: onWizardPressed,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.wizardButtonGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryPurple.withValues(alpha: 0.50),
                        blurRadius: 16,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: AppColors.neonPurple.withValues(alpha: 0.35),
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

  Widget _buildNavItem({
    required int index,
    required IconData activeIcon,
    required IconData inactiveIcon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;
    const Color activeColor = AppColors.neonPurple;
    final Color inactiveColor = AppColors.textMuted.withValues(alpha: 0.65);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTabSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryPurple.withValues(alpha: 0.20)
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
}
