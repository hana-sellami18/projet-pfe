import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';
import { CandidatureService } from '../../services/candidature.service';
import { StagiaireService } from '../../services/stagiaire.service';
import { StageService } from '../../services/stage.service';
import { NotificationService } from '../../services/notification.service';
import { AuthService } from '../../services/auth.service';
import { DashboardStats, Notification } from '../../shared/models';

@Component({
  selector: 'app-dashboard',
  standalone: true,
  imports: [CommonModule, RouterLink],
  templateUrl: './dashboard.component.html',
  styleUrls: ['./dashboard.component.css']
})
export class DashboardComponent implements OnInit {

  stats: DashboardStats = {
    totalCandidatures: 0, enAttente: 0, acceptees: 0, refusees: 0,
    stagiairesActifs: 0, sujetsPopulaires: 0, totalSujets: 0
  };

  barData: { mois: string; count: number; pct: number; active: boolean }[] = [];
  donutData = [
    { label: 'Licence',    pct: 40, color: '#FF9800', dash: '100.5', offset: '0' },
    { label: 'Master',     pct: 30, color: '#1A1A2E', dash: '75.4',  offset: '-100.5' },
    { label: 'Cycle Ingé.',pct: 20, color: '#555',    dash: '50.3',  offset: '-175.9' },
    { label: 'Autres',     pct: 10, color: '#D1D5DB', dash: '25.1',  offset: '-226.2' },
  ];

  notifications: Notification[] = [];
  showNotif     = false;
  notifCount    = 0;
  currentTime   = '';
  today         = '';
  greetingMsg   = '';
  greetingLabel = '';
  userName      = '';

  private timer: any;

  constructor(
    private candidatureService: CandidatureService,
    private stagiaireService:   StagiaireService,
    private stageService:       StageService,
    private notifService:       NotificationService,
    private auth:               AuthService
  ) {}

  ngOnInit(): void {
    const user = this.auth.getCurrentUser();
    this.userName = user ? `${user.prenom} ${user.nom}` : 'Admin RH';
    this.updateTime();
    this.timer = setInterval(() => this.updateTime(), 1000);
    this.loadStats();
    this.loadNotifications();
    this.loadBarData();
  }

  ngOnDestroy(): void { if (this.timer) clearInterval(this.timer); }

  private updateTime(): void {
    const now = new Date();
    this.currentTime = now.toLocaleTimeString('fr-FR', { hour:'2-digit', minute:'2-digit', second:'2-digit' });
    this.today       = now.toLocaleDateString('fr-FR', { weekday:'long', day:'numeric', month:'long' });
    const h = now.getHours();
    this.greetingMsg   = h<5?'Bonne nuit':h<12?'Bonjour':h<18?'Bon après-midi':h<22?'Bonsoir':'Bonne nuit';
    this.greetingLabel = h<5?'🌙 Nuit':h<12?'🌅 Matin':h<18?'☀️ Après-midi':h<22?'🌆 Soir':'🌙 Nuit';
  }

  private loadStats(): void {
    this.candidatureService.getStats().subscribe(s => {
      this.stats.enAttente  = s.enAttente;
      this.stats.acceptees  = s.acceptees;
      this.stats.refusees   = s.refusees;
      this.stats.totalCandidatures = s.enAttente + s.acceptees + s.refusees;
    });
    this.stagiaireService.getAll().subscribe(list => {
      this.stats.stagiairesActifs = list.filter(s => s.statut === 'EN_COURS').length;
    });
    this.stageService.getAll().subscribe(list => {
      this.stats.totalSujets      = list.length;
      this.stats.sujetsPopulaires = list.filter(s => s.nbCandidatures > 3).length;
    });
  }

  private loadBarData(): void {
    this.candidatureService.getParMois().subscribe(data => {
      const max = Math.max(...data.map(d => d.count), 1);
      this.barData = data.map((d, i) => ({
        mois:   d.mois,
        count:  d.count,
        pct:    Math.round((d.count / max) * 100),
        active: i === data.length - 1
      }));
    });
  }

  private loadNotifications(): void {
    this.notifService.getNonLues().subscribe(list => {
      this.notifications = list;
      this.notifCount    = list.length;
    });
  }

  toggleNotif(): void { this.showNotif = !this.showNotif; }

  marquerToutesLues(): void {
    this.notifService.marquerToutesLues().subscribe(() => {
      this.notifications = [];
      this.notifCount    = 0;
      this.showNotif     = false;
    });
  }
}
