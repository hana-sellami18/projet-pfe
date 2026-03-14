import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-parametres',
  standalone: true,
  imports: [CommonModule],
  template: `
    <div style="padding:24px">
      <h1 style="font-size:22px;font-weight:900;color:#1a1a2e">Paramètres</h1>
      <p style="color:#888;margin-top:8px">Page en cours de développement.</p>
    </div>
  `
})
export class ParametresComponent {}
