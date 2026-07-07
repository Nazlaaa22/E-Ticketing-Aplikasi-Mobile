import 'package:dio/dio.dart';

class TicketRepository {
  final Dio _dio = Dio();

  Future<List<double>> getWeeklyChart() async {
    final response = await _dio.get("/dashboard/weekly");

    final List data = response.data;

    return data.map<double>((item) {
      return (item["count"] as num).toDouble();
    }).toList();
  }
}