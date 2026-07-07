import 'package:flutter/material.dart';

import 'helpdesk_edit_profile_page.dart';
import 'helpdesk_change_password_page.dart';

import 'package:e_ticketing_helpdesk/features/auth/presentation/pages/login_page.dart';

class HelpdeskProfilePage extends StatelessWidget {
  const HelpdeskProfilePage({super.key});

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
                padding: const EdgeInsets.fromLTRB(20,25,20,30),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff166534),
                      Color(0xff22C55E),
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

                    const SizedBox(height:10),

                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "BS",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff166534),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height:18),

                    const Text(
                      "Budi Santoso",
                      style: TextStyle(
                        fontSize:24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height:6),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal:14,
                        vertical:5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.18),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Text(
                        "HELPDESK",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),

                    const SizedBox(height:15),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Icon(
                          Icons.email_outlined,
                          color: Colors.white70,
                          size:18,
                        ),

                        SizedBox(width:6),

                        Text(
                          "budi@mail.com",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height:20),
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
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [

                      _infoItem(
                        Icons.calendar_month,
                        "Bergabung",
                        "12 Mei 2024",
                        Colors.green,
                      ),

                      Container(
                        width: 1,
                        height: 55,
                        color: Colors.grey.withOpacity(.2),
                      ),

                      _infoItem(
                        Icons.verified_user,
                        "Role",
                        "Helpdesk",
                        Colors.blue,
                      ),

                      Container(
                        width: 1,
                        height: 55,
                        color: Colors.grey.withOpacity(.2),
                      ),

                      _infoItem(
                        Icons.assignment_turned_in,
                        "Ticket",
                        "36",
                        Colors.orange,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

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

              const SizedBox(height: 15),

              _menuCard(
                context,
                icon: Icons.person_outline,
                title: "Edit Profil",
                subtitle: "Ubah nama, email dan nomor HP",
                color: Colors.green,
                page: const HelpdeskEditProfilePage(),
              ),

              _menuCard(
                context,
                icon: Icons.lock_outline,
                title: "Ganti Password",
                subtitle: "Perbarui password akun",
                color: Colors.blue,
                page: const HelpdeskChangePasswordPage(),
              ),

              _menuCard(
                context,
                icon: Icons.notifications_none,
                title: "Notifikasi",
                subtitle: "Kelola notifikasi aplikasi",
                color: Colors.orange,
                page: const SizedBox(),
              ),

              _menuCard(
                context,
                icon: Icons.dark_mode_outlined,
                title: "Dark Mode",
                subtitle: "Aktifkan mode gelap",
                color: Colors.deepPurple,
                page: const SizedBox(),
              ),

              _menuCard(
                context,
                icon: Icons.info_outline,
                title: "Tentang Aplikasi",
                subtitle: "Versi 1.0.0",
                color: Colors.teal,
                page: const SizedBox(),
              ),

              const SizedBox(height: 25),
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

                                  SizedBox(height: 3),

                                  Text(
                                    "Keluar dari akun helpdesk",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(
                              Icons.arrow_forward_ios,
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
  /// DIALOG LOGOUT
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
                    borderRadius:
                    BorderRadius.circular(12),
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


