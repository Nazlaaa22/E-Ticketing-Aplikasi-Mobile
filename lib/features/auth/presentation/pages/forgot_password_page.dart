import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final emailController = TextEditingController();

  bool isLoading = false;

  void _sendResetLink() async {

    if (emailController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email wajib diisi"),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Link reset password berhasil dikirim"),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    emailController.dispose();
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

                      Align(

                        alignment: Alignment.centerLeft,

                        child: IconButton(

                          onPressed: () {
                            Navigator.pop(context);
                          },

                          icon: const Icon(Icons.arrow_back_ios),

                        ),

                      ),

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

                        "Forgot Password",

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),

                      ),

                      const SizedBox(height: 10),

                      const Text(

                        "Enter your registered email address and we will send you a password reset link.",

                        textAlign: TextAlign.center,

                        style: TextStyle(
                          color: Colors.grey,
                          height: 1.4,
                        ),

                      ),

                      const SizedBox(height: 30),

                      const Text(

                        "Email",

                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),

                      ),

                      const SizedBox(height: 8),

                      TextField(

                        controller: emailController,

                        keyboardType: TextInputType.emailAddress,

                        decoration: InputDecoration(

                          hintText: "name@company.com",

                          prefixIcon: const Icon(
                            Icons.email_outlined,
                          ),

                          filled: true,

                          fillColor: Colors.grey.shade100,

                          border: OutlineInputBorder(

                            borderRadius:
                            BorderRadius.circular(16),

                            borderSide: BorderSide.none,

                          ),

                        ),

                      ),

                      const SizedBox(height: 30),

                      SizedBox(

                        height: 55,

                        child: ElevatedButton(

                          onPressed:
                          isLoading ? null : _sendResetLink,

                          style: ElevatedButton.styleFrom(

                            backgroundColor:
                            const Color(0xff2563EB),

                            foregroundColor: Colors.white,

                            elevation: 0,

                            shape: RoundedRectangleBorder(

                              borderRadius:
                              BorderRadius.circular(16),

                            ),

                          ),

                          child: isLoading

                              ? const SizedBox(

                            width: 22,

                            height: 22,

                            child: CircularProgressIndicator(

                              color: Colors.white,

                              strokeWidth: 2.5,

                            ),

                          )

                              : const Row(

                            mainAxisAlignment:
                            MainAxisAlignment.center,

                            children: [

                              Icon(Icons.send),

                              SizedBox(width: 8),

                              Text(

                                "Send Reset Link",

                                style: TextStyle(

                                  fontSize: 16,

                                  fontWeight:
                                  FontWeight.bold,

                                ),

                              ),

                            ],

                          ),

                        ),

                      ),

                      const SizedBox(height: 24),

                      Center(

                        child: TextButton.icon(

                          onPressed: () {

                            Navigator.pop(context);

                          },

                          icon: const Icon(Icons.arrow_back),

                          label: const Text(
                            "Back to Login",
                          ),

                        ),

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