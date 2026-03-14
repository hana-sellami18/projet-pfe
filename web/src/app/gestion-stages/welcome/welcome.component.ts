import { Component, Input, Output, EventEmitter, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';

export interface ActivityItem {
  type:  'new' | 'open' | 'candidature' | 'closed';
  color: 'orange' | 'green' | 'blue' | 'red';
  text:  string;
  time:  string;
}

export interface BarItem {
  label:  string;
  val:    number;
  pct:    number;
  active: boolean;
}

export interface OffreStageWelcome {
  titre:            string;
  estDisponible:    boolean;
  datePublication?: Date | string | null;
}

@Component({
  selector: 'app-welcome',
  standalone: true,
  imports: [CommonModule],
  // ✅ template inline — plus besoin de welcome.html
  template: `
    <div style="padding:24px">
      <h1 style="font-size:22px;font-weight:900;color:#1a1a2e">
        {{ greetingMessage }}, {{ userName }} 👋
      </h1>
      <p style="color:#888;margin-top:6px">{{ today }} — {{ currentTime }}</p>
    </div>
  `
})
export class WelcomeComponent implements OnInit, OnDestroy {
  @Input() userName          = 'Admin RH';
  @Input() totalOffres       = 0;
  @Input() disponiblesCount  = 0;
  @Input() candidaturesCount = 0;
  @Input() offres: OffreStageWelcome[] = [];

  @Output() goDashboard = new EventEmitter<void>();
  @Output() goList      = new EventEmitter<void>();
  @Output() openForm    = new EventEmitter<void>();

  showNotif = false;
  toggleNotif(): void { this.showNotif = !this.showNotif; }

  barData: BarItem[] = [
    { label: 'Jan', val: 10, pct: 40,  active: false },
    { label: 'Fév', val: 15, pct: 55,  active: false },
    { label: 'Mar', val: 8,  pct: 35,  active: false },
    { label: 'Avr', val: 20, pct: 75,  active: false },
    { label: 'Mai', val: 12, pct: 48,  active: false },
    { label: 'Jui', val: 18, pct: 70,  active: true  },
  ];

  currentTime = '';
  today       = '';
  private timer: ReturnType<typeof setInterval> | null = null;

  get greetingMessage(): string {
    const h = new Date().getHours();
    if (h >= 5  && h < 12) return 'Bonjour';
    if (h >= 12 && h < 18) return 'Bon après-midi';
    if (h >= 18 && h < 22) return 'Bonsoir';
    return 'Bonne nuit';
  }

  get recentActivity(): ActivityItem[] {
    if (!this.offres?.length) return [];
    const items: ActivityItem[] = [];
    if (this.candidaturesCount > 0) {
      items.push({ type: 'candidature', color: 'blue', text: `${this.candidaturesCount} candidature(s) en cours`, time: "Aujourd'hui" });
    }
    const recent = [...this.offres]
      .filter(o => o.datePublication != null)
      .sort((a, b) => new Date(b.datePublication!).getTime() - new Date(a.datePublication!).getTime())
      .slice(0, 3);
    for (const o of recent) {
      items.push(o.estDisponible
        ? { type: 'open',   color: 'green', text: `Offre "${o.titre}" est ouverte`, time: this.timeAgo(o.datePublication) }
        : { type: 'closed', color: 'red',   text: `Offre "${o.titre}" est fermée`,  time: this.timeAgo(o.datePublication) }
      );
    }
    return items.slice(0, 4);
  }

  ngOnInit(): void {
    this.updateTime();
    this.timer = setInterval(() => this.updateTime(), 1000);
  }

  ngOnDestroy(): void {
    if (this.timer) clearInterval(this.timer);
  }

  private updateTime(): void {
    const now = new Date();
    this.currentTime = now.toLocaleTimeString('fr-FR', { hour: '2-digit', minute: '2-digit', second: '2-digit' });
    this.today       = now.toLocaleDateString('fr-FR', { weekday: 'long', day: 'numeric', month: 'long' });
  }

  private timeAgo(date: Date | string | null | undefined): string {
    if (!date) return 'Date inconnue';
    const diff  = Date.now() - new Date(date).getTime();
    const mins  = Math.floor(diff / 60_000);
    const hours = Math.floor(diff / 3_600_000);
    const days  = Math.floor(diff / 86_400_000);
    if (mins  < 1)   return "À l'instant";
    if (mins  < 60)  return `Il y a ${mins} min`;
    if (hours < 24)  return `Il y a ${hours}h`;
    if (days  === 1) return 'Hier';
    return `Il y a ${days} jours`;
  }
}
