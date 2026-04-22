import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:e_ticketing_helpdesk/features/helpdesk/presentation/pages/helpdesk_ticket_page.dart';
import 'package:e_ticketing_helpdesk/features/notification/presentation/pages/notification_page.dart';
import 'package:e_ticketing_helpdesk/features/helpdesk/presentation/pages/helpdesk_detail_ticket_page.dart';

class HelpdeskDashboardPage extends StatefulWidget {
  const HelpdeskDashboardPage({super.key});

  @override
  State<HelpdeskDashboardPage> createState() => _HelpdeskDashboardPageState();
}

class _HelpdeskDashboardPageState extends State<HelpdeskDashboardPage> {
  final Dio _dio = Dio();

  List<dynamic> tickets = [];
  bool isLoading = true;

  int ditugaskan = 0;
  int mendesak = 0;
  int selesai = 0;

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  Future<void> fetchTickets() async {
    try {
      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/posts',
      );

      final data = response.data as List;

      int open = 0;
      int pending = 0;
      int done = 0;

      final mapped = data.take(5).map((e) {
        final id = e["id"];

        String status;
        Color color;

        if (id % 3 == 0) {
          status = "Kritis";
          color = Colors.red;
          open++;
        } else if (id % 3 == 1) {
          status = "Pending";
          color = Colors.orange;
          pending++;
        } else {
          status = "Selesai";
          color = Colors.green;
          done++;
        }

        return {
          "id": "#TKT-00$id",
          "title": e["title"],
          "status": status,
          "color": color
        };
      }).toList();

      setState(() {
        tickets = mapped;
        ditugaskan = open;
        mendesak = pending;
        selesai = done;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [

            /// 🔥 HEADER (TIDAK DIUBAH)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
              decoration: const BoxDecoration(
                color: Color(0xFF166534),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: Text("BS",
                        style: TextStyle(
                            color: Color(0xFF166534),
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Selamat pagi,",
                            style: TextStyle(color: Colors.white70)),
                        Text("Budi Santoso",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text("Helpdesk",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationPage(),
                        ),
                      );
                    },
                    child:
                    const Icon(Icons.notifications, color: Colors.white),
                  )
                ],
              ),
            ),

            /// 🔥 CONTENT
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text("Tiket Saya Hari Ini",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),

                  const SizedBox(height: 10),

                  /// 🔥 STAT (SUDAH API)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const HelpdeskTicketPage(),
                              ),
                            );
                          },
                          child: _statBox("$ditugaskan", "Ditugaskan",
                              Colors.green),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const HelpdeskTicketPage(),
                              ),
                            );
                          },
                          child: _statBox(
                              "$mendesak", "Mendesak", Colors.orange),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                const HelpdeskTicketPage(),
                              ),
                            );
                          },
                          child: _statBox(
                              "$selesai", "Diselesaikan", Colors.blue),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _statBox("2.4j", "Waktu Respon",
                            Colors.indigo), // tetap
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// TARGET (TIDAK DIUBAH)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Target harian",
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: 0.62,
                          backgroundColor: Colors.grey.shade200,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 6),
                        const Text("62% tercapai — 3 tiket tersisa",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text("Perlu Ditangani Segera",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),

                  const SizedBox(height: 10),

                  /// 🔥 LIST API
                  ...tickets.map((t) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HelpdeskDetailTicketPage(
                              id: t["id"] as String,
                              title: t["title"] as String,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 50,
                              color: t["color"] as Color,
                            ),
                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(t["id"] as String,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text(t["title"] as String),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (t["color"] as Color)
                                          .withOpacity(0.2),
                                      borderRadius:
                                      BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      t["status"] as String,
                                      style: TextStyle(
                                          color:
                                          t["color"] as Color,
                                          fontSize: 11),
                                    ),
                                  )
                                ],
                              ),
                            ),

                            const Text("15 mnt lalu",
                                style: TextStyle(
                                    fontSize: 11, color: Colors.grey))
                          ],
                        ),
                      ),
                    );
                  }).toList()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _statBox(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}