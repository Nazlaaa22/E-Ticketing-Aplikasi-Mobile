import 'package:e_ticketing_helpdesk/features/report/presentation/pages/report_page.dart';
import 'package:flutter/material.dart';

// ADMIN
import 'package:e_ticketing_helpdesk/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:e_ticketing_helpdesk/features/ticket/presentation/pages/ticket_page.dart';
import 'package:e_ticketing_helpdesk/features/agent/presentation/pages/agent_page.dart';

// USER
import 'package:e_ticketing_helpdesk/features/dashboard/presentation/pages/user_dashboard_page.dart';
import 'package:e_ticketing_helpdesk/features/ticket/presentation/pages/user_ticket_page.dart';

// SHARED
import 'package:e_ticketing_helpdesk/features/notification/presentation/pages/admin_notification_page.dart';
import 'package:e_ticketing_helpdesk/features/profile/presentation/pages/profile_page.dart';
import 'package:e_ticketing_helpdesk/features/notification/presentation/pages/user_notification_page.dart';

import 'package:provider/provider.dart';
import '../../../../core/theme/theme_provider.dart';

class HomePage extends StatefulWidget {
  final String role;

  const HomePage({super.key, required this.role});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    /// 🔥 ROLE LOGIC
    if (widget.role == "admin") {
      _pages = [
        const DashboardPage(),
        const TicketPage(),
        const AgentPage(),
        const ReportPage(),
        const ProfilePage(),
      ];
    } else {
      _pages = [
        const UserDashboardPage(),
        const UserTicketPage(),
        const UserNotificationPage(),
        const ProfilePage(),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor:
      theme.isDark
          ? const Color(0xff121212)
          : const Color(0xffF5F7FB),
      body: _pages[_currentIndex],

      /// 🔥 ADMIN NAV (5 MENU)
      bottomNavigationBar: widget.role == "admin"
          ? _adminBottomNav()
          : _userBottomNav(),
    );
  }

  /// 🔥 ================= ADMIN NAV =================
  Widget _adminBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Provider.of<ThemeProvider>(context).isDark
            ? const Color(0xff1E1E1E)
            : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home, "Home", 0),
          _navItem(Icons.confirmation_number, "Tiket", 1),
          _navItem(Icons.groups, "Agen", 2),
          _navItem(Icons.bar_chart, "Laporan", 3),
          _navItem(Icons.person, "Profil", 4),
        ],
      ),
    );
  }

  /// 🔥 ================= USER NAV =================
  Widget _userBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      backgroundColor:
      Provider.of<ThemeProvider>(context).isDark
          ? const Color(0xff1E1E1E)
          : Colors.white,

      selectedItemColor: const Color(0xff2563EB),

      unselectedItemColor:
      Provider.of<ThemeProvider>(context).isDark
          ? Colors.white70
          : Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number), label: "Tiket"),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications), label: "Notif"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
      ],
    );
  }

  /// 🔥 ITEM ADMIN
  Widget _navItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive
                ? const Color(0xff2563EB)
                : Provider.of<ThemeProvider>(context).isDark
                ? Colors.white70
                : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive
                  ? const Color(0xff2563EB)
                  : Provider.of<ThemeProvider>(context).isDark
                  ? Colors.white70
                  : Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}