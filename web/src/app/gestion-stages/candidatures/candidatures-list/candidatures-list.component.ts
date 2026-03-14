import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { CandidatureService } from '../../../services/candidature.service';
import { Candidature, StatutCandidature } from '../../../shared/models';

@Component({
  selector: 'app-candidatures-list',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule],
  templateUrl: './candidatures-list.component.html',
  styleUrls: ['./candidatures-list.component.css']
})
export class CandidaturesListComponent implements OnInit {
  candidatures:         Candidature[] = [];
  filteredCandidatures: Candidature[] = [];
  loading       = true;
  search        = '';
  statutFilter  = '';
  entretienId:  number | null = null;
  dateEntretien = '';
  showIAModal:  Candidature | null = null;

  constructor(private service: CandidatureService) {}

  ngOnInit(): void { this.load(); }

  load(): void {
    this.loading = true;
    this.service.getAll().subscribe({
      next: data => { this.candidatures = data; this.filter(); this.loading = false; },
      error: ()  => this.loading = false
    });
  }

  filter(): void {
    this.filteredCandidatures = this.candidatures.filter(c => {
      const matchSearch = !this.search ||
        `${c.nomCandidat ?? ''} ${c.prenomCandidat ?? ''}`.toLowerCase().includes(this.search.toLowerCase());
      const matchStatut = !this.statutFilter || c.statut === this.statutFilter;
      return matchSearch && matchStatut;
    });
  }

  accepter(c: Candidature): void {
    this.service.accepter(c.id).subscribe(() => { c.statut = 'ACCEPTEE'; });
  }

  refuser(c: Candidature): void {
    this.service.refuser(c.id).subscribe(() => { c.statut = 'REFUSEE'; });
  }

  ouvrirEntretien(id: number): void { this.entretienId = id; this.dateEntretien = ''; }

  confirmerEntretien(): void {
    if (!this.entretienId || !this.dateEntretien) return;
    // ✅ programmerEntretien au lieu de planifierEntretien
    this.service.programmerEntretien(this.entretienId, this.dateEntretien).subscribe(() => {
      const c = this.candidatures.find(x => x.id === this.entretienId);
      if (c) c.dateEntretien = this.dateEntretien; // string assigné à Date | string → OK
      this.entretienId = null;
    });
  }

  voirIA(c: Candidature): void { this.showIAModal = c; }

  statutClass(s: StatutCandidature): string {
    const map: Record<StatutCandidature, string> = {
      EN_ATTENTE: 'orange', ACCEPTEE: 'green', REFUSEE: 'red', ENTRETIEN: 'blue'
    };
    return map[s] ?? '';
  }

  statutLabel(s: StatutCandidature): string {
    const map: Record<StatutCandidature, string> = {
      EN_ATTENTE: 'En attente', ACCEPTEE: 'Acceptée', REFUSEE: 'Refusée', ENTRETIEN: 'Entretien'
    };
    return map[s] ?? s;
  }

  scoreClass(score: number | undefined): string {
    if (!score) return 'low';
    return score >= 75 ? 'high' : score >= 50 ? 'mid' : 'low';
  }
}
