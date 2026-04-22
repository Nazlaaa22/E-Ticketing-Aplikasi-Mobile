import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../../ticket/presentation/pages/user_ticket_detail_page.dart';
import '../../../ticket/presentation/pages/user_create_ticket_page.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  final Dio _dio = Dio();

  List<Map<String, dynamic>> tickets = [];
  bool isLoading = true;

  int total = 0;
  int open = 0;
  int pending = 0;
  int done = 0;

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

      final mapped = data.take(10).map<Map<String, dynamic>>((e) {
        final id = e["id"];

        String status;
        if (id % 3 == 0) {
          status = "Open";
        } else if (id % 3 == 1) {
          status = "Pending";
        } else {
          status = "Done";
        }

        return {
          "title": e["title"],
          "status": status,
        };
      }).toList();

      // HITUNG STAT (biar tetep masuk ke UI lama)
      total = mapped.length;
      open = mapped.where((e) => e["status"] == "Open").length;
      pending = mapped.where((e) => e["status"] == "Pending").length;
      done = mapped.where((e) => e["status"] == "Done").length;

      setState(() {
        tickets = mapped;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              /// 🔥 HEADER (TIDAK DIUBAH)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Selamat datang,",
                            style: TextStyle(color: Colors.white70)),
                        SizedBox(height: 4),
                        Text(
                          "Nazlatul Khoiriyah",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text("NK"),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 📊 STATS (CUMA VALUE YG DINAMIS)
              Row(
                children: [
                  _statCard("$total", "Total", Colors.blue, isRight: true),
                  _statCard("$pending", "Menunggu", Colors.orange),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _statCard("$done", "Selesai", Colors.green, isRight: true),
                  _statCard("$open", "Ditolak", Colors.red),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔥 BUAT ADUAN (TIDAK DIUBAH)
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UserCreateTicketPage(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Buat Aduan Baru",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Laporkan masalah kamu ke helpdesk",
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 16)
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Tiket Terbaru",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 10),

              /// LIST (DINAMIS)
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                  children: tickets
                      .map((e) => _ticketItem(
                    context,
                    title: e["title"],
                    status: e["status"],
                  ))
                      .toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// STAT CARD (TIDAK DIUBAH)
  Widget _statCard(String value, String label, Color color,
      {bool isRight = false}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: isRight ? 10 : 0),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  /// ITEM TIKET (TIDAK DIUBAH)
  Widget _ticketItem(
      BuildContext context, {
        required String title,
        required String status,
      }) {
    Color color;

    switch (status) {
      case "Open":
        color = Colors.orange;
        break;
      case "Pending":
        color = Colors.blue;
        break;
      case "Done":
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UserTicketDetailPage(
              data: {
                "title": title,
                "status": status,
                "date": "20 Apr 2026",
                "category": "IT Support",
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(color: color, fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}