import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import '../data/models/sujet_model.dart';
import '../widgets/detail/Section_card.dart';
import '../widgets/detail/Skill_tag.dart';
import '../widgets/detail/Subject_apply_button.dart';
import '../widgets/detail/Subject_detail_header.dart';
import '../widgets/detail/Subject_info_card.dart';

const Color asmOrange = Color(0xFFF28C28);

@RoutePage()
class SubjectDetailPage extends StatelessWidget {
  final SujetModel sujet;
  const SubjectDetailPage({super.key, required this.sujet});

  static const _domainIcons = {
    'informatique': Icons.code_rounded,
    'génie civil': Icons.architecture_rounded,
    'électronique': Icons.electrical_services_rounded,
    'mécanique': Icons.settings_rounded,
    'gestion': Icons.bar_chart_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final domainKey = sujet.filiereCible.toLowerCase();
    final icon = _domainIcons.entries
        .firstWhere(
          (e) => domainKey.contains(e.key),
      orElse: () => const MapEntry('default', Icons.work_outline_rounded),
    )
        .value;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Column(
        children: [
          SubjectDetailHeader(sujet: sujet, domainIcon: icon),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  SubjectInfoCard(sujet: sujet),
                  const SizedBox(height: 16),
                  SectionCard(
                    title: 'Description',
                    icon: Icons.description_outlined,
                    child: Text(
                      sujet.description,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                        height: 1.75,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (sujet.competencesCibles.isNotEmpty) ...[
                    SectionCard(
                      title: 'Compétences requises',
                      icon: Icons.psychology_outlined,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: sujet.competencesCibles
                            .map((c) => SkillTag(label: c))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _PublicationDate(date: sujet.datePublication),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SubjectApplyButton(sujet: sujet),
    );
  }
}

// ── Date de publication ───────────────────────────────────────────
class _PublicationDate extends StatelessWidget {
  final DateTime date;
  const _PublicationDate({required this.date});

  String _formatDate(DateTime d) {
    const months = [
      'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
      'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: asmOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.calendar_today_rounded,
                size: 14, color: asmOrange),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date de publication',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
              ),
              Text(
                _formatDate(date),
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}