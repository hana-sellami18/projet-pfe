import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { CandidatureService } from '../../../services/candidature.service';
import { Candidature } from '../../../shared/models';

@Component({
  selector: 'app-candidature-detail',
  standalone: true,
  imports: [CommonModule, RouterLink],
  template: `
    <div class="page">
      <div class="page-header">
        <h1 class="page-title">Détail de la Candidature</h1>
        <a routerLink="/app/candidatures" class="btn-back">← Retour</a>
      </div>
      <div class="loading" *ngIf="loading"><div class="spinner"></div></div>
      <div class="detail-grid" *ngIf="!loading && candidature">
        <div class="detail-card">
          <div class="candidate-header">
            <!-- ✅ Opérateur ?. pour champs optionnels -->
            <div class="candidate-av-lg">{{ candidature.prenomCandidat?.charAt(0) }}{{ candidature.nomCandidat?.charAt(0) }}</div>
            <div>
              <h2>{{ candidature.prenomCandidat }} {{ candidature.nomCandidat }}</h2>
              <p>{{ candidature.email }}</p>
              <span class="statut-badge" [ngClass]="statutClass(candidature.statut)">{{ statutLabel(candidature.statut) }}</span>
            </div>
          </div>
          <div class="info-grid">
            <div class="info-item"><label>Sujet</label><span>{{ candidature.offreTitre }}</span></div>
            <div class="info-item"><label>Filière</label><span>{{ candidature.filiere }}</span></div>
            <div class="info-item"><label>Date de dépôt</label><span>{{ candidature.dateDepot | date:'dd/MM/yyyy' }}</span></div>
            <div class="info-item"><label>Entretien prévu</label><span>{{ candidature.dateEntretien ? (candidature.dateEntretien | date:'dd/MM/yyyy HH:mm') : '—' }}</span></div>
          </div>
        </div>
        <div class="detail-card">
          <!-- ✅ Fallback 0 pour scoreIA -->
          <h3>Score IA — {{ candidature.scoreIA ?? 0 }}%</h3>
          <div class="score-big-bar">
            <div class="score-big-fill" [style.width.%]="candidature.scoreIA ?? 0" [ngClass]="scoreClass(candidature.scoreIA ?? 0)"></div>
          </div>
          <h4 style="margin-top:18px;margin-bottom:10px;">Compétences extraites</h4>
          <div class="comp-list">
            <span class="comp-tag" *ngFor="let c of candidature.competencesIA">{{ c }}</span>
          </div>
          <div class="cv-btn-wrap" *ngIf="candidature.cvUrl">
            <a [href]="candidature.cvUrl" target="_blank" class="btn-cv">📄 Télécharger le CV</a>
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
    .candidate-header{display:flex;align-items:center;gap:14px;margin-bottom:18px;padding-bottom:18px;border-bottom:1px solid #f3f3f3;}
    .candidate-av-lg{width:56px;height:56px;border-radius:50%;background:linear-gradient(135deg,#FF9800,#F57C00);color:#fff;font-size:18px;font-weight:900;display:flex;align-items:center;justify-content:center;}
    .candidate-header h2{font-size:16px;font-weight:800;color:#1a1a2e;}
    .candidate-header p{font-size:12px;color:#aaa;margin-top:2px;}
    .statut-badge{display:inline-block;font-size:10.5px;font-weight:700;padding:3px 10px;border-radius:999px;margin-top:5px;}
    .statut-badge.orange{background:#FFF3E0;color:#E65100;}
    .statut-badge.green{background:#E8F8EE;color:#15803d;}
    .statut-badge.red{background:#FEF2F2;color:#dc2626;}
    .info-grid{display:grid;grid-template-columns:1fr 1fr;gap:12px;}
    .info-item label{font-size:11px;font-weight:700;color:#aaa;text-transform:uppercase;letter-spacing:.4px;display:block;margin-bottom:3px;}
    .info-item span{font-size:13px;font-weight:700;color:#333;}
    .detail-card h3{font-size:14px;font-weight:800;color:#1a1a2e;margin-bottom:10px;}
    .score-big-bar{height:10px;background:#f0f0f0;border-radius:999px;overflow:hidden;}
    .score-big-fill{height:100%;border-radius:999px;transition:width .6s;}
    .score-big-fill.high{background:#22c55e;}
    .score-big-fill.mid{background:#FF9800;}
    .score-big-fill.low{background:#ef4444;}
    .detail-card h4{font-size:13px;font-weight:700;color:#555;}
    .comp-list{display:flex;flex-wrap:wrap;gap:6px;}
    .comp-tag{background:#FFF3E0;border:1px solid #FFD0A0;color:#E65100;font-size:11.5px;font-weight:700;padding:4px 11px;border-radius:999px;}
    .cv-btn-wrap{margin-top:18px;}
    .btn-cv{display:inline-flex;align-items:center;gap:7px;background:#f5f6f8;border:1.5px solid #e8eaed;color:#333;font-size:12.5px;font-weight:700;padding:10px 18px;border-radius:10px;text-decoration:none;}
    @media(max-width:800px){.detail-grid{grid-template-columns:1fr;}}
  `]
})
export class CandidatureDetailComponent implements OnInit {
  candidature: Candidature | null = null;
  loading = true;

  constructor(private route: ActivatedRoute, private service: CandidatureService) {}

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) this.service.getById(+id).subscribe({
      next: c => { this.candidature = c; this.loading = false; },
      error: () => this.loading = false
    });
  }

  statutClass(s: string): string { return ({ EN_ATTENTE:'orange', ACCEPTEE:'green', REFUSEE:'red', ENTRETIEN:'blue' } as any)[s] ?? ''; }
  statutLabel(s: string): string { return ({ EN_ATTENTE:'En attente', ACCEPTEE:'Acceptée', REFUSEE:'Refusée', ENTRETIEN:'Entretien' } as any)[s] ?? s; }
  scoreClass(score: number): string { return score >= 75 ? 'high' : score >= 50 ? 'mid' : 'low'; }
}
