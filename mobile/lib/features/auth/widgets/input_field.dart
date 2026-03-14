import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;
  final TextEditingController? controller;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? errorText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  const InputField({
    super.key,
    required this.icon,
    required this.hint,
    this.obscure = false,
    this.controller,
    this.readOnly = false,
    this.onTap,
    this.errorText,
    this.keyboardType,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    // La couleur orange est conservée ici au cas où vous en auriez besoin ailleurs,
    // mais elle n'est plus appliquée à l'icône de gauche.
    const Color asmOrange = Color(0xFFF57C00);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: errorText != null ? Colors.red : Colors.grey.shade300,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              // Modification ici : l'icône est maintenant grise
              prefixIcon: Icon(icon, color: Colors.grey),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 4),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}