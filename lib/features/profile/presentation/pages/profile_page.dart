import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/theme_provider.dart';

import '../../../auth/presentation/pages/login_page.dart';
import 'change_password_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final AuthService authService = AuthService();

  String userName = "";
  String userEmail = "";
  String userRole = "";

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {

    userName = await authService.getName() ?? "";
    userEmail = await authService.getEmail() ?? "";
    userRole = await authService.getRole() ?? "";

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final themeProvider =
    Provider.of<ThemeProvider>(context);

    final darkMode = themeProvider.isDark;
    return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,

        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.scaffoldBackgroundColor,
          centerTitle: true,

          title: Text(
            "Profil",
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),

          iconTheme: IconThemeData(
            color: theme.colorScheme.onSurface,
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [

            ///================ PROFILE =================

            Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              color: theme.cardColor,

              borderRadius: BorderRadius.circular(24),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Column(
              children: [

                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.blue.shade100,

                  child: const Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xff2563EB),
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  userName,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  userEmail,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface
                        .withOpacity(.7),
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xff2563EB)
                        .withOpacity(.12),

                    borderRadius:
                    BorderRadius.circular(25),
                  ),

                  child: Text(
                    userRole.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xff2563EB),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          ///================ MENU =================

          _menuCard(
            context: context,
            icon: Icons.person_outline,
            title: "Edit Profil",
            subtitle: "Ubah nama dan informasi akun",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const EditProfilePage(),
                ),
              );
            },
          ),

          const SizedBox(height: 14),

          _menuCard(
            context: context,
            icon: Icons.lock_outline,
            title: "Ganti Password",
            subtitle: "Perbarui password akun",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChangePasswordPage(),
                ),
              );
            },
          ),

          const SizedBox(height: 14),

          _menuCard(
            context: context,
            icon: Icons.notifications_none,
            title: "Notifikasi",
            subtitle: "Lihat semua notifikasi",
            onTap: () {},
          ),

          const SizedBox(height: 14),

          ///================ DARK MODE =================

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 8,
            ),

            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 10,
                ),
              ],
            ),

            child: Row(
              children: [

                const Icon(
                  Icons.dark_mode,
                  color: Colors.indigo,
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Dark Mode",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),

                      Text(
                        "Aktifkan tema gelap",
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withOpacity(.7),
                        ),
                      ),

                    ],
                  ),
                ),

                Switch(
                  value: darkMode,
                  activeColor: const Color(0xff2563EB),
                  onChanged: (value) async {
                    await themeProvider.toggleTheme(value);
                  },
                ),

              ],
            ),
          ),

          const SizedBox(height: 14),

          _menuCard(
            context: context,
            icon: Icons.info_outline,
            title: "Tentang Aplikasi",
            subtitle: "Versi 2.0.0",
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName:
                "E-Ticketing Helpdesk",
                applicationVersion: "1.0.0",
              );
            },
          ),

          const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(.08),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.red,
                  ),
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
  Widget _menuCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor:
              const Color(0xff2563EB).withOpacity(.12),
              child: Icon(
                icon,
                color: const Color(0xff2563EB),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface
                          .withOpacity(.7),
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: theme.colorScheme.onSurface.withOpacity(.6),
            ),
          ],
        ),
      ),
    );
  }
  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Logout",
            style: TextStyle(
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            "Apakah Anda yakin ingin logout?",
            style: TextStyle(
              color: theme.colorScheme.onSurface,
            ),
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
              onPressed: () async {
                await authService.logout();

                if (!mounted) return;

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
        );
      },
    );
  }
}
