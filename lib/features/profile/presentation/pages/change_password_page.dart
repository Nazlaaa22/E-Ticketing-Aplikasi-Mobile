import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {

  final oldPass = TextEditingController();
  final newPass = TextEditingController();

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password berhasil diubah")),
    );
  }

  @override
  Widget build(BuildContext context) {
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

            const SizedBox(height: 16),

            TextField(
              controller: newPass,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password Baru"),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _save,
              child: const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}