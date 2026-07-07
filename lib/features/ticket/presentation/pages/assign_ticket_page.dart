import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AssignTicketPage extends StatefulWidget {
  final String ticketId;

  const AssignTicketPage({
    super.key,
    required this.ticketId,
  });

  @override
  State<AssignTicketPage> createState() => _AssignTicketPageState();
}

class _AssignTicketPageState extends State<AssignTicketPage> {
  final Dio dio = Dio();

  int selectedIndex = -1;

  bool loading = true;

  List<dynamic> agents = [];

  @override
  void initState() {
    super.initState();
    getAgents();
  }

  Future<void> getAgents() async {
    try {
      final response = await dio.get(
        "http://127.0.0.1:8000/api/helpdesks",
      );

      setState(() {
        agents = response.data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Gagal mengambil data helpdesk\n$e",
          ),
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
          title: Text(
            "Assign Ticket ${widget.ticketId}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: loading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : Column(
            children: [
        Expanded(
        child: ListView.builder(
        padding: const EdgeInsets.all(16),
      itemCount: agents.length,
      itemBuilder: (context, index) {
        final agent = agents[index];

        return InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: selectedIndex == index
                  ? const Color(0xff2563EB).withOpacity(.08)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selectedIndex == index
                    ? const Color(0xff2563EB)
                    : Colors.grey.shade300,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [

                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xff2563EB),
                  child: Text(
                    agent["name"]
                        .toString()
                        .substring(0, 1)
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        agent["name"] ?? "-",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        agent["email"] ?? "-",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [

                          const Icon(
                            Icons.phone,
                            size: 16,
                            color: Colors.grey,
                          ),

                          const SizedBox(width: 5),

                          Text(
                            agent["phone"] ?? "-",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),

                AnimatedSwitcher(
                  duration:
                  const Duration(milliseconds: 250),
                  child: selectedIndex == index
                      ? const Icon(
                    Icons.check_circle,
                    key: ValueKey(1),
                    color: Color(0xff2563EB),
                    size: 34,
                  )
                      : const Icon(
                    Icons.radio_button_unchecked,
                    key: ValueKey(2),
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
    ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: selectedIndex == -1
                        ? null
                        : () {
                      final agent = agents[selectedIndex];

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Ticket ${widget.ticketId} berhasil di-assign ke ${agent["name"]}",
                          ),
                        ),
                      );

                      Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.assignment_ind),
                    label: const Text(
                      "Konfirmasi Assign",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
        ),
    );
  }
}