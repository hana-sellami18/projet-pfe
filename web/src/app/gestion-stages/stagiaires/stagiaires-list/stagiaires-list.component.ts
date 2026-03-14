import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { StagiaireService } from '../../../services/stagiaire.service';
import { Stagiaire } from '../../../shared/models';

@Component({
  selector: 'app-stagiaires-list',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule],
  templateUrl: './stagiaires-list.component.html',
  styleUrls: ['./stagiaires-list.component.css']
})
export class StagiairesListComponent implements OnInit {
  stagiaires:         Stagiaire[] = [];
  filteredStagiaires: Stagiaire[] = [];
  loading      = true;
  search       = '';
  statutFilter = '';

  constructor(private service: StagiaireService) {}

  ngOnInit(): void {
    this.service.getAll().subscribe({
      next: data => { this.stagiaires = data; this.filter(); this.loading = false; },
      error: ()  => this.loading = false
    });
  }

  filter(): void {
    this.filteredStagiaires = this.stagiaires.filter(s => {
      const matchSearch = !this.search || `${s.nom} ${s.prenom}`.toLowerCase().includes(this.search.toLowerCase());
      const matchStatut = !this.statutFilter || s.statut === this.statutFilter;
      return matchSearch && matchStatut;
    });
  }

  genererAttestation(s: Stagiaire): void {
    this.service.genererAttestation(s.id).subscribe(blob => {
      const url = URL.createObjectURL(blob);
      const a   = document.createElement('a');
      a.href = url; a.download = `attestation_${s.nom}_${s.prenom}.pdf`; a.click();
      URL.revokeObjectURL(url);
    });
  }

  // ✅ Correction : number | undefined géré
  progressionClass(p: number | undefined): string {
    if (!p) return 'low';
    return p >= 75 ? 'high' : p >= 40 ? 'mid' : 'low';
  }
}
