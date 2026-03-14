import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { EvaluationService } from '../../../services/evaluation.service';
import { Evaluation } from '../../../shared/models';

@Component({
  selector: 'app-evaluations-list',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './evaluations-list.component.html',
  styleUrls: ['./evaluations-list.component.css']
})
export class EvaluationsListComponent implements OnInit {
  evaluations: Evaluation[] = [];
  loading = true;

  constructor(private service: EvaluationService) {}

  ngOnInit(): void {
    this.service.getAll().subscribe({
      next: data => { this.evaluations = data; this.loading = false; },
      error: ()  => this.loading = false
    });
  }

  validerRH(ev: Evaluation): void {
    // ✅ Correction : valideeRH (pas valideRH)
    this.service.validerRH(ev.id).subscribe(() => ev.valideeRH = true);
  }

  genererAttestation(ev: Evaluation): void {
    this.service.genererAttestation(ev.id).subscribe(blob => {
      const url = URL.createObjectURL(blob);
      const a   = document.createElement('a');
      a.href = url; a.download = `attestation_${ev.stagiaireNom ?? ev.id}.pdf`; a.click();
      URL.revokeObjectURL(url);
    });
  }

  noteStars(note: number): number[] { return Array.from({ length: 5 }, (_, i) => i + 1); }

  noteColor(note: number): string {
    if (note >= 4) return 'green';
    if (note >= 3) return 'orange';
    return 'red';
  }
}
