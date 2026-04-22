import 'package:flutter/material.dart';

class ReportDetailPage extends StatelessWidget {
  final String title;
  final String desc;

  const ReportDetailPage({
    super.key,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TITLE
            Text(title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            Text(desc, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 20),

            /// DATA DETAIL
            _data("Total Tiket", "120"),
            _data("Selesai", "90"),
            _data("Pending", "20"),
            _data("Ditolak", "10"),

            const SizedBox(height: 20),

            /// NOTE
            const Text(
              "Catatan:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              "Performa meningkat dibanding minggu lalu.",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _data(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}