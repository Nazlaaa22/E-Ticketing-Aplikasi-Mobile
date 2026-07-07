import 'package:flutter/material.dart';
import 'package:e_ticketing_helpdesk/features/auth/data/repositories/auth_repository.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final AuthRepository _repository = AuthRepository();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  Future<void> _register() async {

    if(nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua field wajib diisi"),
        ),
      );

      return;
    }

    if(passwordController.text != confirmPasswordController.text){

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

    try{

      final response = await _repository.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if(!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response["message"]),
        ),
      );

      Navigator.pop(context);

    }catch(e){

      if(!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );

    }

    if(mounted){
      setState(() {
        isLoading = false;
      });
    }

  }

  @override
  void dispose() {

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

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
                                    Icons.person_add_alt_1,
                                    color: Color(0xff2563EB),
                                  ),

                                  SizedBox(width: 8),

                                  Text(
                                    "Create Account",
                                    style: TextStyle(
                                      color: Color(0xff2563EB),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )

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
                                "Create Your Account",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                "Register to access Helpdesk Ticketing",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 28),

                              const Text(
                                "Full Name",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextField(

                                controller: nameController,

                                decoration: InputDecoration(

                                  hintText: "Your Full Name",

                                  prefixIcon: const Icon(Icons.person_outline),

                                  filled: true,

                                  fillColor: Colors.grey.shade100,

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),

                                ),

                              ),

                              const SizedBox(height: 18),

                              const Text(
                                "Email",
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

                              const SizedBox(height: 18),

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

                                    onPressed: (){
                                      setState(() {
                                        obscurePassword=!obscurePassword;
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
                                  const SizedBox(height: 18),

                                  const Text(
                                    "Confirm Password",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  TextField(
                                    controller: confirmPasswordController,
                                    obscureText: obscureConfirm,
                                    decoration: InputDecoration(
                                      hintText: "••••••••",
                                      prefixIcon:
                                      const Icon(Icons.lock_outline),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          obscureConfirm
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            obscureConfirm =
                                            !obscureConfirm;
                                          });
                                        },
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

                                  const SizedBox(height: 28),

                                  SizedBox(
                                    height: 55,
                                    child: ElevatedButton(
                                      onPressed:
                                      isLoading ? null : _register,
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
                                        height: 22,
                                        width: 22,
                                        child:
                                        CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                          : const Text(
                                        "Create Account",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                          FontWeight.bold,
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
                                        "Already have an account? ",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),

                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "Sign In",
                                          style: TextStyle(
                                            color: Color(0xff2563EB),
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),

                                  const SizedBox(height: 10),

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