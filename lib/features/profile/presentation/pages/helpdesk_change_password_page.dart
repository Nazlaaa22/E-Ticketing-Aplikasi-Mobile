import 'package:flutter/material.dart';

class HelpdeskChangePasswordPage extends StatelessWidget {
  const HelpdeskChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final oldPass = TextEditingController();
    final newPass = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Ganti Password")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: oldPass,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password Lama"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: newPass,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password Baru"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Update Password"),
            )
          ],
        ),
      ),
    );
  }
}