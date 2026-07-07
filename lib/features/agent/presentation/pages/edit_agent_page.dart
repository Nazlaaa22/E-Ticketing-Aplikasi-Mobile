import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class EditAgentPage extends StatefulWidget {
  final int id;
  final String name;
  final String email;
  final String phone;

  const EditAgentPage({
    super.key,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  @override
  State<EditAgentPage> createState() => _EditAgentPageState();
}

class _EditAgentPageState extends State<EditAgentPage> {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000/api",
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.name,
    );

    emailController = TextEditingController(
      text: widget.email,
    );

    phoneController = TextEditingController(
      text: widget.phone,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> updateHelpdesk() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      await _dio.put(
        "/helpdesks/${widget.id}",
        data: {
          "name": nameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
        },
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Data berhasil diperbarui",
          ),
        ),
      );

      Navigator.pop(context, true);
    } on DioException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.response?.data.toString() ??
                e.message.toString(),
          ),
        ),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> deleteHelpdesk() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Helpdesk"),
        content: const Text(
          "Yakin ingin menghapus akun helpdesk ini?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _dio.delete(
        "/helpdesks/${widget.id}",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Helpdesk berhasil dihapus",
          ),
        ),
      );

      Navigator.pop(context, true);
    } on DioException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.response?.data.toString() ??
                e.message.toString(),
          ),
        ),
      );
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
                      30,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2563EB),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        CircleAvatar(
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

                        const SizedBox(height: 24),

                        const Text(
                          "Edit Helpdesk",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "Perbarui data helpdesk",
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
                      radius: 46,
                      backgroundColor:
                      Colors.blue.shade100,
                      child: const Icon(
                        Icons.person,
                        size: 48,
                        color: Color(0xFF2563EB),
                      ),
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
                              hint: "Nama Lengkap",
                              icon: Icons.person_outline,
                            ),

                            const SizedBox(height: 18),

                            _input(
                              controller: emailController,
                              hint: "Email",
                              icon: Icons.email_outlined,
                              keyboardType:
                              TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 18),

                            _input(
                              controller: phoneController,
                              hint: "Nomor HP",
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
                                    : updateHelpdesk,
                                icon: isLoading
                                    ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                  CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                    : const Icon(Icons.save),
                                label: const Text(
                                  "Update Helpdesk",
                                  style: TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                style:
                                ElevatedButton.styleFrom(
                                  backgroundColor:
                                  const Color(
                                      0xFF2563EB),
                                  foregroundColor:
                                  Colors.white,
                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(18),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: OutlinedButton.icon(
                                onPressed: deleteHelpdesk,
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                label: const Text(
                                  "Hapus Helpdesk",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                                style:
                                OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.red,
                                  ),
                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(18),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 35),
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
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$hint wajib diisi";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF2563EB),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
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
}