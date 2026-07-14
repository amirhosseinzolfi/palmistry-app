import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/pkg_database_service.dart';

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
        backgroundColor: Color(0xFF070A13),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00F2FE)),
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF070A13),
        appBar: AppBar(
          backgroundColor: const Color(0xFF04060C),
          elevation: 0,
          title: const Text(
            "گزارش نهایی تحلیل دست",
            style: TextStyle(fontFamily: 'Vazirmatn'),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Parchment styled Report Container
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF151932), Color(0xFF0C0E1E)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.25), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Logo Icon
                    const Center(
                      child: Icon(
                        Icons.nightlight_round,
                        color: Color(0xFFFFB703),
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        "تفسیر و راهنمای شخصی کف‌بینی",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Vazirmatn',
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Center(
                      child: Text(
                        "بر اساس فرمול جامع کف‌بینی شخصی",
                        style: TextStyle(
                          color: Color(0xFF6C7A9C),
                          fontSize: 11,
                          fontFamily: 'Vazirmatn',
                        ),
                      ),
                    ),
                    const Divider(color: Color(0x206366F1), height: 30),

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
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFB703).withOpacity(0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0x30FFB703)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Icon(Icons.info_rounded, color: Color(0xFFFFB703), size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "کف دست نقشه تقدیر نیست؛ بلکه بازتاب گرایش‌ها در زمان کنونی است. انتخاب‌ها، آگاهی و اراده شما همیشه اثرگذارترین عامل هستند.",
                              style: TextStyle(
                                color: Color(0xFFA9B2C3),
                                fontSize: 11,
                                height: 1.6,
                                fontFamily: 'Vazirmatn',
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
                        backgroundColor: const Color(0xFF12162B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0x15FFFFFF)),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: const Text("کپی کردن متن", style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _compileReportText()));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "متن گزارش در حافظه موقت کپی شد! ✓",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontFamily: 'Vazirmatn'),
                            ),
                            backgroundColor: Color(0xFF6366F1),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.home_rounded, size: 18),
                      label: const Text("بازگشت به خانه", style: TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold)),
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
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFFFB703),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazirmatn',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildParsedText(content),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildParsedText(String content) {
    final lines = content.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: lines.map((line) {
        if (line.trim().isEmpty) return const SizedBox(height: 5);

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
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ));
          lastIndex = match.end;
        }
        
        if (lastIndex < cleanedLine.length) {
          spans.add(TextSpan(text: cleanedLine.substring(lastIndex)));
        }

        if (spans.isEmpty) spans.add(TextSpan(text: cleanedLine));

        return Padding(
          padding: EdgeInsets.only(bottom: 6, right: isBullet ? 12.0 : 0.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isBullet)
                const Padding(
                  padding: EdgeInsets.only(top: 6, left: 6),
                  child: Icon(Icons.lens, size: 5, color: Color(0xFF00F2FE)),
                ),
              Expanded(
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: const TextStyle(
                      color: Color(0xFFA9B2C3),
                      fontSize: 12.5,
                      height: 1.6,
                      fontFamily: 'Vazirmatn',
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
