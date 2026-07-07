import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../ticket/data/repositories/ticket_repository.dart';
import 'report_detail_page.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TicketRepository repo = TicketRepository();

  int total = 0;
  int done = 0;
  int progress = 0;

  List<double> weeklyData = List.filled(7, 0);

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReport();
  }

  Future<void> fetchReport() async {
    try {
      final tickets = await repo.getTickets();

      int selesai = 0;
      int proses = 0;

      for (var item in tickets) {
        final status = item["status"]
            .toString()
            .trim()
            .toLowerCase();

        if (status == "done") {
          selesai++;
        } else if (status == "progress") {
          proses++;
        }
      }

      final weekly = await repo.getWeeklyChart();

      List<double> chart = List.filled(7, 0);

      for (var item in weekly) {
        final day = item["day"].toString();
        final count = (item["count"] as num).toDouble();

        switch (day) {
          case "Mon":
            chart[0] = count;
            break;
          case "Tue":
            chart[1] = count;
            break;
          case "Wed":
            chart[2] = count;
            break;
          case "Thu":
            chart[3] = count;
            break;
          case "Fri":
            chart[4] = count;
            break;
          case "Sat":
            chart[5] = count;
            break;
          case "Sun":
            chart[6] = count;
            break;
        }
      }

      if (!mounted) return;

      setState(() {
        total = tickets.length;
        done = selesai;
        progress = proses;
        weeklyData = chart;
        isLoading = false;
      });
    } catch (e) {
      debugPrint("REPORT ERROR : $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
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
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [

              /// ================= HEADER =================

              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff2563EB),
                      Color(0xff3B82F6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                Row(
                children: [

                const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Laporan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      "Statistik Helpdesk E-Ticketing",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),

                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),

            ],
          ),

          const SizedBox(height: 24),
                    Row(
                      children: [

                        Expanded(
                          child: _statCard(
                            context,
                            total.toString(),
                            "Total",
                            Icons.confirmation_number,
                            Colors.blue,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _statCard(
                            context,
                            done.toString(),
                            "Done",
                            Icons.check_circle,
                            Colors.green,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _statCard(
                            context,
                            progress.toString(),
                            "Progress",
                            Icons.schedule,
                            Colors.orange,
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 22),

              /// ================= GRAFIK =================

              _chartCard(),

              const SizedBox(height: 24),

              /// ================= MENU =================

              _menuCard(
                context,
                icon: Icons.analytics_outlined,
                title: "Laporan Tiket Mingguan",
                subtitle: "Jumlah tiket dalam 7 hari terakhir",
              ),

              _menuCard(
                context,
                icon: Icons.people_alt_outlined,
                title: "Kinerja Helpdesk",
                subtitle: "Performa agen helpdesk",
              ),

              _menuCard(
                context,
                icon: Icons.task_alt,
                title: "Tiket Selesai",
                subtitle: "Riwayat penyelesaian tiket",
              ),

              _menuCard(
                context,
                icon: Icons.picture_as_pdf,
                title: "Export Laporan",
                subtitle: "Unduh laporan PDF",
              ),

              const SizedBox(height: 30),

            ],
          ),
        ),
    );
  }
  //==================================================
  // CARD STATISTIK
  //==================================================

  Widget _statCard(
      BuildContext context,
      String value,
      String title,
      IconData icon,
      Color color,
      ) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.transparent
                : Colors.black.withValues(alpha: .05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [

          CircleAvatar(
            radius: 20,
            backgroundColor: color.withValues(alpha: .12),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: .70),
              fontSize: 12,
            ),
          ),

        ],
      ),
    );
  }

  //==================================================
  // MENU CARD
  //==================================================

  Widget _menuCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
      }) {

    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReportDetailPage(
              title: title,
              desc: subtitle,
            ),
          ),
        );
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: theme.brightness == Brightness.dark
                  ? Colors.transparent
                  : Colors.black.withValues(alpha: .05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Row(
          children: [

            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.withValues(alpha: .10),
              child: Icon(
                icon,
                color: Colors.blue,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: .70),
                      fontSize: 12,
                    ),
                  ),

                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),

          ],
        ),
      ),
    );
  }
  //==================================================
  // WEEKLY CHART
  //==================================================

  Widget _chartCard() {
    final theme = Theme.of(context);

    double maxValue = weeklyData.isEmpty
        ? 5
        : weeklyData.reduce((a, b) => a > b ? a : b);

    if (maxValue < 5) maxValue = 5;

    return Container(
      height: 270,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff2563EB),
            Color(0xff60A5FA),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.transparent
                : Colors.blue.withValues(alpha: .25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Grafik Tiket Mingguan",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Data diambil dari database",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: BarChart(
              BarChartData(
                maxY: maxValue + 2,
                alignment: BarChartAlignment.spaceAround,

                borderData: FlBorderData(show: false),

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white24,
                      strokeWidth: 1,
                    );
                  },
                ),

                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {

                        const days = [
                          "Sen",
                          "Sel",
                          "Rab",
                          "Kam",
                          "Jum",
                          "Sab",
                          "Min",
                        ];

                        if (value.toInt() < 0 ||
                            value.toInt() >= days.length) {
                          return const SizedBox();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            days[value.toInt()],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                barGroups: List.generate(
                  weeklyData.length,
                      (index) => _bar(
                    index,
                    weeklyData[index],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _bar(
      int x,
      double y,
      ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 16,
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }
}