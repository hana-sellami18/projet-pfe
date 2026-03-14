import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../pages/upload_cv_page.dart' show asmOrange;

/// Affiche le bottom sheet de succès après soumission de candidature.
void showUploadSuccessSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: false,
    isScrollControlled: true,
    builder: (_) => const _SuccessSheetContent(),
  );
}

class _SuccessSheetContent extends StatelessWidget {
  const _SuccessSheetContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 28),
          // Icône success avec rings
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6BCB77).withOpacity(0.06),
                ),
              ),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6BCB77).withOpacity(0.1),
                  border: Border.all(
                      color: const Color(0xFF6BCB77).withOpacity(0.25),
                      width: 2),
                ),
              ),
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF6BCB77),
                ),
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Candidature envoyée !',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Votre dossier est maintenant en attente.\nL'encadrant examinera votre candidature.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
              height: 1.6,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 24),
          // Timeline statut
          const UploadStatusTimeline(),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => context.router.popUntilRoot(),
              style: ElevatedButton.styleFrom(
                backgroundColor: asmOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Retour à l'accueil",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    fontFamily: 'Poppins'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UploadStatusTimeline extends StatelessWidget {
  const UploadStatusTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      ('Dépôt du CV', true, Icons.upload_file_rounded),
      ('En attente de validation', true, Icons.hourglass_top_rounded),
      ('Réponse encadrant', false, Icons.mark_email_unread_outlined),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: List.generate(steps.length, (i) {
          final (label, done, icon) = steps[i];
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: done
                          ? (i == 1
                          ? asmOrange.withOpacity(0.12)
                          : const Color(0xFF6BCB77).withOpacity(0.12))
                          : Colors.grey.shade100,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: done
                            ? (i == 1
                            ? asmOrange.withOpacity(0.4)
                            : const Color(0xFF6BCB77).withOpacity(0.4))
                            : Colors.grey.shade200,
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 14,
                      color: done
                          ? (i == 1 ? asmOrange : const Color(0xFF6BCB77))
                          : Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      color: done ? Colors.black87 : Colors.grey.shade400,
                      fontSize: 13,
                      fontWeight:
                      done ? FontWeight.w600 : FontWeight.w400,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const Spacer(),
                  if (done && i == 0)
                    _StatusBadge(
                        label: 'Fait', color: const Color(0xFF6BCB77)),
                  if (done && i == 1)
                    _StatusBadge(label: 'En cours', color: asmOrange),
                ],
              ),
              if (i < steps.length - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Container(
                        width: 2,
                        height: 18,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: i == 0
                              ? const Color(0xFF6BCB77).withOpacity(0.3)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}