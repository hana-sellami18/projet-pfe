import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, tap } from 'rxjs';
import { Router } from '@angular/router';
import { Utilisateur } from '../shared/models';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private baseUrl = 'http://localhost:8089/api/auth';

  constructor(private http: HttpClient, private router: Router) {}

  register(userData: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/register`, userData);
  }

  login(credentials: any): Observable<any> {
    return this.http.post(`${this.baseUrl}/login`, credentials).pipe(
      tap((response: any) => {
        localStorage.setItem('token', response.token);
        localStorage.setItem('role', response.role);
        localStorage.setItem('userId', response.id);
        localStorage.setItem('currentUser', JSON.stringify({
          id: response.id,
          nom: response.nom,
          prenom: response.prenom,
          email: response.email,
          role: response.role
        }));
      })
    );
  }

  logout(): void {
    localStorage.clear();
    this.router.navigate(['/login']);
  }

  getToken(): string | null {
    return localStorage.getItem('token');
  }

  getRole(): string | null {
    return localStorage.getItem('role');
  }

  isLoggedIn(): boolean {
    return !!localStorage.getItem('token');
  }

  isRH(): boolean {
    return localStorage.getItem('role') === 'RH';
  }

  // ✅ Méthode ajoutée
  getCurrentUser(): Utilisateur | null {
    const data = localStorage.getItem('currentUser');
    return data ? JSON.parse(data) as Utilisateur : null;
  }
}
