import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { NotificationService } from '../../services/notification.service';
import { Utilisateur } from '../../shared/models';

interface NavItem {
  label: string;
  route: string;
  icon:  string;
  badge?: number;
}

@Component({
  selector: 'app-sidebar',
  standalone: true,
  imports: [CommonModule, RouterLink, RouterLinkActive],
  templateUrl: './sidebar.component.html',
  styleUrls: ['./sidebar.component.css']
})
export class SidebarComponent implements OnInit {
  collapsed   = false;
  currentUser: Utilisateur | null = null;
  notifCount  = 0;

  navItems: NavItem[] = [
    { label: 'Dashboard',       route: '/app/dashboard',    icon: 'grid'       },
    { label: 'Sujets de Stage', route: '/app/sujets',       icon: 'file-text'  },
    { label: 'Candidatures',    route: '/app/candidatures', icon: 'users'      },
    { label: 'Stagiaires',      route: '/app/stagiaires',   icon: 'user-check' },
    { label: 'Évaluations',     route: '/app/evaluations',  icon: 'star'       },
    { label: 'Archives',        route: '/app/archives',     icon: 'archive'    },
    { label: 'Paramètres',      route: '/app/parametres',   icon: 'settings'   },
  ];

  constructor(private auth: AuthService, private notifService: NotificationService) {}

  ngOnInit(): void {
    this.currentUser = this.auth.getCurrentUser();
    this.notifService.count$.subscribe(n => this.notifCount = n);
    this.notifService.getNonLues().subscribe();
  }

  toggleCollapse(): void { this.collapsed = !this.collapsed; }
  logout(): void { this.auth.logout(); }

  getInitials(): string {
    if (!this.currentUser) return 'A';
    // ✅ Correction : opérateur ?? pour éviter l'erreur "possibly undefined"
    const p = this.currentUser.prenom ?? '';
    const n = this.currentUser.nom ?? '';
    return `${p.charAt(0)}${n.charAt(0)}`.toUpperCase() || 'A';
  }
}
