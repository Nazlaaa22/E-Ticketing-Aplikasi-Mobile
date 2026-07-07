import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'user_ticket_detail_page.dart';

class UserTicketPage extends StatefulWidget {
  const UserTicketPage({super.key});

  @override
  State<UserTicketPage> createState() => _UserTicketPageState();
}

class _UserTicketPageState extends State<UserTicketPage> {
  final Dio _dio = Dio();

  final TextEditingController _searchController =
  TextEditingController();

  List<Map<String, String>> tickets = [];
  List<Map<String, String>> filteredTickets = [];

  bool isLoading = true;

  String selectedFilter = "All";

  @override
  void initState() {
    super.initState();

    fetchTickets();

    _searchController.addListener(_searchTicket);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchTickets() async {
    try {
      final response = await _dio.get(
        "https://jsonplaceholder.typicode.com/posts",
      );

      final data = response.data as List;

      tickets = data.take(20).map<Map<String, String>>((e) {
        final id = e["id"];

        String status;

        if (id % 3 == 0) {
          status = "Open";
        } else if (id % 3 == 1) {
          status = "Progress";
        } else {
          status = "Done";
        }

        return {
          "ticket": "TK-${id.toString().padLeft(3, "0")}",
          "title": e["title"],
          "description": e["body"],
          "status": status,
          "category": id % 2 == 0
              ? "Hardware"
              : "Jaringan",
          "date": "05 Juli 2026",
        };
      }).toList();

      filteredTickets = List.from(tickets);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _changeFilter(String value) {
    selectedFilter = value;
    _searchTicket();
  }

  void _searchTicket() {
    final keyword =
    _searchController.text.toLowerCase();

    List<Map<String, String>> result = tickets;

    if (selectedFilter != "All") {
      result = result
          .where(
            (e) => e["status"] == selectedFilter,
      )
          .toList();
    }

    if (keyword.isNotEmpty) {
      result = result.where((e) {
        return e["title"]!
            .toLowerCase()
            .contains(keyword) ||
            e["ticket"]!
                .toLowerCase()
                .contains(keyword) ||
            e["category"]!
                .toLowerCase()
                .contains(keyword);
      }).toList();
    }

    setState(() {
      filteredTickets = result;
    });
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
        backgroundColor:
        isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FB),

        body: SafeArea(
            child: Column(
              children: [

              // ==========================
              // HEADER
              // ==========================

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
                    Color(0xFF4F8CFF),
                    Color(0xFF2563EB),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Tiket Saya",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Lihat seluruh tiket yang pernah kamu buat",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                  const SizedBox(height: 22),

                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      borderRadius:
                      BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [

                        Container(
                          width: 54,
                          height: 54,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.confirmation_number,
                            color: Color(0xFF2563EB),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "Total Tiket",
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "${tickets.length}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 28,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white70,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        children: [
                          // ==========================
                          // SEARCH
                          // ==========================

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
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: "Cari tiket...",
                                prefixIcon: const Icon(Icons.search),
                                border: InputBorder.none,
                                contentPadding:
                                const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // ==========================
                          // FILTER
                          // ==========================

                          SizedBox(
                            height: 42,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [

                                _filterChip("All"),

                                const SizedBox(width: 8),

                                _filterChip("Open"),

                                const SizedBox(width: 8),

                                _filterChip("Progress"),

                                const SizedBox(width: 8),

                                _filterChip("Done"),

                              ],
                            ),
                          ),

                          const SizedBox(height: 18),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Daftar Tiket",
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
                                : filteredTickets.isEmpty
                                ? const Center(
                              child: Text(
                                "Belum ada tiket.",
                              ),
                            )
                                : ListView.builder(
                              itemCount:
                              filteredTickets.length,
                              itemBuilder:
                                  (context, index) {
                                return _ticketCard(
                                  filteredTickets[
                                  index],
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
  // ==========================
  // FILTER CHIP
  // ==========================

  Widget _filterChip(String label) {
    final theme = Theme.of(context);
    final bool active = selectedFilter == label;

    return ChoiceChip(
      label: Text(label),
      selected: active,
      showCheckmark: false,
      backgroundColor: theme.cardColor,
      selectedColor: const Color(0xFF2563EB).withOpacity(.15),
      labelStyle: TextStyle(
        color: active
            ? const Color(0xFF2563EB)
            : theme.colorScheme.onSurface,
        fontWeight:
        active ? FontWeight.bold : FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      onSelected: (_) => _changeFilter(label),
    );
  }

  // ==========================
  // TICKET CARD
  // ==========================

  Widget _ticketCard(Map<String, String> data) {
    final theme = Theme.of(context);

    final status = data["status"] ?? "";
    final category = data["category"] ?? "";

    IconData icon =
    category == "Hardware"
        ? Icons.computer
        : Icons.wifi;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                UserTicketDetailPage(data: data),
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
              color: theme.brightness ==
                  Brightness.dark
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
                color:
                _statusColor(status).withOpacity(.12),
                borderRadius:
                BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: _statusColor(status),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    data["ticket"] ?? "-",
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    data["title"] ?? "-",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                      theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      _statusBadge(status),

                      const SizedBox(width: 8),

                      Icon(
                        Icons.category,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme
                              .colorScheme.onSurface
                              .withOpacity(.65),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [

                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        data["date"] ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          color: theme
                              .colorScheme.onSurface
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

  // ==========================
  // STATUS COLOR
  // ==========================

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

  // ==========================
  // STATUS BADGE
  // ==========================

  Widget _statusBadge(String status) {
    final color = _statusColor(status);

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
