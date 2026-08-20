import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_info.dart';
import '../services/user_info_service.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final UserInfoService _userInfoService = UserInfoService();
  final _formKey = GlobalKey<FormState>();
  
  bool _isLogin = true;
  int _signupStep = 1;
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String _gender = "مرد";

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
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
        _dobController.text = "${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isLogin && _signupStep == 1) {
      setState(() {
        _signupStep = 2;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // In a real app, you'd call a login API. 
    // Here we'll simulate logic or save user if signup.
    if (!_isLogin) {
      final newUser = UserInfoModel(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        dateOfBirth: _dobController.text.trim(),
        gender: _gender,
        palmistryInfo: {},
      );
      
      final result = await _userInfoService.saveAndSyncUserInfo(newUser);
      if (mounted && result['message'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    } else {
      // Login flow: authenticate with server & download profile + palmistry data
      final loginResult = await _userInfoService.loginUser(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (loginResult['success'] != true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loginResult['message'] ?? "خطا در ورود به حساب"),
              backgroundColor: Colors.red.shade800,
            ),
          );
          setState(() => _isLoading = false);
        }
        return;
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(loginResult['message'] ?? "ورود موفقیت‌آمیز بود"),
            backgroundColor: Colors.green.shade800,
          ),
        );
      }
    }


    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo or Icon
                const Icon(
                  Icons.auto_awesome_rounded,
                  size: 80,
                  color: AppColors.primaryIndigo,
                ),
                const SizedBox(height: 20),
                Text(
                  _isLogin ? "ورود به حساب" : "ثبت‌نام در کف‌بین",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Vazirmatn',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _isLogin 
                    ? "خوش آمدید! وارد حساب خود شوید." 
                    : (_signupStep == 1 ? "مشخصات فردی خود را وارد کنید." : "اطلاعات حساب کاربری را تکمیل کنید."),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                    fontFamily: 'Vazirmatn',
                  ),
                ),
                const SizedBox(height: 40),

                if (_isLogin) ..._buildLoginFields(),
                if (!_isLogin && _signupStep == 1) ..._buildSignupStep1Fields(),
                if (!_isLogin && _signupStep == 2) ..._buildSignupStep2Fields(),

                const SizedBox(height: 30),

                // Primary Button
                GestureDetector(
                  onTap: _isLoading ? null : _handleAuth,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryIndigo.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            _isLogin ? "ورود" : (_signupStep == 1 ? "مرحله بعد" : "ثبت‌نام"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Vazirmatn',
                            ),
                          ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Toggle Login/Signup
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _signupStep = 1;
                    });
                  },
                  child: Text(
                    _isLogin ? "حساب ندارید؟ ثبت‌نام کنید" : "قبلاً ثبت‌نام کرده‌اید؟ وارد شوید",
                    style: const TextStyle(
                      color: AppColors.neonElectricBlue,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                ),
                
                if (!_isLogin && _signupStep == 2)
                  TextButton(
                    onPressed: () => setState(() => _signupStep = 1),
                    child: const Text(
                      "بازگشت به مرحله قبل",
                      style: TextStyle(color: Colors.white38, fontFamily: 'Vazirmatn'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLoginFields() {
    return [
      _buildTextField(
        controller: _usernameController,
        label: "نام کاربری",
        icon: Icons.person_outline,
        validator: (v) => (v == null || v.isEmpty) ? "نام کاربری را وارد کنید" : null,
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _passwordController,
        label: "رمز عبور",
        icon: Icons.lock_outline,
        obscureText: _obscurePassword,
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: Colors.white38),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        validator: (v) => (v == null || v.isEmpty) ? "رمز عبور را وارد کنید" : null,
      ),
    ];
  }

  List<Widget> _buildSignupStep1Fields() {
    return [
      Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _firstNameController,
              label: "نام",
              icon: Icons.person_outline,
              validator: (v) => (v == null || v.isEmpty) ? "نام" : null,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildTextField(
              controller: _lastNameController,
              label: "نام خانوادگی",
              icon: Icons.person_outline,
              validator: (v) => (v == null || v.isEmpty) ? "فامیلی" : null,
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      GestureDetector(
        onTap: _selectDateOfBirth,
        child: AbsorbPointer(
          child: _buildTextField(
            controller: _dobController,
            label: "تاریخ تولد",
            icon: Icons.calendar_today_rounded,
            validator: (v) => (v == null || v.isEmpty) ? "تاریخ تولد" : null,
          ),
        ),
      ),
      const SizedBox(height: 16),
      const Text("جنسیت:", style: TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'Vazirmatn')),
      const SizedBox(height: 8),
      Row(
        children: ["مرد", "زن"].map((g) {
          final selected = _gender == g;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _gender = g),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primaryIndigo.withOpacity(0.2) : AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selected ? AppColors.primaryIndigo : Colors.white10),
                ),
                child: Text(
                  g,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: selected ? Colors.white : Colors.white54, fontFamily: 'Vazirmatn'),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    ];
  }

  List<Widget> _buildSignupStep2Fields() {
    return [
      _buildTextField(
        controller: _usernameController,
        label: "نام کاربری",
        icon: Icons.account_circle_outlined,
        validator: (v) => (v == null || v.length < 3) ? "نام کاربری حداقل ۳ حرف" : null,
      ),
      const SizedBox(height: 16),
      _buildTextField(
        controller: _passwordController,
        label: "رمز عبور",
        icon: Icons.lock_outline,
        obscureText: _obscurePassword,
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: Colors.white38),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        validator: (v) => (v == null || v.length < 6) ? "رمز عبور حداقل ۶ حرف" : null,
      ),
    ];
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontFamily: 'Vazirmatn'),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white38, fontSize: 14, fontFamily: 'Vazirmatn'),
        prefixIcon: Icon(icon, color: AppColors.primaryIndigo, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.surfaceDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.white.withOpacity(0.05))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primaryIndigo)),
      ),
    );
  }
}
