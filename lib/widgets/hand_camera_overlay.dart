import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Minimal & Modern Hand Camera Overlay & Alignment Guide for Palm Scanning
class HandCameraOverlay extends StatefulWidget {
  final bool isLeftHand;
  final bool isScanning;
  final double scanProgress;

  const HandCameraOverlay({
    Key? key,
    this.isLeftHand = false,
    this.isScanning = false,
    this.scanProgress = 0.0,
  }) : super(key: key);

  @override
  State<HandCameraOverlay> createState() => _HandCameraOverlayState();
}

class _HandCameraOverlayState extends State<HandCameraOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return CustomPaint(
          painter: _HandOverlayPainter(
            isLeftHand: widget.isLeftHand,
            isScanning: widget.isScanning,
            scanProgress: widget.scanProgress,
            pulseValue: _pulseController.value,
          ),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class _HandOverlayPainter extends CustomPainter {
  final bool isLeftHand;
  final bool isScanning;
  final double scanProgress;
  final double pulseValue;

  _HandOverlayPainter({
    required this.isLeftHand,
    required this.isScanning,
    required this.scanProgress,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final Offset center = Offset(width / 2, height / 2);

    // 1. Draw Subtle Darkened Outer Vignette Overlay
    final Path framePath = Path()..addRect(Rect.fromLTWH(0, 0, width, height));
    final double cropW = min(width * 0.82, 340.0);
    final double cropH = min(height * 0.72, 480.0);
    final Rect cropRect = Rect.fromCenter(center: center, width: cropW, height: cropH);
    final RRect cropRRect = RRect.fromRectAndRadius(cropRect, const Radius.circular(24));
    final Path cutPath = Path()..addRRect(cropRRect);
    final Path vignettePath = Path.combine(PathOperation.difference, framePath, cutPath);

    canvas.drawPath(
      vignettePath,
      Paint()..color = Colors.black.withOpacity(0.55),
    );

    // 2. Draw Corner Target Brackets [  ]
    final double bracketSize = 28.0;
    final double bracketStroke = 3.0;
    final Paint bracketPaint = Paint()
      ..color = isScanning ? AppColors.neonElectricBlue : AppColors.primaryPurple.withOpacity(0.85 + pulseValue * 0.15)
      ..strokeWidth = bracketStroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final RRect rrect = cropRRect;
    // Top-Left corner
    canvas.drawPath(
      Path()
        ..moveTo(rrect.left, rrect.top + bracketSize)
        ..lineTo(rrect.left, rrect.top + 12)
        ..arcToPoint(Offset(rrect.left + 12, rrect.top), radius: const Radius.circular(12))
        ..lineTo(rrect.left + bracketSize, rrect.top),
      bracketPaint,
    );
    // Top-Right corner
    canvas.drawPath(
      Path()
        ..moveTo(rrect.right - bracketSize, rrect.top)
        ..lineTo(rrect.right - 12, rrect.top)
        ..arcToPoint(Offset(rrect.right, rrect.top + 12), radius: const Radius.circular(12))
        ..lineTo(rrect.right, rrect.top + bracketSize),
      bracketPaint,
    );
    // Bottom-Left corner
    canvas.drawPath(
      Path()
        ..moveTo(rrect.left, rrect.bottom - bracketSize)
        ..lineTo(rrect.left, rrect.bottom - 12)
        ..arcToPoint(Offset(rrect.left + 12, rrect.bottom), radius: const Radius.circular(12))
        ..lineTo(rrect.left + bracketSize, rrect.bottom),
      bracketPaint,
    );
    // Bottom-Right corner
    canvas.drawPath(
      Path()
        ..moveTo(rrect.right - bracketSize, rrect.bottom)
        ..lineTo(rrect.right - 12, rrect.bottom)
        ..arcToPoint(Offset(rrect.right, rrect.bottom - 12), radius: const Radius.circular(12))
        ..lineTo(rrect.right, rrect.bottom - bracketSize),
      bracketPaint,
    );

    // 3. Render Hand Template Outline Vector
    canvas.save();
    canvas.translate(center.dx, center.dy);
    if (isLeftHand) {
      canvas.scale(-1.0, 1.0); // Flip horizontally for Left Hand template
    }

    final double scale = cropW / 360.0;
    canvas.scale(scale, scale);
    canvas.translate(-180.0, -250.0);

    // Draw Hand Outer Silhouette Dashed Glow
    final Path handOutline = _createHandSilhouettePath();
    final Paint outlinePaint = Paint()
      ..color = isScanning 
          ? AppColors.neonElectricBlue.withOpacity(0.4 + pulseValue * 0.3)
          : AppColors.primaryIndigo.withOpacity(0.35 + pulseValue * 0.25)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    final Paint fillPaint = Paint()
      ..color = AppColors.primaryIndigo.withOpacity(0.04 + pulseValue * 0.03)
      ..style = PaintingStyle.fill;

    canvas.drawPath(handOutline, fillPaint);
    canvas.drawPath(handOutline, outlinePaint);

    // Draw Major Lines Overlay Guide (Heart, Head, Life)
    _drawGuideLines(canvas, pulseValue, isScanning);

    canvas.restore();

    // 4. Laser Scanning Line Animation (When in AI Scanning Mode)
    if (isScanning) {
      final double scanY = cropRect.top + (cropH * scanProgress.clamp(0.0, 1.0));
      
      // Laser line glowing background
      final Paint laserGlowPaint = Paint()
        ..color = AppColors.neonElectricBlue.withOpacity(0.4)
        ..strokeWidth = 6.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6.0);
      canvas.drawLine(Offset(cropRect.left + 8, scanY), Offset(cropRect.right - 8, scanY), laserGlowPaint);

      // Laser line sharp core
      final Paint laserCorePaint = Paint()
        ..color = AppColors.neonElectricBlue
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(cropRect.left + 12, scanY), Offset(cropRect.right - 12, scanY), laserCorePaint);

      // Scanning gradient shadow beam
      final Rect beamRect = Rect.fromLTRB(cropRect.left, scanY - 35, cropRect.right, scanY);
      final Paint beamPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.neonElectricBlue.withOpacity(0.0),
            AppColors.neonElectricBlue.withOpacity(0.18),
          ],
        ).createShader(beamRect);
      canvas.drawRect(beamRect, beamPaint);
    }
  }

  Path _createHandSilhouettePath() {
    final Path path = Path();
    // Simplified smooth open palm outline matching 360x500 space
    path.moveTo(140, 440); // Wrist Base Left
    path.cubicTo(130, 410, 110, 360, 100, 320); // Moon Mount Edge
    path.cubicTo(90, 280, 80, 240, 75, 210);   // Mercury Finger Base
    path.cubicTo(70, 160, 80, 115, 92, 115);   // Pinky Finger Tip
    path.cubicTo(104, 115, 108, 160, 115, 190); // Pinky Inner
    path.cubicTo(116, 140, 125, 60, 138, 60);   // Ring Finger Tip
    path.cubicTo(148, 60, 153, 140, 158, 180);  // Ring Inner
    path.cubicTo(160, 110, 170, 35, 182, 35);   // Middle Finger Tip
    path.cubicTo(194, 35, 200, 110, 205, 180);  // Middle Inner
    path.cubicTo(208, 130, 215, 60, 228, 60);   // Index Finger Tip
    path.cubicTo(240, 60, 246, 130, 248, 185);  // Index Inner
    path.cubicTo(255, 220, 260, 240, 265, 250);  // Thumb Base
    path.cubicTo(280, 220, 305, 170, 315, 170);  // Thumb Tip
    path.cubicTo(325, 170, 315, 230, 290, 300);  // Thumb Outer Edge
    path.cubicTo(270, 350, 250, 400, 230, 440);  // Wrist Base Right
    path.close();
    return path;
  }

  void _drawGuideLines(Canvas canvas, double pulse, bool scanning) {
    final Paint linePaint = Paint()
      ..color = scanning 
          ? AppColors.neonElectricBlue.withOpacity(0.65)
          : AppColors.neonPurple.withOpacity(0.45 + pulse * 0.2)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Heart Line Guide Curve
    final Path heartLine = Path()
      ..moveTo(95, 260)
      ..cubicTo(130, 250, 160, 235, 195, 220);
    canvas.drawPath(heartLine, linePaint);

    // Head Line Guide Curve
    final Path headLine = Path()
      ..moveTo(230, 225)
      ..cubicTo(190, 240, 165, 260, 140, 280);
    canvas.drawPath(headLine, linePaint);

    // Life Line Guide Curve
    final Path lifeLine = Path()
      ..moveTo(245, 230)
      ..cubicTo(200, 250, 185, 285, 185, 330);
    canvas.drawPath(lifeLine, linePaint);
  }

  @override
  bool shouldRepaint(covariant _HandOverlayPainter oldDelegate) {
    return oldDelegate.isLeftHand != isLeftHand ||
        oldDelegate.isScanning != isScanning ||
        oldDelegate.scanProgress != scanProgress ||
        oldDelegate.pulseValue != pulseValue;
  }
}
