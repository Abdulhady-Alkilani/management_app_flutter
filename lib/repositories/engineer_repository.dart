import 'package:dio/dio.dart';
import '../core/network/api_constants.dart';
import '../core/network/dio_client.dart';

class EngineerRepository {
  final Dio _dio = DioClient().dio;

  // ── CV ────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getCv() async {
    final response = await _dio.get(ApiConstants.engCv);
    return response.data;
  }

  Future<Map<String, dynamic>> updateCv(Map<String, dynamic> data) async {
    final response = await _dio.put(ApiConstants.engCv, data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> addSkills(List<dynamic> skills) async {
    final response = await _dio.post(
      ApiConstants.engSkills,
      data: {'skills': skills},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getAvailableSkills() async {
    final response = await _dio.get(ApiConstants.skills);
    return response.data;
  }

  // ── Projects ──────────────────────────────────────────────
  Future<Map<String, dynamic>> getProjects() async {
    final response = await _dio.get(ApiConstants.engProjects);
    return response.data;
  }

  // ── Tasks ─────────────────────────────────────────────────
  Future<Map<String, dynamic>> getTasks({int? projectId}) async {
    final url = projectId != null
        ? '${ApiConstants.engTasks}?project_id=$projectId'
        : ApiConstants.engTasks;
    final response = await _dio.get(url);
    return response.data;
  }

  Future<Map<String, dynamic>> updateTask(
      int taskId, Map<String, dynamic> data) async {
    final response = await _dio.put(
      '${ApiConstants.engTasks}/$taskId',
      data: data,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getTaskDetails(int taskId) async {
    final response = await _dio.get('${ApiConstants.engTasks}/$taskId');
    return response.data;
  }

  // ── Reports ───────────────────────────────────────────────
  Future<Map<String, dynamic>> getReports() async {
    final response = await _dio.get(ApiConstants.engReports);
    return response.data;
  }

  Future<Map<String, dynamic>> getReportDetails(int reportId) async {
    final response = await _dio.get('${ApiConstants.engReports}/$reportId');
    return response.data;
  }

  Future<Map<String, dynamic>> createReport(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiConstants.engReports, data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> updateReport(
      int reportId, Map<String, dynamic> data) async {
    final response = await _dio.put(
      '${ApiConstants.engReports}/$reportId',
      data: data,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> deleteReport(int reportId) async {
    final response = await _dio.delete(
      '${ApiConstants.engReports}/$reportId',
    );
    return response.data;
  }
}
