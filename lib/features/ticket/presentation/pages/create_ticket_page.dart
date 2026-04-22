import 'package:flutter/material.dart';

class CreateTicketPage extends StatefulWidget {
  const CreateTicketPage({super.key});

  @override
  State<CreateTicketPage> createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  String _status = "Open";
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // simulasi API

    setState(() => _isLoading = false);

    if (!mounted) return;

    /// 🔥 BALIKIN DATA KE TICKET PAGE
    Navigator.pop(context, {
      "title": _titleController.text,
      "desc": _descController.text,
      "status": _status,
    });

    /// OPTIONAL (kalau mau snackbar di halaman sebelumnya aja)
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Tiket berhasil dibuat")),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buat Tiket"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,

          child: Column(
            children: [

              /// 🔹 TITLE
              _buildTextField(
                controller: _titleController,
                label: "Judul Tiket",
                icon: Icons.title,
                validator: (value) =>
                value!.isEmpty ? "Judul tidak boleh kosong" : null,
              ),

              const SizedBox(height: 16),

              /// 🔹 DESCRIPTION
              _buildTextField(
                controller: _descController,
                label: "Deskripsi",
                icon: Icons.description,
                maxLines: 4,
                validator: (value) =>
                value!.isEmpty ? "Deskripsi tidak boleh kosong" : null,
              ),

              const SizedBox(height: 16),

              /// 🔹 STATUS DROPDOWN
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonFormField<String>(
                  value: _status,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    labelText: "Status",
                  ),
                  items: ["Open", "Progress", "Done"]
                      .map(
                        (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() => _status = value!);
                  },
                ),
              ),

              const SizedBox(height: 24),

              /// 🔹 BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text("Simpan Tiket"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: label,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}