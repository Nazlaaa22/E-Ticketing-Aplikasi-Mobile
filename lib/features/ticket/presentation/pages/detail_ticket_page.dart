import 'package:e_ticketing_helpdesk/features/ticket/presentation/pages/assign_ticket_page.dart';
import 'package:flutter/material.dart';
import 'assign_ticket_page.dart';

class DetailTicketPage extends StatefulWidget {
  final String id; // ✅ TAMBAH
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
  State<DetailTicketPage> createState() => _DetailTicketPageState();
}

class _DetailTicketPageState extends State<DetailTicketPage> {
  late String _status;
  final TextEditingController _commentController = TextEditingController();

  final List<Map<String, String>> _comments = [
    {
      "sender": "Helpdesk - Budi",
      "message": "Sedang kami cek, mohon tunggu."
    },
    {
      "sender": "User",
      "message": "Baik, terima kasih."
    }
  ];

  @override
  void initState() {
    super.initState();
    _status = widget.status;
  }

  void _addComment() {
    if (_commentController.text.isEmpty) return;

    setState(() {
      _comments.add({
        "sender": "Admin",
        "message": _commentController.text
      });
    });

    _commentController.clear();
  }

  void _updateStatus(String newStatus) {
    setState(() {
      _status = newStatus;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Status diubah ke $newStatus")),
    );
  }

  /// 🔥 BALIK KE PAGE SEBELUMNYA DENGAN DATA BARU
  void _saveAndBack() {
    Navigator.pop(context, {
      "title": widget.title,
      "desc": widget.desc,
      "status": _status,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text("Detail Tiket"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveAndBack, // ✅ SIMPAN
          )
        ],
      ),

      body: Column(
        children: [

          /// CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// TITLE
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// STATUS + UPDATE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statusBadge(_status),

                      DropdownButton<String>(
                        value: _status,
                        items: ["Open", "Progress", "Done"]
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            _updateStatus(value);
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// DESC
                  const Text(
                    "Deskripsi",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 6),

                  Text(widget.desc),

                  const SizedBox(height: 20),

                  /// 🔥 BUTTON ASSIGN (TAMBAH TANPA RUSAK UI)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AssignTicketPage(
                              ticketId: widget.id,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                      ),
                      child: const Text("Assign ke Helpdesk"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// COMMENT
                  const Text(
                    "Komentar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ..._comments.map((c) => _commentBubble(
                    c["sender"]!,
                    c["message"]!,
                  )),
                ],
              ),
            ),
          ),

          /// INPUT COMMENT
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                )
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Tulis komentar...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// STATUS BADGE
  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _statusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _statusColor(status),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// COMMENT UI
  Widget _commentBubble(String sender, String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: sender == "Admin"
            ? Colors.blue.shade50
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(message),
        ],
      ),
    );
  }

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