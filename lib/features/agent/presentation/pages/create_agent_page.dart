import 'package:flutter/material.dart';

class CreateAgentPage extends StatefulWidget {
  const CreateAgentPage({super.key});

  @override
  State<CreateAgentPage> createState() => _CreateAgentPageState();
}

class _CreateAgentPageState extends State<CreateAgentPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  String role = "Helpdesk";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text("Tambah Agen"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// NAMA
            _inputField("Nama Agen", nameController),

            const SizedBox(height: 12),

            /// EMAIL
            _inputField("Email", emailController),

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
                  /// 🔥 SIMULASI SAVE
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Agen berhasil ditambahkan")),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Simpan"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}