import 'package:flutter/material.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorStateWidget({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, color: Colors.red.shade300, size: 48),
          const SizedBox(height: 16),
          const Text('Oups, une erreur est survenue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          Text(message, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: onRetry, child: const Text('Réessayer')),
        ],
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, color: Colors.grey.shade400, size: 48),
          const SizedBox(height: 16),
          const Text('Aucun résultat', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          Text('Essayez d\'autres filtres.', style: TextStyle(color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}