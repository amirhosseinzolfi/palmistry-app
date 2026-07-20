// ignore_for_file: deprecated_member_use
import 'dart:math';
import 'package:flutter/material.dart';

// Definition of an interactive zone
class InteractiveZone {
  final String id;
  final String name;
  final List<Offset> points; // For lines
  final Offset? center; // For mounts / symbols
  final double? radius; // For mounts

  const InteractiveZone({
    required this.id,
    required this.name,
    this.points = const [],
    this.center,
    this.radius,
  });
}

// Predefined list of hit-test zones matching the coordinates in 360x500 space
const List<InteractiveZone> interactiveZones = [
  // Mounts
  InteractiveZone(id: "mount-jupiter", name: "برجستگی مشتری", center: Offset(225, 205), radius: 18),
  InteractiveZone(id: "mount-saturn", name: "برجستگی زحل", center: Offset(180, 205), radius: 18),
  InteractiveZone(id: "mount-apollo", name: "برجستگی خورشید", center: Offset(135, 205), radius: 18),
  InteractiveZone(id: "mount-mercury", name: "برجستگی عطارد", center: Offset(90, 215), radius: 18),
  InteractiveZone(id: "mount-mars-lower", name: "برجستگی مریخ پایین", center: Offset(225, 250), radius: 15),
  InteractiveZone(id: "mount-mars-upper", name: "برجستگی مریخ بالا", center: Offset(85, 265), radius: 15),
  InteractiveZone(id: "mount-mars-plain", name: "دشت مریخ", center: Offset(165, 275), radius: 22),
  InteractiveZone(id: "mount-venus", name: "برجستگی ونوس", center: Offset(235, 345), radius: 32),
  InteractiveZone(id: "mount-moon", name: "برجستگی ماه", center: Offset(90, 360), radius: 30),

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
    Offset(225, 190), Offset(195, 175), Offset(145, 175), Offset(100, 190)
  ]),
  InteractiveZone(id: "line-intuition", name: "خط شهود", points: [
    Offset(85, 365), Offset(115, 320), Offset(115, 280), Offset(90, 235)
  ]),
  InteractiveZone(id: "line-mars", name: "خط مریخ", points: [
    Offset(230, 240), Offset(222, 280), Offset(230, 335), Offset(210, 385)
  ]),
  InteractiveZone(id: "line-travel", name: "خطوط سفر", points: [
    Offset(85, 380), Offset(65, 380),
    Offset(90, 395), Offset(70, 395)
  ]),
  InteractiveZone(id: "line-bracelets", name: "دستبندهای مچ", points: [
    Offset(205, 450), Offset(175, 455), Offset(145, 455), Offset(125, 450)
  ]),

  // Special Rings
  InteractiveZone(id: "ring-solomon", name: "حلقه سلیمان", points: [
    Offset(225, 205)
  ]),
  InteractiveZone(id: "ring-saturn", name: "حلقه زحل", points: [
    Offset(180, 205)
  ]),
  InteractiveZone(id: "ring-apollo", name: "حلقه خورشید", points: [
    Offset(135, 205)
  ]),
  InteractiveZone(id: "ring-mercury", name: "حلقه عطارد", points: [
    Offset(90, 215)
  ]),

  // Symbols
  InteractiveZone(id: "symbol-star", name: "ستاره", center: Offset(225, 195), radius: 10),
  InteractiveZone(id: "symbol-square", name: "مربع", center: Offset(230, 330), radius: 10),
  InteractiveZone(id: "symbol-triangle", name: "مثلث", center: Offset(135, 220), radius: 10),
  InteractiveZone(id: "symbol-island", name: "جزیره", center: Offset(165, 225), radius: 10),
  InteractiveZone(id: "symbol-cross", name: "صلیب", center: Offset(165, 275), radius: 10),
  InteractiveZone(id: "symbol-grille", name: "شبکه", center: Offset(95, 345), radius: 12),
  
  // Fingers
  InteractiveZone(id: "finger-thumb", name: "انگشت شست", center: Offset(295, 190), radius: 25),
  InteractiveZone(id: "finger-jupiter", name: "انگشت اشاره", center: Offset(225, 110), radius: 20),
  InteractiveZone(id: "finger-saturn", name: "انگشت میانی", center: Offset(180, 95), radius: 20),
  InteractiveZone(id: "finger-apollo", name: "انگشت حلقه", center: Offset(135, 110), radius: 20),
  InteractiveZone(id: "finger-mercury", name: "انگشت کوچک", center: Offset(90, 150), radius: 18),
];

