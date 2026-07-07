import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:e_ticketing_helpdesk/features/auth/data/repositories/auth_repository.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';
import '../../../../core/services/auth_service.dart';
import 'package:e_ticketing_helpdesk/features/home/presentation/pages/home_page.dart';
import 'package:e_ticketing_helpdesk/features/home/presentation/pages/helpdesk_home_page.dart';
import 'package:e_ticketing_helpdesk/features/home/presentation/pages/user_home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthRepository _repository = AuthRepository();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isLoading = false;
  bool obscurePassword = true;
  bool rememberMe = false;

  Future<void> _login() async {

    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email dan Password wajib diisi"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {

      final response = await _repository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final user = response["user"];
      final role = user["role"];

      // ===========================
      // SIMPAN SESSION LOGIN
      // ===========================
      await AuthService().saveUser(
        id: user["id"],
        name: user["name"],
        email: user["email"],
        role: user["role"],
      );

      if (!mounted) return;

      if (role == "admin") {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomePage(role: "admin"),
          ),
        );

      } else if (role == "helpdesk") {

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

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login gagal\n$e"),
        ),
      );

    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

  }

  Future<void> _loginGoogle() async {

    try {

      final account = await _googleSignIn.signIn();

      if (account != null) {

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const UserHomePage(),
          ),
        );

      }

    } catch (_) {}

  }

  @override
  void dispose() {

    emailController.dispose();
    passwordController.dispose();

    super.dispose();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        backgroundColor: const Color(0xffF5F7FB),

        body: SafeArea(

            child: Center(

                child: SingleChildScrollView(

                    padding: const EdgeInsets.all(24),

                    child: ConstrainedBox(

                        constraints: const BoxConstraints(
                          maxWidth: 430,
                        ),

                        child: Card(

                            elevation: 8,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),

                            child: Padding(

                              padding: const EdgeInsets.all(24),

                              child: Column(

                                crossAxisAlignment: CrossAxisAlignment.stretch,

                                children: [

                                const Row(

                                mainAxisAlignment: MainAxisAlignment.center,

                                children: [

                                  Icon(
                                    Icons.confirmation_num,
                                    color: Color(0xff2563EB),
                                  ),

                                  SizedBox(width: 8),

                                  Text(
                                    "Helpdesk Admin",
                                    style: TextStyle(
                                      color: Color(0xff2563EB),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                ],

                              ),

                              const SizedBox(height: 20),

                              ClipRRect(

                                borderRadius: BorderRadius.circular(18),

                                child: Image.asset(
                                  "assets/images/login.png",
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),

                              ),

                              const SizedBox(height: 24),

                              const Text(

                                "Welcome Back",

                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),

                              ),

                              const SizedBox(height: 8),

                              const Text(

                                "Access your administrative ticketing dashboard",

                                textAlign: TextAlign.center,

                                style: TextStyle(
                                  color: Colors.grey,
                                ),

                              ),

                              const SizedBox(height: 28),

                              const Text(
                                "Work Email",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextField(

                                controller: emailController,

                                decoration: InputDecoration(

                                  hintText: "name@company.com",

                                  prefixIcon: const Icon(Icons.email_outlined),

                                  filled: true,

                                  fillColor: Colors.grey.shade100,

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),

                                ),

                              ),

                              const SizedBox(height: 20),

                              const Text(
                                "Password",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextField(

                                controller: passwordController,

                                obscureText: obscurePassword,

                                decoration: InputDecoration(

                                  hintText: "••••••••",

                                  prefixIcon: const Icon(Icons.lock_outline),

                                  suffixIcon: IconButton(

                                    icon: Icon(
                                      obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),

                                    onPressed: () {

                                      setState(() {
                                        obscurePassword = !obscurePassword;
                                      });

                                    },

                                  ),

                                  filled: true,

                                  fillColor: Colors.grey.shade100,

                                  border: OutlineInputBorder(

                                    borderRadius: BorderRadius.circular(16),

                                    borderSide: BorderSide.none,

                                  ),

                                ),

                              ),
                                  const SizedBox(height: 16),

                                  Row(
                                    children: [
                                      Checkbox(
                                        value: rememberMe,
                                        activeColor: const Color(0xff2563EB),
                                        onChanged: (value) {
                                          setState(() {
                                            rememberMe = value ?? false;
                                          });
                                        },
                                      ),

                                      const Text(
                                        "Remember Me",
                                        style: TextStyle(fontSize: 13),
                                      ),

                                      const Spacer(),

                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                              const ForgotPasswordPage(),
                                            ),
                                          );
                                        },
                                        child: const Text("Forgot Password?"),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 20),

                                  SizedBox(
                                    height: 55,
                                    child: ElevatedButton(
                                      onPressed: isLoading ? null : _login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xff2563EB),
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: isLoading
                                          ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                          : const Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Sign In to Dashboard",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(Icons.arrow_forward),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 28),

                                  Row(
                                    children: const [
                                      Expanded(child: Divider()),
                                      Padding(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                        child: Text(
                                          "OR CONTINUE WITH",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Divider()),
                                    ],
                                  ),

                                  const SizedBox(height: 20),

                                  SizedBox(
                                    height: 55,
                                    child: OutlinedButton.icon(
                                      onPressed: _loginGoogle,
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                        ),
                                      ),
                                      icon: const Icon(
                                        Icons.g_mobiledata,
                                        color: Colors.red,
                                        size: 32,
                                      ),
                                      label: const Text(
                                        "Login with Google",
                                        style: TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),

                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Don't have an account? ",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                              const RegisterPage(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "Register",
                                          style: TextStyle(
                                            color: Color(0xff2563EB),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ),
                    ),
                ),
            ),
        ),
    );
  }
}