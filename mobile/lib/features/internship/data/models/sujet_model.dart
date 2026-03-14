class SujetModel {
  final int id;
  final String titre;
  final String description;
  final String filiereCible;
  final String cycleCible;
  final List<String> competencesCibles;
  final DateTime datePublication;
  final bool estDisponible;

  SujetModel({
    required this.id,
    required this.titre,
    required this.description,
    required this.filiereCible,
    required this.cycleCible,
    required this.competencesCibles,
    required this.datePublication,
    required this.estDisponible,
  });

  factory SujetModel.fromJson(Map<String, dynamic> json) {
    return SujetModel(
      id: json['id'],
      titre: json['titre'] ?? '',
      description: json['description'] ?? '',
      filiereCible: json['filiereCible'] ?? '',
      cycleCible: json['cycleCible'] ?? '',
      competencesCibles: List<String>.from(json['competencesCibles'] ?? []),
      datePublication: DateTime.parse(json['datePublication'] ?? DateTime.now().toString()),
      estDisponible: json['estDisponible'] ?? true,
    );
  }
}