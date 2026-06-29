import 'package:flutter/material.dart';
import '../models/palmistry_data.dart';
import '../widgets/hand_painter.dart';
import 'wizard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  int _currentTabIndex = 0; // 0: Interactive Hand Tab, 1: Manual/Search Tab
  String _handFilter = "all"; // "all", "lines", "mounts", "symbols", "fingers"
  String _selectedCategory = "all";
  String _searchQuery = "";
  String? _selectedSvgId;

  // Map chapter IDs to their position index in the filtered list
  final Map<String, GlobalKey> _cardKeys = {};

  @override
  void initState() {
    super.initState();
    for (var chapter in palmistryDatabase) {
      _cardKeys[chapter.id] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<PalmistryChapter> get _filteredChapters {
    return palmistryDatabase.where((chapter) {
      // Category filter check
      final matchesCategory = _selectedCategory == "all" || chapter.category == _selectedCategory;

      // Search filter check
      bool matchesSearch = true;
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final hasInTitle = chapter.title.toLowerCase().contains(query);
        final hasInContent = chapter.content.toLowerCase().contains(query);
        bool hasInDetails = false;
        for (var d in chapter.details) {
          if (d.name.toLowerCase().contains(query) || d.value.toLowerCase().contains(query)) {
            hasInDetails = true;
            break;
          }
        }
        matchesSearch = hasInTitle || hasInContent || hasInDetails;
      }

      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _onElementSelected(String targetId) {
    setState(() {
      _selectedSvgId = targetId;
    });

    // Match selected hand region to a chapter ID
    String? chapterId;
    String title = "";
    String desc = "";

    if (targetId.startsWith("finger-")) {
      final fingerName = targetId.split("-")[1];
      if (fingerName == "thumb") {
        chapterId = "thumb-logic";
        title = "انگشت شست 👍";
        desc = "شست مهم‌ترین انگشت در کف‌بینی سنتی است و شاه‌کلید اراده، منطق، کنترل نفس و تصمیم‌گیری است. تناسب بند بالایی (اراده) و بند پایینی (منطق) و انعطاف آن تفسیر می‌شود.";
      } else {
        chapterId = "fingers";
        if (fingerName == "jupiter") {
          title = "انگشت اشاره (مشتری) ☝️";
          desc = "نشان‌دهنده رهبری، عزت نفس، اعتمادبه‌نفس و جاه‌طلبِ مفرط و میل به تاثیرگذاری بر محیط. بلند بودن آن نشان‌دهنده لیدر طبیعی و کوتاه بودن آن نشان‌دهنده فروتنی یا تردید است.";
        } else if (fingerName == "saturn") {
          title = "انگشت میانی (زحل) 🪐";
          desc = "نشان‌دهنده تعهد، مسئولیت‌پذیری، نظم، جدیت و واقع‌بینی. بلند بودن آن نشان‌دهنده انضباط کاری بالا و کوتاه بودن آن نشان‌دهنده سبک‌گیری مسئولیت‌ها است.";
        } else if (fingerName == "apollo") {
          title = "انگشت حلقه (خورشید) ☀️";
          desc = "نشان‌دهنده ذوق خلاقیت، استعداد هنری، درخشش اجتماعی و کاریزمای درونی. بلند بودن آن نشان‌دهنده خلاقیت سرشار و کوتاه بودن نشان‌دهنده عمل‌گرایی بی صدا است.";
        } else if (fingerName == "mercury") {
          title = "انگشت کوچک (عطارد) 💬";
          desc = "نشان‌دهنده هوش کلامی، کلام تاثیرگذار، روابط اجتماعی و استعداد تجارت و فروش. بلند بودن آن نشان‌دهنده کلام نافذ و کوتاه بودن نشان‌دهنده کم‌حرفی است.";
        }
      }
    } else if (targetId.startsWith("mount-")) {
      if (targetId == "mount-jupiter") {
        chapterId = "mount-jupiter";
        title = "برجستگی مشتری ♃";
        desc = "واقع در زیر انگشت اشاره. نشان‌دهنده عزت نفس، میل به رهبری، جاه‌طلبِ مثبت و هدفمندی اجتماعی.";
      } else if (targetId == "mount-saturn") {
        chapterId = "mount-saturn";
        title = "برجستگی زحل ♄";
        desc = "واقع در زیر انگشت میانی. نشان‌دهنده صبر، انضباط شخصی، مسئولیت‌پذیری، تفکر فلسفی و تعهد کاری.";
      } else if (targetId == "mount-apollo") {
        chapterId = "mount-sun";
        title = "برجستگی خورشید ☀️";
        desc = "واقع در زیر انگشت حلقه. نشان‌دهنده ذوق خلاقیت، زیباییدوستی، کاریزما و تمایل به دیده شدن و اعتبار اجتماعی.";
      } else if (targetId == "mount-mercury") {
        chapterId = "mount-mercury";
        title = "برجستگی عطارد ☿";
        desc = "واقع در زیر انگشت کوچک. نشان‌دهنده قدرت ارتباطات، بیان، تجارت، فروش و هوش روانشناسی عملی.";
      } else if (targetId == "mount-venus") {
        chapterId = "mount-venus";
        title = "برجستگی ونوس ♀️";
        desc = "بخش گوشتی پایه شست. نشان‌دهنده عشق، شور زندگی، محبت عمیق، انرژی بدنی و خانواده.";
      } else if (targetId == "mount-moon") {
        chapterId = "mount-moon";
        title = "برجستگی ماه 🌙";
        desc = "بخش پهن لبه پایینی دست. نشان‌دهنده تخیل قوی، شهود، رویاپردازی، ناخودآگاه، هنر و کشش به سفرهای دور.";
      } else {
        chapterId = "mount-mars";
        if (targetId == "mount-mars-lower") {
          title = "برجستگی مریخ پایین (مثبت) ♂️";
          desc = "واقع در بین شست و خط زندگی. نشان‌دهنده شجاعت فیزیکی مستقیم، توان دفاع فعال و اقدام در مواقع خطر.";
        } else if (targetId == "mount-mars-upper") {
          title = "برجستگی مریخ بالا (منفی)";
          desc = "واقع در لبه دست بین عطارد و ماه. نشان‌دهنده استقامت روحی، صبر استراتژیک، مقاومت و خستگی‌ناپذیری در مشکلات.";
        } else if (targetId == "mount-mars-plain") {
          title = "دشت مریخ (مرکز دست)";
          desc = "گودی وسط کف دست. نشان‌دهنده میدان نبرد زندگی و نحوه برخورد و تعادل در تنش‌ها و فشارهای روزمره.";
        }
      }
    } else if (targetId.startsWith("line-")) {
      if (targetId == "line-heart") {
        chapterId = "line-heart";
        title = "خط قلب (عشق) 💓";
        desc = "مسیر عواطف، روابط، سبک وابستگی عاطفی، پایداری روابط و ابراز صمیمیت را نشان می‌دهد.";
      } else if (targetId == "line-head") {
        chapterId = "line-head";
        title = "خط سر / ذهن 🧠";
        desc = "نحوه تفکر، یادگیری، استدلال، تمرکز، سبک فکری و تصمیم‌گیری‌های اساسی را آشکار می‌سازد.";
      } else if (targetId == "line-life") {
        chapterId = "line-life";
        title = "خط زندگی ❤️🔥";
        desc = "بنیه بدنی، توان جسمی و روانی، مقاومت بدنی و دوره‌های تحول‌آفرین زندگی را نشان می‌دهد (نه طول عمر فیزیکی).";
      } else {
        chapterId = "line-fate-minor";
        if (targetId == "line-fate") {
          title = "خط سرنوشت / تقدیر 🔮";
          desc = "مسیر شغلی، رسالت کاری، میزان تعهد به اهداف بیرونی و انضباط در اجرای برنامه‌ها را نشان می‌دهد.";
        } else if (targetId == "line-sun") {
          title = "خط خورشید (آپولو)";
          desc = "نشان‌دهنده کسب نام نیکو، موفقیت‌های خلاق، شهرت، و رضایت درونی عمیق از دستاوردها.";
        } else if (targetId == "line-mercury") {
          title = "خط سلامت (عطارد)";
          desc = "نمایانگر هوش تجاری برجسته، و تعادل در سیستم عصبی بدنی نمادین.";
        } else if (targetId == "line-marriage") {
          title = "خط ازدواج / رابطه";
          desc = "نمایانگر پیوندهای عاطفی عمیق، وفاداری، تعهد صمیمی و کیفیت روابط بلندمدت.";
        } else if (targetId == "line-girdle-venus") {
          title = "کمربند ونوس";
          desc = "نشان‌دهنده حساسیت عاطفی بالا، شدت احساسات، زیباییدوستی و استعدادهای هنری.";
        } else if (targetId == "line-intuition") {
          title = "خط شهود";
          desc = "نشان‌دهنده الهام قلبی، حس ششم فوق‌العاده قوی و توانایی خواندن پنهان آدم‌ها و فضاها.";
        } else if (targetId == "line-mars") {
          title = "خط مریخ (حمایت)";
          desc = "خط موازی خط زندگی در داخل. نشان‌دهنده محافظت بالا و مقاومت فیزیکی و حیاتی مضاعف.";
        } else if (targetId == "line-bracelets") {
          title = "دستبندهای مچ";
          desc = "نشان‌دهنده پایه انرژی فیزیکی، ریشه‌های حیات، سلامتی عمومی و تعادل عمومی بدنی.";
        } else if (targetId == "line-travel") {
          title = "خطوط سفر ✈️";
          desc = "سفرهای خارجی سرنوشت‌ساز، مهاجرت‌های موثر، یا جابه‌جایی‌هایی که مسیر زندگی را تغییر می‌دهند.";
        }
      }
    } else if (targetId.startsWith("ring-")) {
      chapterId = "line-fate-minor";
      if (targetId == "ring-solomon") {
        title = "حلقه سلیمان";
        desc = "خرد، قدرت ارائه مشاوره، بینش روان‌شناختی، همدلی و کشش به فلسفه و متافیزیک.";
      } else if (targetId == "ring-saturn") {
        title = "حلقه زحل";
        desc = "تمایل به تفکر انفرادی، جدیت فلسفی، و گاهی موانع ابراز تمایلات اجتماعی.";
      } else if (targetId == "ring-apollo") {
        title = "حلقه خورشید";
        desc = "حساسیت زیبایی‌شناختی بسیار بالا، تمایل به کار خلاق و موانع ابراز عمومی هنر.";
      } else if (targetId == "ring-mercury") {
        title = "حلقه عطارد";
        desc = "پیچیدگی‌های کلامی، یا احتیاط زیاد در ابراز احساسات صمیمانه عاطفی.";
      }
    } else if (targetId.startsWith("symbol-")) {
      chapterId = "line-fate-minor";
      if (targetId == "symbol-star") {
        title = "نشانه ستاره ⭐";
        desc = "نماد رویدادهای ناگهانی، خلاقیت درخشان، درخشش و موفقیت بزرگ غیرمنتظره در آن ناحیه.";
      } else if (targetId == "symbol-square") {
        title = "نشانه مربع ⏹️";
        desc = "سپر محافظت کامل؛ نجات سلامت از بحران‌ها، شکست‌ها و خطرات فیزیکی یا کاری.";
      } else if (targetId == "symbol-triangle") {
        title = "نشانه مثلث 🔺";
        desc = "نشان‌دهنده هوش استراتژیک، متمرکز، تصمیم‌گیری عقلانی و توانایی‌های بالای فکری.";
      } else if (targetId == "symbol-island") {
        title = "نشانه جزیره 👁️";
        desc = "نشان‌دهنده دوره‌های افت موقت انرژی، استرس، ابهامات فکری یا تنش‌های عاطفی.";
      } else if (targetId == "symbol-cross") {
        title = "صلیب عرفانی ➕";
        desc = "شهود قلبی بسیار بالا، درک ناخودآگاه قوی و استعداد فراوان در مسائل متافیزیک.";
      } else if (targetId == "symbol-grille") {
        title = "نشانه شبکه 🌐";
        desc = "نشان‌دهنده تنش بالا، استرس شدید، پراکندگی مداوم انرژی و آشفتگی موقت در آن ناحیه.";
      }
    }

    if (chapterId != null) {
      _showQuickPreviewBottomSheet(title, desc, chapterId);
    }
  }

  void _showQuickPreviewBottomSheet(String title, String desc, String chapterId) {
    // Find matching chapter database record
    PalmistryChapter? chapter;
    for (var c in palmistryDatabase) {
      if (c.id == chapterId) {
        chapter = c;
        break;
      }
    }
    final activeChapter = chapter ?? palmistryDatabase.first;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      isScrollControlled: true, // Let DraggableScrollableSheet expand properly
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.38,
          minChildSize: 0.35,
          maxChildSize: 0.88,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0C0F22),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(color: Color(0x3000F2FE), width: 1.5),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
                  children: [
                    // Drag Handle Indicator
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    
                    // Header Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Color(0xFFFFB703),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Vazirmatn',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Quick Summary
                    Text(
                      desc,
                      style: const TextStyle(
                        color: Color(0xFFA9B2C3),
                        fontSize: 14.5,
                        height: 1.6,
                        fontFamily: 'Vazirmatn',
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Slide up hint
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.keyboard_double_arrow_up_rounded, size: 16, color: Color(0xFF00F2FE)),
                        const SizedBox(width: 6),
                        Text(
                          "برای مشاهده راهنمای کامل، به بالا بکشید",
                          style: TextStyle(
                            color: const Color(0xFF00F2FE).withOpacity(0.8),
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Vazirmatn',
                          ),
                        ),
                      ],
                    ),
                    
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(color: Color(0x15FFFFFF), height: 1),
                    ),
                    
                    // Detailed Title
                    const Text(
                      "تفسیر تفصیلی و معنای نمادین",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Vazirmatn',
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Detailed Content
                    Text(
                      activeChapter.content,
                      style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 13.5,
                        height: 1.7,
                        fontFamily: 'Vazirmatn',
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Details/Variations list
                    if (activeChapter.details.isNotEmpty) ...[
                      const Text(
                        "حالت‌ها و انواع مختلف برای تحلیل:",
                        style: TextStyle(
                          color: Color(0xFFFFB703),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Vazirmatn',
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...activeChapter.details.map((detail) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E293B).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0x10FFFFFF)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                detail.name,
                                style: const TextStyle(
                                  color: Color(0xFF00F2FE),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Vazirmatn',
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                detail.value,
                                style: const TextStyle(
                                  color: Color(0xFFA9B2C3),
                                  fontSize: 12.5,
                                  height: 1.6,
                                  fontFamily: 'Vazirmatn',
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _scrollToChapter(String id) {
    // Look up category directly from the database chapter config
    final chapter = palmistryDatabase.firstWhere(
      (c) => c.id == id,
      orElse: () => palmistryDatabase.first,
    );
    final cat = chapter.category;
    
    setState(() {
      _currentTabIndex = 1; // Switch tab to Manual/Search Tab
      _selectedCategory = cat;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _cardKeys[id];
      if (key != null && key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF080A16),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B0E20),
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF00F2FE)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.back_hand, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Text(
                "کف‌بینی تعاملی کیهانی",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazirmatn',
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline, color: Colors.white60),
              onPressed: () {
                _scrollToChapter("basics");
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentTabIndex,
          children: [
            _buildHandTab(),
            _buildManualTab(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          onTap: (index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
          backgroundColor: const Color(0xFF0C0F22),
          selectedItemColor: const Color(0xFF00F2FE),
          unselectedItemColor: const Color(0x60FFFFFF),
          selectedLabelStyle: const TextStyle(fontFamily: 'Vazirmatn', fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 11),
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.back_hand_rounded),
              label: "نقشه تعاملی",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: "دانشنامه خطوط",
            ),
          ],
        ),
        floatingActionButton: _currentTabIndex == 0 
            ? FloatingActionButton.extended(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                elevation: 4,
                label: const Text(
                  "طالع‌خوان تعاملی (۱۱ مرحله)",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Vazirmatn',
                  ),
                ),
                icon: const Icon(Icons.auto_awesome),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WizardScreen()),
                  );
                },
              )
            : null,
      ),
    );
  }

  Widget _buildHandTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Filter Chips at top
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildHandFilterChip("همه بخش‌ها", "all"),
                _buildHandFilterChip("خطوط دست", "lines"),
                _buildHandFilterChip("تپه‌ها", "mounts"),
                _buildHandFilterChip("نشانه‌ها", "symbols"),
                _buildHandFilterChip("انگشتان", "fingers"),
              ],
            ),
          ),
        ),
        
        // Helper hint text
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            "روی بخش‌های دست ضربه بزنید تا معنی و تفسیر را درجا ببینید",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6C7A9C),
              fontSize: 12,
              fontFamily: 'Vazirmatn',
            ),
          ),
        ),
        
        // The Interactive Hand Map Widget
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(15, 5, 15, 20),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, 0),
                radius: 1.0,
                colors: [
                  const Color(0xFF131832).withOpacity(0.4),
                  const Color(0xFF080A16),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x10FFFFFF)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: InteractiveHandWidget(
                selectedId: _selectedSvgId,
                activeFilter: _handFilter,
                onSelected: _onElementSelected,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHandFilterChip(String label, String filterValue) {
    final bool isSelected = _handFilter == filterValue;
    return GestureDetector(
      onTap: () {
        setState(() {
          _handFilter = filterValue;
          _selectedSvgId = null; // Clear selection when changing filter
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1).withOpacity(0.2) : const Color(0xFF12162B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF6366F1) : const Color(0x10FFFFFF),
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF00F2FE) : const Color(0xFFA9B2C3),
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Vazirmatn',
          ),
        ),
      ),
    );
  }

  Widget _buildManualTab() {
    final chapters = _filteredChapters;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Search & Category Headers
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: "جستجو در تمام راهنما و خطوط دست...",
                  hintStyle: const TextStyle(color: Color(0xFF6C7A9C), fontSize: 13, fontFamily: 'Vazirmatn'),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF6366F1)),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.white60),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = "";
                            });
                          },
                        )
                      : null,
                  fillColor: const Color(0xFF12162B),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0x15FFFFFF)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0x10FFFFFF)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFF6366F1)),
                  ),
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              ),
              const SizedBox(height: 12),

              // Category Filter chips (horizontal scroll)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip("همه موضوعات", "all"),
                    _buildCategoryChip("اصول اولیه دست", "basics"),
                    _buildCategoryChip("خطوط اصلی و فرعی", "lines"),
                    _buildCategoryChip("برجستگی‌ها و انگشتان", "mounts-fingers"),
                    _buildCategoryChip("نشانه‌ها و حلقه‌ها", "signs-misc"),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Scrollable Chapters list
        Expanded(
          child: chapters.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 30),
                  itemCount: chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = chapters[index];
                    final isHighlighted = _selectedSvgId == chapter.id;

                    return Container(
                      key: _cardKeys[chapter.id],
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF12162B),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isHighlighted ? const Color(0xFF00F2FE) : const Color(0x10FFFFFF),
                          width: isHighlighted ? 1.5 : 1.0,
                        ),
                        boxShadow: isHighlighted
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF00F2FE).withOpacity(0.12),
                                  blurRadius: 12,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : null,
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                chapter.title,
                                style: const TextStyle(
                                  color: Color(0xFF00F2FE), // Neon Cyan title
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Vazirmatn',
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6366F1).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.2)),
                                ),
                                child: Text(
                                  chapter.badge,
                                  style: const TextStyle(
                                    color: Color(0xFF818CF8),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Vazirmatn',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(color: Color(0x15FFFFFF), height: 24),
                          Text(
                            chapter.content,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                              color: Color(0xFFA9B2C3),
                              fontSize: 13,
                              height: 1.7,
                              fontFamily: 'Vazirmatn',
                            ),
                          ),
                          if (chapter.details.isNotEmpty) ...[
                            const SizedBox(height: 15),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0C0F22),
                                borderRadius: BorderRadius.circular(12),
                                border: const Border(
                                  right: BorderSide(color: Color(0xFF6366F1), width: 3.5),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: chapter.details.map((detail) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          color: Color(0xFFA9B2C3),
                                          fontSize: 12,
                                          height: 1.6,
                                          fontFamily: 'Vazirmatn',
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "${detail.name}: ",
                                            style: const TextStyle(
                                              color: Color(0xFF00F2FE),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(text: detail.value),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label, String categoryId) {
    final bool isSelected = _selectedCategory == categoryId;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = categoryId;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1).withOpacity(0.2) : const Color(0xFF12162B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF6366F1) : const Color(0x10FFFFFF),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFFFFB703) : const Color(0xFFA9B2C3),
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Vazirmatn',
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFF12162B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x10FFFFFF)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: Color(0xFF6C7A9C)),
          const SizedBox(height: 12),
          const Text(
            "موردی یافت نشد",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Vazirmatn'),
          ),
          const SizedBox(height: 6),
          const Text(
            "عبارت دیگری جستجو کنید یا فیلترها را ریست کنید.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF6C7A9C), fontSize: 12.5, fontFamily: 'Vazirmatn'),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchQuery = "";
                _selectedCategory = "all";
              });
            },
            child: const Text("ریست کردن جستجو", style: TextStyle(color: Color(0xFF00F2FE), fontWeight: FontWeight.bold, fontFamily: 'Vazirmatn')),
          )
        ],
      ),
    );
  }
}
