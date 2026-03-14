import 'package:flutter/material.dart';
import '../../pages/upload_cv_page.dart' show asmOrange;

class UploadDropZone extends StatelessWidget {
  final Animation<double> pulseAnimation;
  final VoidCallback onTap;

  const UploadDropZone({
    super.key,
    required this.pulseAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: asmOrange.withOpacity(0.25),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Motif de points en arrière-plan
            Positioned.fill(
              child: CustomPaint(painter: _DotPatternPainter()),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: pulseAnimation,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: asmOrange.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: asmOrange.withOpacity(0.3), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: asmOrange.withOpacity(0.15),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.upload_file_rounded,
                        color: asmOrange,
                        size: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Appuyer pour sélectionner',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'PDF uniquement · 5 MB max',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: asmOrange.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: asmOrange.withOpacity(0.2)),
                    ),
                    child: const Text(
                      'Parcourir les fichiers →',
                      style: TextStyle(
                        color: asmOrange,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = asmOrange.withOpacity(0.06)
      ..style = PaintingStyle.fill;
    const spacing = 20.0;
    const radius = 1.5;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}