// ignore_for_file: deprecated_member_use
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// Definition of an interactive zone
class InteractiveZone {
  final String id;
  final String name;
  final List<Offset> points; // For lines
  final Offset? center; // For mounts / symbols
  final double? radius; // For circular mounts
  final double? radiusX; // For oval mounts (horizontal radius)
  final double? radiusY; // For oval mounts (vertical radius)
  final double? rotation; // For oval rotation angle in degrees

  const InteractiveZone({
    required this.id,
    required this.name,
    this.points = const [],
    this.center,
    this.radius,
    this.radiusX,
    this.radiusY,
    this.rotation,
  });
}

// Predefined list of hit-test zones matching the coordinates in 360x500 space
const List<InteractiveZone> interactiveZones = [
  // Mounts
  InteractiveZone(id: "mount-jupiter", name: "برجستگی مشتری", center: Offset(221, 205), radiusX: 23, radiusY: 19, rotation: 18),
  InteractiveZone(id: "mount-saturn", name: "برجستگی زحل", center: Offset(179, 202), radiusX: 20, radiusY: 20, rotation: 18),
  InteractiveZone(id: "mount-apollo", name: "برجستگی خورشید", center: Offset(139, 210), radiusX: 18, radiusY: 20, rotation: 7),
  InteractiveZone(id: "mount-mercury", name: "برجستگی عطارد", center: Offset(102, 238), radiusX: 20, radiusY: 22, rotation: 7),
  InteractiveZone(id: "mount-mars-lower", name: "برجستگی مریخ پایین", center: Offset(218, 246), radiusX: 28, radiusY: 22, rotation: -24),
  InteractiveZone(id: "mount-mars-upper", name: "برجستگی مریخ بالا", center: Offset(107, 283), radiusX: 19, radiusY: 23, rotation: -14),
  InteractiveZone(id: "mount-mars-plain", name: "دشت مریخ", center: Offset(167, 282), radiusX: 28, radiusY: 36, rotation: 18),
  InteractiveZone(id: "mount-venus", name: "برجستگی ونوس",  center: Offset(230, 301), radiusX: 31, radiusY: 40, rotation: 40),
  InteractiveZone(id: "mount-moon", name: "برجستگی ماه", center: Offset(125, 336), radiusX: 21, radiusY: 27, rotation: -35),

  // Major Lines
  InteractiveZone(id: "line-heart", name: "خط قلب", points: [
    Offset(88, 262),
    Offset(101, 258),
    Offset(117, 255),
    Offset(136, 249),
    Offset(152, 243),
    Offset(167, 236),
    Offset(182, 228),
    Offset(195, 220),
  ]),
  InteractiveZone(id: "line-head", name: "خط سر / ذهن", points: [
    Offset(233, 224),
    Offset(221, 227),
    Offset(209, 234),
    Offset(192, 242),
    Offset(181, 251),
    Offset(169, 260),
    Offset(154, 272),
    Offset(140, 280),
  ]),
  InteractiveZone(id: "line-life", name: "خط زندگی", points: [
    Offset(248, 231),
    Offset(232, 234),
    Offset(217, 245),
    Offset(206, 256),
    Offset(195, 269),
    Offset(190, 284),
    Offset(184, 299),
    Offset(184, 320),
  ]),
  InteractiveZone(id: "line-fate", name: "خط سرنوشت", points: [
    Offset(175, 336),
    Offset(169, 323),
    Offset(169, 310),
    Offset(169, 292),
    Offset(170, 274),
    Offset(172, 254),
    Offset(178, 235),
    Offset(183, 221),
    Offset(191, 207),
  ]),
  // Minor Lines
  InteractiveZone(id: "line-sun", name: "خط خورشید", points: [
    Offset(149, 339),
    Offset(150, 318),
    Offset(149, 297),
    Offset(148, 275),
    Offset(146, 255),
    Offset(146, 235),
    Offset(145, 221),
  ]),
  InteractiveZone(id: "line-mercury", name: "خط سلامت", points: [
    Offset(170, 331),
    Offset(173, 317),
    Offset(178, 301),
    Offset(182, 281),
    Offset(188, 263),
    Offset(196, 246),
    Offset(203, 229),
    Offset(207, 217),
    Offset(215, 202),
  ]),
  InteractiveZone(id: "line-marriage", name: "خط ازدواج", points: [
    Offset(88, 252),
    Offset(95, 249),
    Offset(105, 246),
  ]),
  InteractiveZone(id: "line-girdle-venus", name: "کمربند ونوس", points: [
    Offset(199, 191),
    Offset(191, 200),
    Offset(183, 206),
    Offset(173, 207),
    Offset(163, 208),
    Offset(154, 209),
    Offset(146, 208),
    Offset(139, 206),
    Offset(133, 204),
  ]),
  InteractiveZone(id: "line-intuition", name: "خط شهود", points: [
    Offset(135, 355),
    Offset(140, 341),
    Offset(140, 322),
    Offset(137, 304),
    Offset(132, 289),
    Offset(125, 273),
    Offset(117, 260),
    Offset(108, 242),
  ]),
  InteractiveZone(id: "line-mars", name: "خط مریخ", points: [
    Offset(162, 310),
    Offset(155, 300),
    Offset(144, 290),
    Offset(135, 277),
    Offset(129, 267),
    Offset(118, 248),
    Offset(112, 237),
  ]),
  
  
  
  InteractiveZone(id: "line-travel", name: "خطوط سفر", points: [
    // Travel Line 1
    Offset(108, 348), Offset(117, 342), Offset(126, 335),
    // Travel Line 2
    Offset(100, 329), Offset(110, 324),  Offset(120, 317),
    // Travel Line 3
    Offset(92, 312), Offset(100, 306), Offset(110, 300),
    // Travel Line 4
    Offset(90, 298), Offset(97, 295), Offset(105, 288)
  ]),
  InteractiveZone(id: "line-children", name: "خطوط فرزندان", points: [
    Offset(88, 238),
    Offset(97, 236),
    Offset(105, 232),
  ]),
  InteractiveZone(id: "line-influence", name: "خطوط نفوذ و حمایت", points: [
    Offset(227, 256),
    Offset(213, 267),
    Offset(207, 278),
    Offset(202, 295),
    Offset(200, 312),
  ]),
  InteractiveZone(id: "line-bracelets", name: "دستبندهای مچ", points: [
    // Bracelet Line 1
    Offset(126, 374), Offset(141, 374), Offset(152, 370), Offset(164, 369), Offset(175, 366), Offset(187, 365), Offset(201, 365),
    // Bracelet Line 2
    Offset(124, 380), Offset(138, 381), Offset(156, 381), Offset(167, 376), Offset(184, 374), Offset(201, 373), Offset(216, 373), Offset(229, 371),
    // Bracelet Line 3
    Offset(125, 390), Offset(141, 398), Offset(159, 394), Offset(181, 394), Offset(199, 391), Offset(217, 388), Offset(232, 385),
  ]),

  // Special Rings
  InteractiveZone(id: "ring-solomon", name: "حلقه سلیمان", points: [
    Offset(209, 198),
    Offset(221, 207),
    Offset(236, 209),
    Offset(247, 204),
  ]),
  InteractiveZone(id: "ring-saturn", name: "حلقه زحل", points: [
    Offset(201, 188),
    Offset(192, 193),
    Offset(183, 196),
    Offset(174, 195),
    Offset(166, 192),
  ]),

  // InteractiveZone(id: "ring-apollo", name: "حلقه خورشید", points: [
  //   Offset(135, 205)
  // ]),
  // InteractiveZone(id: "ring-mercury", name: "حلقه عطارد", points: [
  //   Offset(90, 215)
  // ]),

  // Symbols
  InteractiveZone(id: "symbol-star", name: "ستاره", center: Offset(220, 220), radius: 12),
  InteractiveZone(id: "symbol-square", name: "مربع", center: Offset(180, 230), radius: 12),
  InteractiveZone(id: "symbol-triangle", name: "مثلث", center: Offset(135, 235), radius: 12),
  InteractiveZone(id: "symbol-cross", name: "صلیب", center: Offset(195, 275), radius: 12),
  InteractiveZone(id: "symbol-island", name: "جزیره", center: Offset(160, 260), radius: 12),
  InteractiveZone(id: "symbol-grille", name: "شبکه", center: Offset(105, 255), radius: 14),
  InteractiveZone(id: "symbol-dot", name: "نقطه", center: Offset(210, 310), radius: 12),
  InteractiveZone(id: "symbol-trident", name: "سه شاخ", center: Offset(175, 205), radius: 14),
  InteractiveZone(id: "symbol-fish", name: "ماهی", center: Offset(145, 340), radius: 14),
  
  // Fingers
  InteractiveZone(id: "finger-thumb", name: "انگشت شست",
   points:[
    Offset(253, 249),
    Offset(261, 239),
    Offset(265, 225),
    Offset(267, 209),
    Offset(268, 196),
    Offset(276, 185),
    Offset(288, 174),
    Offset(295, 168),
    Offset(309, 169),
    Offset(314, 173),
    Offset(313, 183),
    Offset(310, 187),
    Offset(306, 198),
    Offset(308, 207),
    Offset(308, 216),
    Offset(303, 227),
    Offset(299, 241),
    Offset(298, 251),
    Offset(297, 265),
    Offset(296, 277),
    Offset(293, 288),
    Offset(287, 302),
    Offset(277, 316),
    Offset(270, 326),
    Offset(260, 337),
    Offset(257, 325),
    Offset(258, 308),
    Offset(259, 294),
    Offset(255, 279),
    Offset(252, 264),
    Offset(252, 253),
  ]),
  InteractiveZone(id: "finger-jupiter", name: "انگشت اشاره",
   points:[
     Offset(208, 182),
     Offset(210, 168),
     Offset(211, 154),
     Offset(213, 135),
     Offset(212, 117),
     Offset(212, 92),
     Offset(215, 73),
     Offset(222, 60),
     Offset(230, 60),
     Offset(238, 62),
     Offset(246, 72),
     Offset(245, 84),
     Offset(245, 98),
     Offset(244, 119),
     Offset(244, 132),
     Offset(245, 148),
     Offset(244, 171),
     Offset(244, 186),
     Offset(229, 192),
     Offset(216, 186),
     Offset(207, 181),
   ]),
  InteractiveZone(id: "finger-saturn", name: "انگشت میانی",
   points:[
     Offset(163, 181),
     Offset(163, 164),
     Offset(163, 151),
     Offset(163, 136),
     Offset(162, 120),
     Offset(162, 106),
     Offset(163, 96),
     Offset(163, 81),
     Offset(164, 69),
     Offset(166, 49),
     Offset(169, 42),
     Offset(175, 39),
     Offset(183, 40),
     Offset(188, 40),
     Offset(193, 49),
     Offset(194, 62),
     Offset(196, 75),
     Offset(195, 93),
     Offset(196, 105),
     Offset(197, 118),
     Offset(197, 138),
     Offset(199, 149),
     Offset(200, 163),
     Offset(199, 179),
     Offset(191, 185),
     Offset(183, 183),
     Offset(174, 184),
     Offset(164, 184),
   ]),
  InteractiveZone(id: "finger-apollo", name: "انگشت حلقه",
   points: [
    Offset(123, 198),
    Offset(122, 183),
    Offset(119, 166),
    Offset(119, 142),
    Offset(117, 124),
    Offset(118, 102),
    Offset(118, 84),
    Offset(120, 70),
    Offset(128, 61),
    Offset(135, 61),
    Offset(141, 65),
    Offset(144, 71),
    Offset(146, 82),
    Offset(146, 93),
    Offset(147, 106),
    Offset(148, 125),
    Offset(149, 145),
    Offset(152, 159),
    Offset(153, 179),
    Offset(151, 192),
    Offset(138, 198),
    Offset(125, 199),
  ]),
  InteractiveZone(id: "finger-mercury",name: "انگشت کوچک",
   points: [
     Offset(85, 224),
     Offset(83, 212),
     Offset(81, 200),
     Offset(80, 186),
     Offset(80, 172),
     Offset(77, 161),
     Offset(77, 148),
     Offset(78, 130),
     Offset(79, 121),
     Offset(84, 116),
     Offset(90, 116),
     Offset(98, 117),
     Offset(102, 124),
     Offset(102, 132),
     Offset(104, 142),
     Offset(104, 155),
     Offset(106, 169),
     Offset(109, 182),
     Offset(112, 197),
     Offset(114, 209),
     Offset(108, 215),
     Offset(102, 217),
     Offset(98, 219),
     Offset(95, 220),
     Offset(87, 223),
   ]),
];

