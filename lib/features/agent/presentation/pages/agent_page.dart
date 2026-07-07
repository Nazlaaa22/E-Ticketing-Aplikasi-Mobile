import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'create_agent_page.dart';
import 'edit_agent_page.dart';

class AgentPage extends StatefulWidget {
  const AgentPage({super.key});

  @override
  State<AgentPage> createState() => _AgentPageState();
}

class _AgentPageState extends State<AgentPage> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000/api",
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  List<Map<String, String>> agents = [];

  bool isLoading = true;

  String search = "";

  @override
  void initState() {
    super.initState();
    fetchAgents();
  }

  Future<void> fetchAgents() async {
    try {
      final response = await _dio.get("/helpdesks");

      final List data = response.data;

      agents = data.map<Map<String, String>>((e) {
        return {
          "id": e["id"].toString(),
          "name": e["name"].toString(),
          "email": e["email"].toString(),
          "phone": e["phone"]?.toString() ?? "-",
          "role": e["role"].toString(),
        };
      }).toList();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, String>> get filteredAgents {
    if (search.isEmpty) return agents;

    return agents.where((e) {
      return e["name"]!
          .toLowerCase()
          .contains(search.toLowerCase()) ||
          e["email"]!
              .toLowerCase()
              .contains(search.toLowerCase());
    }).toList();
  }

  Future<void> _goToCreateAgent() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateAgentPage(),
      ),
    );

    if (result == true) {
      fetchAgents();
    }
  }

  Future<void> _goToEdit(Map<String, String> agent) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditAgentPage(
          id: int.parse(agent["id"]!),
          name: agent["name"]!,
          email: agent["email"]!,
          phone: agent["phone"]!,
        ),
      ),
    );

    if (result == true) {
      fetchAgents();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: Column(
        children: [

          /// ================= HEADER =================
          Container(
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 24),
            decoration: BoxDecoration(
              color: Color(0xFF2563EB),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [

                    const Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Daftar Helpdesk",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "Kelola akun helpdesk",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),

                    FloatingActionButton.small(
                      heroTag: "addHelpdesk",
                      backgroundColor: Colors.white,
                      onPressed: _goToCreateAgent,
                      child: const Icon(
                        Icons.add,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.10)
                        : Colors.white.withValues(alpha: 0.15),
                    borderRadius:
                    BorderRadius.circular(16),
                  ),
                  child: TextField(
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      hintText: "Cari helpdesk...",
                      hintStyle: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          /// ================= LIST =================
          Expanded(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : filteredAgents.isEmpty
                ? Center(
              child: Text(
                "Belum ada Helpdesk",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: .7),
                ),
              ),
            )
                : ListView.builder(
              padding:
              const EdgeInsets.all(16),
              itemCount:
              filteredAgents.length,
              itemBuilder:
                  (context, index) {

                final agent =
                filteredAgents[index];

                return GestureDetector(
                  onTap: () =>
                      _goToEdit(agent),

                  child: _agentCard(agent),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  /// ================= CARD =================

  Widget _agentCard(Map<String, String> agent) {
    final theme = Theme.of(context);
    return Container(
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
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [

          /// AVATAR
          CircleAvatar(
            radius: 28,
            backgroundColor: const Color(0xFF2563EB).withOpacity(.12),
            child: Text(
              agent["name"]![0].toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),

          const SizedBox(width: 15),

          /// DATA
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  agent["name"]!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 15,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        agent["email"]!,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: .7),
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      size: 15,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      agent["phone"]!,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: .7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Helpdesk",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// EDIT
          Container(
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: .08)
                  : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => _goToEdit(agent),
              icon: const Icon(
                Icons.edit,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
        ],
      ),
    );
  }
}