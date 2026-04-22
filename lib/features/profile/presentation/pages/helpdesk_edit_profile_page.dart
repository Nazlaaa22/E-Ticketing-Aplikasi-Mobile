import 'package:flutter/material.dart';

class HelpdeskEditProfilePage extends StatelessWidget {
  const HelpdeskEditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final name = TextEditingController(text: "Budi Santoso");
    final email = TextEditingController(text: "budi@email.com");

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Nama"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}