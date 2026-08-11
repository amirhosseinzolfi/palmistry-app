import 'package:flutter/material.dart';
import '../models/user_info.dart';
import '../services/user_info_service.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final UserInfoService _userInfoService = UserInfoService();
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _serverUrlController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String _gender = "مرد";
  String _dominantHand = "راست";
  String _handSize = "متوسط";

  bool _isLoading = true;
  bool _isSaving = false;
  bool _obscurePassword = true;
  bool _isSynced = false;
  String? _lastSyncedAt;
  bool _showServerSettings = false;

  @override
  void initState() {
    super.initState();
    _loadExistingUserData();
  }

  Future<void> _loadExistingUserData() async {
    final existingUser = await _userInfoService.loadLocalUserInfo();
    final serverUrl = await _userInfoService.getServerUrl();
    
    _serverUrlController.text = serverUrl;

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
      _lastSyncedAt = existingUser.lastSyncedAt;
    } else {
      // Default birth date example
      _dobController.text = "1375/01/15";
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _serverUrlController.dispose();
    _notesController.dispose();
    super.dispose();
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
              primary: Color(0xFF6366F1),
              onPrimary: Colors.white,
              surface: Color(0xFF14172C),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _saveAndSyncData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    // Save custom server URL if modified
    if (_serverUrlController.text.trim().isNotEmpty) {
      await _userInfoService.setServerUrl(_serverUrlController.text.trim());
    }

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
          _lastSyncedAt = updatedUser.lastSyncedAt;
        }
      });

      final bool isSuccess = result['success'] == true;
      final String msg = result['message'] ?? "";

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                isSuccess ? Icons.cloud_done_rounded : Icons.phone_android_rounded,
                color: isSuccess ? const Color(0xFF00F2FE) : const Color(0xFFFFB703),
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
          backgroundColor: const Color(0xFF14172C),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF070A13),
        appBar: AppBar(
          backgroundColor: const Color(0xFF04060C),
          elevation: 0,
          title: const Text(
            "پروفایل کاربر و همگام‌سازی",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazirmatn',
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                _showServerSettings ? Icons.dns_rounded : Icons.settings_outlined,
                color: const Color(0xFF00F2FE),
              ),
              tooltip: "تنظیمات سرور",
              onPressed: () {
                setState(() {
                  _showServerSettings = !_showServerSettings;
                });
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF00F2FE)))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Card with Sync Status Indicator
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF131832), Color(0xFF0F172A)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0x306366F1)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6366F1), Color(0xFF00F2FE)],
                                ),
                              ),
                              child: const Icon(Icons.person_rounded, color: Colors.white, size: 26),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _usernameController.text.isNotEmpty
                                        ? "حساب کاربری: ${_usernameController.text}"
                                        : "ثبت مشخصات کاربر",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Vazirmatn',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        _isSynced ? Icons.check_circle_rounded : Icons.phone_android_rounded,
                                        size: 14,
                                        color: _isSynced ? const Color(0xFF10B981) : const Color(0xFFFFB703),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _isSynced
                                            ? "همگام‌سازی شده با سرور FastAPI${_lastSyncedAt != null ? ' (${_lastSyncedAt!.split('T')[0]})' : ''}"
                                            : "ذخیره در حافظه گوشی",
                                        style: TextStyle(
                                          color: _isSynced ? const Color(0xFF10B981) : const Color(0xFFFFB703),
                                          fontSize: 11.5,
                                          fontFamily: 'Vazirmatn',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Optional Server Config Panel
                      if (_showServerSettings) ...[
                        _buildSectionHeader("آدرس سرور FastAPI", Icons.dns_rounded),
                        const SizedBox(height: 10),
                        _buildTextField(
                          controller: _serverUrlController,
                          label: "آدرس سرور (URL)",
                          hint: "http://127.0.0.1:8000",
                          icon: Icons.link_rounded,
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Section 1: Account Info (Username & Password)
                      _buildSectionHeader("اطلاعات حساب کاربری", Icons.lock_outline_rounded),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _usernameController,
                        label: "نام کاربری (Username)",
                        hint: "مثال: ali_astronomy",
                        icon: Icons.account_circle_outlined,
                        validator: (v) => (v == null || v.trim().length < 3) ? "نام کاربری حداقل ۳ کاراکتر باشد" : null,
                      ),
                      const SizedBox(height: 12),
                      _buildTextField(
                        controller: _passwordController,
                        label: "رمز عبور (Password)",
                        hint: "••••••••",
                        icon: Icons.key_rounded,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (v) => (v == null || v.trim().length < 3) ? "رمز عبور حداقل ۳ کاراکتر باشد" : null,
                      ),

                      const SizedBox(height: 22),

                      // Section 2: Personal Identity (First & Last Name, Birth Date, Gender)
                      _buildSectionHeader("مشخصات فردی", Icons.badge_outlined),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _firstNameController,
                              label: "نام",
                              hint: "علی",
                              icon: Icons.person_outline,
                              validator: (v) => (v == null || v.trim().isEmpty) ? "نام را وارد کنید" : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                              controller: _lastNameController,
                              label: "نام خانوادگی",
                              hint: "رضایی",
                              icon: Icons.family_restroom_outlined,
                              validator: (v) => (v == null || v.trim().isEmpty) ? "نام خانوادگی را وارد کنید" : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _selectDateOfBirth,
                        child: AbsorbPointer(
                          child: _buildTextField(
                            controller: _dobController,
                            label: "تاریخ تولد",
                            hint: "1375/01/15",
                            icon: Icons.calendar_today_rounded,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Gender Radio Selector
                      const Text(
                        "جنسیت:",
                        style: TextStyle(color: Color(0xFFA9B2C3), fontSize: 13, fontFamily: 'Vazirmatn'),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: ["مرد", "زن", "سایر"].map((genderOption) {
                          final bool isSelected = _gender == genderOption;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _gender = genderOption),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF6366F1).withOpacity(0.3) : const Color(0xFF14172C),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF00F2FE) : const Color(0x15FFFFFF),
                                  ),
                                ),
                                child: Text(
                                  genderOption,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontFamily: 'Vazirmatn',
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 22),

                      // Section 3: Palmistry Features (Dominant Hand, Hand Size)
                      _buildSectionHeader("ویژگی‌های کف‌بینی (Palmistry Info)", Icons.back_hand_outlined),
                      const SizedBox(height: 14),

                      // Dominant Hand Selector
                      const Text(
                        "دست برتر:",
                        style: TextStyle(color: Color(0xFFA9B2C3), fontSize: 13, fontFamily: 'Vazirmatn'),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: ["راست", "چپ"].map((handOption) {
                          final bool isSelected = _dominantHand == handOption;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _dominantHand = handOption),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF6366F1).withOpacity(0.3) : const Color(0xFF14172C),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF00F2FE) : const Color(0x15FFFFFF),
                                  ),
                                ),
                                child: Text(
                                  handOption == "راست" ? "دست راست (فعال)" : "دست چپ (پتانسیل)",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontFamily: 'Vazirmatn',
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 14),

                      // Hand Size Selector
                      const Text(
                        "اندازه دست:",
                        style: TextStyle(color: Color(0xFFA9B2C3), fontSize: 13, fontFamily: 'Vazirmatn'),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: ["کوچک", "متوسط", "بزرگ"].map((sizeOption) {
                          final bool isSelected = _handSize == sizeOption;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _handSize = sizeOption),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF6366F1).withOpacity(0.3) : const Color(0xFF14172C),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? const Color(0xFF00F2FE) : const Color(0x15FFFFFF),
                                  ),
                                ),
                                child: Text(
                                  sizeOption,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontFamily: 'Vazirmatn',
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 14),

                      _buildTextField(
                        controller: _notesController,
                        label: "توضیحات و یادداشت شخصی (اختیاری)",
                        hint: "ویژگی‌های برجسته کف دست، خطوط خاص...",
                        icon: Icons.notes_rounded,
                        maxLines: 2,
                      ),

                      const SizedBox(height: 30),

                      // Save & Sync Button
                      GestureDetector(
                        onTap: _isSaving ? null : _saveAndSyncData,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8B5CF6).withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: Center(
                            child: _isSaving
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.save_rounded, color: Colors.white, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        "ذخیره در گوشی و همگام‌سازی با سرور",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Vazirmatn',
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00F2FE), size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF00F2FE),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Vazirmatn',
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(child: Divider(color: Color(0x20FFFFFF))),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Vazirmatn'),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFA9B2C3), fontSize: 13, fontFamily: 'Vazirmatn'),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0x40FFFFFF), fontSize: 12.5, fontFamily: 'Vazirmatn'),
        prefixIcon: Icon(icon, color: const Color(0xFF6366F1), size: 20),
        suffixIcon: suffixIcon,
        fillColor: const Color(0xFF14172C),
        filled: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0x15FFFFFF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0x10FFFFFF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF6366F1), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFEF4444)),
        ),
      ),
    );
  }
}