class InteractiveHandWidget extends StatelessWidget {
  final String? selectedId;
  final String activeFilter; // "all", "lines", "mounts", "symbols", "fingers"
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
                if (activeFilter == "lines" && !zone.id.startsWith("line-") && !zone.id.startsWith("ring-")) continue;
                if (activeFilter == "mounts" && !zone.id.startsWith("mount-")) continue;
                if (activeFilter == "symbols" && !zone.id.startsWith("symbol-")) continue;
                if (activeFilter == "fingers" && !zone.id.startsWith("finger-")) continue;
              }

              if (zone.center != null && zone.radius != null) {
                // Circular hit-testing (Mounts / Symbols / Finger tips)
                double dist = (tapOffset - zone.center!).distance;
                if (dist <= zone.radius!) {
                  if (dist < minDistance) {
                    minDistance = dist;
                    closestId = zone.id;
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

    // Render highlighted Finger Zones (Only when showing all or fingers)
    if ((activeFilter == "all" || activeFilter == "fingers") && selectedId != null && selectedId!.startsWith("finger-")) {
      final Paint fingerHighlightPaint = Paint()
        ..color = const Color(0xFF6366F1).withOpacity(0.2)
        ..style = PaintingStyle.fill;
      
      final Path fingerPath = Path();
      if (selectedId == "finger-thumb") {
        fingerPath.moveTo(250, 260);
        fingerPath.cubicTo(265, 210, 290, 170, 300, 170);
        fingerPath.cubicTo(310, 170, 305, 220, 280, 270);
        fingerPath.cubicTo(270, 290, 260, 310, 250, 330);
        fingerPath.close();
      } else if (selectedId == "finger-jupiter") {
        fingerPath.moveTo(242, 180);
        fingerPath.cubicTo(242, 140, 238, 75, 225, 55);
        fingerPath.cubicTo(212, 75, 210, 140, 210, 180);
        fingerPath.close();
      } else if (selectedId == "finger-saturn") {
        fingerPath.moveTo(208, 180);
        fingerPath.cubicTo(208, 130, 195, 50, 180, 35);
        fingerPath.cubicTo(165, 50, 152, 130, 152, 180);
        fingerPath.close();
      } else if (selectedId == "finger-apollo") {
        fingerPath.moveTo(150, 180);
        fingerPath.cubicTo(150, 140, 145, 75, 135, 55);
        fingerPath.cubicTo(125, 75, 117, 140, 117, 190);
        fingerPath.close();
      } else if (selectedId == "finger-mercury") {
        fingerPath.moveTo(115, 190);
        fingerPath.cubicTo(115, 160, 100, 125, 90, 115);
        fingerPath.cubicTo(80, 125, 72, 160, 72, 210);
        fingerPath.close();
      }
      canvas.drawPath(fingerPath, fingerHighlightPaint);
    }

    // Render Mounts (Only when showing all or mounts)
    if (activeFilter == "all" || activeFilter == "mounts") {
      _drawMount(canvas, "mount-jupiter", const Offset(135, 205), 18, "مشتری");
      _drawMount(canvas, "mount-saturn", const Offset(180, 205), 18, "زحل");
      _drawMount(canvas, "mount-apollo", const Offset(225, 205), 18, "خورشید");
      _drawMount(canvas, "mount-mercury", const Offset(270, 215), 18, "عطارد");
      _drawMount(canvas, "mount-mars-lower", const Offset(135, 250), 15, "مریخ 🡫");
      _drawMount(canvas, "mount-mars-upper", const Offset(275, 265), 15, "مریخ 🡩");
      _drawMount(canvas, "mount-mars-plain", const Offset(195, 275), 22, "دشت مریخ");
      _drawMount(canvas, "mount-venus", const Offset(125, 345), 32, "ونوس");
      _drawMount(canvas, "mount-moon", const Offset(270, 360), 30, "ماه");
    }

    // Render Lines & Rings (Only when showing all or lines)
    if (activeFilter == "all" || activeFilter == "lines") {
      // Heart Line (Neon Cyan Glow)
      _drawLine(canvas, "line-heart", _getPathForZone("line-heart"), const Color(0xFF00F2FE), 3.0);

      // Head Line (Neon Cyan Glow)
      _drawLine(canvas, "line-head", _getPathForZone("line-head"), const Color(0xFF00F2FE), 3.0);

      // Life Line (Neon Cyan Glow)
      _drawLine(canvas, "line-life", _getPathForZone("line-life"), const Color(0xFF00F2FE), 3.0);

      // Fate Line (Neon Cyan Glow)
      _drawLine(canvas, "line-fate", _getPathForZone("line-fate"), const Color(0xFF00F2FE), 3.0);

      // Sun Line (Indigo Glow)
      _drawLine(canvas, "line-sun", _getPathForZone("line-sun"), const Color(0xFF6366F1), 2.0);

      // Health Line (Indigo Glow)
      _drawLine(canvas, "line-mercury", _getPathForZone("line-mercury"), const Color(0xFF6366F1), 2.0);

      // Marriage Line (Indigo Glow)
      _drawLine(canvas, "line-marriage", _getPathForZone("line-marriage"), const Color(0xFF6366F1), 2.0);

      // Girdle of Venus
      _drawLine(canvas, "line-girdle-venus", _getPathForZone("line-girdle-venus"), const Color(0xFF6366F1), 2.0);

      // Intuition Line
      _drawLine(canvas, "line-intuition", _getPathForZone("line-intuition"), const Color(0xFF6366F1), 2.0);

      // Mars Line
      _drawLine(canvas, "line-mars", _getPathForZone("line-mars"), const Color(0xFF6366F1), 1.5);

      // Travel Lines (multi-segment)
      final travelZone = interactiveZones.firstWhere((z) => z.id == "line-travel");
      if (travelZone.points.length >= 2) {
        for (int i = 0; i < travelZone.points.length; i += 2) {
          if (i + 1 < travelZone.points.length) {
            final p = Path()
              ..moveTo(travelZone.points[i].dx, travelZone.points[i].dy)
              ..lineTo(travelZone.points[i+1].dx, travelZone.points[i+1].dy);
            _drawLine(canvas, "line-travel", p, const Color(0xFF6366F1), 1.8);
          }
        }
      }

      // Bracelets
      final braceletsZone = interactiveZones.firstWhere((z) => z.id == "line-bracelets");
      final Path b1 = _getPathForZone("line-bracelets");
      final Path b2 = Path();
      final Path b3 = Path();
      if (braceletsZone.points.isNotEmpty) {
        b2.moveTo(braceletsZone.points.first.dx - 2, braceletsZone.points.first.dy + 6);
        b3.moveTo(braceletsZone.points.first.dx - 4, braceletsZone.points.first.dy + 12);
        for (int i = 1; i < braceletsZone.points.length; i++) {
          b2.lineTo(braceletsZone.points[i].dx, braceletsZone.points[i].dy + 6);
          b3.lineTo(braceletsZone.points[i].dx, braceletsZone.points[i].dy + 12);
        }
      }
      _drawLine(canvas, "line-bracelets", b1, const Color(0xFF6366F1), 1.5);
      _drawLine(canvas, "line-bracelets", b2, const Color(0xFF6366F1), 1.5);
      _drawLine(canvas, "line-bracelets", b3, const Color(0xFF6366F1), 1.5);

      // Rings (Solomon, Saturn, Apollo, Mercury)
      _drawRing(canvas, "ring-solomon", const Offset(135, 205), 15);
      _drawRing(canvas, "ring-saturn", const Offset(180, 205), 18);
      _drawRing(canvas, "ring-apollo", const Offset(225, 205), 18);
      _drawRing(canvas, "ring-mercury", const Offset(270, 215), 18);
    }

    // Render Symbols (Only when showing all or symbols)
    if (activeFilter == "all" || activeFilter == "symbols") {
      _drawStar(canvas, "symbol-star", const Offset(135, 195));
      _drawSquare(canvas, "symbol-square", const Offset(130, 330));
      _drawTriangle(canvas, "symbol-triangle", const Offset(225, 220));
      _drawIsland(canvas, "symbol-island", const Offset(195, 225));
      _drawCross(canvas, "symbol-cross", const Offset(195, 275));
      _drawGrille(canvas, "symbol-grille", const Offset(265, 345));
    }

    canvas.restore();
  }

  void _drawMount(Canvas canvas, String id, Offset center, double radius, String label) {
    final bool isActive = selectedId == id;
    
    final Paint mountPaint = Paint()
      ..color = isActive ? const Color(0xFF6366F1).withOpacity(0.35) : const Color(0xFF6366F1).withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = isActive ? const Color(0xFF6366F1) : const Color(0x356366F1)
      ..strokeWidth = isActive ? 2.2 : 1.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, mountPaint);
    canvas.drawCircle(center, radius, borderPaint);

    // Draw text label
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: isActive ? Colors.white : const Color(0xFFA9B2C3).withOpacity(0.7),
          fontSize: radius > 25 ? 9.0 : 7.0,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          fontFamily: 'Vazirmatn',
        ),
      ),
      textDirection: TextDirection.rtl,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );
  }

  void _drawLine(Canvas canvas, String id, Path path, Color color, double width) {
    final bool isActive = selectedId == id;

    // Glowing background paint on selection
    if (isActive) {
      final Paint glowPaint = Paint()
        ..color = color.withOpacity(0.4)
        ..strokeWidth = width + 4.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);
      canvas.drawPath(path, glowPaint);
    }

    final Paint linePaint = Paint()
      ..color = isActive ? color : color.withOpacity(0.4)
      ..strokeWidth = isActive ? width + 1.2 : width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);
  }

  void _drawRing(Canvas canvas, String id, Offset center, double radius) {
    final bool isActive = selectedId == id;
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    if (isActive) {
      final Paint glowPaint = Paint()
        ..color = const Color(0xFFFFB703).withOpacity(0.4)
        ..strokeWidth = 4.0
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
      canvas.drawArc(rect, 0.2, pi - 0.4, false, glowPaint);
    }

    final Paint ringPaint = Paint()
      ..color = isActive ? const Color(0xFFFFB703) : const Color(0x60FFB703)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    
    canvas.drawArc(rect, 0.2, pi - 0.4, false, ringPaint);
  }

  // Draw small marks symbols
  void _drawStar(Canvas canvas, String id, Offset p) {
    final bool isActive = selectedId == id;
    final Paint starPaint = Paint()
      ..color = isActive ? const Color(0xFFFFB703) : const Color(0x80FFB703)
      ..strokeWidth = isActive ? 2.2 : 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(p.dx - 4, p.dy - 4), Offset(p.dx + 4, p.dy + 4), starPaint);
    canvas.drawLine(Offset(p.dx + 4, p.dy - 4), Offset(p.dx - 4, p.dy + 4), starPaint);
    canvas.drawLine(Offset(p.dx, p.dy - 5), Offset(p.dx, p.dy + 5), starPaint);
    canvas.drawLine(Offset(p.dx - 5, p.dy), Offset(p.dx + 5, p.dy), starPaint);
  }

  void _drawSquare(Canvas canvas, String id, Offset p) {
    final bool isActive = selectedId == id;
    final Paint paint = Paint()
      ..color = isActive ? const Color(0xFFFFB703) : const Color(0x80FFB703)
      ..strokeWidth = isActive ? 2.2 : 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Rect.fromCenter(center: p, width: 8, height: 8), paint);
  }

  void _drawTriangle(Canvas canvas, String id, Offset p) {
    final bool isActive = selectedId == id;
    final Paint paint = Paint()
      ..color = isActive ? const Color(0xFFFFB703) : const Color(0x80FFB703)
      ..strokeWidth = isActive ? 2.2 : 1.2
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..moveTo(p.dx, p.dy - 5)
      ..lineTo(p.dx + 5, p.dy + 4)
      ..lineTo(p.dx - 5, p.dy + 4)
      ..close();

    canvas.drawPath(path, paint);
  }

  void _drawIsland(Canvas canvas, String id, Offset p) {
    final bool isActive = selectedId == id;
    final Paint paint = Paint()
      ..color = isActive ? const Color(0xFFFFB703) : const Color(0x80FFB703)
      ..strokeWidth = isActive ? 2.2 : 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawOval(Rect.fromCenter(center: p, width: 9, height: 5), paint);
  }

  void _drawCross(Canvas canvas, String id, Offset p) {
    final bool isActive = selectedId == id;
    final Paint paint = Paint()
      ..color = isActive ? const Color(0xFFFFB703) : const Color(0x80FFB703)
      ..strokeWidth = isActive ? 2.2 : 1.2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(p.dx - 4, p.dy - 4), Offset(p.dx + 4, p.dy + 4), paint);
    canvas.drawLine(Offset(p.dx + 4, p.dy - 4), Offset(p.dx - 4, p.dy + 4), paint);
  }

  void _drawGrille(Canvas canvas, String id, Offset p) {
    final bool isActive = selectedId == id;
    final Paint paint = Paint()
      ..color = isActive ? const Color(0xFFFFB703) : const Color(0x80FFB703)
      ..strokeWidth = isActive ? 1.8 : 1.0
      ..style = PaintingStyle.stroke;

    for (double i = -4; i <= 4; i += 4) {
      canvas.drawLine(Offset(p.dx - 6, p.dy + i), Offset(p.dx + 6, p.dy + i), paint);
      canvas.drawLine(Offset(p.dx + i, p.dy - 6), Offset(p.dx + i, p.dy + 6), paint);
    }
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
