import { Routes } from '@angular/router';
import { AuthGuard } from './interceptors/auth.guard';

export const routes: Routes = [
  { path: '', redirectTo: 'login', pathMatch: 'full' },

  {
    path: 'login',
    loadComponent: () => import('./components/login/login.component').then(m => m.LoginComponent)
  },
  {
    path: 'register',
    loadComponent: () => import('./components/register/register.component').then(m => m.RegisterComponent)
  },

  {
    path: 'app',
    canActivate: [AuthGuard],
    loadComponent: () => import('./gestion-stages/layout/layout.component').then(m => m.LayoutComponent),
    children: [
      { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
      {
        path: 'dashboard',
        loadComponent: () => import('./gestion-stages/dashboard/dashboard.component').then(m => m.DashboardComponent)
      },
      {
        path: 'sujets',
        loadComponent: () => import('./gestion-stages/sujets/sujets-list/sujets-list.component').then(m => m.SujetsListComponent)
      },
      {
        path: 'sujets/nouveau',
        loadComponent: () => import('./gestion-stages/sujets/sujet-form/sujet-form.component').then(m => m.SujetFormComponent)
      },
      {
        path: 'sujets/:id/modifier',
        loadComponent: () => import('./gestion-stages/sujets/sujet-form/sujet-form.component').then(m => m.SujetFormComponent)
      },
      {
        path: 'candidatures',
        loadComponent: () => import('./gestion-stages/candidatures/candidatures-list/candidatures-list.component').then(m => m.CandidaturesListComponent)
      },
      {
        path: 'candidatures/:id',
        loadComponent: () => import('./gestion-stages/candidatures/candidature-detail/candidature-detail.component').then(m => m.CandidatureDetailComponent)
      },
      {
        path: 'stagiaires',
        loadComponent: () => import('./gestion-stages/stagiaires/stagiaires-list/stagiaires-list.component').then(m => m.StagiairesListComponent)
      },
      {
        path: 'stagiaires/:id',
        loadComponent: () => import('./gestion-stages/stagiaires/stagiaire-detail/stagiaire-detail.component').then(m => m.StagiaireDetailComponent)
      },
      {
        path: 'evaluations',
        loadComponent: () => import('./gestion-stages/evaluations/evaluations-list/evaluations-list.component').then(m => m.EvaluationsListComponent)
      },
      {
        path: 'archives',
        loadComponent: () => import('./gestion-stages/archives/archives-list/archives-list.component').then(m => m.ArchivesListComponent)
      },
      {
        path: 'parametres',
        // VERIFICATION : Assure-toi que le fichier est bien dans :
        // src/app/gestion-stages/parametres/parametres.component.ts
        loadComponent: () => import('./gestion-stages/parametres/parametres.component').then(m => m.ParametresComponent)
      },
      {
        path: 'profil',
        loadComponent: () => import('./gestion-stages/profil/profil.component').then(m => m.ProfilComponent)
      },
    ]
  },

  { path: '**', redirectTo: 'login' }
];
