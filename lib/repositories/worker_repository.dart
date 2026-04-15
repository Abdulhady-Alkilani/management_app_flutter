import 'package:dio/dio.dart';
import '../core/network/api_constants.dart';
import '../core/network/dio_client.dart';

class WorkerRepository {
  final Dio _dio = DioClient().dio;

  // ── CV ────────────────────────────────────────────────────
  Future<Map<String, dynamic>> getCv() async {
    final response = await _dio.get(ApiConstants.workerCv);
    return response.data;
  }

  Future<Map<String, dynamic>> updateCv(Map<String, dynamic> data) async {
    final response = await _dio.put(ApiConstants.workerCv, data: data);
    return response.data;
  }

  Future<Map<String, dynamic>> addSkills(List<String> skills) async {
    final response = await _dio.post(
      ApiConstants.workerSkills,
      data: {'skills': skills},
    );
    return response.data;
  }

  // ── Workshops ─────────────────────────────────────────────
  Future<Map<String, dynamic>> getWorkshops() async {
    final response = await _dio.get(ApiConstants.workerWorkshops);
    return response.data;
  }

  // ── Tasks ─────────────────────────────────────────────────
  Future<Map<String, dynamic>> getTasks() async {
    final response = await _dio.get(ApiConstants.workerTasks);
    return response.data;
  }

  Future<Map<String, dynamic>> updateTask(
      int taskId, Map<String, dynamic> data) async {
    final response = await _dio.put(
      '${ApiConstants.workerTasks}/$taskId',
      data: data,
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getTaskDetails(int taskId) async {
    final response = await _dio.get('${ApiConstants.workerTasks}/$taskId');
    return response.data;
  }
}
