import 'package:flutter/material.dart';
import '../../../ticket/data/repositories/ticket_repository.dart';
import '../../../ticket/presentation/pages/ticket_page.dart';
import '../../../ticket/presentation/pages/create_ticket_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = TicketRepository();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: FutureBuilder(
        future: repo.getTickets(), // 🔥 API
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Gagal load data"));
          }

          final tickets = snapshot.data!;

          final total = tickets.length;

          final open = tickets.where((e) =>
          (e["status"] ?? "").toString().toLowerCase() == "open"
          ).length;

          final done = tickets.where((e) =>
          (e["status"] ?? "").toString().toLowerCase() == "done"
          ).length;

          final pending = tickets.where((e) =>
          (e["status"] ?? "").toString().toLowerCase() == "pending"
          ).length;

          return SingleChildScrollView(
            child: Column(
              children: [

                /// 🔵 HEADER (TIDAK DIUBAH)
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2563EB),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Dashboard",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          const Icon(Icons.notifications, color: Colors.white)
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: const [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.white,
                            child: Text("AD"),
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Selamat pagi,", style: TextStyle(color: Colors.white70)),
                              Text("Admin Sistem",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              SizedBox(height: 4),
                              Text("Administrator",
                                  style: TextStyle(color: Colors.white70, fontSize: 12))
                            ],
                          )
                        ],
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

                      const Text("Ringkasan Tiket",
                          style: TextStyle(fontWeight: FontWeight.bold)),

                      const SizedBox(height: 12),

                      /// 🔥 DATA DARI API (FIXED)
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.4,
                        children: [
                          _statCard(context, "$total", "Total Tiket", Colors.blue, ""),
                          _statCard(context, "$pending", "Open", Colors.orange, ""),
                          _statCard(context, "$done", "Done", Colors.green, ""),
                          _statCard(context, "$open", "Progress", Colors.red, ""),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// CHART (TETAP)
                      const Text("Tiket Masuk — 7 Hari Terakhir",
                          style: TextStyle(fontWeight: FontWeight.bold)),

                      const SizedBox(height: 10),

                      Container(
                        height: 140,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _bar(40, "Sen"),
                            _bar(70, "Sel"),
                            _bar(30, "Rab"),
                            _bar(80, "Kam"),
                            _bar(60, "Jum"),
                            _bar(20, "Sab"),
                            _bar(25, "Min"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text("Aksi Cepat",
                          style: TextStyle(fontWeight: FontWeight.bold)),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _quickAction(context, Icons.add, "Buat\nTiket"),
                          _quickAction(context, Icons.person, "Assign"),
                          _quickAction(context, Icons.check, "Selesaikan"),
                          _quickAction(context, Icons.bar_chart, "Laporan"),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔹 CARD (TIDAK DIUBAH)
  Widget _statCard(BuildContext context, String value, String label, Color color, String badge) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TicketPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Text(badge,
                  style: TextStyle(color: color, fontSize: 10)),
            ),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _bar(double height, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 12,
          height: height.clamp(10, 80),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10))
      ],
    );
  }

  /// 🔥 AKSI CEPAT (TIDAK DIUBAH)
  Widget _quickAction(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label.contains("Buat")) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTicketPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Fitur belum tersedia")),
          );
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon),
          ),
          const SizedBox(height: 6),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12))
        ],
      ),
    );
  }
}