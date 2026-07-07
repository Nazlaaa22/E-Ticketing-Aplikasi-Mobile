import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../../ticket/presentation/pages/user_create_ticket_page.dart';
import '../../../ticket/presentation/pages/user_ticket_detail_page.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() =>
      _UserDashboardPageState();
}

class _UserDashboardPageState
    extends State<UserDashboardPage> {

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
        "https://jsonplaceholder.typicode.com/posts",
      );

      final data = response.data as List;

      final mapped =
      data.take(8).map<Map<String, dynamic>>((e) {

        final id = e["id"];

        String status;
        Color color;
        IconData icon;

        if (id % 4 == 0) {
          status = "Open";
          color = Colors.orange;
          icon = Icons.schedule;
        } else if (id % 4 == 1) {
          status = "Progress";
          color = Colors.blue;
          icon = Icons.sync;
        } else if (id % 4 == 2) {
          status = "Done";
          color = Colors.green;
          icon = Icons.check_circle;
        } else {
          status = "Rejected";
          color = Colors.red;
          icon = Icons.cancel;
        }

        return {
          "title": e["title"],
          "status": status,
          "color": color,
          "icon": icon,
        };
      }).toList();

      total = mapped.length;

      open =
          mapped.where((e) => e["status"] == "Open").length;

      pending =
          mapped.where((e) => e["status"] == "Progress").length;

      done =
          mapped.where((e) => e["status"] == "Done").length;

      setState(() {
        tickets = mapped;
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
        body: SafeArea(
          child: isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

            /// =========================
            /// HEADER
            /// =========================

            Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xff2563EB),
                  Color(0xff60A5FA),
                ],
              ),
              borderRadius:
              BorderRadius.circular(24),
            ),
            child: Row(
              children: [

                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      "NK",
                      style: TextStyle(
                        color: Color(0xff2563EB),
                        fontWeight:
                        FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
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
                        "Nazlatul Khoiriyah",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                          FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        "User",
                        style: TextStyle(
                          color: Colors.white70,
                        ),
                      ),

                    ],
                  ),
                ),

                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            "Ringkasan Tiket",
            style: theme.textTheme.titleLarge
                ?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [

              Expanded(
                child: _statCard(
                  "$total",
                  "Total",
                  Colors.blue,
                  Icons.confirmation_number,
                  isDark,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _statCard(
                  "$pending",
                  "Progress",
                  Colors.orange,
                  Icons.schedule,
                  isDark,
                ),
              ),

            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              Expanded(
                child: _statCard(
                  "$done",
                  "Done",
                  Colors.green,
                  Icons.check_circle,
                  isDark,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _statCard(
                  "$open",
                  "Open",
                  Colors.red,
                  Icons.warning,
                  isDark,
                ),
              ),

            ],
          ),

          const SizedBox(height: 26),

          Text(
            "Quick Action",
            style: theme.textTheme.titleMedium
                ?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [

              Expanded(
                child: _quickAction(
                  icon: Icons.add_circle,
                  title: "Buat Aduan",
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const UserCreateTicketPage(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _quickAction(
                  icon: Icons.history,
                  title: "Riwayat",
                  color: Colors.green,
                  onTap: () {},
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _quickAction(
                  icon: Icons.support_agent,
                  title: "Helpdesk",
                  color: Colors.orange,
                  onTap: () {},
                ),
              ),

            ],
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius:
              BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.transparent
                      : Colors.black.withOpacity(.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  "Progress Ticket",
                  style: theme.textTheme.titleMedium
                      ?.copyWith(
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 14),

                ClipRRect(
                  borderRadius:
                  BorderRadius.circular(20),
                  child:
                  const LinearProgressIndicator(
                    value: .72,
                    minHeight: 10,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "72% tiket telah diproses",
                  style: TextStyle(
                    color: theme.colorScheme
                        .onSurface
                        .withOpacity(.7),
                  ),
                ),

              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            "Ticket Terbaru",
            style: theme.textTheme.titleMedium
                ?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),
                  ...tickets.map((e) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserTicketDetailPage(
                              data: {
                                "title": e["title"],
                                "status": e["status"],
                                "date": "20 Apr 2026",
                                "category": "IT Support",
                              },
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
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: (e["color"] as Color)
                                    .withOpacity(.12),
                                borderRadius:
                                BorderRadius.circular(16),
                              ),
                              child: Icon(
                                e["icon"] as IconData,
                                color: e["color"] as Color,
                                size: 28,
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    e["title"],
                                    maxLines: 2,
                                    overflow:
                                    TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                      color: theme.colorScheme
                                          .onSurface,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  Row(
                                    children: [

                                      Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: (e["color"]
                                          as Color)
                                              .withOpacity(.12),
                                          borderRadius:
                                          BorderRadius.circular(
                                              30),
                                        ),
                                        child: Text(
                                          e["status"],
                                          style: TextStyle(
                                            color: e["color"]
                                            as Color,
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      Text(
                                        "20 Apr 2026",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: theme
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(.6),
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
                                  .withOpacity(.5),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.list_alt),
                      label: const Text(
                        "Lihat Semua Ticket",
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xff2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),

                  const SizedBox(height: 30),

                ],
            ),
          ),
        ),
        );
    }
  /// =========================
  /// STAT CARD
  /// =========================

  Widget _statCard(
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
            ),
          ),

          const SizedBox(height: 12),

          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            label,
            style: TextStyle(
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

  /// =========================
  /// QUICK ACTION
  /// =========================

  Widget _quickAction({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark =
        theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 18,
          ),
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
          child: Column(
            children: [

              CircleAvatar(
                radius: 22,
                backgroundColor:
                color.withOpacity(.12),
                child: Icon(
                  icon,
                  color: color,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}