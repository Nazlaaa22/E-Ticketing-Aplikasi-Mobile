import 'package:flutter/material.dart';

import 'package:e_ticketing_helpdesk/features/profile/presentation/pages/user_change_password_page.dart';
import 'package:e_ticketing_helpdesk/features/profile/presentation/pages/user_edit_profile_page.dart';
import 'package:e_ticketing_helpdesk/features/profile/presentation/pages/user_ticket_history_page.dart';

import '../../../auth/presentation/pages/login_page.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,

        body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [

                /// =========================
                /// HEADER
                /// =========================

                Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  20,
                  25,
                  20,
                  30,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff2563EB),
                      Color(0xff60A5FA),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.settings,
                        color: Colors.white.withOpacity(.9),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(50),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 55,
                          color: Color(0xff2563EB),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      "Nazlatul Khoiriyah",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color:
                        Colors.white.withOpacity(.18),
                        borderRadius:
                        BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "USER",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [

                        Icon(
                          Icons.email_outlined,
                          color: Colors.white70,
                          size: 18,
                        ),

                        SizedBox(width: 6),

                        Text(
                          "user@email.com",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 20),
              /// =========================
              /// INFO CARD
              /// =========================

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.transparent
                            : Colors.black.withOpacity(.05),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      _infoItem(
                        Icons.calendar_month,
                        "Bergabung",
                        "2025",
                        Colors.blue,
                      ),

                      Container(
                        width: 1,
                        height: 55,
                        color: Colors.grey.withOpacity(.2),
                      ),

                      _infoItem(
                        Icons.confirmation_number,
                        "Ticket",
                        "18",
                        Colors.green,
                      ),

                      Container(
                        width: 1,
                        height: 55,
                        color: Colors.grey.withOpacity(.2),
                      ),

                      _infoItem(
                        Icons.verified_user,
                        "Status",
                        "Aktif",
                        Colors.orange,
                      ),

                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Pengaturan",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              _menuCard(
                context,
                icon: Icons.person_outline,
                title: "Edit Profil",
                subtitle: "Perbarui data akun",
                color: Colors.blue,
                page: const UserEditProfilePage(),
              ),

              _menuCard(
                context,
                icon: Icons.lock_outline,
                title: "Ganti Password",
                subtitle: "Amankan akun kamu",
                color: Colors.orange,
                page: const UserChangePasswordPage(),
              ),

              _menuCard(
                context,
                icon: Icons.history,
                title: "Riwayat Tiket",
                subtitle: "Lihat semua tiket",
                color: Colors.green,
                page: const UserTicketHistoryPage(),
              ),

              _menuCard(
                context,
                icon: Icons.info_outline,
                title: "Tentang Aplikasi",
                subtitle: "Versi 1.0.0",
                color: Colors.indigo,
                page: const SizedBox(),
              ),

              const SizedBox(height: 24),
                  /// =========================
                  /// LOGOUT
                  /// =========================

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _confirmLogout(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.red.withOpacity(.15),
                          ),
                        ),
                        child: Row(
                          children: [

                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(.12),
                                borderRadius:
                                BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.logout_rounded,
                                color: Colors.red,
                              ),
                            ),

                            const SizedBox(width: 16),

                            const Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    "Logout",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),

                                  SizedBox(height: 4),

                                  Text(
                                    "Keluar dari akun pengguna",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.red,
                              size: 18,
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                ],
              ),
            ),
        ),
    );
  }

  /// =========================
  /// INFO ITEM
  /// =========================

  Widget _infoItem(
      IconData icon,
      String title,
      String value,
      Color color,
      ) {
    return Column(
      children: [

        CircleAvatar(
          radius: 22,
          backgroundColor: color.withOpacity(.12),
          child: Icon(
            icon,
            color: color,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: color,
          ),
        ),

      ],
    );
  }

  /// =========================
  /// LOGOUT DIALOG
  /// =========================

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text("Logout"),
        content: const Text(
          "Apakah kamu yakin ingin keluar dari akun?",
        ),
        actions: [

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Batal"),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
                    (route) => false,
              );
            },
            child: const Text("Logout"),
          ),

        ],
      ),
    );
  }
  /// =========================
  /// MENU CARD
  /// =========================

  Widget _menuCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required Widget page,
      }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 7,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (page is SizedBox) return;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => page,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.transparent
                      : Colors.black.withOpacity(.05),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [

                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: theme.colorScheme.onSurface
                              .withOpacity(.65),
                        ),
                      ),

                    ],
                  ),
                ),

                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurface
                        .withOpacity(.55),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}