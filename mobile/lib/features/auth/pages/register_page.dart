import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../core/routes/app_router.dart';
import '../../../core/di/injection.dart'; // Pour sl<AuthRepository>()
import '../data/models/user_model.dart';
import '../data/models/reference_model.dart';
import '../data/repositories/auth_repository.dart';
import '../logic/auth_bloc.dart';
import '../logic/auth_event.dart';
import '../logic/auth_state.dart';

// Import de tes widgets séparés
import '../widgets/input_field.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/role_item.dart';

const Color asmOrange = Color(0xFFF57C00);

@RoutePage()
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String selectedRole = "RH";

  final TextEditingController nomController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  final TextEditingController dateNaissanceController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController etablissementController = TextEditingController();

  // ✅ Listes dynamiques d'objets ReferenceModel
  List<ReferenceModel> _filieres = [];
  List<ReferenceModel> _cycles = [];

  // ✅ On stocke l'objet complet sélectionné pour avoir accès à l'ID
  ReferenceModel? selectedFiliere;
  ReferenceModel? selectedCycle;

  bool _isPasswordHidden = true;

  String? _nomError, _emailError, _telephoneError, _dateNaissanceError, _passwordError;
  String? _filiereError, _etablissementError, _cycleError;

  @override
  void initState() {
    super.initState();
    _loadReferences(); // ✅ Chargement des données au démarrage
  }

  // ✅ Récupération des données depuis le Backend via le Repository
  Future<void> _loadReferences() async {
    try {
      final repo = sl<AuthRepository>();
      final filieresData = await repo.getFilieres();
      final cyclesData = await repo.getCycles();

      setState(() {
        _filieres = filieresData;
        _cycles = cyclesData;
      });
    } catch (e) {
      debugPrint("Erreur lors du chargement des références : $e");
    }
  }

  @override
  void dispose() {
    nomController.dispose();
    emailController.dispose();
    telephoneController.dispose();
    dateNaissanceController.dispose();
    passwordController.dispose();
    etablissementController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: asmOrange)),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => dateNaissanceController.text = DateFormat('yyyy-MM-dd').format(picked));
    }
  }

  void _register() {
    setState(() {
      _nomError = _emailError = _telephoneError = _dateNaissanceError = _passwordError = null;
      _filiereError = _etablissementError = _cycleError = null;
    });

    bool hasError = false;
    if (nomController.text.trim().isEmpty) { _nomError = "Le nom est requis"; hasError = true; }
    if (!emailController.text.contains('@')) { _emailError = "Email invalide"; hasError = true; }
    if (passwordController.text.length < 6) { _passwordError = "Minimum 6 caractères"; hasError = true; }

    if (selectedRole == "Stagiaire") {
      if (selectedFiliere == null) { _filiereError = "Sélectionnez une filière"; hasError = true; }
      if (etablissementController.text.trim().isEmpty) { _etablissementError = "Établissement requis"; hasError = true; }
      if (selectedCycle == null) { _cycleError = "Sélectionnez un cycle"; hasError = true; }
    }

    if (hasError) return;

    // ✅ Création du UserModel avec les IDs (cycleId et filiereId)
    final user = UserModel(
      nomComplet: nomController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
      telephone: telephoneController.text.trim(),
      dateNaissance: dateNaissanceController.text,
      role: selectedRole.toUpperCase(),
      etablissement: selectedRole == "Stagiaire" ? etablissementController.text.trim() : null,
      filiereId: selectedRole == "Stagiaire" ? selectedFiliere?.id : null,
      cycleId: selectedRole == "Stagiaire" ? selectedCycle?.id : null,
    );

    context.read<AuthBloc>().add(RegisterSubmitted(user));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Compte créé avec succès !"), backgroundColor: Colors.green),
          );
          context.router.replace(const LoginRoute());
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: Stack(
          children: [
            Positioned(
              top: 0, left: 0,
              child: Container(
                width: 150, height: 100,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFFF9800), Color(0xFFF57C00)]),
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(80)),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                    const Text(
                      "Créer un compte",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 30),

                    InputField(icon: Icons.person, hint: "Nom complet", controller: nomController, errorText: _nomError),
                    const SizedBox(height: 16),
                    InputField(icon: Icons.email, hint: "Email", controller: emailController, errorText: _emailError),
                    const SizedBox(height: 16),
                    InputField(icon: Icons.phone, hint: "Téléphone", controller: telephoneController, errorText: _telephoneError, keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),
                    InputField(icon: Icons.cake, hint: "Date de naissance", controller: dateNaissanceController, readOnly: true, onTap: () => _selectDate(context), errorText: _dateNaissanceError),
                    const SizedBox(height: 16),
                    InputField(
                      icon: Icons.lock,
                      hint: "Mot de passe",
                      obscure: _isPasswordHidden,
                      controller: passwordController,
                      errorText: _passwordError,
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordHidden ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        RoleItem(icon: Icons.assignment, label: "Encadrant", selected: selectedRole == "Encadrant", onTap: () => setState(() => selectedRole = "Encadrant")),
                        RoleItem(icon: Icons.school, label: "Stagiaire", selected: selectedRole == "Stagiaire", onTap: () => setState(() => selectedRole = "Stagiaire")),
                      ],
                    ),

                    const SizedBox(height: 25),

                    if (selectedRole == "Stagiaire") ...[
                      // ✅ Dropdown dynamique pour Filière
                      DropdownField(
                          icon: Icons.book,
                          hint: "Filière",
                          value: selectedFiliere?.nom, // On affiche le nom
                          items: _filieres.map((f) => f.nom).toList(),
                          onChanged: (val) {
                            setState(() => selectedFiliere = _filieres.firstWhere((f) => f.nom == val));
                          },
                          errorText: _filiereError
                      ),
                      const SizedBox(height: 16),
                      InputField(icon: Icons.business, hint: "Établissement", controller: etablissementController, errorText: _etablissementError),
                      const SizedBox(height: 16),
                      // ✅ Dropdown dynamique pour Cycle
                      DropdownField(
                          icon: Icons.history_edu,
                          hint: "Cycle d'études",
                          value: selectedCycle?.nom,
                          items: _cycles.map((c) => c.nom).toList(),
                          onChanged: (val) {
                            setState(() => selectedCycle = _cycles.firstWhere((c) => c.nom == val));
                          },
                          errorText: _cycleError
                      ),
                      const SizedBox(height: 25),
                    ],

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return Container(
                          width: double.infinity, height: 55,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Color(0xFFFF9800), Color(0xFFE65100)]),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(color: asmOrange.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
                              ]
                          ),
                          child: ElevatedButton(
                            onPressed: state is AuthLoading ? null : _register,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                            ),
                            child: state is AuthLoading
                                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text("S'INSCRIRE", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Déjà un compte ? "),
                        GestureDetector(
                          onTap: () => context.router.replace(const LoginRoute()),
                          child: const Text("Se connecter", style: TextStyle(color: asmOrange, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
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