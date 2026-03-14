import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-register',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './register.component.html',
  styleUrls: ['../login/login.component.css']
})
export class RegisterComponent {
  regData = {
    nomComplet: '',
    email: '',
    telephone: '',
    dateNaissance: '',
    password: '',
    role: 'ROLE_RH'
  };

  constructor(private router: Router, private authService: AuthService) {}

  onRegister(): void {
    this.authService.register({ ...this.regData, role: 'ROLE_RH' }).subscribe({
      next: () => this.router.navigate(['/app/dashboard']),
      error: () => alert("Erreur lors de l'inscription. Vérifiez vos informations.")
    });
  }

  goToLogin(): void {
    this.router.navigate(['/login']);
  }
}
