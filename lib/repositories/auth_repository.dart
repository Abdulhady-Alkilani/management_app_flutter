import 'package:dio/dio.dart';
import '../core/network/api_constants.dart';
import '../core/network/dio_client.dart';

class AuthRepository {
  final Dio _dio = DioClient().dio;

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {
          'username': username,
          'password': password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'فشل تسجيل الدخول');
      } else {
        throw Exception('خطأ في الاتصال بالخادم');
      }
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post(ApiConstants.logout);
    } catch (e) {
      // Ignored: logging out locally is standard even if server fails
    }
  }

  Future<Map<String, dynamic>> getUser() async {
    try {
      final response = await _dio.get(ApiConstants.user);
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'فشل الحصول على بيانات المستخدم');
      } else {
        throw Exception('خطأ في الاتصال بالخادم');
      }
    }
  }
}
