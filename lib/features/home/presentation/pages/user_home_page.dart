import 'package:e_ticketing_helpdesk/features/ticket/presentation/pages/user_ticket_page.dart';
import 'package:flutter/material.dart';
import '../../../dashboard/presentation/pages/user_dashboard_page.dart';
import '../../../ticket/presentation/pages/user_ticket_page.dart';
import '../../../notification/presentation/pages/user_notification_page.dart';
import '../../../profile/presentation/pages/user_profile_page.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  int _index = 0;

  final pages = [
    const UserDashboardPage(),
    const UserTicketPage(),
    const UserNotificationPage(),
    const UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.confirmation_number), label: "Tiket"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Notif"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}