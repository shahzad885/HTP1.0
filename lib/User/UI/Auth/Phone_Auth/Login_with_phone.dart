
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:htp/User/UI/Auth/Phone_Auth/Verify_code.dart';
import 'package:htp/User/Utils/Utils.dart';
import 'package:htp/User/Widgets/CRoundButton.dart';

class LoginWithPhone extends StatefulWidget {
  const LoginWithPhone({super.key});

  @override
  State<LoginWithPhone> createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  
  bool loading = false;
  final _auth = FirebaseAuth.instance;
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
     final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
       backgroundColor: const Color(0xffD6E2EA),
      appBar: AppBar(
         backgroundColor: const Color(0xffD6E2EA),
        title:  Text('Login with Phone',  style: GoogleFonts.roboto(
                        fontSize: screenWidth * 0.045,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(
                hintText: ' +1 234 5678 910',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            CRoundButton(
                loading: loading,
                buttonText: 'login',
                onTap: () {
                  setState(() {
                    loading = true;
                  });

                  _auth.verifyPhoneNumber(
                    phoneNumber: phoneController.text.toString(),
                    verificationCompleted: (_) {
                      setState(() {
                        loading = false;
                      });
                    },
                    verificationFailed: (error) {
                      debugPrint('in failded sec');
                      Utils().ToastMessage(error.toString());
                      setState(() {
                        loading = false;
                      });
                    },
                    codeSent: (verificationId, int? token) {
                      setState(() {
                        loading = false;
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerifyCode(
                              verificationId: verificationId,
                            ),
                          ));
                    },
                    codeAutoRetrievalTimeout: (error) {
                      setState(() {
                        loading = false;
                      });
                      Utils().ToastMessage(error.toString());
                    },
                  );
                })
          ],
        ),
      ),
    );
  }
}
