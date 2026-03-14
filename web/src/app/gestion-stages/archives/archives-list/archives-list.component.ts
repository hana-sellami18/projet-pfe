import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { StagiaireService } from '../../../services/stagiaire.service';
import { Stagiaire } from '../../../shared/models';

@Component({
  selector: 'app-archives-list',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="page">
      <div class="page-header">
        <div>
          <h1 class="page-title">Archives</h1>
          <p class="page-sub">{{ filtered.length }} stage(s) archivé(s)</p>
        </div>
      </div>
      <div class="filters-bar">
        <div class="search-wrap">
          <input type="text" placeholder="Rechercher..." [(ngModel)]="search" (input)="filter()">
        </div>
        <select [(ngModel)]="filiereFilter" (change)="filter()">
          <option value="">Toutes les filières</option>
          <option value="LICENCE">Licence</option>
          <option value="MASTER">Master</option>
          <option value="CYCLE_INGE">Cycle Ingé.</option>
        </select>
      </div>
      <div class="loading" *ngIf="loading"><div class="spinner"></div></div>
      <div class="table-wrap" *ngIf="!loading">
        <table>
          <thead>
            <tr>
              <th>Stagiaire</th><th>Filière</th><th>Sujet</th><th>Encadrant</th><th>Date fin</th><th>Rapport</th><th>Attestation</th>
            </tr>
          </thead>
          <tbody>
            <tr *ngFor="let s of filtered">
              <td><div class="candidate-cell"><div class="candidate-av">{{s.prenom.charAt(0)}}{{s.nom.charAt(0)}}</div><span class="candidate-name">{{s.prenom}} {{s.nom}}</span></div></td>
              <td><span class="filiere-badge">{{s.filiere}}</span></td>
              <td><span class="sujet-name">{{s.sujetStage}}</span></td>
              <td>{{s.encadrantNom||'—'}}</td>
              <td>{{s.dateFin | date:'dd/MM/yyyy'}}</td>
              <td>
                <a *ngIf="s.rapportUrl" [href]="s.rapportUrl" target="_blank" class="btn-dl">📄 PDF</a>
                <span *ngIf="!s.rapportUrl" style="color:#bbb;font-size:12px;">—</span>
              </td>
              <td>
                <button class="btn-dl" (click)="telechargerAttestation(s)">📜 Attestation</button>
              </td>
            </tr>
            <tr *ngIf="filtered.length===0"><td colspan="7" class="empty-row">Aucune archive</td></tr>
          </tbody>
        </table>
      </div>
    </div>
  `,
  styles: [`
    @import url('https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800;900&display=swap');
    *{box-sizing:border-box;margin:0;padding:0;font-family:'Plus Jakarta Sans',sans-serif;}
    .page{padding:24px 26px 50px;display:flex;flex-direction:column;gap:16px;animation:fadeIn .35s ease both;}
    @keyframes fadeIn{from{opacity:0;transform:translateY(10px)}to{opacity:1;transform:translateY(0)}}
    .page-header{display:flex;align-items:flex-start;justify-content:space-between;}
    .page-title{font-size:22px;font-weight:900;color:#1a1a2e;}
    .page-sub{font-size:12.5px;color:#999;margin-top:3px;}
    .filters-bar{display:flex;gap:10px;}
    .search-wrap{display:flex;align-items:center;gap:8px;background:#fff;border:1.5px solid #e8eaed;border-radius:999px;padding:8px 16px;flex:1;max-width:300px;}
    .search-wrap input{border:none;background:transparent;outline:none;font-size:12.5px;color:#333;font-family:inherit;flex:1;}
    .filters-bar select{background:#fff;border:1.5px solid #e8eaed;border-radius:10px;padding:8px 14px;font-size:12.5px;font-weight:600;color:#444;font-family:inherit;cursor:pointer;outline:none;}
    .loading{display:flex;justify-content:center;padding:60px;}
    .spinner{width:36px;height:36px;border:3px solid #f0f0f0;border-top-color:#f57c00;border-radius:50%;animation:spin .7s linear infinite;}
    @keyframes spin{to{transform:rotate(360deg)}}
    .table-wrap{background:#fff;border:1px solid #e8eaed;border-radius:14px;overflow:hidden;box-shadow:0 2px 10px rgba(0,0,0,.04);}
    table{width:100%;border-collapse:collapse;}
    thead tr{background:#F8F9FB;border-bottom:1px solid #E8EAED;}
    th{padding:12px 16px;text-align:left;font-size:11.5px;font-weight:700;color:#888;text-transform:uppercase;letter-spacing:.4px;}
    td{padding:12px 16px;border-bottom:1px solid #F3F3F3;font-size:12.5px;color:#444;vertical-align:middle;}
    .candidate-cell{display:flex;align-items:center;gap:8px;}
    .candidate-av{width:30px;height:30px;border-radius:50%;background:linear-gradient(135deg,#FF9800,#F57C00);color:#fff;font-size:11px;font-weight:800;display:flex;align-items:center;justify-content:center;}
    .candidate-name{font-size:12.5px;font-weight:700;color:#1a1a2e;}
    .filiere-badge{font-size:10.5px;font-weight:700;padding:3px 9px;border-radius:999px;background:#FFF3E0;color:#E65100;}
    .sujet-name{font-size:12px;font-weight:600;color:#444;max-width:150px;display:block;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
    .btn-dl{background:#FFF3E0;border:1px solid #FFD0A0;color:#F57C00;font-size:11px;font-weight:700;padding:5px 11px;border-radius:8px;text-decoration:none;cursor:pointer;}
    .empty-row{text-align:center;color:#bbb;font-size:13px;padding:40px;}
  `]
})
export class ArchivesListComponent implements OnInit {
  archives: Stagiaire[] = [];
  filtered: Stagiaire[] = [];
  loading       = true;
  search        = '';
  filiereFilter = '';

  constructor(private service: StagiaireService) {}

  ngOnInit(): void {
    this.service.getAll().subscribe({
      next: data => { this.archives = data.filter(s => s.statut === 'TERMINE'); this.filter(); this.loading = false; },
      error: ()  => this.loading = false
    });
  }

  filter(): void {
    this.filtered = this.archives.filter(s => {
      const matchSearch  = !this.search || `${s.nom} ${s.prenom}`.toLowerCase().includes(this.search.toLowerCase());
      const matchFiliere = !this.filiereFilter || s.filiere === this.filiereFilter;
      return matchSearch && matchFiliere;
    });
  }

  telechargerAttestation(s: Stagiaire): void {
    this.service.genererAttestation(s.id).subscribe(blob => {
      const url = URL.createObjectURL(blob);
      const a   = document.createElement('a');
      a.href = url; a.download = `attestation_${s.nom}.pdf`; a.click();
      URL.revokeObjectURL(url);
    });
  }
}
