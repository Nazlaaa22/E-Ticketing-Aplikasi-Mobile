import 'package:flutter/material.dart';
import '../../../ticket/data/repositories/ticket_repository.dart';

class ReportDetailPage extends StatefulWidget {
  final String title;
  final String desc;

  const ReportDetailPage({
    super.key,
    required this.title,
    required this.desc,
  });

  @override
  State<ReportDetailPage> createState() =>
      _ReportDetailPageState();
}

class _ReportDetailPageState
    extends State<ReportDetailPage> {

  final TicketRepository repo = TicketRepository();

  bool isLoading = true;

  Map<String, dynamic> weeklyReport = {};

  List<dynamic> doneTickets = [];

  List<dynamic> helpdeskReport = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {

      if (widget.title == "Laporan Tiket Mingguan") {

        weeklyReport =
        await repo.getWeeklyReport();

      }

      else if (widget.title ==
          "Kinerja Helpdesk") {

        helpdeskReport =
        await repo.getHelpdeskReport();

      }

      else if (widget.title ==
          "Tiket Selesai") {

        doneTickets =
        await repo.getDoneReport();

      }

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

    } catch (e) {

      debugPrint(e.toString());

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
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            /// ==========================
            /// HEADER
            /// ==========================

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff2563EB),
                    Color(0xff3B82F6),
                  ],
                ),
                borderRadius:
                BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight:
                      FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    widget.desc,
                    style: const TextStyle(
                      color: Colors.white70,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 22),

            if (widget.title ==
                "Laporan Tiket Mingguan")
              _weeklySection(),

            if (widget.title ==
                "Kinerja Helpdesk")
              _helpdeskSection(),

            if (widget.title ==
                "Tiket Selesai")
              _doneSection(),

            if (widget.title ==
                "Export Laporan")
              _exportSection(),

          ],
        ),
      ),
    );
  }
  //==================================================
  // LAPORAN MINGGUAN
  //==================================================

  Widget _weeklySection() {
    return Column(
      children: [

        Row(
          children: [

            Expanded(
              child: _infoCard(
                "Total",
                "${weeklyReport["total"] ?? 0}",
                Icons.confirmation_number,
                Colors.blue,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _infoCard(
                "Done",
                "${weeklyReport["done"] ?? 0}",
                Icons.check_circle,
                Colors.green,
              ),
            ),

          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [

            Expanded(
              child: _infoCard(
                "Progress",
                "${weeklyReport["progress"] ?? 0}",
                Icons.schedule,
                Colors.orange,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _infoCard(
                "Open",
                "${weeklyReport["open"] ?? 0}",
                Icons.warning_amber,
                Colors.red,
              ),
            ),

          ],
        ),

        const SizedBox(height: 24),

        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Tiket Terbaru",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 12),

        ...(weeklyReport["tickets"] ?? []).map<Widget>((ticket) {

          return _ticketCard(
            ticket["title"],
            ticket["status"],
            ticket["category"],
          );

        }).toList(),

      ],
    );
  }

  //==================================================
  // KINERJA HELPDESK
  //==================================================

  Widget _helpdeskSection() {
    return Column(
      children: helpdeskReport.map<Widget>((item) {

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              Text(
                item["assigned_to"]?.toString() ??
                    "Belum Assigned",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [

                  Expanded(
                    child: _smallItem(
                      "Total",
                      "${item["total"]}",
                    ),
                  ),

                  Expanded(
                    child: _smallItem(
                      "Done",
                      "${item["done"]}",
                    ),
                  ),

                  Expanded(
                    child: _smallItem(
                      "Progress",
                      "${item["progress"]}",
                    ),
                  ),

                ],
              )

            ],
          ),
        );

      }).toList(),
    );
  }

  //==================================================
  // TIKET DONE
  //==================================================

  Widget _doneSection() {
    return Column(
      children: doneTickets.map<Widget>((ticket) {

        return _ticketCard(
          ticket["title"],
          "Done",
          ticket["category"],
        );

      }).toList(),
    );
  }

  //==================================================
  // EXPORT
  //==================================================

  Widget _exportSection() {
    return Column(
      children: [

        const SizedBox(height: 40),

        const Icon(
          Icons.picture_as_pdf,
          size: 90,
          color: Colors.red,
        ),

        const SizedBox(height: 20),

        const Text(
          "Export Laporan PDF",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 10),

        const Text(
          "Download seluruh laporan tiket dalam bentuk PDF.",
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.download),
            label: const Text("Download PDF"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
              onPressed: () async {

                final url = await repo.exportPdf();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Membuka PDF..."),
                  ),
                );

              }
          ),
        )

      ],
    );
  }
  //==================================================
  // CARD RINGKASAN
  //==================================================

  Widget _infoCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
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

          const SizedBox(height: 10),

          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  //==================================================
  // TICKET CARD
  //==================================================

  Widget _ticketCard(
      String title,
      String status,
      String category,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [

          CircleAvatar(
            radius: 22,
            backgroundColor:
            Colors.blue.withOpacity(.12),
            child: const Icon(
              Icons.confirmation_number,
              color: Colors.blue,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  category,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color:
              _statusColor(status).withOpacity(.12),
              borderRadius:
              BorderRadius.circular(30),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: _statusColor(status),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        ],
      ),
    );
  }

  //==================================================
  // SMALL ITEM
  //==================================================

  Widget _smallItem(
      String title,
      String value,
      ) {
    return Column(
      children: [

        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xff2563EB),
          ),
        ),

        const SizedBox(height: 5),

        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),

      ],
    );
  }

  //==================================================
  // STATUS COLOR
  //==================================================

  Color _statusColor(String status) {

    switch (status.toLowerCase()) {

      case "done":
        return Colors.green;

      case "progress":
        return Colors.orange;

      case "open":
        return Colors.red;

      default:
        return Colors.blue;
    }
  }
}