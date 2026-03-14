import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Stagiaire } from '../shared/models';

@Injectable({ providedIn: 'root' })
export class StagiaireService {
  private apiUrl = 'http://localhost:8089/api/stagiaires';

  constructor(private http: HttpClient) {}

  getAll(): Observable<Stagiaire[]> {
    return this.http.get<Stagiaire[]>(this.apiUrl);
  }

  getById(id: number): Observable<Stagiaire> {
    return this.http.get<Stagiaire>(`${this.apiUrl}/${id}`);
  }

  genererAttestation(id: number): Observable<Blob> {
    return this.http.get(`${this.apiUrl}/${id}/attestation`, { responseType: 'blob' });
  }
}
