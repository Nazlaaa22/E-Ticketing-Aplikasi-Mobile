import 'package:flutter/material.dart';

class HelpdeskDetailTicketPage extends StatefulWidget {
  final String id;
  final String title;

  const HelpdeskDetailTicketPage({
    super.key,
    required this.id,
    required this.title,
  });

  @override
  State<HelpdeskDetailTicketPage> createState() =>
      _HelpdeskDetailTicketPageState();
}

class _HelpdeskDetailTicketPageState
    extends State<HelpdeskDetailTicketPage> {

  String selectedStatus = "Dalam Proses";

  final TextEditingController chatController = TextEditingController();

  final List<Map<String, dynamic>> chats = [
    {
      "sender": "user",
      "name": "R. Wijaya",
      "message":
      "Server tidak bisa diakses sejak jam 08.00. Data mahasiswa tidak bisa dibuka sama sekali."
    },
    {
      "sender": "me",
      "name": "Budi",
      "message":
      "Baik, sedang kami cek dari sisi server. Mohon tunggu 15 menit ya."
    },
    {
      "sender": "user",
      "name": "R. Wijaya",
      "message":
      "Oke siap, ditunggu. Ini urgent karena ada ujian hari ini."
    },
    {
      "sender": "me",
      "name": "Budi",
      "message":
      "Sudah ditemukan penyebabnya sedang dilakukan restart service DB. Estimasi 10 menit."
    },
  ];

  void sendChat() {
    if (chatController.text.isEmpty) return;

    setState(() {
      chats.add({
        "sender": "me",
        "name": "Budi",
        "message": chatController.text
      });
      chatController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: Column(
        children: [

          /// 🔥 HEADER
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF166534),
            ),
            child: Column(
              children: [

                Row(
                  children: [

                    /// BACK
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white),
                    ),

                    const SizedBox(width: 10),

                    /// ID
                    Text(
                      widget.id,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),

                    const Spacer(),

                    /// STATUS BADGE
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Kritis",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 12),

                /// TITLE
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14),
                  ),
                )
              ],
            ),
          ),

          /// 🔥 CONTENT
          Expanded(
            child: Column(
              children: [

                /// STATUS BUTTON
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _statusButton("Dalam Proses"),
                      _statusButton("Pending"),
                      _statusButton("Selesai"),
                    ],
                  ),
                ),

                /// CHAT LIST
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      final isMe = chat["sender"] == "me";

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          constraints:
                          const BoxConstraints(maxWidth: 260),
                          decoration: BoxDecoration(
                            color: isMe
                                ? const Color(0xFFD1FAE5)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                isMe
                                    ? "${chat["name"]} — Anda"
                                    : "${chat["name"]} — Pelapor",
                                style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey),
                              ),
                              const SizedBox(height: 4),
                              Text(chat["message"]),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// INPUT CHAT
                Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatController,
                          decoration: InputDecoration(
                            hintText: "Tulis balasan...",
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding:
                            const EdgeInsets.symmetric(
                                horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: sendChat,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF166534),
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.send,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 🔥 STATUS BUTTON
  Widget _statusButton(String text) {
    final isActive = selectedStatus == text;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStatus = text;
        });
      },
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF166534)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}