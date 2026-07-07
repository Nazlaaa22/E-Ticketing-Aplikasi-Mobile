import 'package:flutter/material.dart';
import '../../../../core/services/auth_service.dart';
import '../../../auth/data/repositories/auth_repository.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthRepository _repository = AuthRepository();
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  int? userId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      userId = await _authService.getUserId();

      if (userId == null) return;

      final data = await _repository.getProfile(userId!);

      nameController.text = data["name"] ?? "";
      usernameController.text = data["username"] ?? "";
      emailController.text = data["email"] ?? "";
      phoneController.text = data["phone"] ?? "";
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    if (userId == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await _repository.updateProfile(
        id: userId!,
        name: nameController.text.trim(),
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
      );

      final user = response["user"];

      await _authService.saveUser(
        id: user["id"],
        name: user["name"],
        email: user["email"],
        role: user["role"],
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profil berhasil diperbarui"),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
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
                            backgroundColor: Colors.white24,
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
                            "Edit Profil",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            "Perbarui informasi akun Anda",
                            style: TextStyle(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Transform.translate(
                      offset: const Offset(0, -40),
                      child: Stack(
                        children: [

                          CircleAvatar(
                            radius: 50,
                            backgroundColor:
                            Colors.blue.shade100,
                            child: const Icon(
                              Icons.person,
                              size: 55,
                              color: Color(0xFF2563EB),
                            ),
                          ),

                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor:
                              const Color(0xFF2563EB),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Upload foto akan ditambahkan berikutnya",
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Column(
                        children: [

                        _input(
                        controller: nameController,
                        label: "Nama Lengkap",
                        icon: Icons.person_outline,
                      ),

                      const SizedBox(height: 18),

                      _input(
                        controller: usernameController,
                        label: "Username",
                        icon: Icons.alternate_email,
                      ),

                      const SizedBox(height: 18),

                      _input(
                        controller: emailController,
                        label: "Email",
                        icon: Icons.email_outlined,
                        keyboardType:
                        TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 18),

                      _input(
                        controller: phoneController,
                        label: "Nomor HP",
                        icon: Icons.phone_outlined,
                        keyboardType:
                        TextInputType.phone,
                      ),

                      const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton.icon(
                              onPressed: isLoading
                                  ? null
                                  : saveProfile,
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
                              icon: isLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child:
                                CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Icon(Icons.save),
                              label: const Text(
                                "Simpan Perubahan",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
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

  Widget _input({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label wajib diisi";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF2563EB),
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
            color: Color(0xFF2563EB),
            width: 2,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }
}
