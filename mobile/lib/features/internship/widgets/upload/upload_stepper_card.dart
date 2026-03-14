import 'package:flutter/material.dart';
import '../../pages/upload_cv_page.dart' show asmOrange;

class UploadStepperCard extends StatelessWidget {
  const UploadStepperCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          UploadStep(
              label: 'Sujet', stepNumber: '1', done: true, active: false),
          UploadStepLine(done: true),
          UploadStep(
              label: 'Détails', stepNumber: '2', done: true, active: false),
          UploadStepLine(done: true),
          UploadStep(
              label: 'CV', stepNumber: '3', done: false, active: true),
        ],
      ),
    );
  }
}

class UploadStep extends StatelessWidget {
  final String label;
  final String stepNumber;
  final bool done;
  final bool active;

  const UploadStep({
    super.key,
    required this.label,
    required this.stepNumber,
    required this.done,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final color = done
        ? const Color(0xFF6BCB77)
        : active
        ? asmOrange
        : Colors.grey.shade300;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1.5),
          ),
          child: Center(
            child: done
                ? Icon(Icons.check_rounded, size: 15, color: color)
                : Text(
              stepNumber,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

class UploadStepLine extends StatelessWidget {
  final bool done;

  const UploadStepLine({super.key, required this.done});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20, left: 4, right: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          color: done ? const Color(0xFF6BCB77) : Colors.grey.shade200,
        ),
      ),
    );
  }
}