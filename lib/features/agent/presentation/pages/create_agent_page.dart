import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class CreateAgentPage extends StatefulWidget {
  const CreateAgentPage({super.key});

  @override
  State<CreateAgentPage> createState() => _CreateAgentPageState();
}

class _CreateAgentPageState extends State<CreateAgentPage> {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000/api",
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF5F7FB),

        body: SingleChildScrollView(
            child: Column(
              children: [

              /// ================= HEADER =================
              Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 55, 24, 30),
              decoration: const BoxDecoration(
                color: Color(0xff2563EB),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Tambah Helpdesk",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Daftarkan akun helpdesk baru",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                    /// ================= AVATAR =================
                    Stack(
                    alignment: Alignment.bottomRight,
                    children: [

                      CircleAvatar(
                        radius: 48,
                        backgroundColor:
                        Colors.blue.shade100,

                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Color(0xff2563EB),
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xff2563EB),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  _textField(
                    controller: nameController,
                    icon: Icons.person_outline,
                    hint: "Nama Lengkap",
                  ),

                  const SizedBox(height: 18),

                  _textField(
                    controller: usernameController,
                    icon: Icons.account_circle_outlined,
                    hint: "Username",
                  ),

                  const SizedBox(height: 18),

                  _textField(
                    controller: emailController,
                    icon: Icons.email_outlined,
                    hint: "Email",
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 18),

                  _textField(
                    controller: phoneController,
                    icon: Icons.phone_outlined,
                    hint: "Nomor HP",
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 18),
                      /// ================= PASSWORD =================

                      _passwordField(
                        controller: passwordController,
                        hint: "Password",
                        isHidden: hidePassword,
                        onTap: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                      ),

                      const SizedBox(height: 18),

                      _passwordField(
                        controller: confirmPasswordController,
                        hint: "Konfirmasi Password",
                        isHidden: hideConfirmPassword,
                        onTap: () {
                          setState(() {
                            hideConfirmPassword =
                            !hideConfirmPassword;
                          });
                        },
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : createHelpdesk,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xff2563EB),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(18),
                            ),
                            elevation: 0,
                          ),
                          child: isLoading
                              ? const SizedBox(
                            height: 22,
                            width: 22,
                            child:
                            CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            "Simpan Helpdesk",
                            style: TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
            ),
              ],
            ),
        ),
    );
  }

  /// ================== CREATE HELPDESK ==================

  Future<void> createHelpdesk() async {
    if (nameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua field wajib diisi"),
        ),
      );
      return;
    }

    if (passwordController.text !=
        confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password tidak sama"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await dio.post(
        "/helpdesks",
        data: {
          "name": nameController.text,
          "username": usernameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
          "password": passwordController.text,
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Helpdesk berhasil ditambahkan"),
        ),
      );

      Navigator.pop(context, true);
    } on DioException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.response?.data["message"] ??
                "Gagal menambahkan helpdesk",
          ),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }
  /// ================== TEXT FIELD ==================

  Widget _textField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: const Color(0xff2563EB),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xff2563EB),
            width: 2,
          ),
        ),
      ),
    );
  }

  /// ================== PASSWORD FIELD ==================

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool isHidden,
    required VoidCallback onTap,
  }) {
    return TextField(
      controller: controller,
      obscureText: isHidden,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Color(0xff2563EB),
        ),
        suffixIcon: IconButton(
          onPressed: onTap,
          icon: Icon(
            isHidden
                ? Icons.visibility_off
                : Icons.visibility,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xff2563EB),
            width: 2,
          ),
        ),
      ),
    );
  }
}