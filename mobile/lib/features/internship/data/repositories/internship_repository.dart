import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/sujet_model.dart';

abstract class InternshipRepository {
  Future<List<SujetModel>> getAvailableSubjects();
  Future<void> postuler(int sujetId, String filePath);
}

class InternshipRepositoryImpl implements InternshipRepository {
  final DioClient _apiClient;

  InternshipRepositoryImpl(this._apiClient);

  @override
  Future<List<SujetModel>> getAvailableSubjects() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.subjectsDisponibles);
      final List<dynamic> data = response.data;
      return data.map((json) => SujetModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(
          "Erreur API (${e.response?.statusCode}): ${e.response?.data}");
    }
  }

  @override
  Future<void> postuler(int sujetId, String filePath) async {
    try {
      // ✅ "File" avec majuscule + sujetId comme paramètre séparé
      final formData = FormData.fromMap({
        'File': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
        'sujetId': sujetId,
      });

      await _apiClient.dio.post(
        ApiEndpoints.postuler,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      print('>>> [CANDIDATURE] CV soumis avec succès ✅');
    } on DioException catch (e) {
      print(
          '>>> [CANDIDATURE] Erreur: ${e.response?.statusCode} - ${e.response?.data}');
      throw Exception(
          "Erreur lors de l'envoi du CV (${e.response?.statusCode}): ${e.response?.data}");
    }
  }
}