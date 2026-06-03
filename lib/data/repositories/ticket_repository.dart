import 'package:dio/dio.dart';

class TicketRepository {
  final Dio _dio = Dio();

  Future<List<dynamic>> getTickets() async {
    try {
      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/posts',
      );

      return response.data;
    } catch (e) {
      throw Exception('Gagal mengambil data tiket: $e');
    }
  }
}