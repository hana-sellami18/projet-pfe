import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { OffreStage } from '../shared/models';

@Injectable({ providedIn: 'root' })
export class StageService {
  private apiUrl = 'http://localhost:8089/api/sujets';

  constructor(private http: HttpClient) {}

  // ✅ Méthodes ajoutées
  getAll(): Observable<OffreStage[]> {
    return this.http.get<OffreStage[]>(this.apiUrl);
  }

  getById(id: number): Observable<OffreStage> {
    return this.http.get<OffreStage>(`${this.apiUrl}/${id}`);
  }

  create(offre: Partial<OffreStage>): Observable<OffreStage> {
    return this.http.post<OffreStage>(this.apiUrl, offre);
  }

  update(id: number, offre: Partial<OffreStage>): Observable<OffreStage> {
    return this.http.put<OffreStage>(`${this.apiUrl}/${id}`, offre);
  }

  delete(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }

  getMesOffres(): Observable<OffreStage[]> {
    return this.http.get<OffreStage[]>(`${this.apiUrl}/mes-offres`);
  }

  getToutesLesOffres(cycle?: string): Observable<OffreStage[]> {
    const url = cycle ? `${this.apiUrl}?cycle=${cycle}` : this.apiUrl;
    return this.http.get<OffreStage[]>(url);
  }
}
