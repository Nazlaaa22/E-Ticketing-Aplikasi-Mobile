import 'package:flutter/material.dart';
import 'create_ticket_page.dart';
import 'detail_ticket_page.dart';
import '../../data/repositories/ticket_repository.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  List<Map<String, String>> tickets = [];
  bool isLoading = true;

  String selectedFilter = "All";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  /// 🔥 LOAD API (FIX: TAMBAH ID)
  void _loadTickets() async {
    try {
      final repo = TicketRepository();
      final data = await repo.getTickets();

      setState(() {
        tickets = data.take(10).map((e) => {
          "id": "TKT-${e["id"]}", // ✅ TAMBAH ID
          "title": e["title"].toString(),
          "desc": e["body"].toString(),
          "status": ["Open", "Progress", "Done"][e["id"] % 3],
        }).toList();

        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  /// 🔍 FILTER + SEARCH
  List<Map<String, String>> get filteredTickets {
    return tickets.where((t) {
      final matchSearch =
      t["title"]!.toLowerCase().contains(searchQuery.toLowerCase());

      final matchFilter =
          selectedFilter == "All" || t["status"] == selectedFilter;

      return matchSearch && matchFilter;
    }).toList();
  }

  /// ➕ TAMBAH TIKET (FIX: TAMBAH ID)
  void _goToCreateTicket() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateTicketPage(),
      ),
    );

    if (result != null) {
      setState(() {
        tickets.add({
          "id": "TKT-${tickets.length + 1}", // ✅ TAMBAH
          "title": result["title"],
          "desc": result["desc"],
          "status": result["status"],
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: Column(
        children: [

          /// 🔵 HEADER
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
                    const Text(
                      "Semua Tiket",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: _goToCreateTicket,
                      icon: const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),

                const SizedBox(height: 12),

                /// 🔍 SEARCH
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search, color: Colors.white),
                      hintText: "Cari tiket...",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() => searchQuery = value);
                    },
                  ),
                ),
              ],
            ),
          ),

          /// 🔥 CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// FILTER
                  Row(
                    children: ["All", "Open", "Progress", "Done"]
                        .map((f) => _filterChip(f))
                        .toList(),
                  ),

                  const SizedBox(height: 12),

                  /// LIST
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredTickets.length,
                      itemBuilder: (context, index) {
                        final data = filteredTickets[index];

                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailTicketPage(
                                  id: data['id']!, // ✅ KIRIM ID
                                  title: data['title']!,
                                  desc: data['desc']!,
                                  status: data['status']!,
                                ),
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                final originalIndex = tickets.indexOf(data);

                                tickets[originalIndex] = {
                                  "id": data["id"]!,
                                  "title": result["title"],
                                  "desc": result["desc"],
                                  "status": result["status"],
                                };
                              });
                            }
                          },
                          child: _ticketCard(
                            id: data['id']!,
                            title: data['title']!,
                            desc: data['desc']!,
                            status: data['status']!,
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 🔘 FILTER CHIP
  Widget _filterChip(String label) {
    final isSelected = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() => selectedFilter = label);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// 🎫 CARD UI (FIX: PAKAI ID)
  Widget _ticketCard({
    required String id,
    required String title,
    required String desc,
    required String status,
  }) {
    final color = _statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                id, // ✅ PAKAI ID BENERAN
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                "Baru saja",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              )
            ],
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: color.withOpacity(0.2),
                    child: Text(
                      title[0],
                      style: TextStyle(color: color, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text("User", style: TextStyle(fontSize: 12)),
                ],
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  /// 🎨 STATUS COLOR
  Color _statusColor(String status) {
    switch (status) {
      case "Open":
        return Colors.orange;
      case "Progress":
        return Colors.blue;
      case "Done":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}