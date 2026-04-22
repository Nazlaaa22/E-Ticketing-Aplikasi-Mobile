import 'dart:io';
import 'package:dio/dio.dart';

class TicketRepository {
  final Dio _dio = Dio();

  Future<List<dynamic>> getTickets() async {
    final response = await _dio.get(
      'https://jsonplaceholder.typicode.com/posts',
    );

    final data = response.data as List;

    final tickets = data.map((e) {
      final id = e["id"] as int;

      String status;

      if (id % 3 == 0) {
        status = "open";
      } else if (id % 3 == 1) {
        status = "pending";
      } else {
        status = "done";
      }

      return {
        ...e,
        "status": status,
      };
    }).toList();

    return tickets;
  }

  Future<void> createTicket({
    required String title,
    required String desc,
    required String category,
    File? image,
  }) async {
    FormData formData = FormData.fromMap({
      "title": title,
      "description": desc,
      "category": category,

      if (image != null)
        "image": await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
    });

    await _dio.post(
      'https://jsonplaceholder.typicode.com/posts', // sementara dummy
      data: formData,
    );
  }
}