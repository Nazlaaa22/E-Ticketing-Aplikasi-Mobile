import 'package:flutter/material.dart';

class UserTicketDetailPage extends StatefulWidget {
  final Map<String, String> data;

  const UserTicketDetailPage({
    super.key,
    required this.data,
  });

  @override
  State<UserTicketDetailPage> createState() =>
      _UserTicketDetailPageState();
}

class _UserTicketDetailPageState extends State<UserTicketDetailPage> {

  final TextEditingController messageController = TextEditingController();

  List<Map<String, String>> messages = [
    {"sender": "Helpdesk", "text": "Sedang kami proses ya"},
    {"sender": "Anda", "text": "Baik, terima kasih"},
  ];

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    setState(() {
      messages.add({
        "sender": "Anda",
        "text": messageController.text,
      });
    });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.data["title"] ?? "-";
    final status = widget.data["status"] ?? "-";
    final date = widget.data["date"] ?? "-";
    final category = widget.data["category"] ?? "-";

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),

      body: Column(
        children: [

          /// 🔽 CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _statusBadge(status),

                  const SizedBox(height: 8),

                  Text("Kategori: $category",
                      style: const TextStyle(color: Colors.grey)),

                  Text("Tanggal: $date",
                      style: const TextStyle(color: Colors.grey)),

                  const SizedBox(height: 20),

                  const Text("Deskripsi",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(title),

                  const SizedBox(height: 20),

                  const Text("Komentar",
                      style: TextStyle(fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  /// 🔥 CHAT LIST DINAMIS
                  ...messages.map((msg) => _chatBubble(
                    msg["sender"]!,
                    msg["text"]!,
                  )),
                ],
              ),
            ),
          ),

          /// 🔽 INPUT CHAT
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: "Tulis balasan...",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: sendMessage, // 🔥 FIX DISINI
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case "Open":
        color = Colors.orange;
        break;
      case "Pending":
        color = Colors.blue;
        break;
      case "Done":
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _chatBubble(String sender, String message) {
    final isUser = sender == "Anda";

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue.shade100 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message),
      ),
    );
  }
}