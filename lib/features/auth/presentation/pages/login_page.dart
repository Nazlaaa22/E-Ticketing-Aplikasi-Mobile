import 'package:flutter/material.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';
import 'package:e_ticketing_helpdesk/features/home/presentation/pages/home_page.dart';
import 'package:e_ticketing_helpdesk/features/home/presentation/pages/user_home_page.dart';
import 'package:e_ticketing_helpdesk/features/home/presentation/pages/helpdesk_home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// 🔥 GOOGLE SIGN IN INSTANCE
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _login() {
    String username = usernameController.text.trim();

    if (username == "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(role: "admin"),
        ),
      );
    } else if (username == "helpdesk") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HelpdeskHomePage(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const UserHomePage(),
        ),
      );
    }
  }

  /// 🔥 LOGIN GOOGLE
  Future<void> _loginWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();

      if (account != null) {
        // 👉 sementara masuk sebagai USER
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const UserHomePage(),
          ),
        );
      }
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                )
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// ICON
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.support_agent,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 16),

                /// TITLE
                const Text(
                  "E-Ticketing Helpdesk",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Masuk ke akun anda",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 20),

                /// USERNAME
                _inputField(
                  controller: usernameController,
                  hint: "Username",
                  icon: Icons.person,
                ),

                const SizedBox(height: 12),

                /// PASSWORD
                _inputField(
                  controller: passwordController,
                  hint: "Password",
                  icon: Icons.lock,
                  isPassword: true,
                ),

                const SizedBox(height: 20),

                /// BUTTON LOGIN
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Masuk"),
                  ),
                ),

                const SizedBox(height: 12),

                /// 🔥 BUTTON GOOGLE (TAMBAHAN)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _loginWithGoogle,
                    icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
                    label: const Text("Masuk dengan Google"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// LUPA PASSWORD
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Lupa password?",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),

                const SizedBox(height: 6),

                /// REGISTER
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Belum punya akun? Daftar",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}