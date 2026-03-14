import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'core/di/injection.dart'; // ✅ Import de l'injection
import 'features/auth/logic/auth_bloc.dart'; // Correction de la casse 'features'
import 'features/internship/logic/internship_bloc.dart'; // ✅ Import indispensable pour Ali

void main() async {
  // 1. Indispensable pour l'initialisation asynchrone
  WidgetsFlutterBinding.ensureInitialized();

  // 2. ✅ Initialise GetIt (La carte mère)
  await initInjection();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Utilisation d'une instance unique pour le routeur
    final appRouter = AppRouter();

    return MultiBlocProvider(
      providers: [
        // 3. ✅ Injection de l'AuthBloc pour le Login/Register
        BlocProvider<AuthBloc>(
          create: (context) => sl<AuthBloc>(),
        ),

        // 4. ✅ Injection de l'InternshipBloc pour la liste des stages et candidatures
        // Sans cette ligne, SubjectListPage plantera avec la même erreur Provider
        BlocProvider<InternshipBloc>(
          create: (context) => sl<InternshipBloc>(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'ASM Stages',
        theme: AppTheme.lightTheme,
        routerConfig: appRouter.config(),
      ),
    );
  }
}