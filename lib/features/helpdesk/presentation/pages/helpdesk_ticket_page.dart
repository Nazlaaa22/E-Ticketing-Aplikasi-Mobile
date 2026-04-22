import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'helpdesk_detail_ticket_page.dart';

class HelpdeskTicketPage extends StatefulWidget {
  const HelpdeskTicketPage({super.key});

  @override
  State<HelpdeskTicketPage> createState() => _HelpdeskTicketPageState();
}

class _HelpdeskTicketPageState extends State<HelpdeskTicketPage> {
  int selectedTab = 0;

  final Dio _dio = Dio();

  List<dynamic> tickets = [];
  bool isLoading = true;

  int aktifCount = 0;
  int selesaiCount = 0;

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

      int aktif = 0;
      int selesai = 0;

      final mapped = data.take(10).map((e) {
        final id = e["id"];

        String status;
        Color color;
        String time = "${id * 2} mnt";

        if (id % 3 == 0) {
          status = "Kritis";
          color = Colors.red;
          aktif++;
        } else if (id % 3 == 1) {
          status = "Pending";
          color = Colors.orange;
          aktif++;
        } else if (id % 5 == 0) {
          status = "Selesai";
          color = Colors.green;
          selesai++;
        } else {
          status = "Open";
          color = Colors.blue;
          aktif++;
        }

        return {
          "id": "#TKT-00$id",
          "title": e["title"],
          "status": status,
          "time": time,
          "color": color
        };
      }).toList();

      setState(() {
        tickets = mapped;
        aktifCount = aktif;
        selesaiCount = selesai;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = selectedTab == 0
        ? tickets.where((t) => t["status"] != "Selesai").toList()
        : tickets.where((t) => t["status"] == "Selesai").toList();

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
                      "Tiket Saya",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.filter_list, color: Colors.white)
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
                      hintText: "Cari tiket...",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// TAB (DINAMIS)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _tabItem("Aktif ($aktifCount)", 0),
                const SizedBox(width: 10),
                _tabItem("Selesai ($selesaiCount)", 1),
              ],
            ),
          ),

          /// LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final t = filtered[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HelpdeskDetailTicketPage(
                          id: t["id"].toString(),
                          title: t["title"].toString(),
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
                            color: t["color"] as Color,
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
                                    t["id"].toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    t["time"].toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),

                              Text(
                                t["title"].toString(),
                                style: const TextStyle(fontSize: 13),
                              ),

                              const SizedBox(height: 8),

                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (t["color"] as Color)
                                          .withOpacity(0.1),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      t["status"].toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:
                                        t["color"] as Color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              HelpdeskDetailTicketPage(
                                                id: t["id"].toString(),
                                                title:
                                                t["title"].toString(),
                                              ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      Colors.green.shade100,
                                      elevation: 0,
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: const Text(
                                      "Update Status",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.green,
                                      ),
                                    ),
                                  )
                                ],
                              )
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

  Widget _tabItem(String text, int index) {
    final isActive = selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF166534) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}