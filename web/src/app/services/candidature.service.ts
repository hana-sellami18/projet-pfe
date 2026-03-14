import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Candidature, DashboardStats } from '../shared/models';

@Injectable({ providedIn: 'root' })
export class CandidatureService {
  private apiUrl = 'http://localhost:8089/api/candidatures';

  constructor(private http: HttpClient) {}

  getAll(): Observable<Candidature[]> {
    return this.http.get<Candidature[]>(this.apiUrl);
  }

  getById(id: number): Observable<Candidature> {
    return this.http.get<Candidature>(`${this.apiUrl}/${id}`);
  }

  accepter(id: number): Observable<void> {
    return this.http.put<void>(`${this.apiUrl}/${id}/accepter`, {});
  }

  refuser(id: number): Observable<void> {
    return this.http.put<void>(`${this.apiUrl}/${id}/refuser`, {});
  }

  // ✅ Renommé de planifierEntretien → programmerEntretien
  programmerEntretien(id: number, date: string): Observable<Candidature> {
    return this.http.put<Candidature>(`${this.apiUrl}/${id}/entretien`, { date });
  }

  getStats(): Observable<DashboardStats> {
    return this.http.get<DashboardStats>(`${this.apiUrl}/stats`);
  }

  getParMois(): Observable<{ mois: string; count: number }[]> {
    return this.http.get<{ mois: string; count: number }[]>(`${this.apiUrl}/par-mois`);
  }
}
