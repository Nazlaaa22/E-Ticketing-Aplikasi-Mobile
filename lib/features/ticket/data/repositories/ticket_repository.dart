import 'package:dio/dio.dart';

class TicketRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000/api",
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  /// ==========================
  /// GET ALL TICKETS
  /// ==========================
  Future<List<dynamic>> getTickets() async {
    try {
      final response = await _dio.get("/tickets");
      return List<dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Gagal mengambil data tiket",
      );
    }
  }

  /// ==========================
  /// GET DETAIL TICKET
  /// ==========================
  Future<Map<String, dynamic>> getTicket(int id) async {
    try {
      final response = await _dio.get("/tickets/$id");
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Gagal mengambil detail tiket",
      );
    }
  }

  /// ==========================
  /// CREATE TICKET
  /// ==========================
  Future<Map<String, dynamic>> createTicket({
    required String title,
    required String description,
    required String status,
  }) async {
    try {
      final response = await _dio.post(
        "/tickets",
        data: {
          "title": title,
          "description": description,
          "category": "General",
          "priority": "Medium",
          "status": status,
        },
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Gagal membuat tiket",
      );
    }
  }

  /// ==========================
  /// UPDATE TICKET
  /// ==========================
  Future<Map<String, dynamic>> updateTicket({
    required int id,
    required String title,
    required String description,
    required String status,
  }) async {
    try {
      final response = await _dio.put(
        "/tickets/$id",
        data: {
          "title": title,
          "description": description,
          "category": "General",
          "priority": "Medium",
          "status": status,
        },
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Gagal mengupdate tiket",
      );
    }
  }

  /// ==========================
  /// UPDATE STATUS
  /// ==========================
  Future<Map<String, dynamic>> updateStatus({
    required int id,
    required String status,
  }) async {
    try {
      final response = await _dio.put(
        "/tickets/$id/status",
        data: {
          "status": status,
        },
      );

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Gagal mengubah status",
      );
    }
  }

  /// ==========================
  /// DELETE TICKET
  /// ==========================
  Future<void> deleteTicket(int id) async {
    try {
      await _dio.delete("/tickets/$id");
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Gagal menghapus tiket",
      );
    }
  }

  /// ==========================
  /// DASHBOARD STATISTICS
  /// ==========================
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final response = await _dio.get("/dashboard/statistics");
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? "Gagal mengambil statistik",
      );
    }
  }

  /// ==========================
  /// WEEKLY CHART
  /// ==========================
  Future<List<dynamic>> getWeeklyChart() async {
    try {
      final response = await _dio.get("/dashboard/weekly");

      return List<dynamic>.from(response.data);

    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ??
            "Gagal mengambil data grafik",
      );
    }
  }

  Future<Map<String,dynamic>> getWeeklyReport() async {
    final response = await _dio.get("/report/weekly");
    return Map<String,dynamic>.from(response.data);
  }

  Future<List<dynamic>> getDoneReport() async {
    final response = await _dio.get("/report/done");
    return List<dynamic>.from(response.data);
  }

  Future<List<dynamic>> getHelpdeskReport() async {
    final response = await _dio.get("/report/helpdesk");
    return List<dynamic>.from(response.data);
  }

  Future<String> exportPdf() async {
    return "http://127.0.0.1:8000/api/report/pdf";
  }
}
