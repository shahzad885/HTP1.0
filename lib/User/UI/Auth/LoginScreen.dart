import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:htp/Admin/dashboard.dart';
import 'package:htp/User/UI/Auth/Phone_Auth/Login_with_phone.dart';
import 'package:htp/User/UI/Auth/SignupScreen.dart';
import 'package:htp/User/UI/HomeScreen.dart';
import 'package:htp/User/Utils/Utils.dart';
import 'package:htp/User/Widgets/CRoundButton.dart';
import 'package:rive/rive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  bool loading = false;
  bool _showPassword = false;

  // Rive animation variables
  StateMachineController? _controller;
  SMIInput<bool>? _isChecking;
  SMIInput<bool>? _isHandsUp;
  SMIInput<bool>? _trigSuccess;
  SMIInput<bool>? _trigFail;

  @override
  void dispose() {
    _controller?.dispose();
    EmailController.dispose();
    PasswordController.dispose();
    super.dispose();
  }

  void Login() {
    setState(() {
      loading = true;
      _isChecking?.change(true);
      _trigFail?.change(false); // Reset fail animation before starting login attempt
    });

    _auth
        .signInWithEmailAndPassword(
            email: EmailController.text, password: PasswordController.text)
        .then((value) {
      setState(() {
        loading = false;
        _isChecking?.change(false);
        _trigSuccess?.change(true); // Trigger success animation
      });

      // Fetch user role from Firestore
      FirebaseFirestore.instance
          .collection('HtpUsers')
          .doc(value.user!.uid)
          .get()
          .then((userDoc) {
        if (userDoc.exists) {
          String role = userDoc['role'] ?? 'user'; // Default to 'user' if no role exists

          // Redirect to Admin Dashboard if the role is 'admin'
          if (role == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AdminDashboard()),
            );
          } else {
            // Redirect to HomeScreen if the role is 'user'
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Homescreen()),
            );
          }
        } else {
          debugPrint("User role not found");
        }
      });

      Timer(const Duration(seconds: 2), () {
        Utils().ToastMessage("Welcome! ${value.user!.email}");
      });
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
        _isChecking?.change(false);
        _trigFail?.change(true); // Trigger fail animation on error
      });

      Utils().ToastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double screenWidth = size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: GoogleFonts.roboto(
            fontSize: screenWidth * 0.055,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xffD6E2EA),
      ),
      backgroundColor: const Color(0xffD6E2EA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              reverse: true, // Moves the content up when the keyboard appears
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 300,
                          width: screenWidth,
                          child: RiveAnimation.asset(
                            'assets/login.riv',
                            stateMachines: const ["Login Machine"],
                            onInit: (artboard) {
                              _controller = StateMachineController.fromArtboard(
                                  artboard, "Login Machine");
                              if (_controller == null) return;
                              artboard.addController(_controller!);
                              _isChecking = _controller!.findInput("isChecking");
                              _isHandsUp = _controller!.findInput("isHandsUp");
                              _trigSuccess = _controller!.findInput("trigSuccess");
                              _trigFail = _controller!.findInput("trigFail");
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Email Text Field
                              TextFormField(
                                controller: EmailController,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  prefixIcon:
                                      const Icon(Icons.email, color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                                onTap: () {
                                  _isHandsUp?.change(false);
                                  _isChecking?.change(true);
                                },
                                onChanged: (value) {
                                  if (_isChecking != null &&
                                      !_isChecking!.value) {
                                    _isChecking!.change(true);
                                  }
                                },
                                onEditingComplete: () {
                                  setState(() {
                                    _isChecking?.change(false);
                                  });
                                },
                              ),
                              const SizedBox(height: 10),

                              // Password Text Field
                              TextFormField(
                                controller: PasswordController,
                                obscureText: !_showPassword,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  prefixIcon:
                                      const Icon(Icons.lock, color: Colors.black),
                                  suffixIcon: IconButton(
                                    color: Colors.black,
                                    icon: Icon(_showPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  if (_isHandsUp != null &&
                                      !_isHandsUp!.value) {
                                    _isHandsUp!.change(true);
                                  }
                                },
                                onEditingComplete: () {
                                  setState(() {
                                    _isHandsUp?.change(false);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Login Button
                        CRoundButton(
                          loading: loading,
                          buttonText: 'Login',
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              Login();
                            }
                          },
                        ),
                        const SizedBox(height: 10),

                        // Signup and Login with Phone Option
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: GoogleFonts.roboto(
                                fontSize: screenWidth * 0.04,
                                color: Colors.black,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Signupscreen()),
                                );
                              },
                              child: Text(
                                'Signup',
                                style: GoogleFonts.roboto(
                                  fontSize: screenWidth * 0.04,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginWithPhone()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black,
                              ),
                              child: const Center(
                                child: Text(
                                  "Login With Phone Number",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
