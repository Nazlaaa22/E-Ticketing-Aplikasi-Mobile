import 'package:e_ticketing_helpdesk/features/profile/presentation/pages/user_change_password_page.dart';
import 'package:e_ticketing_helpdesk/features/profile/presentation/pages/user_edit_profile_page.dart';
import 'package:e_ticketing_helpdesk/features/profile/presentation/pages/user_ticket_history_page.dart';
import 'package:flutter/material.dart';
import '../../../auth/presentation/pages/login_page.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: Column(
        children: [

          /// 🔥 HEADER BIRU (KONSISTEN)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F8CFF), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [

                /// AVATAR
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40, color: Colors.blue),
                ),

                const SizedBox(height: 12),

                /// NAMA
                const Text(
                  "Nazlatul Khoiriyah",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                /// EMAIL
                const Text(
                  "user@email.com",
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 8),

                /// ROLE BADGE
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "User",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// 🔥 MENU LIST
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [

                _menuCard(
                  icon: Icons.edit,
                  title: "Edit Profil",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserEditProfilePage(),
                      ),
                    );
                  },
                ),

                _menuCard(
                  icon: Icons.lock,
                  title: "Ganti Password",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserChangePasswordPage(),
                      ),
                    );
                  },
                ),

                _menuCard(
                  icon: Icons.history,
                  title: "Riwayat Tiket",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const UserTicketHistoryPage(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 10),

                /// LOGOUT
                _menuCard(
                  icon: Icons.logout,
                  title: "Logout",
                  color: Colors.red,
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LoginPage()),
                          (route) => false,
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// 🔥 MENU CARD (LEBIH CLEAN)
  Widget _menuCard({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          )
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.black),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: color ?? Colors.black,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}