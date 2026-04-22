import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserCreateTicketPage extends StatefulWidget {
  const UserCreateTicketPage({super.key});

  @override
  State<UserCreateTicketPage> createState() => _UserCreateTicketPageState();
}

class _UserCreateTicketPageState extends State<UserCreateTicketPage> {

  final titleController = TextEditingController();
  final descController = TextEditingController();

  String selectedCategory = "IT Support";

  final categories = [
    "IT Support",
    "Jaringan",
    "Hardware",
    "Software",
  ];

  File? selectedImage;

  /// 🔥 PICK IMAGE
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        title: const Text("Buat Aduan"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// TITLE
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Judul Masalah",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// CATEGORY
            DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map((e) {
                return DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    selectedCategory = val;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: "Kategori",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// DESKRIPSI
            TextField(
              controller: descController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: "Deskripsi",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// 📸 UPLOAD GAMBAR (FIX KLIK)
            GestureDetector(
              onTap: pickImage,
              behavior: HitTestBehavior.opaque, // 🔥 FIX KLIK
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [

                    if (selectedImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          selectedImage!,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Column(
                        children: const [
                          Icon(Icons.image, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("Upload Gambar",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),

                    const SizedBox(height: 8),

                    const Text(
                      "Tap untuk pilih gambar",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// BUTTON KIRIM
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Aduan berhasil dikirim")),
                  );

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Kirim Aduan"),
              ),
            )
          ],
        ),
      ),
    );
  }
}