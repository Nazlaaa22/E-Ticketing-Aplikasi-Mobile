import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:e_ticketing_helpdesk/features/helpdesk/presentation/pages/helpdesk_ticket_page.dart';
import 'package:e_ticketing_helpdesk/features/helpdesk/presentation/pages/helpdesk_detail_ticket_page.dart';
import 'package:e_ticketing_helpdesk/features/notification/presentation/pages/helpdesk_notification_page.dart';

class HelpdeskDashboardPage extends StatefulWidget {
  const HelpdeskDashboardPage({super.key});

  @override
  State<HelpdeskDashboardPage> createState() =>
      _HelpdeskDashboardPageState();
}

class _HelpdeskDashboardPageState
    extends State<HelpdeskDashboardPage> {
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
        "https://jsonplaceholder.typicode.com/posts",
      );

      final data = response.data as List;

      int open = 0;
      int urgent = 0;
      int done = 0;

      final mapped = data.take(6).map((e) {
        final id = e["id"];

        String status;
        Color color;

        if (id % 3 == 0) {
          status = "Urgent";
          color = Colors.red;
          urgent++;
        } else if (id % 3 == 1) {
          status = "Progress";
          color = Colors.orange;
          open++;
        } else {
          status = "Done";
          color = Colors.green;
          done++;
        }

        return {
          "id": "#TKT-$id",
          "title": e["title"],
          "status": status,
          "color": color,
        };
      }).toList();

      setState(() {
        tickets = mapped;
        ditugaskan = open;
        mendesak = urgent;
        selesai = done;
        isLoading = false;
      });
    } catch (_) {
      setState(() {
        isLoading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

            /// HEADER
            Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff166534),
                  Color(0xff22C55E),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [

                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.support_agent,
                    color: Color(0xff166534),
                    size: 30,
                  ),
                ),

                const SizedBox(width: 16),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Selamat Datang 👋",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        "Budi Santoso",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        "Helpdesk Support",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const HelpdeskNotificationPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            "Ringkasan Hari Ini",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [

              Expanded(
                child: _statBox(
                  "$ditugaskan",
                  "Assigned",
                  Colors.blue,
                  Icons.assignment,
                  isDark,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _statBox(
                  "$mendesak",
                  "Urgent",
                  Colors.red,
                  Icons.priority_high,
                  isDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              Expanded(
                child: _statBox(
                  "$selesai",
                  "Done",
                  Colors.green,
                  Icons.check_circle,
                  isDark,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _statBox(
                  "2.4j",
                  "Response",
                  Colors.orange,
                  Icons.timer,
                  isDark,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  "Target Hari Ini",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(20),
                  child: const LinearProgressIndicator(
                    value: .65,
                    minHeight: 10,
                    color: Color(0xff22C55E),
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "65% target telah tercapai",
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            "Ticket Terbaru",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),
                  ...tickets.map((t) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HelpdeskDetailTicketPage(
                              id: t["id"],
                              title: t["title"],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
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
                              width: 6,
                              height: 70,
                              decoration: BoxDecoration(
                                color: t["color"],
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [

                                      Text(
                                        t["id"],
                                        style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold,
                                          color: theme.colorScheme
                                              .onSurface,
                                        ),
                                      ),

                                      const Spacer(),

                                      Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: (t["color"] as Color)
                                              .withOpacity(.12),
                                          borderRadius:
                                          BorderRadius.circular(
                                              30),
                                        ),
                                        child: Text(
                                          t["status"],
                                          style: TextStyle(
                                            color: t["color"],
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  Text(
                                    t["title"],
                                    maxLines: 2,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight:
                                      FontWeight.w600,
                                      color: theme.colorScheme
                                          .onSurface,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Row(
                                    children: [

                                      const Icon(
                                        Icons.schedule,
                                        size: 16,
                                        color: Colors.grey,
                                      ),

                                      const SizedBox(width: 4),

                                      Text(
                                        "15 menit yang lalu",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: theme
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(.6),
                                        ),
                                      ),

                                      const Spacer(),

                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                        color: theme.colorScheme
                                            .onSurface
                                            .withOpacity(.5),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.assignment),
                      label: const Text(
                        "Lihat Semua Ticket",
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xff166534),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                            const HelpdeskTicketPage(),
                          ),
                        );
                      },
                    ),
                  ),

                ],
            ),
          ),
        ),
    );
  }
  Widget _statBox(
      String value,
      String label,
      Color color,
      IconData icon,
      bool isDark,
      ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.transparent
                : Colors.black.withOpacity(.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [

          CircleAvatar(
            radius: 22,
            backgroundColor: color.withOpacity(.12),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(.7),
            ),
          ),

        ],
      ),
    );
  }
}