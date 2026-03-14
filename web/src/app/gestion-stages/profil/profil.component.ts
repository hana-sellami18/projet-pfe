import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AuthService } from '../../services/auth.service';
import { Utilisateur } from '../../shared/models';

@Component({
  selector: 'app-profil',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="page">
      <div class="page-header">
        <h1 class="page-title">Mon Profil</h1>
      </div>
      <div class="profil-card">
        <div class="profil-av-wrap">
          <div class="profil-av">{{ getInitials() }}</div>
          <button class="change-photo">Changer la photo</button>
        </div>
        <div class="form-grid" *ngIf="user">
          <div class="form-group"><label>Prénom</label><input type="text" [(ngModel)]="user.prenom"></div>
          <div class="form-group"><label>Nom</label><input type="text" [(ngModel)]="user.nom"></div>
          <div class="form-group full"><label>Email</label><input type="email" [(ngModel)]="user.email"></div>
          <div class="form-group"><label>Rôle</label><input type="text" [value]="user.role" disabled></div>
        </div>
        <div class="divider"></div>
        <h3>Changer le mot de passe</h3>
        <div class="form-grid">
          <div class="form-group"><label>Mot de passe actuel</label><input type="password" placeholder="••••••••"></div>
          <div class="form-group"><label>Nouveau mot de passe</label><input type="password" placeholder="••••••••"></div>
        </div>
        <button class="btn-save">Enregistrer les modifications</button>
      </div>
    </div>
  `,
  styles: [`
    @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap');
    *{box-sizing:border-box;margin:0;padding:0;font-family:'Plus Jakarta Sans',sans-serif;}
    .page{padding:24px 26px 50px;display:flex;flex-direction:column;gap:16px;}
    .page-title{font-size:22px;font-weight:900;color:#1a1a2e;}
    .profil-card{background:#fff;border:1px solid #e8eaed;border-radius:16px;padding:28px;max-width:600px;box-shadow:0 2px 12px rgba(0,0,0,.05);}
    .profil-av-wrap{display:flex;align-items:center;gap:16px;margin-bottom:24px;padding-bottom:20px;border-bottom:1px solid #f3f3f3;}
    .profil-av{width:64px;height:64px;border-radius:50%;background:linear-gradient(135deg,#FF9800,#F57C00);color:#fff;font-size:22px;font-weight:900;display:flex;align-items:center;justify-content:center;}
    .change-photo{background:#f5f6f8;border:1.5px solid #e8eaed;color:#555;font-size:12px;font-weight:700;padding:8px 14px;border-radius:8px;cursor:pointer;}
    .form-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:16px;}
    .form-group{display:flex;flex-direction:column;gap:6px;}
    .form-group.full{grid-column:1/-1;}
    .form-group label{font-size:12.5px;font-weight:700;color:#333;}
    .form-group input{background:#F6F7F9;border:1.5px solid #E8EAED;border-radius:10px;padding:10px 13px;font-size:13px;color:#333;font-family:inherit;outline:none;}
    .form-group input:focus{border-color:#f57c00;}
    .form-group input:disabled{opacity:.6;cursor:not-allowed;}
    .divider{height:1px;background:#f3f3f3;margin:20px 0;}
    h3{font-size:14px;font-weight:800;color:#1a1a2e;margin-bottom:14px;}
    .btn-save{background:linear-gradient(135deg,#FF9800,#F57C00);color:#fff;font-size:12.5px;font-weight:800;padding:10px 22px;border-radius:10px;cursor:pointer;border:none;margin-top:8px;}
  `]
})
export class ProfilComponent implements OnInit {
  user: Utilisateur | null = null;

  constructor(private auth: AuthService) {}

  ngOnInit(): void {
    this.user = this.auth.getCurrentUser();
  }

  getInitials(): string {
    if (!this.user) return 'A';
    // ✅ Correction : vérification optionnelle sur prenom
    const p = this.user.prenom ?? '';
    const n = this.user.nom ?? '';
    return `${p.charAt(0)}${n.charAt(0)}`.toUpperCase() || 'A';
  }
}
