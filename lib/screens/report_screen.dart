import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/pkg_database_service.dart';
import '../theme/app_theme.dart';

class ReportScreen extends StatefulWidget {
  final Map<String, String> selections;

  const ReportScreen({Key? key, required this.selections}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final PkgDatabaseService _dbService = PkgDatabaseService();
  bool _isLoading = true;

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

  String _resolveOptionDesc(String stepKey, String optionValue) {
    for (var step in _dbService.wizardSteps) {
      if (step['key'] == stepKey) {
        final List<dynamic> options = step['options'] ?? [];
        for (var opt in options) {
          if (opt['value'] == optionValue) {
            return _dbService.translate(opt['desc_key']);
          }
        }
      }
    }
    return "";
  }

  String _compileReportText() {
    final buffer = StringBuffer();
    buffer.writeln("🔮 کارنامه تحلیل کف‌بینی شخصی شما 🔮");
    buffer.writeln("-----------------------------------------");
    buffer.writeln("۱. کهن‌الگو و عنصر دست:");
    buffer.writeln(_compileHandShapeText(plainText: true));
    buffer.writeln("\n۲. تحلیل شخصیت، اراده و منطق:");
    buffer.writeln(_compileThumbSkinText(plainText: true));
    buffer.writeln("\n۳. وضعیت انرژی‌های درونی:");
    buffer.writeln(_compileMountsText(plainText: true));
    buffer.writeln("\n۴. مسیر فکری، عاطفی و زیستی (خطوط اصلی):");
    buffer.writeln(_compileMajorLinesText(plainText: true));
    buffer.writeln("\n۵. استعدادها، نشانه‌ها و ترکیب‌های طلایی:");
    buffer.writeln(_compileMinorSignsText(plainText: true));
    buffer.writeln("\n-----------------------------------------");
    buffer.writeln("⚠️ یادداشت مهم: کف دست نقشه قطعی سرنوشت نیست، بلکه بازتاب‌دهنده الگوهای ذهنی و پتانسیل‌های فعلی شماست. اراده و آگاهی شما همواره فراتر از خطوط دستتان است.");
    return buffer.toString();
  }

  String _compileHandShapeText({bool plainText = false}) {
    final shapeVal = widget.selections["handShape"] ?? "earth";
    final activeHandVal = widget.selections["activeHand"] ?? "right_active";

    final shapeText = _resolveOptionDesc("handShape", shapeVal);
    final activeHandText = _resolveOptionDesc("activeHand", activeHandVal);

    if (plainText) {
      return "عنصر دست: $shapeText\nوضعیت دست: $activeHandText";
    }
    return "• **تحلیل عنصر دست:**\n$shapeText\n\n• **پیکربندی دست:**\n$activeHandText";
  }

  String _compileThumbSkinText({bool plainText = false}) {
    final skinVal = widget.selections["skinTexture"] ?? "firm_balanced";
    final thumbVal = widget.selections["thumbType"] ?? "balanced_open";

    final skinText = _resolveOptionDesc("skinTexture", skinVal);
    final thumbText = _resolveOptionDesc("thumbType", thumbVal);

    return "$skinText\n\n$thumbText";
  }

  String _compileMountsText({bool plainText = false}) {
    final fingerVal = widget.selections["fingerDominant"] ?? "jupiter_long";
    final mountVal = widget.selections["prominentMount"] ?? "venus_moon";

    final fingerText = _resolveOptionDesc("fingerDominant", fingerVal);
    final mountText = _resolveOptionDesc("prominentMount", mountVal);

    return "$fingerText\n\n$mountText";
  }

  String _compileMajorLinesText({bool plainText = false}) {
    final heartVal = widget.selections["heartLine"] ?? "long_curved";
    final headVal = widget.selections["headLine"] ?? "long_straight";
    final lifeVal = widget.selections["lifeLine"] ?? "deep_clear";

    final heartText = _resolveOptionDesc("heartLine", heartVal);
    final headText = _resolveOptionDesc("headLine", headVal);
    final lifeText = _resolveOptionDesc("lifeLine", lifeVal);

    return "• **خط قلب:** $heartText\n\n• **خط ذهن:** $headText\n\n• **خط زندگی:** $lifeText";
  }

  String _compileMinorSignsText({bool plainText = false}) {
    final fateVal = widget.selections["fateLine"] ?? "strong_fate";
    final signVal = widget.selections["specialSign"] ?? "mystic_cross";

    final fateText = _resolveOptionDesc("fateLine", fateVal);
    final signText = _resolveOptionDesc("specialSign", signVal);

    final shape = widget.selections["handShape"] ?? "earth";
    final head = widget.selections["headLine"] ?? "long_straight";
    final heart = widget.selections["heartLine"] ?? "long_curved";
    final life = widget.selections["lifeLine"] ?? "deep_clear";

    String comboText = "";
    if (shape == "fire" && head == "short_practical") {
      comboText = "\n\n" + _dbService.translate("key_combo_fire_practical_desc");
    } else if (shape == "water" && heart == "chained_broken") {
      comboText = "\n\n" + _dbService.translate("key_combo_water_sensitive_desc");
    } else if (shape == "air" && head == "long_straight") {
      comboText = "\n\n" + _dbService.translate("key_combo_air_strategic_desc");
    } else if (shape == "earth" && life == "deep_clear") {
      comboText = "\n\n" + _dbService.translate("key_combo_earth_stable_desc");
    }

    return "• **خط سرنوشت/فرعی:** $fateText\n\n• **نشانه خاص:** $signText$comboText";
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
        appBar: AppBar(
          backgroundColor: AppColors.appBarBackground,
          elevation: 0,
          title: Text(
            "گزارش نهایی تحلیل دست",
            style: AppStyles.fontHeader(fontSize: 16),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Premium Dark Glassmorphic Report Container
              Container(
                decoration: AppStyles.cardDecoration(
                  backgroundColor: AppColors.surfaceCard,
                  borderColor: AppColors.surfaceCardBorder,
                  showGlow: true,
                  glowColor: AppColors.primaryIndigo,
                ),
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Logo Icon
                    const Center(
                      child: Icon(
                        Icons.nightlight_round,
                        color: AppColors.neonElectricBlue,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        "تفسیر و راهنمای شخصی کف‌بینی",
                        style: AppStyles.fontHeader(
                          fontSize: 16.5,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        "بر اساس فرمول جامع کف‌بینی شخصی",
                        style: AppStyles.fontCaption(
                          fontSize: 11.5,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    const Divider(color: Color(0x206366F1), height: 28),

                    // Section 1
                    _buildReportSection(
                      context,
                      "۱. کهن‌الگو و عنصر دست شما",
                      _compileHandShapeText(),
                    ),

                    // Section 2
                    _buildReportSection(
                      context,
                      "۲. اراده، منطق و بافت پوست",
                      _compileThumbSkinText(),
                    ),

                    // Section 3
                    _buildReportSection(
                      context,
                      "۳. وضعیت انرژی‌های درونی (سیاره و برجستگی)",
                      _compileMountsText(),
                    ),

                    // Section 4
                    _buildReportSection(
                      context,
                      "۴. مسیرهای زیستی، ذهنی و عاطفی",
                      _compileMajorLinesText(),
                    ),

                    // Section 5
                    _buildReportSection(
                      context,
                      "۵. خطوط فرعی، نشانه‌ها و ترکیب‌های طلایی",
                      _compileMinorSignsText(),
                    ),

                    const SizedBox(height: 10),
                    // Warning note box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: AppStyles.textContainerDecoration(
                        backgroundColor: AppColors.primaryIndigo.withOpacity(0.08),
                        borderColor: AppColors.primaryIndigo.withOpacity(0.3),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_rounded, color: AppColors.neonElectricBlue, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "کف دست نقشه تقدیر نیست؛ بلکه بازتاب گرایش‌ها در زمان کنونی است. انتخاب‌ها، آگاهی و اراده شما همیشه اثرگذارترین عامل هستند.",
                              style: AppStyles.fontBody(
                                color: AppColors.textSecondary,
                                fontSize: 11.5,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.surfaceCard,
                        foregroundColor: AppColors.textPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppColors.surfaceCardBorder),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: Text("کپی کردن متن", style: AppStyles.fontTitle(fontSize: 13, color: AppColors.textPrimary)),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _compileReportText()));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "متن گزارش در حافظه موقت کپی شد! ✓",
                              textAlign: TextAlign.center,
                              style: AppStyles.fontBody(color: Colors.white, fontSize: 13),
                            ),
                            backgroundColor: AppColors.primaryIndigo,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryIndigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.home_rounded, size: 18),
                      label: Text("بازگشت به خانه", style: AppStyles.fontTitle(fontSize: 13, color: Colors.white)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportSection(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 3.5,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.primaryIndigo,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppStyles.fontTitle(
                color: AppColors.neonElectricBlue,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: AppStyles.textContainerDecoration(),
          child: _buildParsedText(content),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildParsedText(String content) {
    final lines = content.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: lines.map((line) {
        if (line.trim().isEmpty) return const SizedBox(height: 4);

        bool isBullet = line.startsWith('•');
        String cleanedLine = isBullet ? line.replaceFirst('•', '').trim() : line;

        List<TextSpan> spans = [];
        final regex = RegExp(r'\*\*(.*?)\*\*');
        int lastIndex = 0;

        for (var match in regex.allMatches(cleanedLine)) {
          if (match.start > lastIndex) {
            spans.add(TextSpan(text: cleanedLine.substring(lastIndex, match.start)));
          }
          spans.add(TextSpan(
            text: match.group(1),
            style: AppStyles.fontTitle(fontSize: 13, color: AppColors.textPrimary),
          ));
          lastIndex = match.end;
        }
        
        if (lastIndex < cleanedLine.length) {
          spans.add(TextSpan(text: cleanedLine.substring(lastIndex)));
        }

        if (spans.isEmpty) spans.add(TextSpan(text: cleanedLine));

        return Padding(
          padding: EdgeInsets.only(bottom: 6, right: isBullet ? 10.0 : 0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isBullet)
                const Padding(
                  padding: EdgeInsets.only(top: 6, left: 6),
                  child: Icon(Icons.lens, size: 5, color: AppColors.neonElectricBlue),
                ),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: AppStyles.fontBody(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.65,
                    ),
                    children: spans,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
