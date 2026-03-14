class ReferenceModel {
  final int id;
  final String nom;

  ReferenceModel({required this.id, required this.nom});

  factory ReferenceModel.fromJson(Map<String, dynamic> json) {
    return ReferenceModel(
      id: json['id'],
      nom: json['nom'],
    );
  }
}