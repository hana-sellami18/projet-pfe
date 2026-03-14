import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../data/models/sujet_model.dart';

const Color asmOrange     = Color(0xFFF28C28);
const Color asmOrangeDark = Color(0xFFE65100);

class SubjectDetailHeader extends StatelessWidget {
  final SujetModel sujet;
  final IconData domainIcon;

  const SubjectDetailHeader({
    super.key,
    required this.sujet,
    required this.domainIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF9800), asmOrangeDark],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BackButton(),
                  _AvailabilityBadge(estDisponible: sujet.estDisponible),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                sujet.titre,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  letterSpacing: -0.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SubjectHeroBadge(icon: domainIcon, label: sujet.filiereCible),
                  const SizedBox(width: 8),
                  SubjectHeroBadge(
                    icon: Icons.workspace_premium_rounded,
                    label: sujet.cycleCible,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Bouton retour ─────────────────────────────────────────────────
class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.maybePop(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: const Icon(Icons.arrow_back_rounded,
            color: Colors.white, size: 18),
      ),
    );
  }
}

// ── Badge disponibilité ───────────────────────────────────────────
class _AvailabilityBadge extends StatelessWidget {
  final bool estDisponible;
  const _AvailabilityBadge({required this.estDisponible});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: estDisponible
            ? Colors.white.withOpacity(0.2)
            : Colors.red.shade900.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: estDisponible
                  ? const Color(0xFF69F0AE)
                  : Colors.red.shade200,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (estDisponible
                      ? const Color(0xFF69F0AE)
                      : Colors.red)
                      .withOpacity(0.6),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            estDisponible ? 'DISPONIBLE' : 'COMPLET',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero badge ────────────────────────────────────────────────────
class SubjectHeroBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const SubjectHeroBadge({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}