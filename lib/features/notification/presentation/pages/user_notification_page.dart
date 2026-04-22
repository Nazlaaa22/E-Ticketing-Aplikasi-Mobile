import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../ticket/presentation/pages/user_ticket_detail_page.dart';

class UserNotificationPage extends StatefulWidget {
  const UserNotificationPage({super.key});

  @override
  State<UserNotificationPage> createState() => _UserNotificationPageState();
}

class _UserNotificationPageState extends State<UserNotificationPage> {
  final Dio _dio = Dio();

  List<Map<String, String>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/posts',
      );

      final data = response.data as List;

      final mapped = data.take(10).map<Map<String, String>>((e) {
        final id = e["id"];

        String type;
        String status;

        if (id % 3 == 0) {
          type = "create";
          status = "Open";
        } else if (id % 3 == 1) {
          type = "update";
          status = "Pending";
        } else {
          type = "comment";
          status = "Done";
        }

        return {
          "title": _titleByType(type),
          "desc": e["title"],
          "time": "${id * 2} menit lalu",
          "type": type,
          "ticket": "TKT-00$id",
          "status": status,
        };
      }).toList();

      setState(() {
        notifications = mapped;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _titleByType(String type) {
    switch (type) {
      case "create":
        return "Tiket berhasil dibuat";
      case "update":
        return "Status tiket diperbarui";
      case "comment":
        return "Balasan dari helpdesk";
      default:
        return "Notifikasi";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: Column(
        children: [

          /// 🔥 HEADER (TIDAK DIUBAH)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F8CFF), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: const Center(
              child: Text(
                "Notifikasi",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          /// 🔥 LIST
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];

                return _notifCard(
                  context,
                  title: notif["title"]!,
                  desc: notif["desc"]!,
                  time: notif["time"]!,
                  type: notif["type"]!,
                  ticketId: notif["ticket"]!,
                  status: notif["status"]!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case "create":
        return Icons.add_circle;
      case "update":
        return Icons.sync;
      case "comment":
        return Icons.chat;
      case "done":
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }

  Color _getColor(String type) {
    switch (type) {
      case "create":
        return Colors.blue;
      case "update":
        return Colors.orange;
      case "comment":
        return Colors.purple;
      case "done":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _notifCard(
      BuildContext context, {
        required String title,
        required String desc,
        required String time,
        required String type,
        required String ticketId,
        required String status,
      }) {
    final color = _getColor(type);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserTicketDetailPage(
              data: {
                "title": desc,
                "status": status,
                "date": "20 Apr 2026",
                "category": "Jaringan",
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
            )
          ],
        ),
        child: Row(
          children: [

            /// ICON
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(_getIcon(type), color: color),
            ),

            const SizedBox(width: 12),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
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
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
          ],
        ),
      ),
    );
  }
}