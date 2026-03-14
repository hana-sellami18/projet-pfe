class UserModel {
  final String nomComplet;
  final String email;
  final String password;
  final String telephone;
  final String dateNaissance;
  final String role;

  // Champs optionnels
  final String? etablissement;

  // ✅ On change le type de String à int (ou l'ID sélectionné)
  final int? cycleId;
  final int? filiereId;

  UserModel({
    required this.nomComplet,
    required this.email,
    required this.password,
    required this.telephone,
    required this.dateNaissance,
    required this.role,
    this.etablissement,
    this.cycleId,
    this.filiereId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "nomComplet": nomComplet,
      "email": email,
      "password": password,
      "telephone": telephone,
      "dateNaissance": dateNaissance,
      // Formatage du rôle pour Spring Security
      "role": role.toUpperCase().startsWith('ROLE_')
          ? role.toUpperCase()
          : 'ROLE_${role.toUpperCase()}',
    };

    // Inclusion dynamique de l'établissement
    if (etablissement != null) data['etablissement'] = etablissement;

    // ✅ Envoi structuré pour correspondre aux entités ManyToOne du Backend
    // Au lieu de "filiere": "Informatique", on envoie "filiere": {"id": 1}
    if (filiereId != null) {
      data['filiere'] = {"id": filiereId};
    }

    if (cycleId != null) {
      data['cycle'] = {"id": cycleId};
    }

    return data;
  }
}