import 'package:flutter/material.dart';
import '../../data/models/sujet_model.dart';

const Color asmOrange = Color(0xFFF28C28);

class SubjectInfoCard extends StatelessWidget {
  final SujetModel sujet;
  const SubjectInfoCard({super.key, required this.sujet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          _InfoItem(
            icon: Icons.school_rounded,
            label: 'Filière',
            value: sujet.filiereCible,
            color: asmOrange,
          ),
          _VertDivider(),
          _InfoItem(
            icon: Icons.workspace_premium_rounded,
            label: 'Cycle',
            value: sujet.cycleCible,
            color: const Color(0xFF4ECDC4),
          ),
          _VertDivider(),
          _InfoItem(
            icon: sujet.estDisponible
                ? Icons.check_circle_outline_rounded
                : Icons.cancel_outlined,
            label: 'Statut',
            value: sujet.estDisponible ? 'Ouvert' : 'Fermé',
            color: sujet.estDisponible
                ? const Color(0xFF4CAF50)
                : Colors.red.shade400,
          ),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.grey.shade100,
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}