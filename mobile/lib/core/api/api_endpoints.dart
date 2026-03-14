class ApiEndpoints {
  // Base
  static const String baseUrl = "http://192.168.1.127:8085/api";

  // Auth
  static const String login = "/auth/login";
  static const String register = "/auth/register";

  // Références (Listes dynamiques)
  static const String filieres = "/references/filieres";
  static const String cycles = "/references/cycles";

  // Sujets
  // Dans ApiEndpoints
  static const String subjects = "/sujets";
  static const String subjectsDisponibles = "/sujets/disponibles"; // ✅ Ajoutez bien /disponibles icijouté
  static const String addSubject = "/sujets/add";

  // Stagiaires
  static const String interns = "/stagiaires";
  static const String internProfile = "/stagiaires/profile";
  static const String postuler = "/candidatures/postuler";
}