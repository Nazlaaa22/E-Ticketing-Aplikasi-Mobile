import 'package:e_ticketing_helpdesk/features/profile/presentation/pages/helpdesk_profile_page.dart';
import 'package:flutter/material.dart';

// HELP DESK PAGES
import 'package:e_ticketing_helpdesk/features/dashboard/presentation/pages/helpdesk_dashboard_page.dart';
import 'package:e_ticketing_helpdesk/features/helpdesk/presentation/pages/helpdesk_ticket_page.dart';
import 'package:e_ticketing_helpdesk/features/helpdesk/presentation/pages/helpdesk_history_page.dart';
import '../../../profile/presentation/pages/helpdesk_profile_page.dart';
import '../../../profile/presentation/pages/helpdesk_edit_profile_page.dart';
import '../../../profile/presentation/pages/helpdesk_change_password_page.dart';


// SHARED
import 'package:e_ticketing_helpdesk/features/profile/presentation/pages/profile_page.dart';

class HelpdeskHomePage extends StatefulWidget {
  const HelpdeskHomePage({super.key});

  @override
  State<HelpdeskHomePage> createState() => _HelpdeskHomePageState();
}

class _HelpdeskHomePageState extends State<HelpdeskHomePage> {
  int _index = 0;

  final pages = [
    const HelpdeskDashboardPage(),
    const HelpdeskTicketPage(),
    const HelpdeskHistoryPage(),
    const HelpdeskProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF166534),
        unselectedItemColor: Colors.grey,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_number), label: "Tiket"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Riwayat"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}