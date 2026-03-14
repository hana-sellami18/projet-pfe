import 'package:flutter/material.dart';

const Color asmOrange = Color(0xFFF28C28);

class ProfileInfoCard extends StatelessWidget {
  final String nomAffiche;
  final String email;
  final String filiere;
  final String cycle;

  const ProfileInfoCard({
    super.key,
    required this.nomAffiche,
    required this.email,
    required this.filiere,
    required this.cycle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          ProfileInfoRow(
            icon: Icons.person_rounded,
            iconBg: Colors.blue.shade50,
            iconColor: Colors.blue.shade400,
            label: 'Nom complet',
            value: nomAffiche,
          ),
          ProfileInfoRow(
            icon: Icons.email_rounded,
            iconBg: Colors.teal.shade50,
            iconColor: Colors.teal.shade400,
            label: 'Email',
            value: email.isNotEmpty ? email : '—',
          ),
          ProfileInfoRow(
            icon: Icons.account_tree_rounded,
            iconBg: Colors.orange.shade50,
            iconColor: asmOrange,
            label: 'Filière',
            value: filiere.isNotEmpty ? filiere : '—',
          ),
          ProfileInfoRow(
            icon: Icons.workspace_premium_rounded,
            iconBg: Colors.purple.shade50,
            iconColor: Colors.purple.shade400,
            label: 'Cycle',
            value: cycle.isNotEmpty ? cycle : '—',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final bool isLast;

  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 11)),
                    const SizedBox(height: 3),
                    Text(value,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
              height: 1,
              color: Colors.grey.shade100,
              indent: 16,
              endIndent: 16),
      ],
    );
  }
}