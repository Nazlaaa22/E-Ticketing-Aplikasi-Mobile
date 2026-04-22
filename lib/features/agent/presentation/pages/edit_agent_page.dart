import 'package:flutter/material.dart';

class EditAgentPage extends StatefulWidget {
  final String name;
  final String role;

  const EditAgentPage({
    super.key,
    required this.name,
    required this.role,
  });

  @override
  State<EditAgentPage> createState() => _EditAgentPageState();
}

class _EditAgentPageState extends State<EditAgentPage> {
  late TextEditingController nameController;
  late String role;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    role = widget.role;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text("Edit Agen"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// NAMA
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Nama Agen",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ROLE
            DropdownButtonFormField(
              value: role,
              items: const [
                DropdownMenuItem(value: "Helpdesk", child: Text("Helpdesk")),
                DropdownMenuItem(value: "Senior Helpdesk", child: Text("Senior Helpdesk")),
              ],
              onChanged: (value) {
                setState(() {
                  role = value!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTON SIMPAN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Agen berhasil diupdate")),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Update"),
              ),
            )
          ],
        ),
      ),
    );
  }
}