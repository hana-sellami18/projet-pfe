import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Evaluation } from '../shared/models';

@Injectable({ providedIn: 'root' })
export class EvaluationService {
  private apiUrl = 'http://localhost:8089/api/evaluations';

  constructor(private http: HttpClient) {}

  getAll(): Observable<Evaluation[]> {
    return this.http.get<Evaluation[]>(this.apiUrl);
  }

  validerRH(id: number): Observable<void> {
    return this.http.put<void>(`${this.apiUrl}/${id}/valider`, {});
  }

  genererAttestation(id: number): Observable<Blob> {
    return this.http.get(`${this.apiUrl}/${id}/attestation`, { responseType: 'blob' });
  }
}
