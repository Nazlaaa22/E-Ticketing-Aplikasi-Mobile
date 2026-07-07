import 'package:dio/dio.dart';

class NotificationRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000/api",
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  Future<List<dynamic>> getNotifications() async {
    final response = await _dio.get("/notifications");
    return response.data;
  }

  Future<void> markAsRead(int id) async {
    await _dio.put(
      "/notifications/$id",
      data: {
        "is_read": true,
      },
    );
  }

  Future<void> deleteNotification(int id) async {
    await _dio.delete("/notifications/$id");
  }
}