const Set<String> majorLineIds = {
  "line-heart",
  "line-head",
  "line-life",
  "line-fate",
  "line-sun",
  "line-mercury",
};

const Set<String> minorLineIds = {
  "line-marriage",
  "line-girdle-venus",
  "line-intuition",
  "line-mars",
  "line-travel",
  "line-children",
  "line-influence",
  "line-bracelets",
  "ring-solomon",
  "ring-saturn",
};

class InteractiveHandWidget extends StatelessWidget {
  final String? selectedId;
  final String activeFilter; // "all", "major", "minor", "mounts", "symbols", "fingers"
  final Function(String) onSelected;

  const InteractiveHandWidget({
    super.key,
    required this.selectedId,
    required this.activeFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;
        final double scale = min(width / 360, height / 500);

        final double offsetX = ((width - 360 * scale) / 2) - (28 * scale);
        final double offsetY = ((height - 500 * scale) / 2) + (85 * scale);

        return GestureDetector(
          onTapDown: (details) {
            final double localX = details.localPosition.dx;
            final double localY = details.localPosition.dy;

            // Normalize coordinates to 360x500 space
            final double normX = (localX - offsetX) / scale;
            final double normY = (localY - offsetY) / scale;
            final Offset tapOffset = Offset(normX, normY);

            // 1. Check if tap is inside the general layout area
            if (normX < 0 || normX > 360 || normY < 0 || normY > 500) return;

            // 2. Perform hit-testing
            String? closestId;
            double minDistance = double.infinity;

            for (var zone in interactiveZones) {
              // Apply activeFilter check
              if (activeFilter != "all") {
                if (activeFilter == "major" && !majorLineIds.contains(zone.id)) continue;
                if (activeFilter == "minor" && !minorLineIds.contains(zone.id)) continue;
                if (activeFilter == "mounts" && !zone.id.startsWith("mount-")) continue;
                if (activeFilter == "symbols" && !zone.id.startsWith("symbol-")) continue;
                if (activeFilter == "fingers" && !zone.id.startsWith("finger-")) continue;
              }

              if (zone.id.startsWith("finger-")) {
                final Path fingerPath = _getFingerPathForZone(zone);
                if (fingerPath.contains(tapOffset)) {
                  closestId = zone.id;
                  minDistance = 0;
                }
                continue;
              }

              if (zone.center != null) {
                if (zone.radiusX != null && zone.radiusY != null) {
                  // Elliptical / Oval hit-testing (with rotation support)
                  final double rotDeg = zone.rotation ?? 0.0;
                  final double relX = tapOffset.dx - zone.center!.dx;
                  final double relY = tapOffset.dy - zone.center!.dy;
                  
                  double unrotX = relX;
                  double unrotY = relY;
                  if (rotDeg != 0) {
                    final double rad = -rotDeg * pi / 180.0;
                    final double cosA = cos(rad);
                    final double sinA = sin(rad);
                    unrotX = relX * cosA - relY * sinA;
                    unrotY = relX * sinA + relY * cosA;
                  }

                  final double dx = unrotX / zone.radiusX!;
                  final double dy = unrotY / zone.radiusY!;
                  if ((dx * dx + dy * dy) <= 1.0) {
                    final double dist = (tapOffset - zone.center!).distance;
                    if (dist < minDistance) {
                      minDistance = dist;
                      closestId = zone.id;
                    }
                  }
                } else if (zone.radius != null) {
                  // Circular hit-testing (Mounts / Symbols / Finger tips)
                  final double dist = (tapOffset - zone.center!).distance;
                  if (dist <= zone.radius!) {
                    if (dist < minDistance) {
                      minDistance = dist;
                      closestId = zone.id;
                    }
                  }
                }
              } else if (zone.points.isNotEmpty) {
                // Linear hit-testing (Lines)
                for (var pt in zone.points) {
                  double dist = (tapOffset - pt).distance;
                  if (dist < 18) { // Hit-test threshold of 18 units
                    if (dist < minDistance) {
                      minDistance = dist;
                      closestId = zone.id;
                    }
                  }
                }
              }
            }

            if (closestId != null) {
              onSelected(closestId);
            }
          },
          child: Stack(
            children: [
              Positioned(
                left: offsetX,
                top: offsetY,
                width: 360 * scale,
                height: 500 * scale,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/hand.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              CustomPaint(
                size: Size(width, height),
                painter: HandPainter(
                  scale: scale,
                  offsetX: offsetX,
                  offsetY: offsetY,
                  selectedId: selectedId,
                  activeFilter: activeFilter,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Path _getPathForZone(String id) {
  final zone = interactiveZones.firstWhere((z) => z.id == id, orElse: () => const InteractiveZone(id: '', name: ''));
  final path = Path();
  if (zone.points.isNotEmpty) {
    path.moveTo(zone.points.first.dx, zone.points.first.dy);
    for (int i = 1; i < zone.points.length; i++) {
      path.lineTo(zone.points[i].dx, zone.points[i].dy);
    }
  }
  return path;
}

Path _getFingerPath(String id) {
  final Path fingerPath = Path();
  if (id == "finger-thumb") {
    fingerPath.moveTo(250, 260);
    fingerPath.cubicTo(265, 210, 290, 170, 300, 170);
    fingerPath.cubicTo(310, 170, 305, 220, 280, 270);
    fingerPath.cubicTo(270, 290, 260, 310, 250, 330);
    fingerPath.close();
  } else if (id == "finger-jupiter") {
    fingerPath.moveTo(242, 180);
    fingerPath.cubicTo(242, 140, 238, 75, 225, 55);
    fingerPath.cubicTo(212, 75, 210, 140, 210, 180);
    fingerPath.close();
  } else if (id == "finger-saturn") {
    fingerPath.moveTo(208, 180);
    fingerPath.cubicTo(208, 130, 195, 50, 180, 35);
    fingerPath.cubicTo(165, 50, 152, 130, 152, 180);
    fingerPath.close();
  } else if (id == "finger-apollo") {
    fingerPath.moveTo(150, 180);
    fingerPath.cubicTo(150, 140, 145, 75, 135, 55);
    fingerPath.cubicTo(125, 75, 117, 140, 117, 190);
    fingerPath.close();
  } else if (id == "finger-mercury") {
    fingerPath.moveTo(115, 190);
    fingerPath.cubicTo(115, 160, 100, 125, 90, 115);
    fingerPath.cubicTo(80, 125, 72, 160, 72, 210);
    fingerPath.close();
  }
  return fingerPath;
}

Path _getFingerPathForZone(InteractiveZone zone) {
  if (zone.points.length >= 3) {
    final Path path = Path()..moveTo(zone.points.first.dx, zone.points.first.dy);
    for (int i = 1; i < zone.points.length; i++) {
      path.lineTo(zone.points[i].dx, zone.points[i].dy);
    }
    path.close();
    return path;
  }
  return _getFingerPath(zone.id);
}

class HandPainter extends CustomPainter {
  final double scale;
  final double offsetX;
  final double offsetY;
  final String? selectedId;
  final String activeFilter;

  HandPainter({
    required this.scale,
    required this.offsetX,
    required this.offsetY,
    required this.selectedId,
    required this.activeFilter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // Translate and scale to match container size
    canvas.translate(offsetX, offsetY);
    canvas.scale(scale, scale);

    // Render Finger Zones with translucent low-contrast purple fill (Only when showing all or fingers)
    if (activeFilter == "all" || activeFilter == "fingers") {
      final fingerZones = interactiveZones.where((z) => z.id.startsWith("finger-"));
      for (var zone in fingerZones) {
        final bool isSelected = selectedId == zone.id;
        final Path fingerPath = _getFingerPathForZone(zone);

        // Low-contrast soft translucent purple fill
        final Paint fingerFillPaint = Paint()
          ..color = isSelected
              ? AppColors.primaryIndigo.withOpacity(0.35)
              : AppColors.primaryIndigo.withOpacity(0.18)
          ..style = PaintingStyle.fill;

        // Soft border
        final Paint fingerBorderPaint = Paint()
          ..color = isSelected
              ? AppColors.neonPurple
              : AppColors.primaryIndigo.withOpacity(0.25)
          ..strokeWidth = isSelected ? 2.0 : 1.0
          ..style = PaintingStyle.stroke;

        canvas.drawPath(fingerPath, fingerFillPaint);
        canvas.drawPath(fingerPath, fingerBorderPaint);

        // Selection glow effect
        if (isSelected) {
          final Paint glowPaint = Paint()
            ..color = AppColors.primaryPurple.withOpacity(0.4)
            ..strokeWidth = 3.5
            ..style = PaintingStyle.stroke
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
          canvas.drawPath(fingerPath, glowPaint);
        }
      }
    }

    // Render Mounts (Only when showing all or mounts)
    if (activeFilter == "all" || activeFilter == "mounts") {
      final mountZones = interactiveZones.where((z) => z.id.startsWith("mount-"));
      for (var zone in mountZones) {
        if (zone.center != null) {

          final modifiedName = zone.name.replaceAll("برجستگی", "کوه");

          _drawMount(
            canvas,
            zone.id,
            zone.center!,
            modifiedName,
            radius: zone.radius,
            radiusX: zone.radiusX,
            radiusY: zone.radiusY,
            rotation: zone.rotation,
          );
        }
      }
    }

    // Render Major Lines (Only when showing all or major)
    if (activeFilter == "all" || activeFilter == "major") {
      // Heart Line (Neon Rose/Crimson)
      _drawLine(canvas, "line-heart", _getPathForZone("line-heart"), AppColors.lineHeart, 3.0);

      // Head Line (Neon Blue)
      _drawLine(canvas, "line-head", _getPathForZone("line-head"), AppColors.lineHead, 3.0);

      // Life Line (Neon Emerald)
      _drawLine(canvas, "line-life", _getPathForZone("line-life"), AppColors.lineLife, 3.0);

      // Fate Line (Neon Purple)
      _drawLine(canvas, "line-fate", _getPathForZone("line-fate"), AppColors.lineFate, 3.0);

      // Sun Line (Neon Amber)
      _drawLine(canvas, "line-sun", _getPathForZone("line-sun"), AppColors.lineSun, 2.0);

      // Health Line (Neon Cyan)
      _drawLine(canvas, "line-mercury", _getPathForZone("line-mercury"), AppColors.lineMercury, 2.0);
    }

    // Render Minor Lines & Rings (Only when showing all or minor)
    if (activeFilter == "all" || activeFilter == "minor") {
      // Marriage Line (Neon Pink)
      _drawLine(canvas, "line-marriage", _getPathForZone("line-marriage"), AppColors.lineMarriage, 2.8);

      // Girdle of Venus (Neon Rose)
      _drawLine(canvas, "line-girdle-venus", _getPathForZone("line-girdle-venus"), AppColors.lineGirdle, 2.8);

      // Intuition Line (Neon Lime)
      _drawLine(canvas, "line-intuition", _getPathForZone("line-intuition"), AppColors.lineIntuition, 2.8);

      // Mars Line (Neon Orange)
      _drawLine(canvas, "line-mars", _getPathForZone("line-mars"), AppColors.lineMars, 2.8);

      // Influence Line (Neon Blue)
      _drawLine(canvas, "line-influence", _getPathForZone("line-influence"), AppColors.lineInfluence, 2.5);

      // Travel Lines (Neon Cyan Blue)
      final List<Offset> t1Pts = [
        const Offset(105, 332), const Offset(113, 328), const Offset(119, 322),
      ];
      final List<Offset> t2Pts = [
        const Offset(100, 321), const Offset(108, 316), const Offset(115, 309),
      ];
      final List<Offset> t3Pts = [
        const Offset(97, 311), const Offset(104, 308), const Offset(111, 300),
      ];
      final List<Offset> t4Pts = [
        const Offset(93, 297), const Offset(103, 292), const Offset(110, 284),
      ];

      Path buildTravelPath(List<Offset> pts) {
        final Path p = Path();
        if (pts.isNotEmpty) {
          p.moveTo(pts.first.dx, pts.first.dy);
          for (int i = 1; i < pts.length; i++) {
            p.lineTo(pts[i].dx, pts[i].dy);
          }
        }
        return p;
      }

      _drawLine(canvas, "line-travel", buildTravelPath(t1Pts), AppColors.lineTravel, 2.5);
      _drawLine(canvas, "line-travel", buildTravelPath(t2Pts), AppColors.lineTravel, 2.5);
      _drawLine(canvas, "line-travel", buildTravelPath(t3Pts), AppColors.lineTravel, 2.5);
      _drawLine(canvas, "line-travel", buildTravelPath(t4Pts), AppColors.lineTravel, 2.5);

      // Children Lines (Neon Teal)
      final childrenZone = interactiveZones.firstWhere((z) => z.id == "line-children");
      if (childrenZone.points.length >= 2) {
        for (int i = 0; i < childrenZone.points.length; i += 2) {
          if (i + 1 < childrenZone.points.length) {
            final p = Path()
              ..moveTo(childrenZone.points[i].dx, childrenZone.points[i].dy)
              ..lineTo(childrenZone.points[i+1].dx, childrenZone.points[i+1].dy);
            _drawLine(canvas, "line-children", p, AppColors.lineChildren, 2.5);
          }
        }
      }

      // Bracelets (Neon Coral)
      final List<Offset> b1Pts = [
        const Offset(125, 395), const Offset(131, 398), const Offset(146, 398), const Offset(165, 397),
        const Offset(183, 395), const Offset(202, 393), const Offset(218, 388), const Offset(234, 382),
      ];
      final List<Offset> b2Pts = [
        const Offset(119, 381), const Offset(131, 383), const Offset(154, 381), const Offset(173, 380),
        const Offset(193, 378), const Offset(214, 375), const Offset(231, 372),
      ];
      final List<Offset> b3Pts = [
        const Offset(122, 373), const Offset(138, 374), const Offset(150, 372), const Offset(159, 369),
        const Offset(170, 368), const Offset(180, 367), const Offset(192, 367), const Offset(199, 368),
        const Offset(212, 369), const Offset(223, 369), const Offset(232, 368), const Offset(238, 366),
      ];

      Path buildBraceletPath(List<Offset> pts) {
        final Path p = Path();
        if (pts.isNotEmpty) {
          p.moveTo(pts.first.dx, pts.first.dy);
          for (int i = 1; i < pts.length; i++) {
            p.lineTo(pts[i].dx, pts[i].dy);
          }
        }
        return p;
      }

      _drawLine(canvas, "line-bracelets", buildBraceletPath(b1Pts), AppColors.lineBracelets, 2.8);
      _drawLine(canvas, "line-bracelets", buildBraceletPath(b2Pts), AppColors.lineBracelets, 2.8);
      _drawLine(canvas, "line-bracelets", buildBraceletPath(b3Pts), AppColors.lineBracelets, 2.8);

      // Rings (Solomon Green, Saturn Violet)
      _drawRing(canvas, "ring-solomon", const Offset(225, 191), 18, color: AppColors.ringSolomon);
      _drawRing(canvas, "ring-saturn", const Offset(180, 190), 18, color: AppColors.ringSaturn);
    }

    // Render Symbols (Only when showing all or symbols)
    if (activeFilter == "all" || activeFilter == "symbols") {
      _drawStar(canvas, "symbol-star", const Offset(220, 220));
      _drawSquare(canvas, "symbol-square", const Offset(180, 230));
      _drawTriangle(canvas, "symbol-triangle", const Offset(135, 235));
      _drawCross(canvas, "symbol-cross", const Offset(195, 275));
      _drawIsland(canvas, "symbol-island", const Offset(160, 260));
      _drawGrille(canvas, "symbol-grille", const Offset(105, 255));
      _drawDot(canvas, "symbol-dot", const Offset(210, 310));
      _drawTrident(canvas, "symbol-trident", const Offset(175, 205));
      _drawFish(canvas, "symbol-fish", const Offset(145, 340));
    }

    canvas.restore();
  }

  Color _getMountColor(String id) {
    switch (id) {
      case "mount-jupiter":
        return AppColors.mountJupiter;
      case "mount-saturn":
        return AppColors.mountSaturn;
      case "mount-apollo":
        return AppColors.mountApollo;
      case "mount-mercury":
        return AppColors.mountMercury;
      case "mount-mars-lower":
        return AppColors.mountMarsLower;
      case "mount-mars-upper":
        return AppColors.mountMarsUpper;
      case "mount-mars-plain":
        return AppColors.mountMarsPlain;
      case "mount-venus":
        return AppColors.mountVenus;
      case "mount-moon":
        return AppColors.mountMoon;
      default:
        return AppColors.primaryIndigo;
    }
  }

  void _drawMount(Canvas canvas, String id, Offset center, String label, {double? radius, double? radiusX, double? radiusY, double? rotation}) {
    final bool isActive = selectedId == id;
    final Color mountColor = _getMountColor(id);

    final Paint mountPaint = Paint()
      ..color = isActive ? mountColor.withOpacity(0.45) : mountColor.withOpacity(0.18)
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = isActive ? mountColor : mountColor.withOpacity(0.55)
      ..strokeWidth = isActive ? 2.5 : 1.2
      ..style = PaintingStyle.stroke;

    final double effectiveRadius = radius ?? max(radiusX ?? 18, radiusY ?? 18);

    canvas.save();
    if (rotation != null && rotation != 0) {
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation * pi / 180.0);
      canvas.translate(-center.dx, -center.dy);
    }

    if (isActive) {
      final Paint glowPaint = Paint()
        ..color = mountColor.withOpacity(0.5)
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

      if (radiusX != null && radiusY != null) {
        final Rect ovalRect = Rect.fromCenter(center: center, width: radiusX * 2, height: radiusY * 2);
        canvas.drawOval(ovalRect, glowPaint);
      } else {
        canvas.drawCircle(center, effectiveRadius, glowPaint);
      }
    }

    if (radiusX != null && radiusY != null) {
      final Rect ovalRect = Rect.fromCenter(center: center, width: radiusX * 2, height: radiusY * 2);
      canvas.drawOval(ovalRect, mountPaint);
      canvas.drawOval(ovalRect, borderPaint);
    } else {
      canvas.drawCircle(center, effectiveRadius, mountPaint);
      canvas.drawCircle(center, effectiveRadius, borderPaint);
    }

    canvas.restore();
  }

  void _drawLine(Canvas canvas, String id, Path path, Color color, double width) {
    final bool isActive = selectedId == id;

    // Glowing ambient background paint (makes all lines pop off the hand diagram)
    final Paint glowPaint = Paint()
      ..color = color.withOpacity(isActive ? 0.65 : 0.35)
      ..strokeWidth = width + (isActive ? 4.5 : 2.0)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, isActive ? 3.5 : 1.5);
    canvas.drawPath(path, glowPaint);

    final Paint linePaint = Paint()
      ..color = isActive ? Colors.white : color.withOpacity(0.9)
      ..strokeWidth = isActive ? width + 1.2 : width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);
  }

  void _drawRing(Canvas canvas, String id, Offset center, double radius, {Color color = const Color(0xFF6366F1)}) {
    final bool isActive = selectedId == id;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    final Paint glowPaint = Paint()
      ..color = color.withOpacity(isActive ? 0.7 : 0.35)
      ..strokeWidth = isActive ? 5.0 : 3.0
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, isActive ? 3.5 : 1.5);
    canvas.drawArc(rect, 0.2, pi - 0.4, false, glowPaint);

    final Paint ringPaint = Paint()
      ..color = isActive ? Colors.white : color.withOpacity(0.9)
      ..strokeWidth = isActive ? 3.2 : 2.5
      ..style = PaintingStyle.stroke;
    
    canvas.drawArc(rect, 0.2, pi - 0.4, false, ringPaint);
  }

  // Draw small marks symbols (Purple theme)
  void _drawStar(Canvas canvas, String id, Offset p) {
    final bool isActive = selectedId == id;
    final Paint starPaint = Paint()
      ..color = isActive ? const Color(0xFFA78BFA) : const Color(0x908B5CF6)
      ..strokeWidth = isActive ? 2.2 : 1.2
      ..style = PaintingStyle.stroke;

    if (isActive) {
      final Paint glowPaint = Paint()
        ..color = const Color(0xFF8B5CF6).withOpacity(0.4)
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      canvas.drawLine(Offset(p.dx - 5, p.dy - 5), Offset(p.dx + 5, p.dy + 5), glowPaint);
      canvas.drawLine(Offset(p.dx + 5, p.dy - 5), Offset(p.dx - 5, p.dy + 5), glowPaint);
    }

    canvas.drawLine(Offset(p.dx - 4, p.dy - 4), Offset(p.dx + 4, p.dy + 4), starPaint);
    canvas.drawLine(Offset(p.dx + 4, p.dy - 4), Offset(p.dx - 4, p.dy + 4), starPaint);
    canvas.drawLine(Offset(p.dx, p.dy - 5), Offset(p.dx, p.dy + 5), starPaint);
    canvas.drawLine(Offset(p.dx - 5, p.dy), Offset(p.dx + 5, p.dy), starPaint);
  }

  void _drawSquare(Canvas canvas, String id, Offset p) {
    final bool isActive = selectedId == id;
    final Paint paint = Paint()
      ..color = isActive ? const Color(0xFFA78BFA) : const Color(0x908B5CF6)
      ..strokeWidth = isActive ? 2.2 : 1.2
      ..style = PaintingStyle.stroke;

    if (isActive) {
      final Paint glowPaint = Paint()
        ..color = const Color(0xFF8B5CF6).withOpacity(0.4)
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      canvas.drawRect(Rect.fromCenter(center: p, width: 8, height: 8), glowPaint);
    }

    canvas.drawRect(Rect.fromCenter(center: p, width: 8, height: 8), paint);
  }

  void _drawTriangle(Canvas canvas, String id, Offset p) {
    final bool isActive = selectedId == id;
    final Paint paint = Paint()
      ..color = isActive ? const Color(0xFFA78BFA) : const Color(0x908B5CF6)
      ..strokeWidth = isActive ? 2.2 : 1.2
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..moveTo(p.dx, p.dy - 5)
      ..lineTo(p.dx + 5, p.dy + 4)
      ..lineTo(p.dx - 5, p.dy + 4)
      ..close();

    if (isActive) {
      final Paint glowPaint = Paint()
        ..color = const Color(0xFF8B5CF6).withOpacity(0.4)
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      canvas.drawPath(path, glowPaint);
    }

    canvas.drawPath(path, paint);
  }

  void _drawIsland(Canvas canvas, String id, Offset p) {
    final bool isActive = selectedId == id;
    final Paint paint = Paint()
      ..color = isActive ? const Color(0xFFA78BFA) : const Color(0x908B5CF6)
      ..strokeWidth = isActive ? 2.2 : 1.2
      ..style = PaintingStyle.stroke;

    if (isActive) {
      final Paint glowPaint = Paint()
        ..color = const Color(0xFF8B5CF6).withOpacity(0.4)
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      canvas.drawOval(Rect.fromCenter(center: p, width: 10, height: 6), glowPaint);
    }

    canvas.drawOval(Rect.fromCenter(center: p, width: 10, height: 6), paint);
  }

  void _drawCross(Canvas canvas, String id, Offset p) {
    final bool isActive = selectedId == id;
    final Paint paint = Paint()
      ..color = isActive ? const Color(0xFFA78BFA) : const Color(0x908B5CF6)
      ..strokeWidth = isActive ? 2.2 : 1.2
      ..style = PaintingStyle.stroke;

    if (isActive) {
      final Paint glowPaint = Paint()
        ..color = const Color(0xFF8B5CF6).withOpacity(0.4)
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      canvas.drawLine(Offset(p.dx - 4, p.dy - 4), Offset(p.dx + 4, p.dy + 4), glowPaint);
      canvas.drawLine(Offset(p.dx + 4, p.dy - 4), Offset(p.dx - 4, p.dy + 4), glowPaint);
    }

    canvas.drawLine(Offset(p.dx - 4, p.dy - 4), Offset(p.dx + 4, p.dy + 4), paint);
    canvas.drawLine(Offset(p.dx + 4, p.dy - 4), Offset(p.dx - 4, p.dy + 4), paint);
  }

  void _drawGrille(Canvas canvas, String id, Offset p) {
    final bool isActive = selectedId == id;
    final Paint paint = Paint()
      ..color = isActive ? const Color(0xFFA78BFA) : const Color(0x908B5CF6)
      ..strokeWidth = isActive ? 1.8 : 1.0
      ..style = PaintingStyle.stroke;

    for (double i = -4; i <= 4; i += 4) {
      canvas.drawLine(Offset(p.dx - 6, p.dy + i), Offset(p.dx + 6, p.dy + i), paint);
      canvas.drawLine(Offset(p.dx + i, p.dy - 6), Offset(p.dx + i, p.dy + 6), paint);
    }
  }

  void _drawDot(Canvas canvas, String id, Offset p) {
    final bool isActive = selectedId == id;
    final Paint fillPaint = Paint()
      ..color = isActive ? const Color(0xFFA78BFA) : const Color(0x908B5CF6)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(p, isActive ? 4.5 : 3.2, fillPaint);

    if (isActive) {
      final Paint glowPaint = Paint()
        ..color = const Color(0xFF8B5CF6).withOpacity(0.4)
        ..strokeWidth = 2.0
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      canvas.drawCircle(p, 6.5, glowPaint);
    }
  }

  void _drawTrident(Canvas canvas, String id, Offset p) {
    final bool isActive = selectedId == id;
    final Paint paint = Paint()
      ..color = isActive ? const Color(0xFFA78BFA) : const Color(0x908B5CF6)
      ..strokeWidth = isActive ? 2.2 : 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path path = Path()
      ..moveTo(p.dx, p.dy + 7)
      ..lineTo(p.dx, p.dy - 7)
      ..moveTo(p.dx, p.dy + 1)
      ..quadraticBezierTo(p.dx - 5, p.dy - 2, p.dx - 5, p.dy - 7)
      ..moveTo(p.dx, p.dy + 1)
      ..quadraticBezierTo(p.dx + 5, p.dy - 2, p.dx + 5, p.dy - 7);

    if (isActive) {
      final Paint glowPaint = Paint()
        ..color = const Color(0xFF8B5CF6).withOpacity(0.4)
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      canvas.drawPath(path, glowPaint);
    }

    canvas.drawPath(path, paint);
  }

  void _drawFish(Canvas canvas, String id, Offset p) {
    final bool isActive = selectedId == id;
    final Paint paint = Paint()
      ..color = isActive ? const Color(0xFFA78BFA) : const Color(0x908B5CF6)
      ..strokeWidth = isActive ? 2.2 : 1.4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path path = Path()
      ..moveTo(p.dx - 7, p.dy)
      ..cubicTo(p.dx - 4, p.dy - 7, p.dx + 4, p.dy - 7, p.dx + 7, p.dy + 5)
      ..moveTo(p.dx - 7, p.dy)
      ..cubicTo(p.dx - 4, p.dy + 7, p.dx + 4, p.dy + 7, p.dx + 7, p.dy - 5);

    if (isActive) {
      final Paint glowPaint = Paint()
        ..color = const Color(0xFF8B5CF6).withOpacity(0.4)
        ..strokeWidth = 3.5
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      canvas.drawPath(path, glowPaint);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant HandPainter oldDelegate) {
    return oldDelegate.selectedId != selectedId ||
        oldDelegate.scale != scale ||
        oldDelegate.offsetX != offsetX ||
        oldDelegate.offsetY != offsetY ||
        oldDelegate.activeFilter != activeFilter;
  }
}
