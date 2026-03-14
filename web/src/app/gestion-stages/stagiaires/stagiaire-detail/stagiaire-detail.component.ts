import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { StagiaireService } from '../../../services/stagiaire.service';
import { Stagiaire } from '../../../shared/models';

@Component({
  selector: 'app-stagiaire-detail',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="page">
      <div class="page-header">
        <h1 class="page-title">Détail Stagiaire</h1>
        <a routerLink="/app/stagiaires" class="btn-back">← Retour</a>
      </div>
      <div class="loading" *ngIf="loading"><div class="spinner"></div></div>
      <div class="detail-grid" *ngIf="!loading && stagiaire">
        <div class="detail-card">
          <div class="stagiaire-header">
            <div class="av-lg">{{ stagiaire.prenom.charAt(0) }}{{ stagiaire.nom.charAt(0) }}</div>
            <div>
              <h2>{{ stagiaire.prenom }} {{ stagiaire.nom }}</h2>
              <p>{{ stagiaire.email }}</p>
              <span class="filiere-badge">{{ stagiaire.filiere }}</span>
            </div>
          </div>
          <div class="info-grid">
            <!-- ✅ Champs optionnels via ?. -->
            <div class="info-item"><label>Sujet</label><span>{{ stagiaire.sujetStage }}</span></div>
            <div class="info-item"><label>Encadrant</label><span>{{ stagiaire.encadrantNom || '—' }}</span></div>
            <div class="info-item"><label>Date début</label><span>{{ stagiaire.dateDebut | date:'dd/MM/yyyy' }}</span></div>
            <div class="info-item"><label>Date fin</label><span>{{ stagiaire.dateFin | date:'dd/MM/yyyy' }}</span></div>
          </div>
        </div>
        <div class="detail-card">
          <h3>Progression — {{ stagiaire.progression ?? 0 }}%</h3>
          <div class="prog-bar-bg"><div class="prog-bar-fill" [style.width.%]="stagiaire.progression ?? 0"></div></div>
          <div style="margin-top:18px;">
            <h4>Rapport</h4>
            <p>{{ stagiaire.rapportDepose ? '✓ Rapport déposé' : '✗ Rapport non déposé' }}</p>
          </div>
          <div class="card-actions">
            <button class="btn-action orange" (click)="genererAttestation()">📜 Générer Attestation</button>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap');
    *{box-sizing:border-box;margin:0;padding:0;font-family:'Plus Jakarta Sans',sans-serif;}
    .page{padding:24px 26px 50px;display:flex;flex-direction:column;gap:16px;}
    .page-header{display:flex;align-items:center;justify-content:space-between;}
    .page-title{font-size:22px;font-weight:900;color:#1a1a2e;}
    .btn-back{background:#f5f6f8;border:1.5px solid #e8eaed;color:#555;font-size:12.5px;font-weight:700;padding:9px 16px;border-radius:10px;text-decoration:none;}
    .loading{display:flex;justify-content:center;padding:60px;}
    .spinner{width:36px;height:36px;border:3px solid #f0f0f0;border-top-color:#f57c00;border-radius:50%;animation:spin .7s linear infinite;}
    @keyframes spin{to{transform:rotate(360deg)}}
    .detail-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;}
    .detail-card{background:#fff;border:1px solid #e8eaed;border-radius:14px;padding:22px;box-shadow:0 2px 10px rgba(0,0,0,.04);}
    .stagiaire-header{display:flex;align-items:center;gap:14px;margin-bottom:18px;padding-bottom:14px;border-bottom:1px solid #f3f3f3;}
    .av-lg{width:54px;height:54px;border-radius:50%;background:linear-gradient(135deg,#FF9800,#F57C00);color:#fff;font-size:18px;font-weight:900;display:flex;align-items:center;justify-content:center;}
    .stagiaire-header h2{font-size:16px;font-weight:800;color:#1a1a2e;}
    .stagiaire-header p{font-size:12px;color:#aaa;margin-top:2px;}
    .filiere-badge{display:inline-block;background:#FFF3E0;color:#E65100;font-size:10.5px;font-weight:700;padding:3px 9px;border-radius:999px;margin-top:5px;}
    .info-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;}
    .info-item label{font-size:11px;font-weight:700;color:#aaa;text-transform:uppercase;letter-spacing:.4px;display:block;margin-bottom:3px;}
    .info-item span{font-size:13px;font-weight:700;color:#333;}
    .detail-card h3{font-size:14px;font-weight:800;color:#1a1a2e;margin-bottom:10px;}
    .prog-bar-bg{height:10px;background:#f0f0f0;border-radius:999px;overflow:hidden;}
    .prog-bar-fill{height:100%;background:linear-gradient(90deg,#ffb74d,#ff9800);border-radius:999px;}
    .detail-card h4{font-size:13px;font-weight:700;color:#555;margin-bottom:6px;}
    .card-actions{margin-top:18px;}
    .btn-action{font-size:12.5px;font-weight:700;padding:10px 18px;border-radius:10px;cursor:pointer;border:none;}
    .btn-action.orange{background:linear-gradient(135deg,#FF9800,#F57C00);color:#fff;}
    @media(max-width:800px){.detail-grid{grid-template-columns:1fr;}}
  `]
})
export class StagiaireDetailComponent implements OnInit {
  stagiaire: Stagiaire | null = null;
  loading = true;

  constructor(private route: ActivatedRoute, private service: StagiaireService) {}

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) this.service.getById(+id).subscribe({
      next: s => { this.stagiaire = s; this.loading = false; },
      error: () => this.loading = false
    });
  }

  genererAttestation(): void {
    if (!this.stagiaire) return;
    this.service.genererAttestation(this.stagiaire.id).subscribe(blob => {
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url; a.download = 'attestation.pdf'; a.click();
      URL.revokeObjectURL(url);
    });
  }
}
