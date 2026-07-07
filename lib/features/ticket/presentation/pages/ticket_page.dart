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
  final TicketRepository _repository = TicketRepository();

  List<Map<String, String>> tickets = [];

  bool isLoading = true;

  String selectedFilter = "All";
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    setState(() => isLoading = true);

    try {
      final data = await _repository.getTickets();

      tickets = data.map<Map<String, String>>((e) {
        return {
          "id": e["id"].toString(),
          "code": "TKT-${e["id"]}",
          "title": e["title"].toString(),
          "desc": e["description"].toString(),
          "status": e["status"].toString(),
          "created_at": e["created_at"]?.toString() ?? "",
        };
      }).toList();
    } catch (e) {
      debugPrint(e.toString());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, String>> get filteredTickets {
    return tickets.where((ticket) {
      final matchSearch = ticket["title"]!
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchFilter =
          selectedFilter == "All" ||
              ticket["status"] == selectedFilter;

      return matchSearch && matchFilter;
    }).toList();
  }

  Future<void> _goToCreateTicket() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateTicketPage(),
      ),
    );

    if (result == true) {
      _loadTickets();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [

      /// HEADER
      Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        50,
        16,
        20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF2563EB),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [

              const Text(
                "Semua Tiket",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              IconButton(
                onPressed: _goToCreateTicket,
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: TextField(
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                hintText: "Cari tiket...",
                hintStyle: TextStyle(
                  color: Colors.white70,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
        ],
      ),
    ),
          /// CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// FILTER
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        "All",
                        "Open",
                        "Progress",
                        "Done",
                      ].map((e) => _filterChip(e)).toList(),
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// LIST TICKET
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _loadTickets,
                      child: ListView.builder(
                        itemCount: filteredTickets.length,
                        itemBuilder: (context, index) {

                          final ticket = filteredTickets[index];

                          return GestureDetector(
                            onTap: () async {

                              final result =
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailTicketPage(
                                    id: ticket["id"]!,
                                    title: ticket["title"]!,
                                    desc: ticket["desc"]!,
                                    status: ticket["status"]!,
                                  ),
                                ),
                              );

                              if (result == true) {
                                _loadTickets();
                              }
                            },

                            child: _ticketCard(
                              id: ticket["id"]!,
                              code: ticket["code"]!,
                              title: ticket["title"]!,
                              desc: ticket["desc"]!,
                              status: ticket["status"]!,
                              createdAt:
                              ticket["created_at"]!,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ==========================
  /// FILTER CHIP
  /// ==========================
  Widget _filterChip(String label) {
    final theme = Theme.of(context);

    final selected = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },

      child: Container(
        margin: const EdgeInsets.only(right: 8),

        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),

        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF2563EB)
              : theme.cardColor,

          borderRadius: BorderRadius.circular(20),
        ),

        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
  /// ==========================
  /// TICKET CARD
  /// ==========================
  Widget _ticketCard({
    required String id,
    required String code,
    required String title,
    required String desc,
    required String status,
    required String createdAt,
  }) {
    final theme = Theme.of(context);
    final color = _statusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                code,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),

              Text(
                _timeAgo(createdAt),
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),

            ],
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            desc,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [

                  CircleAvatar(
                    radius: 13,
                    backgroundColor: color.withOpacity(.15),
                    child: Text(
                      title[0].toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Text(
                    "User",
                    style: TextStyle(fontSize: 12),
                  ),

                ],
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }

  /// ==========================
  /// TIME AGO
  /// ==========================
  String _timeAgo(String createdAt) {
    if (createdAt.isEmpty) return "-";

    try {
      final date = DateTime.parse(createdAt).toLocal();
      final diff = DateTime.now().difference(date);

      if (diff.inSeconds < 60) return "Baru saja";
      if (diff.inMinutes < 60) return "${diff.inMinutes} menit lalu";
      if (diff.inHours < 24) return "${diff.inHours} jam lalu";
      if (diff.inDays == 1) return "Kemarin";
      if (diff.inDays < 7) return "${diff.inDays} hari lalu";
      if (diff.inDays < 30) return "${(diff.inDays / 7).floor()} minggu lalu";

      return "${date.day}/${date.month}/${date.year}";
    } catch (_) {
      return "-";
    }
  }
  /// ==========================
  /// STATUS COLOR
  /// ==========================
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