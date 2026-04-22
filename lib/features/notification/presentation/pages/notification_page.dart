import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {

    final notifications = [
      {
        "title": "Tiket berhasil dibuat",
        "desc": "Tiket #TKT-001 sudah masuk ke sistem",
        "type": "create",
        "time": "Baru saja"
      },
      {
        "title": "Status diperbarui",
        "desc": "Tiket #TKT-002 sekarang Progress",
        "type": "update",
        "time": "5 menit lalu"
      },
      {
        "title": "Balasan dari helpdesk",
        "desc": "Admin membalas tiket kamu",
        "type": "reply",
        "time": "10 menit lalu"
      },
      {
        "title": "Tiket selesai",
        "desc": "Tiket #TKT-003 sudah selesai",
        "type": "done",
        "time": "1 jam lalu"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi"),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final data = notifications[index];

          return _notifCard(
            title: data["title"]!,
            desc: data["desc"]!,
            type: data["type"]!,
            time: data["time"]!,
          );
        },
      ),
    );
  }

  Widget _notifCard({
    required String title,
    required String desc,
    required String type,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        children: [

          /// ICON
          CircleAvatar(
            backgroundColor: _color(type).withOpacity(0.15),
            child: Icon(
              _icon(type),
              color: _color(type),
            ),
          ),

          const SizedBox(width: 12),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _icon(String type) {
    switch (type) {
      case "create":
        return Icons.add_circle;
      case "update":
        return Icons.update;
      case "reply":
        return Icons.chat;
      case "done":
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }

  Color _color(String type) {
    switch (type) {
      case "create":
        return Colors.blue;
      case "update":
        return Colors.orange;
      case "reply":
        return Colors.purple;
      case "done":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}