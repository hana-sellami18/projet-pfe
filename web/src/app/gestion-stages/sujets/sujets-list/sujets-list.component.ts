import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { FormsModule } from '@angular/forms';
import { StageService } from '../../../services/stage.service';
import { OffreStage, Filiere } from '../../../shared/models';

@Component({
  selector: 'app-sujets-list',
  standalone: true,
  imports: [CommonModule, RouterLink, FormsModule],
  templateUrl: './sujets-list.component.html',
  styleUrls: ['./sujets-list.component.css']
})
export class SujetsListComponent implements OnInit {
  sujets:         OffreStage[] = [];
  filteredSujets: OffreStage[] = [];
  loading         = true;
  search          = '';
  filiereFilter   = '';
  statutFilter    = '';
  deleteId: number | null = null;

  constructor(private stageService: StageService) {}

  ngOnInit(): void { this.load(); }

  load(): void {
    this.loading = true;
    this.stageService.getAll().subscribe({
      next: data => { this.sujets = data; this.filter(); this.loading = false; },
      error: ()  => { this.loading = false; }
    });
  }

  filter(): void {
    this.filteredSujets = this.sujets.filter(s => {
      const matchSearch  = !this.search       || s.titre.toLowerCase().includes(this.search.toLowerCase());
      const matchFiliere = !this.filiereFilter || s.filiere === this.filiereFilter;
      const matchStatut  = !this.statutFilter  || String(s.estDisponible) === this.statutFilter;
      return matchSearch && matchFiliere && matchStatut;
    });
  }

  confirmDelete(id: number): void { this.deleteId = id; }

  doDelete(): void {
    if (!this.deleteId) return;
    this.stageService.delete(this.deleteId).subscribe(() => {
      this.sujets = this.sujets.filter(s => s.id !== this.deleteId);
      this.filter();
      this.deleteId = null;
    });
  }

  cancelDelete(): void { this.deleteId = null; }

  filiereLabel(f: Filiere): string {
    const map: Record<string, string> = { LICENCE:'Licence', MASTER:'Master', CYCLE_INGE:'Cycle Ingé.', AUTRE:'Autre' };
    return map[f] ?? f;
  }
}
