import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../core/routes/app_router.dart';

const Color asmOrange = Color(0xFFF57C00);

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    // Attendre 3 secondes
    await Future.delayed(const Duration(seconds: 3));

    // Naviguer vers la page de login
    if (mounted) {
      context.router.replace(const LoginRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo ASM
            Image.asset(
              "assets/images/logo_asm.png",
              height: 100,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),

            // Titre de l'application
            const Text(
              "Gestion de Stagiaires",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Sous-titre
            const Text(
              "ASM - Application de Suivi",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),

            // Indicateur de chargement orange
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(asmOrange),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}