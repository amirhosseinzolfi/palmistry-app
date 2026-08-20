import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// User Profile & Settings Tab (پروفایل و مدیریت حساب)
class ProfileTab extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController usernameController;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController dobController;
  final String gender;
  final bool isSynced;
  final bool isSaving;
  final ValueChanged<String> onGenderChanged;
  final VoidCallback onSelectDateOfBirth;
  final VoidCallback onSaveAndSyncData;

  const ProfileTab({
    super.key,
    required this.formKey,
    required this.usernameController,
    required this.firstNameController,
    required this.lastNameController,
    required this.dobController,
    required this.gender,
    required this.isSynced,
    required this.isSaving,
    required this.onGenderChanged,
    required this.onSelectDateOfBirth,
    required this.onSaveAndSyncData,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Compact Modern Profile Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: AppStyles.cardDecoration(
              backgroundColor: AppColors.surfaceCard,
              borderColor: AppColors.surfaceCardBorder,
            ),
            child: Row(
              children: [
                // Avatar with Glow
                Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceDark,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_rounded,
                        color: Colors.white, size: 32),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usernameController.text.isNotEmpty
                            ? usernameController.text
                            : "کاربر جدید",
                        style: AppStyles.fontHeader(fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            isSynced
                                ? Icons.cloud_done_rounded
                                : Icons.cloud_off_rounded,
                            size: 14,
                            color: isSynced
                                ? AppColors.neonEmerald
                                : AppColors.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isSynced ? "همگام‌سازی شده" : "ذخیره محلی",
                            style: AppStyles.fontCaption(
                              color: isSynced
                                  ? AppColors.neonEmerald
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Quick Action: Sync
                IconButton(
                  onPressed: isSaving ? null : onSaveAndSyncData,
                  icon: Icon(
                    Icons.sync_rounded,
                    color: isSaving
                        ? AppColors.textMuted
                        : AppColors.neonElectricBlue,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Section: History
          _buildSectionHeader("سوابق تحلیل‌های شما", AppColors.primaryPurple),
          const SizedBox(height: 12),
          _buildHistoryCardItem(
            date: "امروز - ۱۷:۳۰",
            title: "تحلیل جامع دست راست",
            summary: "عنصر آتش | خط سر عمیق | خط قلب منحنی",
            isRecent: true,
          ),
          const SizedBox(height: 8),
          _buildHistoryCardItem(
            date: "دیروز - ۲۱:۱۵",
            title: "ارزیابی خطوط اصلی",
            summary: "خط سرنوشت مستقیم | خط زندگی شفاف",
            isRecent: false,
          ),
          const SizedBox(height: 24),

          // Section: Personal Info Settings
          _buildSectionHeader(
              "تنظیمات حساب کاربری", AppColors.neonCelestialBlue),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: AppStyles.cardDecoration(
              backgroundColor: AppColors.surfaceCard,
              borderColor: AppColors.surfaceCardBorder,
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _buildProfileTextField(
                    controller: firstNameController,
                    label: "نام",
                    hint: "مثلاً: علی",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 12),
                  _buildProfileTextField(
                    controller: lastNameController,
                    label: "نام خانوادگی",
                    hint: "رضایی",
                    icon: Icons.family_restroom_outlined,
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: onSelectDateOfBirth,
                    child: AbsorbPointer(
                      child: _buildProfileTextField(
                        controller: dobController,
                        label: "تاریخ تولد",
                        hint: "1370/01/01",
                        icon: Icons.calendar_today_rounded,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: ["مرد", "زن"].map((g) {
                      final bool sel = gender == g;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => onGenderChanged(g),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.primaryIndigo
                                      .withValues(alpha: 0.15)
                                  : AppColors.surfaceDark,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: sel
                                      ? AppColors.primaryIndigo
                                      : Colors.white10),
                            ),
                            child: Text(
                              g,
                              textAlign: TextAlign.center,
                              style: AppStyles.fontCaption(
                                color: sel ? Colors.white : AppColors.textMuted,
                                fontWeight:
                                    sel ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSaving ? null : onSaveAndSyncData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryIndigo,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : Text("بروزرسانی پروفایل",
                              style: AppStyles.fontTitle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppStyles.fontTitle(
              color: AppColors.textPrimary,
              fontSize: 15,
            ),
          ),
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
            ? AppColors.primaryPurple.withValues(alpha: 0.6)
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
                  ? AppColors.primaryPurple.withValues(alpha: 0.2)
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

  Widget _buildProfileTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: AppStyles.fontBody(color: AppColors.textPrimary, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppStyles.fontCaption(color: AppColors.textMuted),
        hintText: hint,
        hintStyle: AppStyles.fontCaption(color: Colors.white10),
        prefixIcon: Icon(icon, color: AppColors.primaryIndigo, size: 20),
        fillColor: AppColors.surfaceDark,
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.white10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AppColors.primaryIndigo, width: 1.5),
        ),
      ),
    );
  }
}
