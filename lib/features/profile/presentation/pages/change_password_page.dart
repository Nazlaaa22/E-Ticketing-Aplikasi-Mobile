import 'package:flutter/material.dart';
import '../../../../core/services/auth_service.dart';
import '../../../auth/data/repositories/auth_repository.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() =>
      _ChangePasswordPageState();
}

class _ChangePasswordPageState
    extends State<ChangePasswordPage> {
  final AuthRepository _repository =
  AuthRepository();

  final AuthService _authService =
  AuthService();

  final _formKey =
  GlobalKey<FormState>();

  final oldPasswordController =
  TextEditingController();

  final newPasswordController =
  TextEditingController();

  final confirmPasswordController =
  TextEditingController();

  bool loading = false;

  bool oldHide = true;
  bool newHide = true;
  bool confirmHide = true;

  int? userId;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    userId = await _authService.getUserId();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> savePassword() async {
    if (!_formKey.currentState!.validate()) return;

    if (newPasswordController.text !=
        confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Konfirmasi password tidak sama",
          ),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await _repository.changePassword(
        id: userId!,
        oldPassword:
        oldPasswordController.text,
        newPassword:
        newPasswordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
          Text("Password berhasil diubah"),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF5F7FB),

        body: SafeArea(
            child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                      children: [

                      /// ================= HEADER =================

                      Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        20,
                        20,
                        35,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2563EB),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          CircleAvatar(
                            radius: 22,
                            backgroundColor:
                            Colors.white24,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          const Text(
                            "Ganti Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            "Perbarui password akun Anda",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Transform.translate(
                      offset: const Offset(0, -35),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor:
                        Colors.blue.shade100,
                        child: const Icon(
                          Icons.lock_outline,
                          color: Color(0xFF2563EB),
                          size: 50,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [

                        _passwordField(
                        controller:
                        oldPasswordController,
                        label:
                        "Password Lama",
                        hide: oldHide,
                        onToggle: () {
                          setState(() {
                            oldHide =
                            !oldHide;
                          });
                        },
                      ),

                      const SizedBox(height: 18),

                      _passwordField(
                        controller:
                        newPasswordController,
                        label:
                        "Password Baru",
                        hide: newHide,
                        onToggle: () {
                          setState(() {
                            newHide =
                            !newHide;
                          });
                        },
                      ),

                      const SizedBox(height: 18),

                      _passwordField(
                        controller:
                        confirmPasswordController,
                        label:
                        "Konfirmasi Password",
                        hide: confirmHide,
                        onToggle: () {
                          setState(() {
                            confirmHide =
                            !confirmHide;
                          });
                        },
                      ),

                      const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton.icon(
                              onPressed: loading
                                  ? null
                                  : savePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xFF2563EB),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(18),
                                ),
                              ),
                              icon: loading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Icon(Icons.lock_reset),
                              label: const Text(
                                "Simpan Password",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                      ],
                    ),
                ),
            ),
        ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool hide,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: hide,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label wajib diisi";
        }

        if (label == "Password Baru" &&
            value.length < 6) {
          return "Minimal 6 karakter";
        }

        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(
          Icons.lock_outline,
          color: Color(0xFF2563EB),
        ),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            hide
                ? Icons.visibility_off
                : Icons.visibility,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
          BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color(0xFF2563EB),
            width: 2,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
