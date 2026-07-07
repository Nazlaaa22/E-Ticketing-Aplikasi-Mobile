import 'package:flutter/material.dart';

class HelpdeskNotificationPage extends StatelessWidget {
  const HelpdeskNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifikasi Helpdesk"),
      ),
      body: const Center(
        child: Text("Halaman Notifikasi Helpdesk"),
      ),
    );
  }
}