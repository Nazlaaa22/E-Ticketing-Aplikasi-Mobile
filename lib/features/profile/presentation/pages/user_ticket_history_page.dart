import 'package:flutter/material.dart';

class UserTicketHistoryPage extends StatelessWidget {
  const UserTicketHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final history = [
      {
        "title": "WiFi kantor bermasalah",
        "status": "Done",
        "date": "10 Apr 2026"
      },
      {
        "title": "Laptop lemot",
        "status": "Done",
        "date": "05 Apr 2026"
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Tiket")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(item["title"]!),
              subtitle: Text(item["date"]!),
              trailing: _status(item["status"]!),
            ),
          );
        },
      ),
    );
  }

  Widget _status(String status) {
    return Text(
      status,
      style: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}