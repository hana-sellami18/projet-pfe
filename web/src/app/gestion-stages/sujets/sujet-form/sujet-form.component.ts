import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { ActivatedRoute, Router, RouterLink } from '@angular/router';
import { StageService } from '../../../services/stage.service';
import { OffreStage, Filiere } from '../../../shared/models';

@Component({
  selector: 'app-sujet-form',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './sujet-form.component.html',
  styleUrls: ['./sujet-form.component.css']
})
export class SujetFormComponent implements OnInit {
  isEdit    = false;
  loading   = false;
  saving    = false;
  error     = '';
  newCompetence = '';

  model: Partial<OffreStage> = {
    titre: '', description: '', competences: [],
    filiere: 'LICENCE', estDisponible: true
  };

  filieres: Filiere[] = ['LICENCE','MASTER','CYCLE_INGE','AUTRE'];

  constructor(
    private route:  ActivatedRoute,
    private router: Router,
    private service: StageService
  ) {}

  ngOnInit(): void {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEdit = true;
      this.loading = true;
      this.service.getById(+id).subscribe({
        next: s  => { this.model = { ...s }; this.loading = false; },
        error: () => { this.error = 'Sujet introuvable'; this.loading = false; }
      });
    }
  }

  addCompetence(): void {
    const c = this.newCompetence.trim();
    if (c && !this.model.competences!.includes(c)) {
      this.model.competences!.push(c);
      this.newCompetence = '';
    }
  }

  removeCompetence(c: string): void {
    this.model.competences = this.model.competences!.filter(x => x !== c);
  }

  submit(): void {
    if (!this.model.titre?.trim()) { this.error = 'Le titre est obligatoire'; return; }
    this.saving = true;
    this.error  = '';
    const obs = this.isEdit
      ? this.service.update(this.model.id!, this.model)
      : this.service.create(this.model);
    obs.subscribe({
      next:  () => this.router.navigate(['/app/sujets']),
      error: () => { this.error = 'Erreur lors de la sauvegarde'; this.saving = false; }
    });
  }

  filiereLabel(f: Filiere): string {
    const map: Record<string,string> = { LICENCE:'Licence', MASTER:'Master', CYCLE_INGE:'Cycle Ingé.', AUTRE:'Autre' };
    return map[f] ?? f;
  }
}
