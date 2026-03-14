import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart'; // INDISPENSABLE pour corriger l'erreur 'Key'
import '../../features/auth/pages/profile_page.dart';
// Importez votre modèle pour corriger l'erreur 'SujetModel' dans le .gr.dart
import '../../features/internship/data/models/sujet_model.dart';

import '../../features/auth/pages/splash_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/internship/pages/subject_list_page.dart';
import '../../features/internship/pages/subject_detail_page.dart';
import '../../features/internship/pages/upload_cv_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),

    // Routes Internship
    AutoRoute(page: SubjectListRoute.page),
    AutoRoute(page: SubjectDetailRoute.page),
    AutoRoute(page: UploadCvRoute.page),
    AutoRoute(page: ProfileRoute.page), // ✅ ajout

  ];
}