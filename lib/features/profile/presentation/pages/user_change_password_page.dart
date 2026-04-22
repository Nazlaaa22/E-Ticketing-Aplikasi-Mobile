import 'package:flutter/material.dart';

class UserChangePasswordPage extends StatefulWidget {
  const UserChangePasswordPage({super.key});

  @override
  State<UserChangePasswordPage> createState() => _UserChangePasswordPageState();
}

class _UserChangePasswordPageState extends State<UserChangePasswordPage> {

  final oldPass = TextEditingController();
  final newPass = TextEditingController();

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

            const SizedBox(height: 10),

            TextField(
              controller: newPass,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password Baru"),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            )
          ],
        ),
      ),
    );
  }
}