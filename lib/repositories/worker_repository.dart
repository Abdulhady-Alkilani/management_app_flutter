import 'package:dio/dio.dart';
import '../core/network/api_constants.dart';
import '../core/network/dio_client.dart';

class WorkerRepository {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> getCv() async {
    final response = await _dio.get(ApiConstants.workerCv);
    return response.data;
  }

  Future<Map<String, dynamic>> getWorkshops() async {
    final response = await _dio.get(ApiConstants.workerWorkshops);
    return response.data;
  }

  Future<Map<String, dynamic>> getTasks() async {
    final response = await _dio.get(ApiConstants.workerTasks);
    return response.data;
  }

}
