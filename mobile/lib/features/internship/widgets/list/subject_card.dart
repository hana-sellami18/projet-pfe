import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../core/routes/app_router.dart';
import '../../data/models/sujet_model.dart';

class SubjectCard extends StatelessWidget {
  final SujetModel sujet;
  final int index;
  final Animation<double> animation;

  const SubjectCard({
    super.key,
    required this.sujet,
    required this.index,
    required this.animation,
  });

  static const _domainIcons = {
    'informatique': Icons.code_rounded,
    'génie civil': Icons.architecture_rounded,
    'électronique': Icons.electrical_services_rounded,
    'mécanique': Icons.settings_rounded,
    'gestion': Icons.bar_chart_rounded,
  };

  static const _accentColors = [
    Color(0xFFF28C28),
    Color(0xFF4ECDC4),
    Color(0xFF45B7D1),
    Color(0xFF6BCB77),
    Color(0xFFAB47BC),
  ];

  @override
  Widget build(BuildContext context) {
    final accent = _accentColors[index % _accentColors.length];
    final domainKey = sujet.filiereCible.toLowerCase();
    final icon = _domainIcons.entries
        .firstWhere((e) => domainKey.contains(e.key),
        orElse: () => const MapEntry('default', Icons.work_outline_rounded))
        .value;

    return FadeTransition(
      opacity: animation,
      child: Transform.translate(
        offset: Offset(0, 24 * (1 - animation.value)),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.router.push(SubjectDetailRoute(sujet: sujet)),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 14, offset: const Offset(0, 4)),
                ],
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTopRow(icon, accent),
                            const SizedBox(height: 10),
                            Divider(height: 1, color: Colors.grey.shade100),
                            const SizedBox(height: 10),
                            _buildDescription(),
                            if (sujet.competencesCibles.isNotEmpty) _buildSkills(),
                            const SizedBox(height: 10),
                            _buildFooter(accent),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow(IconData icon, Color accent) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44, height: 44,
          decoration: BoxDecoration(color: accent.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: accent, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(sujet.titre,
                        style: const TextStyle(color: Color(0xFF1A2340), fontSize: 14, fontWeight: FontWeight.w700),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                  _StatusIndicator(isAvailable: sujet.estDisponible),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  _MiniTag(label: sujet.filiereCible, color: accent),
                  const SizedBox(width: 6),
                  _MiniTag(label: sujet.cycleCible, color: Colors.grey.shade400, isOutline: true),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(sujet.description,
        style: TextStyle(color: Colors.grey.shade600, fontSize: 12, height: 1.55),
        maxLines: 2, overflow: TextOverflow.ellipsis);
  }

  Widget _buildSkills() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Wrap(
        spacing: 6, runSpacing: 6,
        children: sujet.competencesCibles.take(3).map((c) => _SkillChip(label: c)).toList(),
      ),
    );
  }

  Widget _buildFooter(Color accent) {
    return Row(
      children: [
        Icon(Icons.schedule_rounded, size: 12, color: Colors.grey.shade400),
        const SizedBox(width: 4),
        Text(_formatDate(sujet.datePublication), style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
        const Spacer(),
        _DetailButton(accent: accent),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date).inDays;
    if (diff == 0) return "Aujourd'hui";
    if (diff == 1) return "Hier";
    return "Il y a $diff jours";
  }
}

// --- Petits sous-widgets de la carte ---

class _StatusIndicator extends StatelessWidget {
  final bool isAvailable;
  const _StatusIndicator({required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      width: 8, height: 8,
      decoration: BoxDecoration(
        color: isAvailable ? const Color(0xFF4CAF50) : Colors.grey.shade300,
        shape: BoxShape.circle,
        boxShadow: isAvailable ? [BoxShadow(color: const Color(0xFF4CAF50).withOpacity(0.4), blurRadius: 6)] : null,
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String label;
  final Color color;
  final bool isOutline;
  const _MiniTag({required this.label, required this.color, this.isOutline = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(isOutline ? 0.4 : 0.2)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700)),
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.grey.shade200)),
    child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.w500)),
  );
}

class _DetailButton extends StatelessWidget {
  final Color accent;
  const _DetailButton({required this.accent});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: accent.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: accent.withOpacity(0.25))),
    child: Row(children: [
      Text('Voir le détail', style: TextStyle(color: accent, fontSize: 11, fontWeight: FontWeight.w600)),
      const SizedBox(width: 3),
      Icon(Icons.arrow_forward_rounded, size: 11, color: accent),
    ]),
  );
}