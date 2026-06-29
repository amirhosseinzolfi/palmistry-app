import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReportScreen extends StatelessWidget {
  final Map<String, String> selections;

  const ReportScreen({Key? key, required this.selections}) : super(key: key);

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
    final shape = selections["handShape"] ?? "earth";
    final hand = selections["activeHand"] ?? "right_active";

    String elementTitle = "";
    String elementText = "";
    if (shape == "earth") {
      elementTitle = "دست خاکی (عنصر خاک)";
      elementText = "کف دست مربع و پهن با انگشتان کوتاه و پوست ضخیم. شما فردی عمیقاً عملی، واقع‌بین، قابل اعتماد و پایدار هستید. از تغییرات بیزارید و به امنیت اهمیت می‌دهید.";
    } else if (shape == "water") {
      elementTitle = "دست آبی (عنصر آب)";
      elementText = "کف دست کشیده و انگشتان بلند با پوست نرم. شما فردی احساسی، شهودی، حساس و خلاق هستید. هنر، روان‌شناسی و مشاوره بهترین بستر برای درخشش شماست.";
    } else if (shape == "fire") {
      elementTitle = "دست آتشی (عنصر آتش)";
      elementText = "کف دست مستطیلی با انگشتان کوتاه‌تر. شما فردی پرانرژی، کاریزماتیک، ریسک‌پذیر و سریع در تصمیم‌گیری هستید که علاقه وافری به کارآفرینی دارید.";
    } else if (shape == "air") {
      elementTitle = "دست هوایی (عنصر هوا)";
      elementText = "کف دست مربع با انگشتان کشیده. تفکر منطقی، هوش کلامی عالی، روحیه استراتژیک و علاقه به یادگیری مستمر از صفات برجسته شماست.";
    }

    String activeHandText = "";
    if (hand == "right_active") {
      activeHandText = "راست‌دست هستید. دست راست نشان‌دهنده مسیر فعلی و تصمیمات آگاهانه شماست و دست چپ استعداد ذاتی شما را بازتاب می‌دهد.";
    } else if (hand == "left_active") {
      activeHandText = "چپ‌دست هستید. دست چپ نشان‌دهنده مسیر فعلی و تصمیمات آگاهانه شماست و دست راست استعدادهای پنهان را نشان می‌دهد.";
    } else if (hand == "similar_hands") {
      activeHandText = "دو دست شما شبیه هم هستند؛ استعدادهای ذاتی شما با شیوه زندگی فعلی کاملاً منطبق است.";
    } else if (hand == "different_hands") {
      activeHandText = "تفاوت جدی بین دو دست شما مشهود است؛ در طول زندگی تحولات جدی داشته‌اید و از الگوهای اولیه فاصله گرفته‌اید.";
    }

    if (plainText) {
      return "عنصر: $elementTitle\nتفسیر: $elementText\nوضعیت دست فعال: $activeHandText";
    }
    return "• **$elementTitle**\n$elementText\n\n• **وضعیت دست:** $activeHandText";
  }

  String _compileThumbSkinText({bool plainText = false}) {
    final skin = selections["skinTexture"] ?? "firm_balanced";
    final thumb = selections["thumbType"] ?? "balanced_open";

    String skinText = "";
    if (skin == "soft_warm") skinText = "پوست نرم و دست گرم نشان‌دهنده حساسیت عاطفی بالا، پردازش حسی سریع و صمیمیت اجتماعی عالی است.";
    else if (skin == "thick_warm") skinText = "پوست ضخیم و دست گرم نشان‌دهنده عمل‌گرایی مطلق، مقاومت و شجاعت فراوان است.";
    else if (skin == "soft_cold") skinText = "پوست نرم و دست سرد گویای رویکردی محتاط، ذهن درگیر عواقب و نیاز بالا به احساس امنیت عاطفی است.";
    else if (skin == "firm_balanced") skinText = "دست محکم و با سفتی متعادل نشان‌دهنده اراده محکم، تعادل میان رویا و عمل، و پایداری در تصمیمات است.";

    String thumbText = "";
    if (thumb == "balanced_open") thumbText = "شست قوی با زاویه باز نشان‌دهنده اراده عالی، منطق توسعه‌یافته، تفکر مستقل و سخاوت بالا است.";
    else if (thumb == "willpower_dominant") thumbText = "بند بالایی بزرگتر شست نشان‌دهنده غلبه اراده بر منطق است؛ شما مصمم اما گاهی عجول عمل می‌کنید.";
    else if (thumb == "logic_dominant") thumbText = "بند پایینی بزرگتر شست نشان‌دهنده غلبه منطق بر اراده است؛ متفکر و تحلیل‌گر هستید اما مستعد تردید در اجرا می‌باشید.";
    else if (thumb == "closed_cautious") thumbText = "زاویه بازشدن بسیار کم شست نشان‌دهنده احتیاط فراوان، محافظه‌کاری مالی شدید و سخت‌گیری شخصی است.";

    return "$skinText\n\n$thumbText";
  }

  String _compileMountsText({bool plainText = false}) {
    final finger = selections["fingerDominant"] ?? "jupiter_long";
    final mount = selections["prominentMount"] ?? "venus_moon";

    String fingerText = "";
    if (finger == "jupiter_long") fingerText = "انگشت اشاره (مشتری) بلند است: نماد جاه‌طلبی شغلی، اعتمادبه‌نفس بالا و تمایل به رهبری گروهی.";
    else if (finger == "apollo_long") fingerText = "انگشت حلقه (خورشید) بلند است: استعداد هنری قوی، خلاقیت بالا، کاریزمای اجتماعی و تمایل به ابراز هنر.";
    else if (finger == "saturn_long") fingerText = "انگشت میانی (زحل) بلند است: مسئولیت‌پذیری بالا، تعهد عمیق به اصول، واقع‌بینی کامل و تمایل به سکوت.";
    else if (finger == "mercury_long") fingerText = "انگشت کوچک (عطارد) بلند است: قدرت کلام، هوش ارتباطی فوق‌العاده و توانایی بالا در فروش و متقاعدسازی.";

    String mountText = "";
    if (mount == "venus_moon") mountText = "برجستگی ونوس و ماه قوی است: توازن عالی میان صمیمیت عاطفی گرم با تخیل، شهود و رویاپردازی خلاق.";
    else if (mount == "jupiter_mercury") mountText = "برجستگی مشتری و عطارد قوی است: ترکیب عالی مدیریت و عزت نفس به همراه قدرت بیان و کلام تاثیرگذار.";
    else if (mount == "saturn_mars") mountText = "زحل قوی و مریخ بالا برجسته است: صبر استراتژیک، پایداری بالا در برابر مشکلات و استقامت روانی فوق‌العاده.";
    else if (mount == "flat_mounts") mountText = "برجستگی‌های دست صاف هستند: صلح‌طلب هستید و از رقابت‌های سنگین و جنجال‌ها دوری می‌کنید.";

    return "$fingerText\n\n$mountText";
  }

  String _compileMajorLinesText({bool plainText = false}) {
    final heart = selections["heartLine"] ?? "long_curved";
    final head = selections["headLine"] ?? "long_straight";
    final life = selections["lifeLine"] ?? "deep_clear";

    String heartText = "";
    if (heart == "long_curved") heartText = "خط قلب بلند و منحنی است: نشانگر عواطف گرم، رمانتیک بودن، وفاداری بالا و تعهد در روابط صمیمی.";
    else if (heart == "short_straight") heartText = "خط قلب کوتاه و صاف است: نشانگر کنترل عاطفی، احتیاط بالا در ابراز علاقه و ترجیح منطق بر احساس.";
    else if (heart == "chained_broken") heartText = "خط قلب زنجیره‌ای یا لرزان است: نشانگر حساسیت عاطفی بالا، نوسانات احساسی و نیاز به خودآگاهی بیشتر.";
    else if (heart == "balanced_split") heartText = "خط قلب به بین اشاره و میانی ختم می‌شود: تعادل عالی میان عقل و عاطفه در زندگی زناشویی.";

    String headText = "";
    if (head == "long_straight") headText = "خط سر بلند و صاف است: نشانگر تفکر منطقی، واقع‌بینی کامل، تحلیل‌گری قوی و تمرکز عالی روی پروژه‌ها.";
    else if (head == "long_curved_moon") headText = "خط سر خمیده رو به پایین است: نشانگر تخیل بالا، شهود عالی، خلاقیت سرشار و مناسب برای نویسندگی و هنر.";
    else if (head == "short_practical") headText = "خط سر کوتاه است: تمرکز بر عمل و نتایج سریع، دوری از تئوری و حلال عینی مشکلات.";
    else if (head == "split_independent") headText = "خط سر جدا از خط زندگی است: استقلال فکری بالا، جسارت در تصمیم‌گیری و نترسیدن از ریسک‌ها.";

    String lifeText = "";
    if (life == "deep_clear") lifeText = "خط زندگی عمیق و بلند است: انرژی حیاتی بالا، بنیه جسمی عالی و ثبات خوب در زندگی.";
    else if (life == "faint_broken") lifeText = "خط زندگی لرزان یا شکسته است: نیاز به مراقبت از سبک زندگی، یا دوره‌های تغییر بزرگ و شروع دوباره.";
    else if (life == "double_mars") lifeText = "خط زندگی دوگانه است: محافظت درونی قوی در رویدادها و مقاومت بدنی مضاعف.";
    else if (life == "outward_branch") lifeText = "خط زندگی انشعاب بیرونی دارد: سفرهای پی‌درپی و احتمال بالای مهاجرت به سرزمین‌های دور.";

    return "• **خط قلب:** $heartText\n\n• **خط ذهن:** $headText\n\n• **خط زندگی:** $lifeText";
  }

  String _compileMinorSignsText({bool plainText = false}) {
    final fate = selections["fateLine"] ?? "strong_fate";
    final sign = selections["specialSign"] ?? "mystic_cross";
    final shape = selections["handShape"] ?? "earth";
    final head = selections["headLine"] ?? "long_straight";
    final heart = selections["heartLine"] ?? "long_curved";
    final life = selections["lifeLine"] ?? "deep_clear";

    String fateText = "";
    if (fate == "strong_fate") fateText = "خط سرنوشت عمیق است: مسیر شغلی هدفمند، تعهد بالا به کار و پیشرفت گام‌به‌گام.";
    else if (fate == "faint_flexible") fateText = "خط سرنوشت کمرنگ است: انعطاف‌پذیری شغلی و آزادی در کارآفرینی و انتخاب آزادانه مسیر زندگی.";
    else if (fate == "apollo_present") fateText = "خط خورشید واضح است: پتانسیل کسب اعتبار عالی، شهرت خلاق و رضایت عمیق درونی از کارها.";
    else if (fate == "marriage_clear") fateText = "خط رابطه عمیق است: پیوند عاطفی بسیار تاثیرگذار و صمیمیت عمیق در تعهد عاطفی.";

    String signText = "";
    if (sign == "star_jupiter_apollo") signText = "نشانه ستاره روی مشتری/خورشید: شانس غیرمنتظره، درخشش هنری یا شهرت ناگهانی در مدیریت.";
    else if (sign == "square_protection") signText = "نشانه مربع: سپر ایمنی در بحران‌ها و عبور به سلامت از طوفان‌های زندگی.";
    else if (sign == "mystic_cross") signText = "صلیب عرفانی: درک شهودی بسیار بالا، تفکرات معنوی و استعداد متافیزیک.";
    else if (sign == "triangle_mercury") signText = "نشانه مثلث: هوش تجاری برجسته، قدرت استراتژیست کلامی و مهارت در امور اقتصادی.";

    String comboText = "";
    if (shape == "fire" && head == "short_practical") {
      comboText = "\n\n💡 **ترکیب طلایی شما (دست آتشی + خط سر کوتاه):** شما بمب عمل‌گرایی و تصمیمات سریع هستید. توصیه می‌شود در سرمایه‌گذاری‌های بزرگ، صبوری پیشه کنید.";
    } else if (shape == "water" && heart == "chained_broken") {
      comboText = "\n\n💡 **ترکیب طلایی شما (دست آبی + خط قلب زنجیره‌ای):** حساسیت عاطفی شما بسیار بالا و روحیه شما بسیار ظریف است. ساختن مرزهای عاطفی برای آرامش شما کلیدی است.";
    } else if (shape == "air" && head == "long_straight") {
      comboText = "\n\n💡 **ترکیب طلایی شما (دست هوایی + خط سر بلند):** شما استراتژیست، متفکر و تحلیل‌گر عالی هستید. برای عبور از overthinking تمرین اقدام بدون تحلیل اضافی کنید.";
    } else if (shape == "earth" && life == "deep_clear") {
      comboText = "\n\n💡 **ترکیب طلایی شما (دست خاکی + خط زندگی عمیق):** شما نماد پایداری، ثبات و امنیت هستید. در مقابل تغییرات مقاومت نکنید تا جریان‌های نوین موفقیت جاری شوند.";
    }

    return "• **خط سرنوشت/فرعی:** $fateText\n\n• **نشانه خاص:** $signText$comboText";
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
                        "بر اساس فرمول جامع کف‌بینی شخصی",
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
        // Simple markdown parsing mockup for bullet points / bold strings in text
        _buildParsedText(content),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _buildParsedText(String content) {
    // Parse very simple bullet points and bolding for native layout
    final lines = content.split('\n');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: lines.map((line) {
        if (line.trim().isEmpty) return const SizedBox(height: 5);

        bool isBullet = line.startsWith('•');
        String cleanedLine = isBullet ? line.replaceFirst('•', '').trim() : line;

        // Parse simple bold tags **text** -> RichText
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
