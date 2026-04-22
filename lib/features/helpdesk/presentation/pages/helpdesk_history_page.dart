import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'helpdesk_history_detail_page.dart';

class HelpdeskHistoryPage extends StatefulWidget {
  const HelpdeskHistoryPage({super.key});

  @override
  State<HelpdeskHistoryPage> createState() => _HelpdeskHistoryPageState();
}

class _HelpdeskHistoryPageState extends State<HelpdeskHistoryPage> {
  final Dio _dio = Dio();

  List<dynamic> history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      final response = await _dio.get(
        'https://jsonplaceholder.typicode.com/posts',
      );

      final data = response.data as List;

      final mapped = data.take(10).map((e) {
        final id = e["id"];

        return {
          "id": "#TKT-00$id",
          "title": e["title"],
          "status": "Selesai",
          "time": "${id} hari lalu",
          "color": Colors.green
        };
      }).toList();

      setState(() {
        history = mapped;
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
          : Column(
        children: [

          /// HEADER (TIDAK DIUBAH)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF166534),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Riwayat Tiket",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.history, color: Colors.white)
                  ],
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Cari riwayat...",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// LIST (DARI API)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final h = history[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HelpdeskHistoryDetailPage(
                          id: h["id"].toString(),
                          title: h["title"].toString(),
                          status: h["status"].toString(),
                          time: h["time"].toString(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [

                        Container(
                          width: 4,
                          height: 60,
                          decoration: BoxDecoration(
                            color: h["color"] as Color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    h["id"].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    h["time"].toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),

                              Text(
                                h["title"].toString(),
                                style:
                                const TextStyle(fontSize: 13),
                              ),

                              const SizedBox(height: 8),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (h["color"] as Color)
                                      .withOpacity(0.1),
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                                child: Text(
                                  h["status"].toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                    h["color"] as Color,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}