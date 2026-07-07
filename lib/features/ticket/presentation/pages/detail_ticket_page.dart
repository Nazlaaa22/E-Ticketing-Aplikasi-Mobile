import 'package:flutter/material.dart';
import '../../data/repositories/ticket_repository.dart';
import 'assign_ticket_page.dart';

class DetailTicketPage extends StatefulWidget {
  final String id;
  final String title;
  final String desc;
  final String status;

  const DetailTicketPage({
    super.key,
    required this.id,
    required this.title,
    required this.desc,
    required this.status,
  });

  @override
  State<DetailTicketPage> createState() =>
      _DetailTicketPageState();
}

class _DetailTicketPageState
    extends State<DetailTicketPage> {

  late String _status;

  @override
  void initState() {
    super.initState();
    _status = widget.status;
  }

  Future<void> _updateStatus(String status) async {
    try {
      final repo = TicketRepository();

      await repo.updateStatus(
        id: int.parse(
          widget.id.replaceAll("TKT-", ""),
        ),
        status: status,
      );

      setState(() {
        _status = status;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Status berhasil diubah menjadi $status",
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    }
  }

  void _save() {
    Navigator.pop(context, true);
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
          title: const Text(
            "Detail Tiket",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [

            IconButton(
              onPressed: _save,
              icon: const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            )

          ],
        ),

        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
              /// CARD HEADER
              Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xff2563EB)
                              .withOpacity(.1),
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                        child: const Icon(
                          Icons.confirmation_number,
                          color: Color(0xff2563EB),
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            Text(
                              widget.title,
                              style: const TextStyle(
                                fontWeight:
                                FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              "ID Ticket : ${widget.id}",
                              style: TextStyle(
                                color: Colors
                                    .grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      _statusBadge(_status),

                      const Spacer(),

                      DropdownButton<String>(
                        value: _status,
                        underline: const SizedBox(),
                        borderRadius:
                        BorderRadius.circular(15),
                        items: const [

                          DropdownMenuItem(
                            value: "Open",
                            child: Text("Open"),
                          ),

                          DropdownMenuItem(
                            value: "Progress",
                            child: Text("Progress"),
                          ),

                          DropdownMenuItem(
                            value: "Done",
                            child: Text("Done"),
                          ),

                        ],
                        onChanged: (value) {
                          if (value != null) {
                            _updateStatus(value);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

          const SizedBox(height: 20),
                  /// DESKRIPSI
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        const Row(
                          children: [

                            Icon(
                              Icons.description,
                              color: Color(0xff2563EB),
                            ),

                            SizedBox(width: 8),

                            Text(
                              "Deskripsi Ticket",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),

                          ],
                        ),

                        const Divider(height: 25),

                        Text(
                          widget.desc,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ASSIGN
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xff2563EB),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(Icons.people_alt),
                      label: const Text(
                        "Assign Helpdesk",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      onPressed: () async {

                        final result =
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AssignTicketPage(
                                  ticketId: widget.id,
                                ),
                          ),
                        );

                        if (result == true && mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Helpdesk berhasil diassign",
                              ),
                            ),
                          );
                        }

                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xff2563EB),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                      icon: const Icon(
                        Icons.save,
                        color: Color(0xff2563EB),
                      ),
                      label: const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          color: Color(0xff2563EB),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _save,
                    ),
                  ),

                  const SizedBox(height: 30),

                ],
            ),
        ),
    );
  }
  /// STATUS BADGE
  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: _statusColor(status).withOpacity(.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _statusColor(status),
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

  /// WARNA STATUS
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