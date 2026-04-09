import 'package:dio/dio.dart';
import '../core/network/api_constants.dart';
import '../core/network/dio_client.dart';

class EngineerRepository {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> getCv() async {
    final response = await _dio.get(ApiConstants.engCv);
    return response.data;
  }

  Future<Map<String, dynamic>> getProjects() async {
    final response = await _dio.get(ApiConstants.engProjects);
    return response.data;
  }

  Future<Map<String, dynamic>> getTasks({int? projectId}) async {
    final url = projectId != null ? '${ApiConstants.engTasks}?project_id=$projectId' : ApiConstants.engTasks;
    final response = await _dio.get(url);
    return response.data;
  }

  Future<Map<String, dynamic>> getReports() async {
    final response = await _dio.get(ApiConstants.engReports);
    return response.data;
  }
}
