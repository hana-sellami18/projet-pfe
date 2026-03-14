import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent {
  loginData = { email: '', password: '' };

  constructor(private router: Router, private authService: AuthService) {}

  onLogin(): void {
    this.authService.login(this.loginData).subscribe({
      next: (response: any) => {
        if (response.role === 'ROLE_RH' || response.role === 'RH') {
          this.router.navigate(['/app/dashboard']);
        } else {
          alert('Accès refusé : Cette interface est réservée aux administrateurs RH.');
          localStorage.clear();
        }
      },
      error: () => alert('Email ou mot de passe incorrect.')
    });
  }

  goToRegister(): void {
    this.router.navigate(['/register']);
  }
}
