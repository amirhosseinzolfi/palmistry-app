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
  InteractiveZone(id: "mount-jupiter", name: "برجستگی مشتری", center: Offset(132, 220), radius: 18),
  InteractiveZone(id: "mount-saturn", name: "برجستگی زحل", center: Offset(168, 220), radius: 18),
  InteractiveZone(id: "mount-apollo", name: "برجستگی خورشید", center: Offset(205, 220), radius: 18),
  InteractiveZone(id: "mount-mercury", name: "برجستگی عطارد", center: Offset(250, 235), radius: 18),
  InteractiveZone(id: "mount-mars-lower", name: "برجستگی مریخ پایین", center: Offset(135, 280), radius: 15),
  InteractiveZone(id: "mount-mars-upper", name: "برجستگی مریخ بالا", center: Offset(270, 290), radius: 15),
  InteractiveZone(id: "mount-mars-plain", name: "دشت مریخ", center: Offset(195, 305), radius: 22),
  InteractiveZone(id: "mount-venus", name: "برجستگی ونوس", center: Offset(125, 365), radius: 32),
  InteractiveZone(id: "mount-moon", name: "برجستگی ماه", center: Offset(260, 380), radius: 30),

  // Major Lines
  InteractiveZone(id: "line-heart", name: "خط قلب", points: [
    Offset(280, 230), Offset(240, 190), Offset(190, 180), Offset(140, 180)
  ]),
  InteractiveZone(id: "line-head", name: "خط سر / ذهن", points: [
    Offset(120, 230), Offset(160, 225), Offset(220, 240), Offset(275, 285)
  ]),
  InteractiveZone(id: "line-life", name: "خط زندگی", points: [
    Offset(120, 230), Offset(145, 280), Offset(130, 385), Offset(175, 450)
  ]),
  InteractiveZone(id: "line-fate", name: "خط سرنوشت", points: [
    Offset(200, 455), Offset(195, 380), Offset(185, 295), Offset(178, 215)
  ]),

  // Minor Lines
  InteractiveZone(id: "line-sun", name: "خط خورشید", points: [
    Offset(208, 225), Offset(208, 270), Offset(208, 320)
  ]),
  InteractiveZone(id: "line-mercury", name: "خط سلامت", points: [
    Offset(205, 420), Offset(225, 365), Offset(245, 305), Offset(255, 240)
  ]),
  InteractiveZone(id: "line-marriage", name: "خط ازدواج", points: [
    Offset(270, 205), Offset(285, 205)
  ]),
  InteractiveZone(id: "line-girdle-venus", name: "کمربند ونوس", points: [
    Offset(135, 190), Offset(160, 150), Offset(210, 150), Offset(245, 190)
  ]),
  InteractiveZone(id: "line-intuition", name: "خط شهود", points: [
    Offset(270, 365), Offset(230, 330), Offset(235, 285), Offset(255, 250)
  ]),
  InteractiveZone(id: "line-mars", name: "خط مریخ", points: [
    Offset(128, 250), Offset(135, 285), Offset(132, 345), Offset(148, 395)
  ]),
  InteractiveZone(id: "line-travel", name: "خطوط سفر", points: [
    Offset(270, 385), Offset(290, 385),
    Offset(265, 400), Offset(285, 400)
  ]),
  InteractiveZone(id: "line-bracelets", name: "دستبندهای مچ", points: [
    Offset(158, 458), Offset(190, 463), Offset(220, 463), Offset(238, 458)
  ]),

  // Special Rings
  InteractiveZone(id: "ring-solomon", name: "حلقه سلیمان", points: [
    Offset(132, 210)
  ]),
  InteractiveZone(id: "ring-saturn", name: "حلقه زحل", points: [
    Offset(168, 210)
  ]),
  InteractiveZone(id: "ring-apollo", name: "حلقه خورشید", points: [
    Offset(205, 210)
  ]),
  InteractiveZone(id: "ring-mercury", name: "حلقه عطارد", points: [
    Offset(250, 222)
  ]),

  // Symbols
  InteractiveZone(id: "symbol-star", name: "ستاره", center: Offset(132, 205), radius: 10),
  InteractiveZone(id: "symbol-square", name: "مربع", center: Offset(130, 345), radius: 10),
  InteractiveZone(id: "symbol-triangle", name: "مثلث", center: Offset(205, 235), radius: 10),
  InteractiveZone(id: "symbol-island", name: "جزیره", center: Offset(195, 240), radius: 10),
  InteractiveZone(id: "symbol-cross", name: "صلیب", center: Offset(195, 305), radius: 10),
  InteractiveZone(id: "symbol-grille", name: "شبکه", center: Offset(250, 350), radius: 12),
  
  // Fingers
  InteractiveZone(id: "finger-thumb", name: "انگشت شست", center: Offset(65, 255), radius: 25),
  InteractiveZone(id: "finger-jupiter", name: "انگشت اشاره", center: Offset(125, 120), radius: 20),
  InteractiveZone(id: "finger-saturn", name: "انگشت میانی", center: Offset(165, 100), radius: 20),
  InteractiveZone(id: "finger-apollo", name: "انگشت حلقه", center: Offset(205, 110), radius: 20),
  InteractiveZone(id: "finger-mercury", name: "انگشت کوچک", center: Offset(250, 150), radius: 18),
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

        final double offsetX = (width - 360 * scale) / 2;
        final double offsetY = (height - 500 * scale) / 2;

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
          child: CustomPaint(
            size: Size(width, height),
            painter: HandPainter(
              scale: scale,
              offsetX: offsetX,
              offsetY: offsetY,
              selectedId: selectedId,
              activeFilter: activeFilter,
            ),
          ),
        );
      },
    );
  }
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

    // Modern glowing hand styles
    final Paint handOutlinePaint = Paint()
      ..color = const Color(0xFF6366F1).withOpacity(0.8) // Glowing Indigo outline
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    final Paint handGlowPaint = Paint()
      ..color = const Color(0xFF6366F1).withOpacity(0.25) // Deep Indigo edge glow
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    final Paint handFillPaint = Paint()
      ..color = const Color(0xFF101326).withOpacity(0.65) // Translucent cosmic card fill
      ..style = PaintingStyle.fill;

    // Outer Hand Shape Path
    final Path handPath = Path()
      ..moveTo(150, 460)
      ..cubicTo(110, 460, 80, 420, 80, 370)
      ..cubicTo(80, 330, 50, 300, 35, 260)
      ..cubicTo(20, 220, 50, 200, 75, 225)
      ..cubicTo(95, 245, 110, 255, 120, 220)
      ..cubicTo(120, 180, 105, 120, 110, 85)
      ..cubicTo(112, 65, 138, 65, 140, 85)
      ..cubicTo(145, 120, 145, 180, 148, 205)
      ..cubicTo(148, 180, 152, 90, 156, 55)
      ..cubicTo(158, 35, 182, 35, 184, 55)
      ..cubicTo(188, 90, 188, 180, 192, 205)
      ..cubicTo(192, 180, 196, 100, 200, 75)
      ..cubicTo(202, 55, 226, 55, 228, 75)
      ..cubicTo(232, 100, 232, 185, 236, 210)
      ..cubicTo(236, 185, 240, 135, 245, 110)
      ..cubicTo(247, 90, 268, 90, 270, 110)
      ..cubicTo(273, 135, 273, 200, 278, 230)
      ..cubicTo(295, 265, 305, 320, 305, 370)
      ..cubicTo(305, 420, 275, 460, 240, 460)
      ..close();

    // Draw hand body
    canvas.drawPath(handPath, handFillPaint);
    canvas.drawPath(handPath, handGlowPaint);
    canvas.drawPath(handPath, handOutlinePaint);

    // Render highlighted Finger Zones (Only when showing all or fingers)
    if ((activeFilter == "all" || activeFilter == "fingers") && selectedId != null && selectedId!.startsWith("finger-")) {
      final Paint fingerHighlightPaint = Paint()
        ..color = const Color(0xFF6366F1).withOpacity(0.2)
        ..style = PaintingStyle.fill;
      
      final Path fingerPath = Path();
      if (selectedId == "finger-thumb") {
        fingerPath.moveTo(80, 370);
        fingerPath.cubicTo(80, 330, 50, 300, 35, 260);
        fingerPath.cubicTo(20, 220, 50, 200, 75, 225);
        fingerPath.cubicTo(95, 245, 110, 255, 120, 220);
        fingerPath.cubicTo(110, 255, 95, 290, 95, 330);
        fingerPath.close();
      } else if (selectedId == "finger-jupiter") {
        fingerPath.moveTo(120, 220);
        fingerPath.cubicTo(120, 180, 105, 120, 110, 85);
        fingerPath.cubicTo(112, 65, 138, 65, 140, 85);
        fingerPath.cubicTo(145, 120, 145, 180, 148, 205);
        fingerPath.close();
      } else if (selectedId == "finger-saturn") {
        fingerPath.moveTo(148, 205);
        fingerPath.cubicTo(148, 180, 152, 90, 156, 55);
        fingerPath.cubicTo(158, 35, 182, 35, 184, 55);
        fingerPath.cubicTo(188, 90, 188, 180, 192, 205);
        fingerPath.close();
      } else if (selectedId == "finger-apollo") {
        fingerPath.moveTo(192, 205);
        fingerPath.cubicTo(192, 180, 196, 100, 200, 75);
        fingerPath.cubicTo(202, 55, 226, 55, 228, 75);
        fingerPath.cubicTo(232, 100, 232, 185, 236, 210);
        fingerPath.close();
      } else if (selectedId == "finger-mercury") {
        fingerPath.moveTo(236, 210);
        fingerPath.cubicTo(236, 185, 240, 135, 245, 110);
        fingerPath.cubicTo(247, 90, 268, 90, 270, 110);
        fingerPath.cubicTo(273, 135, 273, 200, 278, 230);
        fingerPath.close();
      }
      canvas.drawPath(fingerPath, fingerHighlightPaint);
    }

    // Render Mounts (Only when showing all or mounts)
    if (activeFilter == "all" || activeFilter == "mounts") {
      _drawMount(canvas, "mount-jupiter", const Offset(132, 220), 18, "مشتری");
      _drawMount(canvas, "mount-saturn", const Offset(168, 220), 18, "زحل");
      _drawMount(canvas, "mount-apollo", const Offset(205, 220), 18, "خورشید");
      _drawMount(canvas, "mount-mercury", const Offset(250, 235), 18, "عطارد");
      _drawMount(canvas, "mount-mars-lower", const Offset(135, 280), 15, "مریخ 🡫");
      _drawMount(canvas, "mount-mars-upper", const Offset(270, 290), 15, "مریخ 🡩");
      _drawMount(canvas, "mount-mars-plain", const Offset(195, 305), 22, "دشت مریخ");
      _drawMount(canvas, "mount-venus", const Offset(125, 365), 32, "ونوس");
      _drawMount(canvas, "mount-moon", const Offset(260, 380), 30, "ماه");
    }

    // Render Lines & Rings (Only when showing all or lines)
    if (activeFilter == "all" || activeFilter == "lines") {
      // Heart Line (Neon Cyan Glow)
      final Path heartLine = Path()
        ..moveTo(280, 230)
        ..cubicTo(240, 190, 190, 180, 140, 180);
      _drawLine(canvas, "line-heart", heartLine, const Color(0xFF00F2FE), 3.0);

      // Head Line (Neon Cyan Glow)
      final Path headLine = Path()
        ..moveTo(120, 230)
        ..cubicTo(160, 225, 220, 240, 275, 285);
      _drawLine(canvas, "line-head", headLine, const Color(0xFF00F2FE), 3.0);

      // Life Line (Neon Cyan Glow)
      final Path lifeLine = Path()
        ..moveTo(120, 230)
        ..cubicTo(145, 280, 130, 385, 175, 450);
      _drawLine(canvas, "line-life", lifeLine, const Color(0xFF00F2FE), 3.0);

      // Fate Line (Neon Cyan Glow)
      final Path fateLine = Path()
        ..moveTo(200, 455)
        ..cubicTo(195, 380, 185, 295, 178, 215);
      _drawLine(canvas, "line-fate", fateLine, const Color(0xFF00F2FE), 3.0);

      // Sun Line (Indigo Glow)
      final Path sunLine = Path()
        ..moveTo(208, 225)
        ..lineTo(208, 320);
      _drawLine(canvas, "line-sun", sunLine, const Color(0xFF6366F1), 2.0);

      // Health Line (Indigo Glow)
      final Path healthLine = Path()
        ..moveTo(205, 420)
        ..cubicTo(225, 365, 245, 305, 255, 240);
      _drawLine(canvas, "line-mercury", healthLine, const Color(0xFF6366F1), 2.0);

      // Marriage Line (Indigo Glow)
      final Path marriageLine = Path()
        ..moveTo(270, 205)
        ..lineTo(285, 205);
      _drawLine(canvas, "line-marriage", marriageLine, const Color(0xFF6366F1), 2.0);

      // Girdle of Venus
      final Path girdleVenus = Path()
        ..moveTo(135, 190)
        ..cubicTo(160, 150, 210, 150, 245, 190);
      _drawLine(canvas, "line-girdle-venus", girdleVenus, const Color(0xFF6366F1), 2.0);

      // Intuition Line
      final Path intuitionLine = Path()
        ..moveTo(270, 365)
        ..cubicTo(230, 330, 235, 285, 255, 250);
      _drawLine(canvas, "line-intuition", intuitionLine, const Color(0xFF6366F1), 2.0);

      // Mars Line
      final Path marsLine = Path()
        ..moveTo(128, 250)
        ..cubicTo(135, 285, 132, 345, 148, 395);
      _drawLine(canvas, "line-mars", marsLine, const Color(0xFF6366F1), 1.5);

      // Travel Lines
      final Path travel1 = Path()..moveTo(270, 385)..lineTo(290, 385);
      final Path travel2 = Path()..moveTo(265, 400)..lineTo(285, 400);
      _drawLine(canvas, "line-travel", travel1, const Color(0xFF6366F1), 1.8);
      _drawLine(canvas, "line-travel", travel2, const Color(0xFF6366F1), 1.8);

      // Bracelets
      final Path b1 = Path()..moveTo(158, 458)..cubicTo(190, 463, 220, 463, 238, 458);
      final Path b2 = Path()..moveTo(156, 464)..cubicTo(190, 469, 220, 469, 240, 464);
      final Path b3 = Path()..moveTo(154, 470)..cubicTo(190, 475, 220, 475, 242, 470);
      _drawLine(canvas, "line-bracelets", b1, const Color(0xFF6366F1), 1.5);
      _drawLine(canvas, "line-bracelets", b2, const Color(0xFF6366F1), 1.5);
      _drawLine(canvas, "line-bracelets", b3, const Color(0xFF6366F1), 1.5);

      // Rings (Solomon, Saturn, Apollo, Mercury)
      _drawRing(canvas, "ring-solomon", const Offset(132, 210), 15);
      _drawRing(canvas, "ring-saturn", const Offset(168, 210), 18);
      _drawRing(canvas, "ring-apollo", const Offset(205, 210), 18);
      _drawRing(canvas, "ring-mercury", const Offset(250, 222), 18);
    }

    // Render Symbols (Only when showing all or symbols)
    if (activeFilter == "all" || activeFilter == "symbols") {
      _drawStar(canvas, "symbol-star", const Offset(132, 205));
      _drawSquare(canvas, "symbol-square", const Offset(130, 345));
      _drawTriangle(canvas, "symbol-triangle", const Offset(205, 235));
      _drawIsland(canvas, "symbol-island", const Offset(195, 240));
      _drawCross(canvas, "symbol-cross", const Offset(195, 305));
      _drawGrille(canvas, "symbol-grille", const Offset(250, 350));
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
