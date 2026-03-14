import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/routes/app_router.dart';
import '../logic/auth_bloc.dart';
import '../logic/auth_state.dart';
import '../widgets/profile/profile_header.dart';
import '../widgets/profile/profile_info_card.dart';
import '../widgets/profile/profile_logout_button.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _storage = const FlutterSecureStorage();

  String _email      = '';
  String _nomComplet = '';
  String _filiere    = '';
  String _cycle      = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final email      = await _storage.read(key: 'email')      ?? '';
    final nomComplet = await _storage.read(key: 'nomComplet') ?? '';
    final filiere    = await _storage.read(key: 'filiere')    ?? '';
    final cycle      = await _storage.read(key: 'cycle')      ?? '';
    if (mounted) {
      setState(() {
        _email      = email;
        _nomComplet = nomComplet;
        _filiere    = filiere;
        _cycle      = cycle;
      });
    }
  }

  String get _initiales {
    final parts = _nomComplet.trim().split(' ');
    if (parts.isEmpty || _nomComplet.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  String get _nomAffiche =>
      _nomComplet.isNotEmpty ? _nomComplet.toUpperCase() : 'STAGIAIRE';

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.router.replaceAll([const LoginRoute()]);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        body: Column(
          children: [
            // ── Header ────────────────────────────────────────
            ProfileHeader(
              initiales: _initiales,
              nomAffiche: _nomAffiche,
              email: _email,
            ),

            // ── Contenu ──────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Carte infos
                    ProfileInfoCard(
                      nomAffiche: _nomAffiche,
                      email: _email,
                      filiere: _filiere,
                      cycle: _cycle,
                    ),

                    const SizedBox(height: 24),

                    // Bouton déconnexion
                    const ProfileLogoutButton(),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}