export interface Stagiaire {
  id: number;
  nom: string;
  prenom: string;
  email: string;
  telephone?: string;
  dateNaissance?: Date;
  statut: 'EN_COURS' | 'TERMINE' | 'ABANDON' | 'SUSPENDU';
  progression?: number;
  filiere?: Filiere;
  // ✅ Champs ajoutés
  sujetStage?: string;
  encadrantNom?: string;
  dateDebut?: Date;
  dateFin?: Date;
  rapportUrl?: string;
  rapportDepose?: boolean;
}

export interface Candidature {
  id: number;
  stagiaireId?: number;
  offreStageId?: number;
  nomCandidat?: string;
  prenomCandidat?: string;
  dateCandidature?: Date;
  statut: StatutCandidature;
  scoreIA?: number;
  dateEntretien?: Date | string;
  // ✅ Champs ajoutés
  email?: string;
  offreTitre?: string;
  filiere?: Filiere;
  dateDepot?: Date;
  competencesIA?: string[];
  cvUrl?: string;
}

export interface Evaluation {
  id: number;
  stagiaireId: number;
  note: number;
  commentaire?: string;
  dateEvaluation: Date;
  valideeRH: boolean;
  stagiaireNom?: string;
  // ✅ Champ ajouté
  encadrantNom?: string;
}

export interface OffreStage {
  id: number;
  titre: string;
  description: string;
  competencesRequises: string[];
  competences?: string[];
  filiere: Filiere;
  dateDebut?: Date;
  dateFin?: Date;
  nbCandidatures: number;
  actif: boolean;
  estDisponible?: boolean;
}

export interface Utilisateur {
  id: number;
  nom: string;
  prenom?: string;
  email: string;
  role: 'ADMIN' | 'RH' | 'MANAGER';
}

export interface Notification {
  id: number;
  message: string;
  lue: boolean;
  date: Date;
}

export interface DashboardStats {
  totalCandidatures: number;
  enAttente: number;
  acceptees: number;
  refusees: number;
  stagiairesActifs: number;
  sujetsPopulaires: number;
  totalSujets?: number;
}

export type StatutCandidature = 'EN_ATTENTE' | 'ACCEPTEE' | 'REFUSEE' | 'ENTRETIEN';

export type Filiere = 'LICENCE' | 'MASTER' | 'CYCLE_INGE' | 'AUTRE' | 'DEV' | 'RESEAU' | 'DATA' | 'IA' | 'CYBER';
