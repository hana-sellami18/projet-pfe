import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../core/routes/app_router.dart';
import '../../data/models/sujet_model.dart';

const Color asmOrange = Color(0xFFF28C28);

class SubjectApplyButton extends StatelessWidget {
  final SujetModel sujet;
  const SubjectApplyButton({super.key, required this.sujet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!sujet.estDisponible) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 14, color: Colors.red.shade400),
                  const SizedBox(width: 6),
                  Text(
                    "Ce sujet n'accepte plus de candidatures",
                    style: TextStyle(
                        color: Colors.red.shade400, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: sujet.estDisponible
                  ? () => context.router
                  .push(UploadCvRoute(sujetId: sujet.id))
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: asmOrange,
                disabledBackgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    sujet.estDisponible
                        ? Icons.send_rounded
                        : Icons.block_rounded,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    sujet.estDisponible
                        ? 'Postuler à ce sujet'
                        : 'Sujet complet',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}