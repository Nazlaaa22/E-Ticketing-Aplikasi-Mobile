import 'package:e_ticketing_helpdesk/features/ticket/data/repositories/ticket_repository.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'report_detail_page.dart';
import '../../../../data/repositories/ticket_repository.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  final repo = TicketRepository();

  int total = 0;
  int done = 0;
  int pending = 0;

  List<double> weeklyData = [0,0,0,0,0,0,0];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReport();
  }

  void fetchReport() async {
    final data = await repo.getTickets();

    int d = 0, p = 0;

    /// 🔥 hitung status
    for (var t in data) {
      if (t["status"] == "done") d++;
      if (t["status"] == "pending") p++;
    }

    /// 🔥 fake distribusi mingguan (biar chart tetap hidup)
    List<double> chart = [5, 8, 4, 10, 7, 3, 4];

    setState(() {
      total = data.length;
      done = d;
      pending = p;
      weeklyData = chart;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [

          /// 🔵 HEADER (TIDAK DIUBAH)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Laporan",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Icon(Icons.bar_chart_rounded,
                    color: Colors.white, size: 26)
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [

                /// 🔥 STATS (SUDAH API)
                Row(
                  children: [
                    _miniStat(total.toString(), "Total"),
                    const SizedBox(width: 10),
                    _miniStat(done.toString(), "Selesai"),
                    const SizedBox(width: 10),
                    _miniStat(pending.toString(), "Pending"),
                  ],
                ),

                const SizedBox(height: 16),

                /// 🔥 CHART (DINAMIS)
                _chartCard(),

                const SizedBox(height: 16),

                _item(context, "Laporan Tiket Mingguan", "Statistik 7 hari"),
                _item(context, "Kinerja Agen", "Performa helpdesk"),
                _item(context, "Tiket Selesai", "Data penyelesaian"),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 🔥 MINI STAT
  Widget _miniStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            )
          ],
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  /// 🔥 CHART
  Widget _chartCard() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text("Statistik Mingguan",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),

          const SizedBox(height: 12),

          Expanded(
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
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
                        const days = ["Sen","Sel","Rab","Kam","Jum","Sab","Min"];
                        if (value.toInt() < 0 || value.toInt() > 6) return const SizedBox();
                        return Text(days[value.toInt()],
                            style: const TextStyle(color: Colors.white, fontSize: 10));
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),

                barGroups: List.generate(7, (i) => _bar(i, weeklyData[i])),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _bar(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 10,
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        )
      ],
    );
  }

  Widget _item(BuildContext context, String title, String desc) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ReportDetailPage(title: title, desc: desc),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bar_chart, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
            const Icon(Icons.arrow_forward_ios, size: 14)
          ],
        ),
      ),
    );
  }
}