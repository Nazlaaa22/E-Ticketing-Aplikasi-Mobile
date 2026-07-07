import 'dart:async';
import 'package:flutter/material.dart';
import 'login_page.dart';
import '../../../../core/services/auth_service.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../home/presentation/pages/helpdesk_home_page.dart';
import '../../../home/presentation/pages/user_home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    Future<void> _checkLogin() async {

      await Future.delayed(const Duration(seconds: 3));

      final loggedIn = await authService.isLoggedIn();

      if (!mounted) return;

      if (loggedIn) {

        final role = await authService.getRole();

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

      } else {

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginPage(),
          ),
        );

      }
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _checkLogin();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff2563EB),
              Color(0xff3B82F6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [

            /// blur atas
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            /// blur bawah
            Positioned(
              bottom: -120,
              right: -120,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Center(
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _controller,
                  curve: Curves.easeOut,
                ),
                child: ScaleTransition(
                  scale: Tween(
                    begin: .8,
                    end: 1.0,
                  ).animate(CurvedAnimation(
                    parent: _controller,
                    curve: Curves.easeOutBack,
                  )),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// LOGO
                      Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.12),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.confirmation_number_rounded,
                          size: 48,
                          color: Color(0xff2563EB),
                        ),
                      ),

                      const SizedBox(height: 35),

                      const Text(
                        "E-Ticketing Helpdesk",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Manage Support Tickets Faster",
                        style: TextStyle(
                          color: Colors.white.withOpacity(.75),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Column(
                children: const [

                  SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 18),

                  Text(
                    "Initializing System",
                    style: TextStyle(
                      color: Colors.white70,
                      letterSpacing: 2,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}