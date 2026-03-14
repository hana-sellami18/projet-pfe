import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/user_model.dart';
import '../models/reference_model.dart';

class AuthRepository {
  final DioClient _apiClient;
  final FlutterSecureStorage _storage;

  AuthRepository(this._apiClient) : _storage = const FlutterSecureStorage();

  Future<List<ReferenceModel>> getFilieres() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.filieres);
      final List data = response.data;
      return data.map((json) => ReferenceModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e, context: "la récupération des filières");
    }
  }

  Future<List<ReferenceModel>> getCycles() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.cycles);
      final List data = response.data;
      return data.map((json) => ReferenceModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleDioError(e, context: "la récupération des cycles");
    }
  }

  Future<Response> register(UserModel user) async {
    try {
      return await _apiClient.dio.post(
        ApiEndpoints.register,
        data: user.toJson(),
      );
    } on DioException catch (e) {
      throw _handleDioError(e, context: "l'inscription");
    }
  }

  Future<String> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.login,
        data: {"email": email, "password": password},
      );

      final data = response.data;

      if (data is Map<String, dynamic> && data.containsKey('token')) {
        final token = data['token'].toString();
        await _storage.write(key: 'token', value: token);
        await _storage.write(key: 'email', value: email);

        if (data.containsKey('role')) {
          await _storage.write(key: 'role', value: data['role'].toString());
        }

        // ✅ nomComplet = "karim" → on l'utilise comme prénom
        if (data.containsKey('nomComplet')) {
          await _storage.write(key: 'nomComplet', value: data['nomComplet'].toString());
        }

        // ✅ cycle est un objet {id, nom} → on extrait le nom
        if (data.containsKey('cycle')) {
          final cycle = data['cycle'];
          if (cycle is Map<String, dynamic>) {
            await _storage.write(key: 'cycle', value: cycle['nom']?.toString() ?? '');
          } else if (cycle != null) {
            await _storage.write(key: 'cycle', value: cycle.toString());
          }
        }

        // ✅ filiere si présente
        if (data.containsKey('filiere')) {
          final filiere = data['filiere'];
          if (filiere is Map<String, dynamic>) {
            await _storage.write(key: 'filiere', value: filiere['nom']?.toString() ?? '');
          } else if (filiere != null) {
            await _storage.write(key: 'filiere', value: filiere.toString());
          }
        }

        print('>>> [AUTH] Profil sauvegardé ✅');
        return token;
      }

      throw "Réponse inattendue du serveur : token absent";
    } on DioException catch (e) {
      throw _handleDioError(e, context: "la connexion");
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    print('>>> [AUTH] Déconnexion ✅');
  }

  Future<String?> getToken() async => await _storage.read(key: 'token');
  Future<String?> getRole()  async => await _storage.read(key: 'role');

  String _handleDioError(DioException e, {required String context}) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      return "Serveur injoignable. Vérifiez votre connexion.";
    }
    if (e.response?.statusCode == 403) return "Accès refusé (403).";
    if (e.response?.statusCode == 401) return "Email ou mot de passe incorrect.";
    if (e.response?.statusCode == 409) return "Cet email est déjà utilisé.";

    final resp = e.response?.data;
    if (resp is Map<String, dynamic>) {
      return resp['message']?.toString() ?? "Erreur lors de $context";
    }
    return "Erreur serveur lors de $context (${e.response?.statusCode ?? 'Inconnu'})";
  }
}