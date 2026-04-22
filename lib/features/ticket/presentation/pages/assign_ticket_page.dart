import 'package:flutter/material.dart';

class AssignTicketPage extends StatefulWidget {
  final String ticketId;

  const AssignTicketPage({super.key, required this.ticketId});

  @override
  State<AssignTicketPage> createState() => _AssignTicketPageState();
}

class _AssignTicketPageState extends State<AssignTicketPage> {
  int selectedIndex = -1;

  final agents = [
    {"name": "Budi Santoso", "role": "Helpdesk", "active": "2 tiket aktif"},
    {"name": "Andi Rizky", "role": "Helpdesk", "active": "4 tiket aktif"},
    {"name": "Dewi Maharani", "role": "Senior Helpdesk", "active": "1 tiket aktif"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assign Ticket ${widget.ticketId}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: agents.length,
              itemBuilder: (context, index) {
                final agent = agents[index];

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(agent["name"]![0]),
                  ),
                  title: Text(agent["name"]!),
                  subtitle: Text("${agent["role"]} • ${agent["active"]}"),
                  trailing: selectedIndex == index
                      ? const Icon(Icons.check_circle, color: Colors.blue)
                      : null,
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                );
              },
            ),
          ),

          /// BUTTON
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedIndex == -1
                    ? null
                    : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Ticket ${widget.ticketId} di-assign ke ${agents[selectedIndex]["name"]}",
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text("Konfirmasi Assign"),
              ),
            ),
          )
        ],
      ),
    );
  }
}