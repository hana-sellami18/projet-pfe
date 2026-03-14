enum StatusCandidature { EN_ATTENTE, ACCEPTEE, REFUSEE }

class CandidatureModel {
  final int id;
  final int sujetId;
  final String? sujetTitre;
  final StatusCandidature statut;
  final DateTime dateDepot;

  CandidatureModel({
    required this.id,
    required this.sujetId,
    this.sujetTitre,
    required this.statut,
    required this.dateDepot,
  });

  factory CandidatureModel.fromJson(Map<String, dynamic> json) {
    return CandidatureModel(
      id: json['id'],
      sujetId: json['sujet']['id'],
      sujetTitre: json['sujet']['titre'],
      statut: StatusCandidature.values.firstWhere(
            (e) => e.name == json['statut'],
        orElse: () => StatusCandidature.EN_ATTENTE,
      ),
      dateDepot: DateTime.parse(json['dateDepot']),
    );
  }
}