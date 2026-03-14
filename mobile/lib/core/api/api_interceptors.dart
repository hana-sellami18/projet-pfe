import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiInterceptors extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // 1. NE PAS ajouter de token pour les routes publiques (login/register)
    // Cela évite l'erreur 401 si un vieux token invalide traîne dans le storage
    if (options.path.contains('/auth/')) {
      print("🚀 [API REQUEST] -> ${options.method} ${options.uri} (Public)");
      return handler.next(options);
    }

    // 2. Récupérer le token sauvegardé lors du login
    final String? token = await _storage.read(key: 'token');

    // 3. Injecter le token si disponible
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
      print("🚀 [API REQUEST] -> ${options.method} ${options.uri}");
      print("🔑 [AUTH] Token injecté ✅");
    } else {
      print("🚀 [API REQUEST] -> ${options.method} ${options.uri}");
      print("⚠️ [AUTH] Aucun token trouvé");
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("✅ [API RESPONSE] -> Status: ${response.statusCode}");
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("❌ [API ERROR] -> Status: ${err.response?.statusCode}");
    print("⚠️ [MESSAGE] : ${err.response?.data}");
    return handler.next(err);
  }
}