import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { Notification } from '../shared/models';

@Injectable({ providedIn: 'root' })
export class NotificationService {
  private apiUrl = 'http://localhost:8089/api/notifications';
  private countSubject = new BehaviorSubject<number>(0);
  count$ = this.countSubject.asObservable();

  constructor(private http: HttpClient) {}

  getNonLues(): Observable<Notification[]> {
    return this.http.get<Notification[]>(`${this.apiUrl}/non-lues`).pipe(
      tap((list: Notification[]) => this.countSubject.next(list.length))
    );
  }

  marquerLue(id: number): Observable<void> {
    return this.http.put<void>(`${this.apiUrl}/${id}/lue`, {});
  }

  // ✅ Méthode manquante ajoutée
  marquerToutesLues(): Observable<void> {
    return this.http.put<void>(`${this.apiUrl}/toutes-lues`, {}).pipe(
      tap(() => this.countSubject.next(0))
    );
  }

  setCount(n: number): void {
    this.countSubject.next(n);
  }
}
