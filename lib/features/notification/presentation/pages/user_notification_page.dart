import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../../ticket/presentation/pages/user_ticket_detail_page.dart';

class UserNotificationPage extends StatefulWidget {
  const UserNotificationPage({super.key});

  @override
  State<UserNotificationPage> createState() =>
      _UserNotificationPageState();
}

class _UserNotificationPageState
    extends State<UserNotificationPage> {

  final Dio _dio = Dio();

  List<Map<String, String>> notifications = [];

  bool isLoading = true;

  int unread = 0;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {

      final response = await _dio.get(
        "https://jsonplaceholder.typicode.com/posts",
      );

      final data = response.data as List;

      notifications = data.take(12).map<Map<String, String>>((e) {

        final id = e["id"];

        String type;
        String status;

        if (id % 3 == 0) {
          type = "create";
          status = "Open";
        } else if (id % 3 == 1) {
          type = "update";
          status = "Progress";
        } else {
          type = "reply";
          status = "Done";
        }

        return {
          "title": _titleByType(type),
          "message": e["title"],
          "time": "${id * 3} menit lalu",
          "ticket": "TK-${id.toString().padLeft(3, "0")}",
          "status": status,
          "type": type,
        };

      }).toList();

      unread = notifications.length ~/ 3;

      setState(() {
        isLoading = false;
      });

    } catch (_) {

      setState(() {
        isLoading = false;
      });

    }
  }

  String _titleByType(String type) {

    switch (type) {

      case "create":
        return "Tiket Berhasil Dibuat";

      case "update":
        return "Status Tiket Diperbarui";

      case "reply":
        return "Balasan dari Helpdesk";

      default:
        return "Notifikasi";

    }

  }
  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;

    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,

        body: SafeArea(
            child: Column(
              children: [

              /// ==========================
              /// HEADER
              /// ==========================

              Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                24,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff2563EB),
                    Color(0xff60A5FA),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  const Row(
                    children: [

                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.notifications,
                          color: Color(0xff2563EB),
                        ),
                      ),

                      SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Text(
                              "Notifikasi",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            SizedBox(height: 4),

                            Text(
                              "Semua aktivitas tiket kamu",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [

                      Expanded(
                        child: Container(
                          padding:
                          const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(.15),
                            borderRadius:
                            BorderRadius.circular(
                                18),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "Total",
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "${notifications.length}",
                                style:
                                const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Container(
                          padding:
                          const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white
                                .withOpacity(.15),
                            borderRadius:
                            BorderRadius.circular(
                                18),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "Belum Dibaca",
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                "$unread",
                                style:
                                const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),

            Expanded(
                child: Padding(
                    padding:
                    const EdgeInsets.all(16),
                    child: Column(
                        children: [
                          /// ==========================
                          /// SEARCH
                          /// ==========================

                          Container(
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.transparent
                                      : Colors.black.withOpacity(.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Cari notifikasi...",
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: theme.colorScheme.primary,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Aktivitas Terbaru",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          Expanded(
                            child: isLoading
                                ? const Center(
                              child:
                              CircularProgressIndicator(),
                            )
                                : notifications.isEmpty
                                ? Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [

                                  Icon(
                                    Icons.notifications_off_outlined,
                                    size: 70,
                                    color: Colors.grey.shade400,
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    "Belum ada notifikasi",
                                    style: TextStyle(
                                      color: theme
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(.6),
                                    ),
                                  ),

                                ],
                              ),
                            )
                                : ListView.builder(
                              itemCount:
                              notifications.length,
                              itemBuilder:
                                  (context, index) {
                                final notif =
                                notifications[index];

                                return _notificationCard(
                                  title:
                                  notif["title"]!,
                                  message:
                                  notif["message"]!,
                                  time:
                                  notif["time"]!,
                                  ticket:
                                  notif["ticket"]!,
                                  status:
                                  notif["status"]!,
                                  type:
                                  notif["type"]!,
                                );
                              },
                            ),
                          ),

                        ],
                    ),
                ),
            ),

              ],
            ),
        ),
    );
  }
  /// ==========================
  /// NOTIFICATION CARD
  /// ==========================

  Widget _notificationCard({
    required String title,
    required String message,
    required String time,
    required String ticket,
    required String status,
    required String type,
  }) {
    final theme = Theme.of(context);

    final color = _getColor(type);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserTicketDetailPage(
              data: {
                "title": message,
                "status": status,
                "date": "05 Juli 2026",
                "category": "Hardware",
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: theme.brightness == Brightness.dark
                  ? Colors.transparent
                  : Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [

            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                _getIcon(type),
                color: color,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    ticket,
                    style: const TextStyle(
                      color: Color(0xff2563EB),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurface
                          .withOpacity(.65),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      _statusBadge(status),

                      const SizedBox(width: 10),

                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface
                              .withOpacity(.65),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: theme.colorScheme.onSurface
                  .withOpacity(.45),
            ),
          ],
        ),
      ),
    );
  }

  /// ==========================
  /// ICON
  /// ==========================

  IconData _getIcon(String type) {
    switch (type) {
      case "create":
        return Icons.add_circle;

      case "update":
        return Icons.sync;

      case "reply":
        return Icons.chat_bubble;

      default:
        return Icons.notifications;
    }
  }

  /// ==========================
  /// COLOR
  /// ==========================

  Color _getColor(String type) {
    switch (type) {
      case "create":
        return Colors.blue;

      case "update":
        return Colors.orange;

      case "reply":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  /// ==========================
  /// STATUS BADGE
  /// ==========================

  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case "Open":
        color = Colors.orange;
        break;

      case "Progress":
        color = Colors.blue;
        break;

      case "Done":
        color = Colors.green;
        break;

      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}